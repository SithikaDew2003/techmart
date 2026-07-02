package lk.sithikaDev.techmart.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.sithikaDev.techmart.service.TestService;

import java.io.IOException;

@WebServlet("/test")
public class TestServlet extends HttpServlet {
    @EJB
    private TestService testService;

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        testService.test("Im Sithika");
        req.getRequestDispatcher("index.jsp").forward(req, resp);
    }
}
