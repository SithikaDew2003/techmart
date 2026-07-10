package lk.sithikaDev.techmart.impl;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.sithikaDev.techmart.entity.Product;
import lk.sithikaDev.techmart.service.ProductService;

import java.math.BigDecimal;
import java.util.ArrayList;
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

    @Override
    public List<Product> searchProducts(String query) {
        if (query == null || query.trim().isEmpty()) {
            return getAllProducts();
        }
        return entityManager.createQuery(
                "SELECT p FROM Product p WHERE LOWER(p.name) LIKE LOWER(:query) OR LOWER(p.description) LIKE LOWER(:query)",
                Product.class
        ).setParameter("query", "%" + query.trim().toLowerCase() + "%").getResultList();
    }

    @Override
    public List<Product> filterProducts(String query, BigDecimal minPrice, BigDecimal maxPrice, String sortBy) {
        StringBuilder jpql = new StringBuilder("SELECT p FROM Product p WHERE 1=1");
        List<String> orderParts = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            jpql.append(" AND (LOWER(p.name) LIKE :query OR LOWER(p.description) LIKE :query)");
        }
        if (minPrice != null) {
            jpql.append(" AND p.price >= :minPrice");
        }
        if (maxPrice != null) {
            jpql.append(" AND p.price <= :maxPrice");
        }

        if (sortBy != null) {
            switch (sortBy) {
                case "price_asc":
                    orderParts.add("p.price ASC");
                    break;
                case "price_desc":
                    orderParts.add("p.price DESC");
                    break;
                case "name_asc":
                    orderParts.add("p.name ASC");
                    break;
                default:
                    orderParts.add("p.id DESC");
                    break;
            }
        } else {
            orderParts.add("p.id DESC");
        }

        jpql.append(" ORDER BY ").append(String.join(", ", orderParts));

        var queryObject = entityManager.createQuery(jpql.toString(), Product.class);
        if (query != null && !query.trim().isEmpty()) {
            queryObject.setParameter("query", "%" + query.trim().toLowerCase() + "%");
        }
        if (minPrice != null) {
            queryObject.setParameter("minPrice", minPrice);
        }
        if (maxPrice != null) {
            queryObject.setParameter("maxPrice", maxPrice);
        }

        return queryObject.getResultList();
    }
}
