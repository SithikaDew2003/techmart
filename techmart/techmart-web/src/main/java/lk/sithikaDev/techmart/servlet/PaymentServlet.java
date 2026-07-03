package lk.sithikaDev.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.sithikaDev.techmart.entity.CartItem;
import lk.sithikaDev.techmart.entity.Order;
import lk.sithikaDev.techmart.entity.Users;
import lk.sithikaDev.techmart.service.CartItemService;
import lk.sithikaDev.techmart.service.OrderService;
import lk.sithikaDev.techmart.service.PaymentService;
import lk.sithikaDev.techmart.dto.PaymentIntentInfo;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

@WebServlet(name = "PaymentServlet", value = "/payment")
public class PaymentServlet extends HttpServlet {

    @EJB
    private PaymentService paymentService;

    @EJB
    private CartItemService cartItemService;

    @EJB
    private OrderService orderService;

    @EJB
    private lk.sithikaDev.techmart.service.ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        Map<Integer, Integer> cart = cartItemService.getCartAsMap(user.getId());

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        // Calculate total
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            lk.sithikaDev.techmart.entity.Product product = productService.getProductById(entry.getKey());
            if (product != null) {
                totalAmount = totalAmount.add(product.getPrice().multiply(new BigDecimal(entry.getValue())));
            }
        }

        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("user", user);
        request.getRequestDispatcher("payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        String action = request.getParameter("action");

        try {
            if ("create_payment_intent".equals(action)) {
                handleCreatePaymentIntent(request, response);
            } else if ("confirm_payment".equals(action)) {
                handleConfirmPayment(request, response);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
            System.err.println("[PAYMENT SERVLET] Error: " + e.getMessage());
        }
    }

    private void handleCreatePaymentIntent(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"User not authenticated\"}");
            return;
        }

        Map<Integer, Integer> cart = cartItemService.getCartAsMap(user.getId());
        BigDecimal totalAmount = BigDecimal.ZERO;

        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            lk.sithikaDev.techmart.entity.Product product = productService.getProductById(entry.getKey());
            if (product != null) {
                totalAmount = totalAmount.add(product.getPrice().multiply(new BigDecimal(entry.getValue())));
            }
        }

        // Create order first
        Order order = new Order();
        order.setCustomerId(user.getId());
        order.setCustomerName(user.getFirstName() + " " + user.getLastName());
        order.setCustomerEmail(user.getEmail());
        order.setOrderItems(cart.toString());
        order.setTotalAmount(totalAmount);
        order.setOrderDate(new Date());
        order.setOrderStatus("PENDING_PAYMENT");
        orderService.createOrder(order);

        // Create Stripe PaymentIntent (service returns DTO)
        PaymentIntentInfo paymentIntent = paymentService.createPaymentIntent(totalAmount, "USD", order.getId().toString());

        String responseJson = "{\"clientSecret\": \"" + paymentIntent.getClientSecret() + "\", \"orderId\": " + order.getId() + "}";
        response.getWriter().write(responseJson);
        System.out.println("[PAYMENT SERVLET] PaymentIntent created: " + paymentIntent.getId());
    }

    private void handleConfirmPayment(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        Users user = (Users) session.getAttribute("user");

        String paymentIntentId = request.getParameter("paymentIntentId");
        String orderId = request.getParameter("orderId");

        if (user == null || paymentIntentId == null || orderId == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid request\"}");
            return;
        }

        Order order = orderService.getOrderById(Integer.parseInt(orderId));
        if (order == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"error\": \"Order not found\"}");
            return;
        }

        // Process payment confirmation
        lk.sithikaDev.techmart.entity.Payment payment = paymentService.processPaymentConfirmation(
                paymentIntentId,
                order.getId(),
                user.getId(),
                order.getTotalAmount()
        );

        if ("succeeded".equals(payment.getStatus())) {
            // Update order status
            order.setOrderStatus("CONFIRMED");
            orderService.updateOrder(order);

            // Clear cart
            cartItemService.clearCart(user.getId());

            response.getWriter().write("{\"success\": true, \"message\": \"Payment successful\", \"orderId\": " + order.getId() + "}");
            System.out.println("[PAYMENT SERVLET] Payment succeeded for order: " + order.getId());
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"Payment failed\"}");
            System.out.println("[PAYMENT SERVLET] Payment failed for order: " + order.getId());
        }
    }
}
