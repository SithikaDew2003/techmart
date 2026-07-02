package lk.sithikaDev.techmart.impl;

import jakarta.ejb.Asynchronous;
import jakarta.ejb.Stateless;
import lk.sithikaDev.techmart.service.NotificationService;

@Stateless
public class NotificationServiceImpl implements NotificationService {

    @Override
    @Asynchronous
    public void sendNotification(String userId, String message) {
        System.out.println("[ASYNC] Starting notification for user: " + userId);
        try {
            // Simulate processing delay
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        System.out.println("[ASYNC] Notification sent to user " + userId + ": " + message);
    }

    @Override
    @Asynchronous
    public void sendOrderConfirmation(String orderId, String email) {
        System.out.println("[ASYNC] Preparing order confirmation for: " + orderId);
        try {
            // Simulate complex email generation
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        System.out.println("[ASYNC] Confirmation email sent to " + email + " for order " + orderId);
    }
}
