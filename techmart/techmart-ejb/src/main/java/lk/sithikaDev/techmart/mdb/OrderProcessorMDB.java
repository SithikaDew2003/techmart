package lk.sithikaDev.techmart.mdb;

import jakarta.ejb.ActivationConfigProperty;
import jakarta.ejb.EJB;
import jakarta.ejb.MessageDriven;
import jakarta.jms.JMSException;
import jakarta.jms.Message;
import jakarta.jms.MessageListener;
import jakarta.jms.TextMessage;
import lk.sithikaDev.techmart.service.ProductService;

@MessageDriven(activationConfig = {
    @ActivationConfigProperty(propertyName = "destinationLookup", propertyValue = "jms/queue/OrderQueue"),
    @ActivationConfigProperty(propertyName = "destinationType", propertyValue = "jakarta.jms.Queue")
})
public class OrderProcessorMDB implements MessageListener {

    @EJB
    private ProductService productService;

    @Override
    public void onMessage(Message message) {
        try {
            if (message instanceof TextMessage) {
                String orderData = ((TextMessage) message).getText();
                System.out.println("[MDB] Received order processing request: " + orderData);
                
                // Requirement: Real-time inventory synchronization across multiple warehouses
                // Mocking inventory update logic: "Order: {1=2, 3=1}"
                if (orderData.startsWith("Order: {")) {
                    String items = orderData.substring(8, orderData.length() - 1);
                    String[] pairs = items.split(", ");
                    for (String pair : pairs) {
                        String[] kv = pair.split("=");
                        if (kv.length == 2) {
                            Integer productId = Integer.parseInt(kv[0]);
                            Integer quantity = Integer.parseInt(kv[1]);
                            System.out.println("[MDB] Syncing inventory for Product ID: " + productId + ", Quantity: " + quantity);
                            productService.updateStock(productId, quantity);
                        }
                    }
                }

                // Simulate intensive order processing
                Thread.sleep(2000);
                System.out.println("[MDB] Order processed successfully: " + orderData);
            }
        } catch (JMSException | InterruptedException e) {
            System.err.println("[MDB] Error processing order message: " + e.getMessage());
        }
    }
}
