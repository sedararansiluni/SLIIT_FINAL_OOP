package com.beauty.servlet;

import com.beauty.model.CartItem;
import com.beauty.model.Service;
import com.beauty.model.User;
import com.beauty.service.ServiceService;
import com.beauty.util.ServiceCart;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet for handling service cart operations
 */
public class ServiceCartServlet extends HttpServlet {
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

        if (action == null) {
            // Default action: list all services
            listServices(request, response, user);
        } else {
            switch (action) {
                case "add":
                    addToCart(request, response, user);
                    break;
                case "remove":
                    removeFromCart(request, response, user);
                    break;
                case "update":
                    updateCartItem(request, response, user);
                    break;
                case "clear":
                    clearCart(request, response, user);
                    break;
                case "view":
                    viewCart(request, response, user);
                    break;
                default:
                    listServices(request, response, user);
                    break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        if (action != null && action.equals("update")) {
            updateCartItem(request, response, user);
        } else {
            doGet(request, response);
        }
    }

    /**
     * List all available services
     */
    private void listServices(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        // Get filter parameters
        String category = request.getParameter("category");
        String query = request.getParameter("query");

        // Get all services
        List<Service> services = serviceService.getAllServices();

        // Apply filters if provided
        if (category != null && !category.isEmpty() && !category.equals("All Categories")) {
            services = serviceService.getServicesByCategory(category);
        }

        // Apply search if provided
        if (query != null && !query.isEmpty()) {
            services = serviceService.searchServices(query);
        }

        // Get the user-specific service cart
        ServiceCart serviceCart = ServiceCart.getInstance(user);

        // Set attributes for the JSP
        request.setAttribute("services", services);
        request.setAttribute("cartItems", serviceCart.getAllItems());
        request.setAttribute("cartSize", serviceCart.getTotalQuantity());
        request.setAttribute("cartTotalPrice", serviceCart.getTotalPrice());
        request.setAttribute("cartTotalDuration", serviceCart.getTotalDuration());
        request.setAttribute("selectedCategory", category);

        // Forward to the services page
        request.getRequestDispatcher("/Client/Client_ServiceCart.jsp").forward(request, response);
    }

    /**
     * Add a service to the cart
     */
    private void addToCart(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        // Get service ID
        String serviceId = request.getParameter("id");

        if (serviceId == null || serviceId.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Service ID is required");
            response.sendRedirect(request.getContextPath() + "/serviceCart");
            return;
        }

        // Get the service
        Service service = serviceService.getServiceById(serviceId);

        if (service == null) {
            request.getSession().setAttribute("error", "Service not found");
            response.sendRedirect(request.getContextPath() + "/serviceCart");
            return;
        }

        // Get quantity parameter (default to 1 if not provided)
        int quantity = 1;
        try {
            String quantityStr = request.getParameter("quantity");
            if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                quantity = Integer.parseInt(quantityStr);
                if (quantity < 1) quantity = 1;
            }
        } catch (NumberFormatException e) {
            // Use default quantity of 1
        }

        // Get special instructions
        String specialInstructions = request.getParameter("specialInstructions");

        // Get the user-specific service cart
        ServiceCart serviceCart = ServiceCart.getInstance(user);

        // Check if service is already in cart
        if (serviceCart.containsService(serviceId)) {
            // Update quantity instead of adding a new item
            CartItem existingItem = serviceCart.getItemByServiceId(serviceId);
            existingItem.setQuantity(existingItem.getQuantity() + quantity);

            // Update special instructions if provided
            if (specialInstructions != null && !specialInstructions.trim().isEmpty()) {
                existingItem.setSpecialInstructions(specialInstructions);
            }

            request.getSession().setAttribute("message", "Service quantity updated in your cart");
        } else {
            // Add service to cart
            CartItem newItem = serviceCart.addService(service, quantity);

            // Set special instructions if provided
            if (specialInstructions != null && !specialInstructions.trim().isEmpty()) {
                newItem.setSpecialInstructions(specialInstructions);
            }

            request.getSession().setAttribute("message", "Service added to cart");
        }

        // Redirect back to services page
        response.sendRedirect(request.getContextPath() + "/serviceCart");
    }

