package lk.sithikaDev.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.sithikaDev.techmart.service.PerformanceMonitor;
import lk.sithikaDev.techmart.service.NotificationService;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "DashboardServlet", value = "/dashboard")
public class DashboardServlet extends HttpServlet {

    @EJB
    private PerformanceMonitor performanceMonitor;

    @EJB
    private NotificationService notificationService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Track dashboard visit
        performanceMonitor.incrementRequestCount("/dashboard");

        // Prepare data for JSP
        Map<String, Long> stats = performanceMonitor.getRequestStatistics();
        long totalRequests = performanceMonitor.getTotalRequests();

        request.setAttribute("stats", stats);
        request.setAttribute("totalRequests", totalRequests);
        request.setAttribute("activeSessions", performanceMonitor.getActiveSessions());

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("testAsync".equals(action)) {
            String email = request.getParameter("email");
            notificationService.sendOrderConfirmation("TEST-ORDER-123", email);
            request.setAttribute("message", "Asynchronous order confirmation triggered for " + email);
        } else if ("resetStats".equals(action)) {
            performanceMonitor.resetStatistics();
            request.setAttribute("message", "Performance statistics have been reset.");
        }

        doGet(request, response);
    }
}
