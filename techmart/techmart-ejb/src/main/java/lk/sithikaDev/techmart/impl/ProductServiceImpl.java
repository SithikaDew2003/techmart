package lk.sithikaDev.techmart.impl;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.sithikaDev.techmart.entity.Product;
import lk.sithikaDev.techmart.service.ProductService;

import java.util.List;

@Stateless
public class ProductServiceImpl implements ProductService {

    @PersistenceContext(unitName = "TechmartPU")
    private EntityManager entityManager;

    @Override
    public List<Product> getAllProducts() {
        return entityManager.createQuery("SELECT p FROM Product p", Product.class).getResultList();
    }

    @Override
    public Product getProductById(Integer id) {
        return entityManager.find(Product.class, id);
    }

    @Override
    public void addProduct(Product product) {
        entityManager.persist(product);
    }

    @Override
    public void updateProduct(Product product) {
        entityManager.merge(product);
    }

    @Override
    public void deleteProduct(Integer productId) {
        Product product = getProductById(productId);
        if (product != null) {
            entityManager.remove(product);
        }
    }

    @Override
    public void updateStock(Integer productId, Integer quantity) {
        Product product = getProductById(productId);
        if (product != null) {
            product.setStockQuantity(product.getStockQuantity() - quantity);
            entityManager.merge(product);
        }
    }
}