    /**
     * Update a cart item
     */
    private void updateCartItem(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        // Get service ID
        String serviceId = request.getParameter("id");

        if (serviceId == null || serviceId.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Service ID is required");
            response.sendRedirect(request.getContextPath() + "/serviceCart?action=view");
            return;
        }

        // Get the user-specific service cart
        ServiceCart serviceCart = ServiceCart.getInstance(user);

        // Check if service exists in cart
        if (!serviceCart.containsService(serviceId)) {
            request.getSession().setAttribute("error", "Service not found in cart");
            response.sendRedirect(request.getContextPath() + "/serviceCart?action=view");
            return;
        }

        // Get quantity parameter
        try {
            String quantityStr = request.getParameter("quantity");
            if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                int quantity = Integer.parseInt(quantityStr);
                if (quantity < 1) {
                    // If quantity is less than 1, remove the item
                    serviceCart.removeService(serviceId);
                    request.getSession().setAttribute("message", "Service removed from cart");
                } else {
                    // Update quantity
                    serviceCart.updateQuantity(serviceId, quantity);
                }
            }
        } catch (NumberFormatException e) {
            // Ignore invalid quantity
        }

        // Get special instructions
        String specialInstructions = request.getParameter("specialInstructions");
        if (specialInstructions != null) {
            serviceCart.updateSpecialInstructions(serviceId, specialInstructions);
        }

        // Get options
        Map<String, String> options = new HashMap<>();
        String stylist = request.getParameter("stylist");
        if (stylist != null && !stylist.trim().isEmpty()) {
            options.put("stylist", stylist);
        }

        String timeSlot = request.getParameter("timeSlot");
        if (timeSlot != null && !timeSlot.trim().isEmpty()) {
            options.put("timeSlot", timeSlot);
        }

        if (!options.isEmpty()) {
            serviceCart.updateOptions(serviceId, options);
        }

        request.getSession().setAttribute("message", "Cart updated successfully");

        // Redirect back to cart view
        response.sendRedirect(request.getContextPath() + "/serviceCart?action=view");
    }

    /**
     * Remove a service from the cart
     */
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        // Get service ID
        String serviceId = request.getParameter("id");

        if (serviceId == null || serviceId.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Service ID is required");
            response.sendRedirect(request.getContextPath() + "/serviceCart?action=view");
            return;
        }

        // Get the user-specific service cart
        ServiceCart serviceCart = ServiceCart.getInstance(user);

        // Remove service from cart
        boolean removed = serviceCart.removeService(serviceId);

        if (removed) {
            request.getSession().setAttribute("message", "Service removed from cart");
        } else {
            request.getSession().setAttribute("error", "Service not found in cart");
        }

        // Redirect back to cart view
        response.sendRedirect(request.getContextPath() + "/serviceCart?action=view");
    }

    /**
     * Clear all services from the cart
     */
    private void clearCart(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        // Get the user-specific service cart
        ServiceCart serviceCart = ServiceCart.getInstance(user);

        // Clear the cart
        serviceCart.clear();

        request.getSession().setAttribute("message", "Cart cleared");

        // Redirect back to services page
        response.sendRedirect(request.getContextPath() + "/serviceCart");
    }

    /**
     * View the cart contents
     */
    private void viewCart(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        // Get the user-specific service cart
        ServiceCart serviceCart = ServiceCart.getInstance(user);

        // Set attributes for the JSP
        request.setAttribute("cartItems", serviceCart.getAllItems());
        request.setAttribute("cartSize", serviceCart.getTotalQuantity());
        request.setAttribute("cartTotalPrice", serviceCart.getTotalPrice());
        request.setAttribute("cartTotalDuration", serviceCart.getTotalDuration());

        // Set an empty services list to avoid null pointer exception
        request.setAttribute("services", new ArrayList<Service>());

        // Forward to the cart view page
        request.getRequestDispatcher("/Client/Client_ServiceCart.jsp").forward(request, response);
    }
}
