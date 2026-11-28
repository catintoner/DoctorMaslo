require("dotenv").config();
const knex = require("knex");

const db = knex({
    client: "pg",
    connection: {
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        port: process.env.DB_PORT,
    },
    pool: { min: 2, max: 5 }, // Ограничиваем пул для слабого сервера
    debug: true,
});

module.exports = db;
