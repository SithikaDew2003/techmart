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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CartServlet", value = "/cart")
public class CartServlet extends HttpServlet {

    @EJB
    private CartItemService cartItemService;

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
            jakarta.servlet.http.HttpSession session = request.getSession();
            Users user = (Users) session.getAttribute("user");

            if (user != null) {
                // User is signed in - use DB cart
                if ("add".equals(action)) {
                    cartItemService.addCartItem(user.getId(), productId, 1);
                } else if ("remove".equals(action)) {
                    cartItemService.removeCartItem(user.getId(), productId);
                }
            } else {
                // User is NOT signed in - use session cart
                Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
                if (cart == null) {
                    cart = new HashMap<>();
                    session.setAttribute("cart", cart);
                }

                if ("add".equals(action)) {
                    cart.put(productId, cart.getOrDefault(productId, 0) + 1);
                } else if ("remove".equals(action)) {
                    cart.remove(productId);
                }
            }
        }

        response.sendRedirect("cart");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        performanceMonitor.incrementRequestCount("/cart-view");
        
        jakarta.servlet.http.HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        Map<Integer, Integer> cartItems = new HashMap<>();

        if (user != null) {
            // User is signed in - get cart from DB
            cartItems = cartItemService.getCartAsMap(user.getId());
            System.out.println("[CART SERVLET] Retrieved DB cart for user: " + user.getId());
        } else {
            // User is NOT signed in - get cart from session
            Map<Integer, Integer> sessionCart = (Map<Integer, Integer>) session.getAttribute("cart");
            if (sessionCart == null) {
                sessionCart = new HashMap<>();
                session.setAttribute("cart", sessionCart);
            }
            cartItems = sessionCart;
            System.out.println("[CART SERVLET] Retrieved session cart");
        }

        request.setAttribute("cartItems", cartItems);
        
        List<lk.sithikaDev.techmart.entity.Product> products = new ArrayList<>();
        for (Integer pid : cartItems.keySet()) {
            products.add(productService.getProductById(pid));
        }
        request.setAttribute("products", products);
        
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
}

