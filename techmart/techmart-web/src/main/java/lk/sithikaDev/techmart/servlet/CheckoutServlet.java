package lk.sithikaDev.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.sithikaDev.techmart.service.CartService;
import lk.sithikaDev.techmart.service.PerformanceMonitor;

import java.io.IOException;

@WebServlet(name = "CheckoutServlet", value = "/checkout")
public class CheckoutServlet extends HttpServlet {

    @EJB
    private CartService cartService;

    @EJB
    private PerformanceMonitor performanceMonitor;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        performanceMonitor.incrementRequestCount("/checkout");
        cartService.checkout();
        response.sendRedirect("index.jsp?success=Order placed successfully!");
    }
}
