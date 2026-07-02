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

@WebServlet(name = "CartServlet", value = "/cart")
public class CartServlet extends HttpServlet {

    @EJB
    private CartService cartService;

    @EJB
    private lk.sithikaDev.techmart.service.ProductService productService;

    @EJB
    private PerformanceMonitor performanceMonitor;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");

        performanceMonitor.incrementRequestCount("/cart-update");

        if (productIdStr != null) {
            Integer productId = Integer.parseInt(productIdStr);
            if ("add".equals(action)) {
                cartService.addItem(productId, 1);
            } else if ("remove".equals(action)) {
                cartService.removeItem(productId);
            }
        }

        response.sendRedirect("cart");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        performanceMonitor.incrementRequestCount("/cart-view");
        
        request.setAttribute("cartItems", cartService.getItems());
        
        java.util.List<lk.sithikaDev.techmart.entity.Product> products = new java.util.ArrayList<>();
        for (Integer pid : cartService.getItems().keySet()) {
            products.add(productService.getProductById(pid));
        }
        request.setAttribute("products", products);
        
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
}
