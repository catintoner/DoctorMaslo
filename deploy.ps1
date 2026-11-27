# DoctorMaslo Auto Deploy Script
# Run from project root: .\deploy.ps1

# --- SETTINGS ---
$ServerIP = "200.165.225.216"
$ServerUser = "root"
$RemotePath = "/var/www/doctormaslo-frontend/build"
$LocalBackupPath = "F:\catintoner\DoctorMaslo\_backups"

# --- COLORS ---
function Write-Step ($text) { Write-Host "`n==> $text" -ForegroundColor Cyan }
function Write-Success ($text) { Write-Host "`n[OK] $text" -ForegroundColor Green }
function Write-ErrorMsg ($text) { Write-Host "`n[ERROR] $text" -ForegroundColor Red }

# --- 1. BUILD ---
Write-Step "Step 1: Building frontend..."
Set-Location -Path "frontend"
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "Build failed! Deploy cancelled."
    Set-Location ..
    exit
}
Set-Location ..

# --- 2. REMOTE BACKUP ---
Write-Step "Step 2: Creating backup on server..."
$BackupDate = Get-Date -Format "yyyy-MM-dd_HH-mm"
$RemoteBackupName = "build_backup_$BackupDate"
$RemoteBackupPath = "/var/www/doctormaslo-frontend/$RemoteBackupName"
$BackupCmd = "cp -r $RemotePath $RemoteBackupPath"
ssh ${ServerUser}@${ServerIP} $BackupCmd
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "Backup failed! Check server connection."
    exit
}

# --- 3. UPLOAD FILES ---
Write-Step "Step 3: Uploading files to server..."
scp -r .\frontend\build\* ${ServerUser}@${ServerIP}:${RemotePath}/
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "File upload failed!"
    exit
}

# --- 4. RELOAD NGINX ---
Write-Step "Step 4: Reloading Nginx..."
ssh ${ServerUser}@${ServerIP} "systemctl reload nginx"

# --- 5. DOWNLOAD BACKUP ---
Write-Step "Step 5: Downloading backup to local machine..."
if (-not (Test-Path $LocalBackupPath)) {
    New-Item -ItemType Directory -Path $LocalBackupPath | Out-Null
}
scp -r ${ServerUser}@${ServerIP}:${RemoteBackupPath} $LocalBackupPath\
if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[WARN] Backup download failed. It remains on the server." -ForegroundColor Yellow
} else {
    # --- 6. DELETE REMOTE BACKUP ---
    Write-Step "Step 6: Deleting backup from server..."
    ssh ${ServerUser}@${ServerIP} "rm -rf $RemoteBackupPath"
}

Write-Success "Deploy successfully finished! Site updated, backup saved locally."