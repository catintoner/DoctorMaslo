//TODO: as example
const productModel = require("../models/productModel");

class ProductService {
    async addProduct(productData) {
        if (productData.price < 0) {
            throw new Error("Цена не может быть отрицательной");
        }
        return await productModel.createProduct(productData);
    }

    async getProducts() {
        return await productModel.getAllProducts();
    }
}

module.exports = new ProductService();