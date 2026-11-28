const db = require("../config/db");

class ProductModel {
    constructor() {
        this.table = "products";
    }

    async createProduct(productData) {
        try {
            const [newProduct] = await this.insertProductToDb(productData);
            return newProduct;
        } catch (error) {
            console.error("Ошибка в createProduct:", error);
            throw error;
        }
    }

    async getAllProducts() {
        try {
            return await db(this.table)
                .select("*")
                .orderBy("name", "asc");
        } catch (error) {
            console.error("Ошибка в getAllProducts:", error);
            throw error;
        }
    }

    async insertProductToDb(productData) {
        const { name, price, sku, picture_url, avito_url } = productData;
        return await db(this.table)
            .insert({
                name,
                price,
                sku,
                picture_url,
                avito_url
            })
            .returning("*");
    }
}

module.exports = new ProductModel();