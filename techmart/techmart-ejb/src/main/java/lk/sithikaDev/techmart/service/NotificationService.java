package lk.sithikaDev.techmart.service;

import jakarta.ejb.Remote;

@Remote
public interface NotificationService {
    void sendNotification(String userId, String message);
    void sendOrderConfirmation(String orderId, String email);
}
