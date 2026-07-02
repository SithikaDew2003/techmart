package lk.sithikaDev.techmart.impl;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.annotation.Resource;
import jakarta.ejb.Stateful;
import jakarta.ejb.StatefulTimeout;
import jakarta.inject.Inject;
import jakarta.jms.JMSContext;
import jakarta.jms.Queue;
import lk.sithikaDev.techmart.service.CartService;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Stateful
@StatefulTimeout(value = 30, unit = TimeUnit.MINUTES)
public class CartServiceImpl implements CartService, Serializable {

    private Map<Integer, Integer> cartItems;

    @Inject
    private JMSContext jmsContext;

    @Resource(lookup = "jms/queue/OrderQueue")
    private Queue orderQueue;

    @PostConstruct
    public void init() {
        cartItems = new HashMap<>();
        System.out.println("[CART SERVICE] Created for a new session.");
    }

    @Override
    public void addItem(Integer productId, Integer quantity) {
        cartItems.put(productId, cartItems.getOrDefault(productId, 0) + quantity);
    }

    @Override
    public void removeItem(Integer productId) {
        cartItems.remove(productId);
    }

    @Override
    public Map<Integer, Integer> getItems() {
        return new HashMap<>(cartItems);
    }

    @Override
    public void checkout() {
        if (cartItems.isEmpty()) return;

        String orderDetails = "Order: " + cartItems.toString();
        System.out.println("[CART SERVICE] Checking out items: " + cartItems);
        
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
        
        clearCart();
    }

    @Override
    public void clearCart() {
        cartItems.clear();
    }

    @PreDestroy
    public void cleanup() {
        System.out.println("[CART SERVICE] Destroying session cart.");
    }
}
