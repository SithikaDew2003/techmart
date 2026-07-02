package lk.sithikaDev.techmart.service;

import jakarta.ejb.Local;
import lk.sithikaDev.techmart.entity.Product;

import java.util.List;

@Local
public interface ProductService {
    List<Product> getAllProducts();
    Product getProductById(Integer id);
    void addProduct(Product product);
    void updateProduct(Product product);
    void deleteProduct(Integer productId);
    void updateStock(Integer productId, Integer quantity);
}
