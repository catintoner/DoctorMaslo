const productService = require("../services/productService");

class ProductController {
    create = async (request, response) => {
        try {
            const newProduct = await productService.addProduct(request.body);
            response.status(201).json(newProduct);
        } catch (err) {
            console.error(err);
            response.status(500).json({ error: err.message || "Ошибка при добавлении продукта" });
        }
    };

    list = async (request, response) => {
        try {
            const products = await productService.getProducts();
            response.json(products);
        } catch (err) {
            console.error(err);
            response.status(500).json({ error: "Ошибка при получении продуктов" });
        }
    };
}

module.exports = new ProductController();