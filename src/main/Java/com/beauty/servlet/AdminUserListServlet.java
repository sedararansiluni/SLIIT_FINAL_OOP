package com.beauty.servlet;

import com.beauty.model.User;
import com.beauty.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for handling admin user listing
 */
public class AdminUserListServlet extends HttpServlet {
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
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
        
        // Get sort parameter
        String sortBy = request.getParameter("sort");
        
        // Get all users
        List<User> allUsers = userService.getAllUsers();
        
        // Sort users if needed
        if (sortBy != null && !sortBy.isEmpty()) {
            allUsers = userService.sortUsers(allUsers, sortBy);
        }
        
        // Set users as request attribute
        request.setAttribute("users", allUsers);
        
        // Forward to admin users page
        request.getRequestDispatcher("/Admin/Admin_Users.jsp").forward(request, response);
    }
}
