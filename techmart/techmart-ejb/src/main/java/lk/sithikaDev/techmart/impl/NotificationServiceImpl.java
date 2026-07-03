package lk.sithikaDev.techmart.impl;

import jakarta.ejb.Asynchronous;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.sithikaDev.techmart.entity.Notification;
import lk.sithikaDev.techmart.entity.UserType;
import lk.sithikaDev.techmart.entity.Users;
import lk.sithikaDev.techmart.service.NotificationService;

import java.util.Date;
import java.util.List;

@Stateless
public class NotificationServiceImpl implements NotificationService {

    @PersistenceContext(unitName = "TechmartPU")
    private EntityManager entityManager;

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
        
        try {
            Notification notification = new Notification();
            notification.setUserId(userId);
            notification.setMessage(message);
            notification.setCreatedTime(new Date());
            notification.setRead(false);
            entityManager.persist(notification);
            System.out.println("[ASYNC] Persisted notification to DB: " + message);
        } catch (Exception e) {
            System.err.println("[ASYNC] Error persisting notification: " + e.getMessage());
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
        
        try {
            List<Users> users = entityManager.createQuery("SELECT u FROM Users u WHERE LOWER(u.email) = LOWER(:email)", Users.class)
                    .setParameter("email", email.trim().toLowerCase())
                    .getResultList();
            if (!users.isEmpty()) {
                Users user = users.get(0);
                Notification notification = new Notification();
                notification.setUserId(String.valueOf(user.getId()));
                notification.setMessage("Order confirmation ORD-" + orderId + " has been processed.");
                notification.setCreatedTime(new Date());
                notification.setRead(false);
                entityManager.persist(notification);
                System.out.println("[ASYNC] Persisted order notification to DB for user " + user.getId());
            }
        } catch (Exception e) {
            System.err.println("[ASYNC] Error persisting order notification: " + e.getMessage());
        }
        
        System.out.println("[ASYNC] Confirmation email sent to " + email + " for order " + orderId);
    }

    @Override
    @Asynchronous
    public void sendPurchaseNotificationToAdmins(String customerName, String customerEmail, java.util.Map<Integer, Integer> cartItems, java.math.BigDecimal totalAmount) {
        System.out.println("[ASYNC] Preparing purchase notification for admins");
        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        try {
            // Find all admin users
            List<Users> admins = entityManager.createQuery(
                    "SELECT u FROM Users u WHERE u.userType = :userType",
                    Users.class
            ).setParameter("userType", UserType.ADMIN).getResultList();

            // Send notification to each admin
            for (Users admin : admins) {
                Notification notification = new Notification();
                notification.setUserId(String.valueOf(admin.getId()));
                String itemsInfo = cartItems.size() + " item(s)";
                notification.setMessage("New Purchase! Customer: " + customerName + " (" + customerEmail + ") purchased " + itemsInfo + " - Total: $" + totalAmount);
                notification.setCreatedTime(new Date());
                notification.setRead(false);
                entityManager.persist(notification);
                System.out.println("[ASYNC] Admin notification sent to: " + admin.getEmail());
            }
        } catch (Exception e) {
            System.err.println("[ASYNC] Error sending purchase notification to admins: " + e.getMessage());
        }
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
