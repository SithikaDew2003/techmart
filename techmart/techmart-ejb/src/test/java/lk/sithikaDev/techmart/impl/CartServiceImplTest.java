package lk.sithikaDev.techmart.impl;

import jakarta.jms.JMSContext;
import jakarta.jms.JMSProducer;
import jakarta.jms.Queue;
import lk.sithikaDev.techmart.entity.Order;
import lk.sithikaDev.techmart.entity.Product;
import lk.sithikaDev.techmart.entity.Users;
import lk.sithikaDev.techmart.service.NotificationService;
import lk.sithikaDev.techmart.service.OrderService;
import lk.sithikaDev.techmart.service.ProductService;
import lk.sithikaDev.techmart.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CartServiceImplTest {

    @InjectMocks
    private CartServiceImpl cartService;

    @Mock
    private JMSContext jmsContext;

    @Mock
    private JMSProducer jmsProducer;

    @Mock
    private Queue orderQueue;

    @Mock
    private NotificationService notificationService;

    @Mock
    private ProductService productService;

    @Mock
    private OrderService orderService;

    @Mock
    private UserService userService;

    private Users customer;

    @BeforeEach
    void setUp() throws Exception {
        injectPrivateField(cartService, "orderQueue", orderQueue);

        customer = new Users();
        customer.setId(1);
        customer.setFirstName("Sithika");
        customer.setLastName("Samadith");
        customer.setEmail("sithika@example.com");
    }

    @Test
    void checkout_shouldReturnWithoutDoingAnything_whenCartItemsIsNull() {
        cartService.checkout(null, 1);

        verifyNoInteractions(userService, productService, orderService, notificationService, jmsContext);
    }

    @Test
    void checkout_shouldReturnWithoutDoingAnything_whenCartItemsIsEmpty() {
        cartService.checkout(Map.of(), 1);

        verifyNoInteractions(userService, productService, orderService, notificationService, jmsContext);
    }

    @Test
    void checkout_shouldReturn_whenCustomerNotFound() {
        when(userService.getAllUsers()).thenReturn(List.of(customer));

        cartService.checkout(Map.of(10, 2), 99);

        verify(userService).getAllUsers();
        verifyNoInteractions(productService, orderService, notificationService, jmsContext);
    }

    @Test
    void checkout_shouldCreateOrderUpdateStockSendJmsAndNotifications_whenValidCheckout() {
        Product product1 = new Product();
        product1.setId(10);
        product1.setPrice(new BigDecimal("1500.00"));

        Product product2 = new Product();
        product2.setId(20);
        product2.setPrice(new BigDecimal("2500.00"));

        Map<Integer, Integer> cartItems = Map.of(
                10, 2,
                20, 1
        );

        when(userService.getAllUsers()).thenReturn(List.of(customer));
        when(productService.getProductById(10)).thenReturn(product1);
        when(productService.getProductById(20)).thenReturn(product2);
        when(jmsContext.createProducer()).thenReturn(jmsProducer);

        cartService.checkout(cartItems, 1);

        ArgumentCaptor<Order> orderCaptor = ArgumentCaptor.forClass(Order.class);
        verify(orderService).createOrder(orderCaptor.capture());

        Order createdOrder = orderCaptor.getValue();

        assertEquals(1, createdOrder.getCustomerId());
        assertEquals("Sithika Samadith", createdOrder.getCustomerName());
        assertEquals("sithika@example.com", createdOrder.getCustomerEmail());
        assertEquals(cartItems.toString(), createdOrder.getOrderItems());
        assertEquals(new BigDecimal("5500.00"), createdOrder.getTotalAmount());
        assertEquals("PENDING", createdOrder.getOrderStatus());
        assertNotNull(createdOrder.getOrderDate());

        verify(productService).updateStock(10, 2);
        verify(productService).updateStock(20, 1);

        verify(jmsContext).createProducer();
        verify(jmsProducer).send(orderQueue, "Order: " + cartItems);

        verify(notificationService).sendPurchaseNotificationToAdmins(
                eq("Sithika Samadith"),
                eq("sithika@example.com"),
                eq(cartItems),
                eq(new BigDecimal("5500.00"))
        );

        verify(notificationService).sendOrderConfirmation(
                startsWith("ORD-"),
                eq("sithika@example.com")
        );
    }

    @Test
    void checkout_shouldIgnoreNullProduct_whenCalculatingTotal() {
        Product product = new Product();
        product.setId(10);
        product.setPrice(new BigDecimal("1000.00"));

        Map<Integer, Integer> cartItems = Map.of(
                10, 2,
                99, 5
        );

        when(userService.getAllUsers()).thenReturn(List.of(customer));
        when(productService.getProductById(10)).thenReturn(product);
        when(productService.getProductById(99)).thenReturn(null);
        when(jmsContext.createProducer()).thenReturn(jmsProducer);

        cartService.checkout(cartItems, 1);

        ArgumentCaptor<Order> orderCaptor = ArgumentCaptor.forClass(Order.class);
        verify(orderService).createOrder(orderCaptor.capture());

        assertEquals(new BigDecimal("2000.00"), orderCaptor.getValue().getTotalAmount());

        verify(productService).updateStock(10, 2);
        verify(productService).updateStock(99, 5);
    }

    @Test
    void checkout_shouldContinueCheckout_whenJmsSendThrowsException() {
        Product product = new Product();
        product.setId(10);
        product.setPrice(new BigDecimal("1000.00"));

        Map<Integer, Integer> cartItems = Map.of(10, 1);

        when(userService.getAllUsers()).thenReturn(List.of(customer));
        when(productService.getProductById(10)).thenReturn(product);
        when(jmsContext.createProducer()).thenReturn(jmsProducer);
        doThrow(new RuntimeException("JMS failed"))
                .when(jmsProducer)
                .send(orderQueue, "Order: " + cartItems);

        assertDoesNotThrow(() -> cartService.checkout(cartItems, 1));

        verify(orderService).createOrder(any(Order.class));
        verify(productService).updateStock(10, 1);
        verify(notificationService).sendPurchaseNotificationToAdmins(
                eq("Sithika Samadith"),
                eq("sithika@example.com"),
                eq(cartItems),
                eq(new BigDecimal("1000.00"))
        );
        verify(notificationService).sendOrderConfirmation(startsWith("ORD-"), eq("sithika@example.com"));
    }

    private void injectPrivateField(Object target, String fieldName, Object value) throws Exception {
        Field field = target.getClass().getDeclaredField(fieldName);
        field.setAccessible(true);
        field.set(target, value);
    }
}