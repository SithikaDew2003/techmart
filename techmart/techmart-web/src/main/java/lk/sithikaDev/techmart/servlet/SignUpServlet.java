package lk.sithikaDev.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.sithikaDev.techmart.entity.UserType;
import lk.sithikaDev.techmart.entity.Users;
import lk.sithikaDev.techmart.service.CartItemService;
import lk.sithikaDev.techmart.service.PerformanceMonitor;
import lk.sithikaDev.techmart.service.UserService;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "SignUpServlet", value = "/signup")
public class SignUpServlet extends HttpServlet {

    @EJB
    private UserService userService;

    @EJB
    private PerformanceMonitor performanceMonitor;

    @EJB
    private CartItemService cartItemService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        performanceMonitor.incrementRequestCount("/signup");
        request.getRequestDispatcher("signup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        boolean hasError = false;

        if (firstName == null || firstName.trim().isEmpty()) {
            request.setAttribute("firstNameError", "First name is required.");
            hasError = true;
        }

        if (lastName == null || lastName.trim().isEmpty()) {
            request.setAttribute("lastNameError", "Last name is required.");
            hasError = true;
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("emailError", "Email is required.");
            hasError = true;
        } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("emailError", "Invalid email format.");
            hasError = true;
        } else if (userService.isEmailExists(email)) {
            request.setAttribute("emailError", "This email is already associated with an account.");
            hasError = true;
        }

        if (password == null || password.isEmpty()) {
            request.setAttribute("passwordError", "Password is required.");
            hasError = true;
        } else if (password.length() < 6) {
            request.setAttribute("passwordError", "Password must be at least 6 characters.");
            hasError = true;
        }

        if (confirmPassword == null || !confirmPassword.equals(password)) {
            request.setAttribute("confirmPasswordError", "Passwords do not match.");
            hasError = true;
        }

        if (hasError) {
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        Users user = new Users();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPassword(password); // Note: In a real app, password should be hashed
        user.setUserType(UserType.CUSTOMER);

        try {
            userService.signUp(user);
            
            // Fetch the newly created user and set in session
            Users newUser = userService.login(email, password);
            if (newUser != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", newUser);
                
                // Transfer session cart to DB cart
                Map<Integer, Integer> sessionCart = (Map<Integer, Integer>) session.getAttribute("cart");
                if (sessionCart != null && !sessionCart.isEmpty()) {
                    System.out.println("[SIGNUP SERVLET] Transferring session cart to DB for user: " + newUser.getId());
                    for (Map.Entry<Integer, Integer> entry : sessionCart.entrySet()) {
                        cartItemService.addCartItem(newUser.getId(), entry.getKey(), entry.getValue());
                    }
                    session.removeAttribute("cart");
                    System.out.println("[SIGNUP SERVLET] Session cart transferred successfully");
                }
            }
            
            response.sendRedirect("home?success=Signup successful");
        } catch (Exception e) {
            request.setAttribute("error", "Error during signup: " + e.getMessage());
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
}

