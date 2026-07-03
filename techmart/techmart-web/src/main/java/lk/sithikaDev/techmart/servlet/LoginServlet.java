package lk.sithikaDev.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.sithikaDev.techmart.entity.Users;
import lk.sithikaDev.techmart.service.CartItemService;
import lk.sithikaDev.techmart.service.PerformanceMonitor;
import lk.sithikaDev.techmart.service.UserService;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {

    @EJB
    private UserService userService;

    @EJB
    private PerformanceMonitor performanceMonitor;

    @EJB
    private CartItemService cartItemService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        performanceMonitor.incrementRequestCount("/login");

        Users user = userService.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Transfer session cart to DB cart
            Map<Integer, Integer> sessionCart = (Map<Integer, Integer>) session.getAttribute("cart");
            if (sessionCart != null && !sessionCart.isEmpty()) {
                System.out.println("[LOGIN SERVLET] Transferring session cart to DB for user: " + user.getId());
                for (Map.Entry<Integer, Integer> entry : sessionCart.entrySet()) {
                    cartItemService.addCartItem(user.getId(), entry.getKey(), entry.getValue());
                }
                session.removeAttribute("cart");
                System.out.println("[LOGIN SERVLET] Session cart transferred successfully");
            }
            
            response.sendRedirect("home");
        } else {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}

