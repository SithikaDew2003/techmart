package lk.sithikaDev.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lk.sithikaDev.techmart.entity.Product;
import lk.sithikaDev.techmart.entity.Users;
import lk.sithikaDev.techmart.service.ProductService;
import lk.sithikaDev.techmart.service.UserService;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

@WebServlet(value = "/admin-panel")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 5 * 5
)
public class AdminPanelServlet extends HttpServlet {

    @EJB
    private ProductService productService;

    @EJB
    private UserService userService;

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("admin-login");
            return;
        }

        String action = request.getParameter("action");

        if ("deleteProduct".equals(action)) {
            Integer id = Integer.parseInt(request.getParameter("id"));
            productService.deleteProduct(id);
        } else if ("deleteUser".equals(action)) {
            Integer id = Integer.parseInt(request.getParameter("id"));
            userService.deleteUser(id);
        }

        List<Product> products = productService.getAllProducts();
        List<Users> users = userService.getAllUsers();

        request.setAttribute("products", products);
        request.setAttribute("users", users);
        request.getRequestDispatcher("admin-panel.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("admin-login");
            return;
        }

        String action = request.getParameter("action");

        if ("addProduct".equals(action)) {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            Integer stock = Integer.parseInt(request.getParameter("stock"));

            Part filePart = request.getPart("image");
            String fileName = getFileName(filePart);

            String imagePath = null;

            if (fileName != null && !fileName.isEmpty()) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                Path filePath = Paths.get(uploadPath, fileName);

                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                }

                imagePath = UPLOAD_DIR + "/" + fileName;
            }

            Product product = new Product();
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setStockQuantity(stock);
            product.setImagePath(imagePath);

            productService.addProduct(product);
        }

        response.sendRedirect("admin-panel");
    }

    private String getFileName(Part part) {
        if (part == null || part.getSubmittedFileName() == null) {
            return null;
        }

        return Paths.get(part.getSubmittedFileName())
                .getFileName()
                .toString();
    }
}