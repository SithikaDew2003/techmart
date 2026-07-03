package lk.sithikaDev.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.sithikaDev.techmart.entity.Users;
import lk.sithikaDev.techmart.service.CartItemService;
import lk.sithikaDev.techmart.service.PerformanceMonitor;

import java.io.IOException;

@WebServlet(name = "CheckoutServlet", value = "/checkout")
public class CheckoutServlet extends HttpServlet {

    @EJB
    private CartItemService cartItemService;

    @EJB
    private PerformanceMonitor performanceMonitor;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect GET requests to cart page
        response.sendRedirect("cart");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        performanceMonitor.incrementRequestCount("/checkout");
        
        jakarta.servlet.http.HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Require login for checkout
        if (user == null) {
            System.out.println("[CHECKOUT SERVLET] User not signed in, redirecting to login");
            session.setAttribute("redirectAfterLogin", "checkout");
            response.sendRedirect("login");
            return;
        }
        
        java.util.Map<Integer, Integer> cart = cartItemService.getCartAsMap(user.getId());
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }
        
        // Route to payment page for Stripe payment processing
        response.sendRedirect("payment");
    }
}



