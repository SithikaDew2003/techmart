package lk.sithikaDev.techmart.impl;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.sithikaDev.techmart.entity.Order;
import lk.sithikaDev.techmart.service.OrderService;
import java.util.List;

@Stateless
public class OrderServiceImpl implements OrderService {

    @PersistenceContext(unitName = "TechmartPU")
    private EntityManager entityManager;

    @Override
    public void createOrder(Order order) {
        entityManager.persist(order);
    }

    @Override
    public Order getOrderById(Integer id) {
        return entityManager.find(Order.class, id);
    }

    @Override
    public List<Order> getAllOrders() {
        return entityManager.createQuery("SELECT o FROM Order o ORDER BY o.orderDate DESC", Order.class)
                .getResultList();
    }

    @Override
    public List<Order> getOrdersByCustomerId(Integer customerId) {
        return entityManager.createQuery("SELECT o FROM Order o WHERE o.customerId = :customerId ORDER BY o.orderDate DESC", Order.class)
                .setParameter("customerId", customerId)
                .getResultList();
    }

    @Override
    public void updateOrder(Order order) {
        entityManager.merge(order);
    }

    @Override
    public void deleteOrder(Integer orderId) {
        Order order = getOrderById(orderId);
        if (order != null) {
            entityManager.remove(order);
        }
    }
}
