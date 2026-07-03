package lk.sithikaDev.techmart.impl;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.sithikaDev.techmart.entity.Payment;
import lk.sithikaDev.techmart.service.PaymentService;
import lk.sithikaDev.techmart.dto.PaymentIntentInfo;
import com.stripe.Stripe;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Stateless
public class PaymentServiceImpl implements PaymentService {

    @PersistenceContext(unitName = "TechmartPU")
    private EntityManager entityManager;

    // Stripe Secret Key - Store this securely in environment variables in production
    private static final String STRIPE_SECRET_KEY = "sk_test_51TF7U82LY9N7Z9csuId1QqmEHIzRnOS1EZaLY2AqXNePJykXADWzg1eKCdnYYx2BHwjv9ZhIKKO6mEYHCUeYScUT00R42EM8Ht";

    @Override
    public PaymentIntentInfo createPaymentIntent(BigDecimal amount, String currency, String orderId) throws Exception {
        try {
            Stripe.apiKey = STRIPE_SECRET_KEY;
            
            // Amount should be in cents for Stripe
            long amountInCents = amount.multiply(new BigDecimal(100)).longValue();
            
            PaymentIntentCreateParams params = PaymentIntentCreateParams.builder()
                    .setAmount(amountInCents)
                    .setCurrency(currency.toLowerCase())
                    .putMetadata("orderId", orderId)
                    .putMetadata("source", "techmart")
                    .build();
            
            PaymentIntent paymentIntent = PaymentIntent.create(params);
            System.out.println("[PAYMENT SERVICE] Created PaymentIntent: " + paymentIntent.getId() + " for order: " + orderId);

            // Return small DTO with id and client secret so interfaces don't expose Stripe types
            PaymentIntentInfo info = new PaymentIntentInfo(paymentIntent.getId(), paymentIntent.getClientSecret());
            return info;
        } catch (Exception e) {
            System.err.println("[PAYMENT SERVICE] Error creating PaymentIntent: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public Payment processPaymentConfirmation(String paymentIntentId, Integer orderId, Integer customerId, BigDecimal amount) throws Exception {
        try {
            Stripe.apiKey = STRIPE_SECRET_KEY;
            
            PaymentIntent paymentIntent = PaymentIntent.retrieve(paymentIntentId);
            
            Payment payment = new Payment();
            payment.setOrderId(orderId);
            payment.setCustomerId(customerId);
            payment.setStripePaymentIntentId(paymentIntentId);
            payment.setAmount(amount);
            payment.setCurrency("USD");
            payment.setStatus(paymentIntent.getStatus());
            payment.setPaymentDate(new Date());
            payment.setCreatedAt(new Date());
            
            // Extract card details from payment method
            // Set default card info (can be enhanced based on Stripe response)
            payment.setCardBrand("stripe");
            payment.setCardLastFour(paymentIntentId.substring(Math.max(0, paymentIntentId.length() - 4)));
            
            entityManager.persist(payment);
            System.out.println("[PAYMENT SERVICE] Payment processed and saved: " + payment.getId() + " with status: " + payment.getStatus());
            
            return payment;
        } catch (Exception e) {
            System.err.println("[PAYMENT SERVICE] Error processing payment: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public Payment getPaymentByStripeId(String stripePaymentIntentId) {
        List<Payment> results = entityManager.createQuery(
                "SELECT p FROM Payment p WHERE p.stripePaymentIntentId = :stripeId",
                Payment.class
        ).setParameter("stripeId", stripePaymentIntentId).getResultList();
        
        return results.isEmpty() ? null : results.get(0);
    }

    @Override
    public Payment getPaymentByOrderId(Integer orderId) {
        List<Payment> results = entityManager.createQuery(
                "SELECT p FROM Payment p WHERE p.orderId = :orderId",
                Payment.class
        ).setParameter("orderId", orderId).getResultList();
        
        return results.isEmpty() ? null : results.get(0);
    }

    @Override
    public void savePayment(Payment payment) {
        if (payment.getCreatedAt() == null) {
            payment.setCreatedAt(new Date());
        }
        entityManager.persist(payment);
        System.out.println("[PAYMENT SERVICE] Payment saved: " + payment.getId());
    }

    @Override
    public void updatePaymentStatus(Integer paymentId, String status) {
        Payment payment = entityManager.find(Payment.class, paymentId);
        if (payment != null) {
            payment.setStatus(status);
            entityManager.merge(payment);
            System.out.println("[PAYMENT SERVICE] Payment status updated: " + paymentId + " -> " + status);
        }
    }

    @Override
    public List<Payment> getPaymentsByCustomerId(Integer customerId) {
        return entityManager.createQuery(
                "SELECT p FROM Payment p WHERE p.customerId = :customerId ORDER BY p.createdAt DESC",
                Payment.class
        ).setParameter("customerId", customerId).getResultList();
    }
}
