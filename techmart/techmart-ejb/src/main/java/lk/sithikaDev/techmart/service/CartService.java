package lk.sithikaDev.techmart.service;

import jakarta.ejb.Local;
import java.util.Map;

@Local
public interface CartService {
    void addItem(Integer productId, Integer quantity);
    void removeItem(Integer productId);
    Map<Integer, Integer> getItems();
    void checkout();
    void clearCart();
}
