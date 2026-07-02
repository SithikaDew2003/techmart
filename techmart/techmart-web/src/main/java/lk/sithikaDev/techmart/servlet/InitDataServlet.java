package lk.sithikaDev.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.sithikaDev.techmart.entity.Product;
import lk.sithikaDev.techmart.entity.UserType;
import lk.sithikaDev.techmart.entity.Users;
import lk.sithikaDev.techmart.service.ProductService;
import lk.sithikaDev.techmart.service.UserService;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "InitDataServlet", value = "/init-data")
public class InitDataServlet extends HttpServlet {

    @EJB
    private ProductService productService;

    @EJB
    private UserService userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Add Sample Products
            if (productService.getAllProducts().isEmpty()) {
                Product p1 = new Product();
                p1.setName("Gaming Laptop");
                p1.setDescription("High-performance gaming laptop with RTX 4080");
                p1.setPrice(new BigDecimal("2499.99"));
                p1.setStockQuantity(10);
                productService.addProduct(p1);

                Product p2 = new Product();
                p2.setName("Wireless Mouse");
                p2.setDescription("Ergonomic wireless gaming mouse");
                p2.setPrice(new BigDecimal("79.50"));
                p2.setStockQuantity(50);
                productService.addProduct(p2);

                Product p3 = new Product();
                p3.setName("Mechanical Keyboard");
                p3.setDescription("RGB Mechanical keyboard with Blue Switches");
                p3.setPrice(new BigDecimal("129.99"));
                p3.setStockQuantity(30);
                productService.addProduct(p3);
            }

            // Add Admin User
            if (!userService.isEmailExists("admin@techmart.com")) {
                Users admin = new Users();
                admin.setFirstName("System");
                admin.setLastName("Admin");
                admin.setEmail("admin@techmart.com");
                admin.setPassword("admin123");
                admin.setUserType(UserType.ADMIN);
                userService.signUp(admin);
            }

            response.getWriter().println("Sample data initialized successfully.");
        } catch (Exception e) {
            response.getWriter().println("Error initializing data: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
