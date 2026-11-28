import { apiRequest } from "./httpClient";

async function getProducts() {
  return await apiRequest("/products");
}

async function createProduct(productData) {
  return await apiRequest("/products", {
    method: "POST",
    body: JSON.stringify(productData),
  });
}

export { getProducts, createProduct };
