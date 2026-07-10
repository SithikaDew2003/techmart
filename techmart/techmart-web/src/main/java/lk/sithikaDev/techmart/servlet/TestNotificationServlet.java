package lk.sithikaDev.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.sithikaDev.techmart.service.NotificationService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "TestNotificationServlet", value = "/test-send-notification")
public class TestNotificationServlet extends HttpServlet {

    @EJB
    private NotificationService notificationService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/plain; charset=UTF-8");

        if (notificationService == null) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("NotificationService not injected. Check EJB availability.");
            return;
        }

        // Build a small test purchase payload
        Map<Integer, Integer> cart = new HashMap<>();
        cart.put(1, 2);
        cart.put(2, 1);
        BigDecimal total = new BigDecimal("549.98");

        try {
            notificationService.sendPurchaseNotificationToAdmins("Test Customer", "test@example.com", cart, total);
            resp.getWriter().write("Test purchase notification sent to JMS via NotificationService.");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Error sending test notification: " + e.getMessage());
        }
    }
}
