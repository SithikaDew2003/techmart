package lk.sithikaDev.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.sithikaDev.techmart.service.NotificationService;
import lk.sithikaDev.techmart.service.PerformanceMonitor;

import java.io.IOException;
import java.util.Date;
import java.util.Map;

@WebServlet(name = "DashboardServlet", value = "/dashboard")
public class DashboardServlet extends HttpServlet {

    @EJB
    private PerformanceMonitor performanceMonitor;

    @EJB
    private NotificationService notificationService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        performanceMonitor.incrementRequestCount("/dashboard");

        Map<String, Long> stats = performanceMonitor.getRequestStatistics();

        request.setAttribute("stats", stats);
        request.setAttribute("totalRequests", performanceMonitor.getTotalRequests());
        request.setAttribute("activeSessions", performanceMonitor.getActiveSessions());

        request.setAttribute("usedMemory", performanceMonitor.getUsedMemory());
        request.setAttribute("freeMemory", performanceMonitor.getFreeMemory());
        request.setAttribute("maxMemory", performanceMonitor.getMaxMemory());
        request.setAttribute("uptimeSeconds", performanceMonitor.getUptimeSeconds());
        request.setAttribute("availableProcessors", performanceMonitor.getAvailableProcessors());
        request.setAttribute("activeThreadCount", performanceMonitor.getActiveThreadCount());
        request.setAttribute("mostVisitedEndpoint", performanceMonitor.getMostVisitedEndpoint());
        request.setAttribute("averageRequestsPerEndpoint", performanceMonitor.getAverageRequestsPerEndpoint());
        request.setAttribute("serverTime", new Date());

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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