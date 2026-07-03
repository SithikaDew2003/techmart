package lk.sithikaDev.techmart.service;

import jakarta.ejb.Local;

@Local
public interface NotificationService {
    void sendNotification(String userId, String message);
    void sendOrderConfirmation(String orderId, String email);
    void sendPurchaseNotificationToAdmins(String customerName, String customerEmail, java.util.Map<Integer, Integer> cartItems, java.math.BigDecimal totalAmount);
    java.util.List<lk.sithikaDev.techmart.entity.Notification> getNotificationsForUser(String userId);
    void markAllAsRead(String userId);
}
