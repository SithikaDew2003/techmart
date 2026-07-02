package lk.sithikaDev.techmart.service;

import jakarta.ejb.Remote;
import lk.sithikaDev.techmart.entity.Product;

import java.util.List;

@Remote
public interface ProductService {
    List<Product> getAllProducts();
    Product getProductById(Integer id);
    void addProduct(Product product);
    void updateStock(Integer productId, Integer quantity);
}
