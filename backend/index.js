require("dotenv").config();

const express = require("express");
const cors = require("cors");

const productRoutes = require("./src/routes/productRoutes");

const app = express();


app.use(cors());
app.use(express.json());


app.use("/api/products", productRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Backend server running on http://localhost:${PORT}`);
});