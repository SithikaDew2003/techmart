package lk.sithikaDev.techmart.impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import lk.sithikaDev.techmart.entity.Order;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.lang.reflect.Field;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OrderServiceImplTest {

    @InjectMocks
    private OrderServiceImpl orderService;

    @Mock
    private EntityManager entityManager;

    @Mock
    private TypedQuery<Order> typedQuery;

    private Order order;

    @BeforeEach
    void setUp() {
        order = new Order();
        order.setId(1);
        order.setCustomerId(100);
        order.setCustomerName("Sithika Samadith");
        order.setCustomerEmail("sithika@example.com");
        order.setOrderStatus("PENDING");
    }

    @Test
    void createOrder_shouldPersistOrder() {
        orderService.createOrder(order);

        verify(entityManager).persist(order);
    }

    @Test
    void getOrderById_shouldReturnOrder_whenOrderExists() {
        when(entityManager.find(Order.class, 1)).thenReturn(order);

        Order result = orderService.getOrderById(1);

        assertNotNull(result);
        assertEquals(1, result.getId());
        assertEquals("Sithika Samadith", result.getCustomerName());

        verify(entityManager).find(Order.class, 1);
    }

    @Test
    void getOrderById_shouldReturnNull_whenOrderDoesNotExist() {
        when(entityManager.find(Order.class, 99)).thenReturn(null);

        Order result = orderService.getOrderById(99);

        assertNull(result);
        verify(entityManager).find(Order.class, 99);
    }

    @Test
    void getAllOrders_shouldReturnOrdersOrderedByDateDesc() {
        Order order2 = new Order();
        order2.setId(2);
        order2.setCustomerId(101);
        order2.setCustomerName("Test User");

        List<Order> orders = List.of(order, order2);

        when(entityManager.createQuery(
                "SELECT o FROM Order o ORDER BY o.orderDate DESC",
                Order.class
        )).thenReturn(typedQuery);

        when(typedQuery.getResultList()).thenReturn(orders);

        List<Order> result = orderService.getAllOrders();

        assertEquals(2, result.size());
        assertEquals(order, result.get(0));
        assertEquals(order2, result.get(1));

        verify(entityManager).createQuery(
                "SELECT o FROM Order o ORDER BY o.orderDate DESC",
                Order.class
        );
        verify(typedQuery).getResultList();
    }

    @Test
    void getOrdersByCustomerId_shouldReturnCustomerOrders() {
        List<Order> customerOrders = List.of(order);

        when(entityManager.createQuery(
                "SELECT o FROM Order o WHERE o.customerId = :customerId ORDER BY o.orderDate DESC",
                Order.class
        )).thenReturn(typedQuery);

        when(typedQuery.setParameter("customerId", 100)).thenReturn(typedQuery);
        when(typedQuery.getResultList()).thenReturn(customerOrders);

        List<Order> result = orderService.getOrdersByCustomerId(100);

        assertEquals(1, result.size());
        assertEquals(100, result.get(0).getCustomerId());

        verify(entityManager).createQuery(
                "SELECT o FROM Order o WHERE o.customerId = :customerId ORDER BY o.orderDate DESC",
                Order.class
        );
        verify(typedQuery).setParameter("customerId", 100);
        verify(typedQuery).getResultList();
    }

    @Test
    void updateOrder_shouldMergeOrder() {
        order.setOrderStatus("COMPLETED");

        orderService.updateOrder(order);

        verify(entityManager).merge(order);
    }

    @Test
    void deleteOrder_shouldRemoveOrder_whenOrderExists() {
        when(entityManager.find(Order.class, 1)).thenReturn(order);

        orderService.deleteOrder(1);

        verify(entityManager).find(Order.class, 1);
        verify(entityManager).remove(order);
    }

    @Test
    void deleteOrder_shouldNotRemoveOrder_whenOrderDoesNotExist() {
        when(entityManager.find(Order.class, 99)).thenReturn(null);

        orderService.deleteOrder(99);

        verify(entityManager).find(Order.class, 99);
        verify(entityManager, never()).remove(any(Order.class));
    }
}
