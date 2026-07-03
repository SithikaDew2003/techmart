package lk.sithikaDev.techmart.service;

import jakarta.ejb.Local;
import java.util.Map;

@Local
public interface CartService {
    void checkout(Map<Integer, Integer> cartItems, Integer customerId);
}
