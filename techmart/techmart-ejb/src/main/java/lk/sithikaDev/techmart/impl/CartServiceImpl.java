package lk.sithikaDev.techmart.impl;

import jakarta.annotation.Resource;
import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.jms.JMSContext;
import jakarta.jms.Queue;
import lk.sithikaDev.techmart.entity.Order;
import lk.sithikaDev.techmart.entity.Users;
import lk.sithikaDev.techmart.service.CartService;
import lk.sithikaDev.techmart.service.NotificationService;
import lk.sithikaDev.techmart.service.OrderService;
import lk.sithikaDev.techmart.service.ProductService;
import lk.sithikaDev.techmart.service.UserService;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

@Stateless
public class CartServiceImpl implements CartService, Serializable {

    @Inject
    private JMSContext jmsContext;

    @Resource(lookup = "jms/queue/OrderQueue")
    private Queue orderQueue;

    @EJB
    private NotificationService notificationService;

    @EJB
    private ProductService productService;

    @EJB
    private OrderService orderService;

    @EJB
    private UserService userService;

    @Override
    public void checkout(Map<Integer, Integer> cartItems, Integer customerId) {
        if (cartItems == null || cartItems.isEmpty()) return;

        String orderDetails = "Order: " + cartItems.toString();
        System.out.println("[CART SERVICE] Checking out items: " + cartItems);

        // Get customer details
        Users customer = userService.getAllUsers().stream()
                .filter(u -> u.getId().equals(customerId))
                .findFirst()
                .orElse(null);

        if (customer == null) {
            System.err.println("[CART SERVICE] Customer not found");
            return;
        }

        // Calculate total amount
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Map.Entry<Integer, Integer> entry : cartItems.entrySet()) {
            lk.sithikaDev.techmart.entity.Product product = productService.getProductById(entry.getKey());
            if (product != null) {
                totalAmount = totalAmount.add(product.getPrice().multiply(new BigDecimal(entry.getValue())));
            }
        }

        // Create Order record
        Order order = new Order();
        order.setCustomerId(customerId);
        order.setCustomerName(customer.getFirstName() + " " + customer.getLastName());
        order.setCustomerEmail(customer.getEmail());
        order.setOrderItems(cartItems.toString());
        order.setTotalAmount(totalAmount);
        order.setOrderDate(new Date());
        order.setOrderStatus("PENDING");
        orderService.createOrder(order);
        System.out.println("[CART SERVICE] Order created with ID: " + order.getId());

        // Reduce stock in database
        if (productService != null) {
            for (Map.Entry<Integer, Integer> entry : cartItems.entrySet()) {
                productService.updateStock(entry.getKey(), entry.getValue());
            }
        }
        
        try {
            // Send message to OrderQueue for MDB to process
            if (orderQueue != null && jmsContext != null) {
                jmsContext.createProducer().send(orderQueue, orderDetails);
            } else {
                System.err.println("[CART SERVICE] JMS resources not available. Checkout proceeding without notification.");
            }
        } catch (Exception e) {
            System.err.println("[CART SERVICE] Error sending JMS message: " + e.getMessage());
        }

        // Send purchase notification to admins asynchronously
        if (notificationService != null) {
            notificationService.sendPurchaseNotificationToAdmins(
                    customer.getFirstName() + " " + customer.getLastName(),
                    customer.getEmail(),
                    cartItems,
                    totalAmount
            );
        }

        // Asynchronous Notification (Requirement: Automated order processing with asynchronous notifications)
        if (notificationService != null) {
            notificationService.sendOrderConfirmation("ORD-" + System.currentTimeMillis(), customer.getEmail());
        }
    }
}
