package lk.sithikaDev.techmart.mdb;

import jakarta.ejb.ActivationConfigProperty;
import jakarta.ejb.MessageDriven;
import jakarta.jms.JMSException;
import jakarta.jms.Message;
import jakarta.jms.MessageListener;
import jakarta.jms.ObjectMessage;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.sithikaDev.techmart.dto.NotificationPayload;
import lk.sithikaDev.techmart.entity.Notification;
import lk.sithikaDev.techmart.entity.UserType;
import lk.sithikaDev.techmart.entity.Users;

import java.util.Date;
import java.util.List;

@MessageDriven(activationConfig = {
        @ActivationConfigProperty(propertyName = "destinationLookup", propertyValue = "jms/NotificationResource"),
        @ActivationConfigProperty(propertyName = "destinationType", propertyValue = "jakarta.jms.Queue")
})
public class NotificationMDB implements MessageListener {

    @PersistenceContext(unitName = "TechmartPU")
    private EntityManager entityManager;

    @Override
    public void onMessage(Message message) {
        try {
            if (message instanceof ObjectMessage) {
                Object obj = ((ObjectMessage) message).getObject();
                if (obj instanceof NotificationPayload) {
                    processPayload((NotificationPayload) obj);
                }
            }
        } catch (JMSException e) {
            System.err.println("[MDB] JMS error: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("[MDB] Processing error: " + e.getMessage());
        }
    }

    private void processPayload(NotificationPayload payload) {
        if (payload.getType() == NotificationPayload.Type.SIMPLE) {
            persistForUser(payload.getUserId(), payload.getMessage());
        } else if (payload.getType() == NotificationPayload.Type.ORDER_CONFIRM) {
            // find user by email
            if (payload.getCustomerEmail() != null) {
                List<Users> users = entityManager.createQuery("SELECT u FROM Users u WHERE LOWER(u.email) = LOWER(:email)", Users.class)
                        .setParameter("email", payload.getCustomerEmail().trim().toLowerCase())
                        .getResultList();
                if (!users.isEmpty()) {
                    Users u = users.get(0);
                    persistForUser(String.valueOf(u.getId()), payload.getMessage());
                }
            }
        } else if (payload.getType() == NotificationPayload.Type.PURCHASE) {
            // send to all admins
            List<Users> admins = entityManager.createQuery("SELECT u FROM Users u WHERE u.userType = :type", Users.class)
                    .setParameter("type", UserType.ADMIN).getResultList();

            String itemsInfo = payload.getCartItems() != null ? payload.getCartItems().size() + " item(s)" : "items";
            String msg = "New Purchase! Customer: " + payload.getCustomerName() + " (" + payload.getCustomerEmail() + ") purchased " + itemsInfo + " - Total: $" + payload.getTotalAmount();
            for (Users admin : admins) {
                persistForUser(String.valueOf(admin.getId()), msg);
            }
        }
    }

    private void persistForUser(String userId, String message) {
        try {
            Notification n = new Notification();
            n.setUserId(userId);
            n.setMessage(message);
            n.setCreatedTime(new Date());
            n.setRead(false);
            entityManager.persist(n);
            System.out.println("[MDB] Persisted notification for user " + userId);
        } catch (Exception e) {
            System.err.println("[MDB] Could not persist notification: " + e.getMessage());
        }
    }
}
