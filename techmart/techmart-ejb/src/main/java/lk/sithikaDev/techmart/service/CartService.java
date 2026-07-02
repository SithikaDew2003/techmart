package lk.sithikaDev.techmart.service;

import jakarta.ejb.Remote;
import java.util.Map;

@Remote
public interface CartService {
    void addItem(Integer productId, Integer quantity);
    void removeItem(Integer productId);
    Map<Integer, Integer> getItems();
    void checkout();
    void clearCart();
}
