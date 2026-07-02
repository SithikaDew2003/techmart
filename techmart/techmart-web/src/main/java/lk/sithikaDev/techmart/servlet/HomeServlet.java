package lk.sithikaDev.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.sithikaDev.techmart.entity.Product;
import lk.sithikaDev.techmart.service.ProductService;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "HomeServlet", value = "/home")
public class HomeServlet extends HttpServlet {

    @EJB
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Product> allProducts = productService.getAllProducts();
        
        // Get first 4 products as featured
        List<Product> featuredProducts = allProducts.stream()
                .limit(4)
                .collect(Collectors.toList());
        
        request.setAttribute("featuredProducts", featuredProducts);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
