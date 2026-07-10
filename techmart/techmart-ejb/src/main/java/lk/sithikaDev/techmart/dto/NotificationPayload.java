package lk.sithikaDev.techmart.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Map;

public class NotificationPayload implements Serializable {
    public enum Type { SIMPLE, ORDER_CONFIRM, PURCHASE }

    private Type type;
    private String userId; // optional: target user id
    private String message; // optional: preformatted message

    // purchase details
    private String customerName;
    private String customerEmail;
    private Map<Integer, Integer> cartItems;
    private BigDecimal totalAmount;

    public NotificationPayload() {}

    // getters and setters
    public Type getType() { return type; }
    public void setType(Type type) { this.type = type; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public Map<Integer, Integer> getCartItems() { return cartItems; }
    public void setCartItems(Map<Integer, Integer> cartItems) { this.cartItems = cartItems; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
}
