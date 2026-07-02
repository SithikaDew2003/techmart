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
import lk.sithikaDev.techmart.service.UserService;

import java.io.IOException;

@WebServlet(value = "/admin-login")
public class AdminLoginServlet extends HttpServlet {

    @EJB
    private UserService userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Users user = userService.login(email, password);

        if (user != null && user.getUserType() == UserType.ADMIN) {
            HttpSession session = request.getSession();
            session.setAttribute("admin", user);
            response.sendRedirect("admin-panel");
        } else {
            request.setAttribute("error", "Invalid Admin Credentials");
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
        }
    }
}
