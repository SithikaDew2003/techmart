package lk.sithikaDev.techmart.service;

import jakarta.ejb.Local;
import lk.sithikaDev.techmart.dto.PaymentIntentInfo;
import lk.sithikaDev.techmart.entity.Payment;

import java.math.BigDecimal;
import java.util.List;

@Local
public interface PaymentService {
    // Return a DTO to avoid exposing Stripe SDK classes in service signatures
    PaymentIntentInfo createPaymentIntent(BigDecimal amount, String currency, String orderId) throws Exception;
    Payment processPaymentConfirmation(String paymentIntentId, Integer orderId, Integer customerId, BigDecimal amount) throws Exception;
    Payment getPaymentByStripeId(String stripePaymentIntentId);
    Payment getPaymentByOrderId(Integer orderId);
    void savePayment(Payment payment);
    void updatePaymentStatus(Integer paymentId, String status);
    List<Payment> getPaymentsByCustomerId(Integer customerId);
}
