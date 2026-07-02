package lk.sithikaDev.techmart.mdb;

import jakarta.ejb.ActivationConfigProperty;
import jakarta.ejb.MessageDriven;
import jakarta.jms.JMSException;
import jakarta.jms.Message;
import jakarta.jms.MessageListener;
import jakarta.jms.TextMessage;

@MessageDriven(activationConfig = {
    @ActivationConfigProperty(propertyName = "destinationLookup", propertyValue = "jms/queue/OrderQueue"),
    @ActivationConfigProperty(propertyName = "destinationType", propertyValue = "jakarta.jms.Queue")
})
public class OrderProcessorMDB implements MessageListener {

    @Override
    public void onMessage(Message message) {
        try {
            if (message instanceof TextMessage) {
                String orderData = ((TextMessage) message).getText();
                System.out.println("[MDB] Received order processing request: " + orderData);
                // Simulate intensive order processing
                Thread.sleep(2000);
                System.out.println("[MDB] Order processed successfully: " + orderData);
            }
        } catch (JMSException | InterruptedException e) {
            System.err.println("[MDB] Error processing order message: " + e.getMessage());
        }
    }
}
