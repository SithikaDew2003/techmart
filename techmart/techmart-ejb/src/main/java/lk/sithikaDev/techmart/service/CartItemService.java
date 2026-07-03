package lk.sithikaDev.techmart.service;

import jakarta.ejb.Local;
import lk.sithikaDev.techmart.entity.CartItem;
import java.util.List;
import java.util.Map;

@Local
public interface CartItemService {
    void addCartItem(Integer customerId, Integer productId, Integer quantity);
    void removeCartItem(Integer customerId, Integer productId);
    void updateCartItemQuantity(Integer customerId, Integer productId, Integer quantity);
    List<CartItem> getCartItemsByCustomerId(Integer customerId);
    CartItem getCartItem(Integer customerId, Integer productId);
    void clearCart(Integer customerId);
    Map<Integer, Integer> getCartAsMap(Integer customerId);
}
