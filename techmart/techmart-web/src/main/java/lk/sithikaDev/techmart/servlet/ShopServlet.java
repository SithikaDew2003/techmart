package lk.sithikaDev.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.sithikaDev.techmart.entity.Product;
import lk.sithikaDev.techmart.service.PerformanceMonitor;
import lk.sithikaDev.techmart.service.ProductService;

import java.math.BigDecimal;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ShopServlet", value = "/shop")
public class ShopServlet extends HttpServlet {

    @EJB
    private ProductService productService;

    @EJB
    private PerformanceMonitor performanceMonitor;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        performanceMonitor.incrementRequestCount("/shop");
        String searchQuery = request.getParameter("search");
        String sortBy = request.getParameter("sortBy");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");

        BigDecimal minPrice = null;
        BigDecimal maxPrice = null;

        try {
            if (minPriceParam != null && !minPriceParam.trim().isEmpty()) {
                minPrice = new BigDecimal(minPriceParam.trim());
            }
            if (maxPriceParam != null && !maxPriceParam.trim().isEmpty()) {
                maxPrice = new BigDecimal(maxPriceParam.trim());
            }
        } catch (NumberFormatException e) {
            request.setAttribute("filterError", "Enter valid price values.");
        }

        List<Product> products = productService.filterProducts(searchQuery, minPrice, maxPrice, sortBy);
        request.setAttribute("products", products);
        request.getRequestDispatcher("shop.jsp").forward(request, response);
    }
}
