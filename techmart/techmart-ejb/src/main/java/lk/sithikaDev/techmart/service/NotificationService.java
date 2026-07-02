package lk.sithikaDev.techmart.service;

import jakarta.ejb.Local;

@Local
public interface NotificationService {
    void sendNotification(String userId, String message);
    void sendOrderConfirmation(String orderId, String email);
}
