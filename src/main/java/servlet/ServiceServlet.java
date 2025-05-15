package com.beauty.servlet;

import com.beauty.model.Service;
import com.beauty.model.User;
import com.beauty.service.ServiceService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for handling service operations
 */
public class ServiceServlet extends HttpServlet {
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
        
        // Check if user is an admin
        if (!user.getEmail().contains("Admin@gmail.com")) {
            response.sendRedirect(request.getContextPath() + "/Client/Client_Dashboard.jsp");
            return;
        }
        
        // Get action parameter
        String action = request.getParameter("action");
        
        if (action == null) {
            // Default action: list all services
            listServices(request, response);
        } else {
            switch (action) {
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteService(request, response);
                    break;
                case "view":
                    viewService(request, response);
                    break;
                default:
                    listServices(request, response);
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
        
        // Check if user is an admin
        if (!user.getEmail().contains("Admin@gmail.com")) {
            response.sendRedirect(request.getContextPath() + "/Client/Client_Dashboard.jsp");
            return;
        }
        
        // Get action parameter
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/services");
            return;
        }
        
        switch (action) {
            case "add":
                addService(request, response);
                break;
            case "update":
                updateService(request, response);
                break;
            case "search":
                searchServices(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/services");
                break;
        }
    }
    
    /**
     * List all services
     */
    private void listServices(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get filter parameters
        String category = request.getParameter("category");
        String sortBy = request.getParameter("sort");
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
        
        // Apply sorting if provided
        if (sortBy != null && !sortBy.isEmpty()) {
            services = serviceService.sortServices(services, sortBy);
        }
        
        // Set attributes for the JSP
        request.setAttribute("services", services);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedSort", sortBy);
        request.setAttribute("searchQuery", query);
        
        // Forward to the services page
        request.getRequestDispatcher("/Admin/Admin_Services.jsp").forward(request, response);
    }
    
    /**
     * Show the edit form for a service
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get service ID
        String id = request.getParameter("id");
        
        // Get the service
        Service service = serviceService.getServiceById(id);
        
        if (service == null) {
            // Service not found, redirect to services list
            request.getSession().setAttribute("error", "Service not found");
            response.sendRedirect(request.getContextPath() + "/services");
            return;
        }
        
        // Set service as request attribute
        request.setAttribute("service", service);
        
        // Forward to the edit form
        request.getRequestDispatcher("/Admin/Admin_Services.jsp").forward(request, response);
    }
    
    /**
     * Add a new service
     */
    private void addService(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get service parameters
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String durationStr = request.getParameter("duration");
        String priceStr = request.getParameter("price");
        String status = request.getParameter("status");
        String description = request.getParameter("description");
        String icon = request.getParameter("icon");
        
        // Validate required fields
        if (name == null || name.trim().isEmpty() || 
            category == null || category.trim().isEmpty() ||
            durationStr == null || durationStr.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty() ||
            status == null || status.trim().isEmpty()) {
            
            request.getSession().setAttribute("error", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/services");
            return;
        }
        
        try {
            // Parse numeric values
            int duration = Integer.parseInt(durationStr);
            double price = Double.parseDouble(priceStr);
            
            // Create new service
            Service service = new Service();
            service.setName(name);
            service.setCategory(category);
            service.setDuration(duration);
            service.setPrice(price);
            service.setStatus(status);
            service.setDescription(description != null ? description : "");
            service.setIcon(icon != null ? icon : "fas fa-spa");
            
            // Add the service
            boolean success = serviceService.addService(service);
            
            if (success) {
                request.getSession().setAttribute("message", "Service added successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to add service");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid duration or price format");
        }
        
        response.sendRedirect(request.getContextPath() + "/services");
    }
    
    /**
     * Update an existing service
     */
    private void updateService(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get service parameters
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String durationStr = request.getParameter("duration");
        String priceStr = request.getParameter("price");
        String status = request.getParameter("status");
        String description = request.getParameter("description");
        String icon = request.getParameter("icon");
        
        // Validate required fields
        if (id == null || id.trim().isEmpty() ||
            name == null || name.trim().isEmpty() || 
            category == null || category.trim().isEmpty() ||
            durationStr == null || durationStr.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty() ||
            status == null || status.trim().isEmpty()) {
            
            request.getSession().setAttribute("error", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/services");
            return;
        }
        
        try {
            // Parse numeric values
            int duration = Integer.parseInt(durationStr);
            double price = Double.parseDouble(priceStr);
            
            // Get existing service
            Service service = serviceService.getServiceById(id);
            
            if (service == null) {
                request.getSession().setAttribute("error", "Service not found");
                response.sendRedirect(request.getContextPath() + "/services");
                return;
            }
            
            // Update service properties
            service.setName(name);
            service.setCategory(category);
            service.setDuration(duration);
            service.setPrice(price);
            service.setStatus(status);
            service.setDescription(description != null ? description : "");
            service.setIcon(icon != null ? icon : service.getIcon());
            
            // Update the service
            boolean success = serviceService.updateService(service);
            
            if (success) {
                request.getSession().setAttribute("message", "Service updated successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to update service");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid duration or price format");
        }
        
        response.sendRedirect(request.getContextPath() + "/services");
    }
    
    /**
     * Delete a service
     */
    private void deleteService(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get service ID
        String id = request.getParameter("id");
        
        if (id == null || id.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Service ID is required");
            response.sendRedirect(request.getContextPath() + "/services");
            return;
        }
        
        // Delete the service
        boolean success = serviceService.deleteService(id);
        
        if (success) {
            request.getSession().setAttribute("message", "Service deleted successfully");
        } else {
            request.getSession().setAttribute("error", "Failed to delete service");
        }
        
        response.sendRedirect(request.getContextPath() + "/services");
    }
    
    /**
     * View a service
     */
    private void viewService(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get service ID
        String id = request.getParameter("id");
        
        // Get the service
        Service service = serviceService.getServiceById(id);
        
        if (service == null) {
            // Service not found, redirect to services list
            request.getSession().setAttribute("error", "Service not found");
            response.sendRedirect(request.getContextPath() + "/services");
            return;
        }
        
        // Set service as request attribute
        request.setAttribute("service", service);
        request.setAttribute("viewMode", true);
        
        // Forward to the services page
        request.getRequestDispatcher("/Admin/Admin_Services.jsp").forward(request, response);
    }
    
    /**
     * Search services
     */
    private void searchServices(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get search query
        String query = request.getParameter("query");
        
        // Redirect to list with search parameter
        response.sendRedirect(request.getContextPath() + "/services?query=" + (query != null ? query : ""));
    }
}
