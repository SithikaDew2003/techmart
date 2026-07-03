package lk.sithikaDev.techmart.service;

import jakarta.ejb.Local;
import lk.sithikaDev.techmart.entity.Order;
import java.util.List;

@Local
public interface OrderService {
    void createOrder(Order order);
    Order getOrderById(Integer id);
    List<Order> getAllOrders();
    List<Order> getOrdersByCustomerId(Integer customerId);
    void updateOrder(Order order);
    void deleteOrder(Integer orderId);
}
