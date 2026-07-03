package lk.sithikaDev.techmart.impl;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.sithikaDev.techmart.entity.CartItem;
import lk.sithikaDev.techmart.service.CartItemService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Stateless
public class CartItemServiceImpl implements CartItemService {

    @PersistenceContext(unitName = "TechmartPU")
    private EntityManager entityManager;

    @Override
    public void addCartItem(Integer customerId, Integer productId, Integer quantity) {
        CartItem existingItem = getCartItem(customerId, productId);
        if (existingItem != null) {
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
            entityManager.merge(existingItem);
        } else {
            CartItem cartItem = new CartItem();
            cartItem.setCustomerId(customerId);
            cartItem.setProductId(productId);
            cartItem.setQuantity(quantity);
            entityManager.persist(cartItem);
        }
        System.out.println("[CART ITEM] Added/Updated: Product " + productId + " for Customer " + customerId);
    }

    @Override
    public void removeCartItem(Integer customerId, Integer productId) {
        CartItem cartItem = getCartItem(customerId, productId);
        if (cartItem != null) {
            entityManager.remove(cartItem);
            System.out.println("[CART ITEM] Removed: Product " + productId + " for Customer " + customerId);
        }
    }

    @Override
    public void updateCartItemQuantity(Integer customerId, Integer productId, Integer quantity) {
        CartItem cartItem = getCartItem(customerId, productId);
        if (cartItem != null) {
            if (quantity <= 0) {
                removeCartItem(customerId, productId);
            } else {
                cartItem.setQuantity(quantity);
                entityManager.merge(cartItem);
                System.out.println("[CART ITEM] Updated quantity: Product " + productId + " to " + quantity);
            }
        }
    }

    @Override
    public List<CartItem> getCartItemsByCustomerId(Integer customerId) {
        return entityManager.createQuery(
                "SELECT c FROM CartItem c WHERE c.customerId = :customerId",
                CartItem.class
        ).setParameter("customerId", customerId).getResultList();
    }

    @Override
    public CartItem getCartItem(Integer customerId, Integer productId) {
        List<CartItem> results = entityManager.createQuery(
                "SELECT c FROM CartItem c WHERE c.customerId = :customerId AND c.productId = :productId",
                CartItem.class
        ).setParameter("customerId", customerId)
                .setParameter("productId", productId)
                .getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    @Override
    public void clearCart(Integer customerId) {
        List<CartItem> items = getCartItemsByCustomerId(customerId);
        for (CartItem item : items) {
            entityManager.remove(item);
        }
        System.out.println("[CART ITEM] Cleared cart for Customer " + customerId);
    }

    @Override
    public Map<Integer, Integer> getCartAsMap(Integer customerId) {
        Map<Integer, Integer> cartMap = new HashMap<>();
        List<CartItem> items = getCartItemsByCustomerId(customerId);
        for (CartItem item : items) {
            cartMap.put(item.getProductId(), item.getQuantity());
        }
        return cartMap;
    }
}
