package com.beauty.servlet;

import com.beauty.model.CartItem;
import com.beauty.model.Service;
import com.beauty.model.User;
import com.beauty.service.ServiceService;
import com.beauty.util.CartStorage;
import com.beauty.util.ServiceCart;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Test servlet for cart storage functionality
 * This is for testing purposes only and should be removed in production
 */
public class CartStorageTestServlet extends HttpServlet {
    private ServiceService serviceService;

    @Override
    public void init() throws ServletException {
        serviceService = new ServiceService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Auth/SignIn.jsp");
            return;
        }

        // Get user from session
        User user = (User) session.getAttribute("user");

        // Get action parameter
        String action = request.getParameter("action");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Cart Storage Test</title>");
        out.println("<style>body { font-family: Arial, sans-serif; margin: 20px; }</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Cart Storage Test</h1>");

        if ("test".equals(action)) {
            // Run test
            out.println("<h2>Running Test</h2>");

            // Get a service to add to cart
            List<Service> services = serviceService.getAllServices();
            if (services.isEmpty()) {
                out.println("<p>No services found to test with.</p>");
            } else {
                Service testService = services.get(0);

                // Get user-specific cart
                ServiceCart cart = ServiceCart.getInstance(user);

                // Clear cart first
                cart.clear();
                out.println("<p>Cleared cart.</p>");

                // Add service to cart
                CartItem item = cart.addService(testService, 2);
                out.println("<p>Added service to cart: " + testService.getName() + " (Quantity: 2)</p>");

                // Verify cart contents
                List<CartItem> items = cart.getAllItems();
                out.println("<p>Cart now has " + items.size() + " items.</p>");

                // Load cart from file
                List<CartItem> loadedItems = CartStorage.loadCart(user.getEmail());
                out.println("<p>Loaded " + loadedItems.size() + " items from file.</p>");

                if (!loadedItems.isEmpty()) {
                    CartItem loadedItem = loadedItems.get(0);
                    out.println("<p>Loaded item: " + loadedItem.getService().getName() +
                            " (Quantity: " + loadedItem.getQuantity() + ")</p>");
                }
            }
        }

        // Show links
        out.println("<p><a href='" + request.getContextPath() + "/cartStorageTest?action=test'>Run Test</a></p>");
        out.println("<p><a href='" + request.getContextPath() + "/serviceCart'>Go to Service Cart</a></p>");

        out.println("</body>");
        out.println("</html>");
    }
}
