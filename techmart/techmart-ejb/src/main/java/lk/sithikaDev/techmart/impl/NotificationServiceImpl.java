package lk.sithikaDev.techmart.impl;

import jakarta.annotation.Resource;
import jakarta.ejb.Stateless;
import jakarta.jms.ConnectionFactory;
import jakarta.jms.JMSContext;
import jakarta.jms.Queue;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.sithikaDev.techmart.dto.NotificationPayload;
import lk.sithikaDev.techmart.entity.Notification;
import lk.sithikaDev.techmart.service.NotificationService;

import java.util.List;

@Stateless
public class NotificationServiceImpl implements NotificationService {

    @PersistenceContext(unitName = "TechmartPU")
    private EntityManager entityManager;

    @Resource(lookup = "jms/NotificationConnectionFactory")
    private ConnectionFactory connectionFactory;

    @Resource(lookup = "jms/NotificationResource")
    private Queue notificationQueue;

    private void sendJms(NotificationPayload payload) {
        try (JMSContext ctx = connectionFactory.createContext()) {
            ctx.createProducer().send(notificationQueue, payload);
            System.out.println("[JMS] Sent notification payload: " + payload.getType());
        } catch (Exception e) {
            System.err.println("[JMS] Error sending payload: " + e.getMessage());
        }
    }

    @Override
    public void sendNotification(String userId, String message) {
        NotificationPayload payload = new NotificationPayload();
        payload.setType(NotificationPayload.Type.SIMPLE);
        payload.setUserId(userId);
        payload.setMessage(message);
        sendJms(payload);
    }

    @Override
    public void sendOrderConfirmation(String orderId, String email) {
        NotificationPayload payload = new NotificationPayload();
        payload.setType(NotificationPayload.Type.ORDER_CONFIRM);
        payload.setMessage("Order confirmation ORD-" + orderId + " has been processed.");
        // we'll resolve the user by email in MDB
        payload.setCustomerEmail(email);
        sendJms(payload);
    }

    @Override
    public void sendPurchaseNotificationToAdmins(String customerName, String customerEmail, java.util.Map<Integer, Integer> cartItems, java.math.BigDecimal totalAmount) {
        NotificationPayload payload = new NotificationPayload();
        payload.setType(NotificationPayload.Type.PURCHASE);
        payload.setCustomerName(customerName);
        payload.setCustomerEmail(customerEmail);
        payload.setCartItems(cartItems);
        payload.setTotalAmount(totalAmount);
        sendJms(payload);
    }

    @Override
    public List<Notification> getNotificationsForUser(String userId) {
        return entityManager.createQuery(
                "SELECT n FROM Notification n WHERE n.userId = :userId ORDER BY n.createdTime DESC",
                Notification.class
        ).setParameter("userId", userId).getResultList();
    }

    @Override
    public void markAllAsRead(String userId) {
        entityManager.createQuery("UPDATE Notification n SET n.isRead = true WHERE n.userId = :userId AND n.isRead = false")
                .setParameter("userId", userId)
                .executeUpdate();
    }
}
