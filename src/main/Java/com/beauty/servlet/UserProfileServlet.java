package com.beauty.servlet;

import com.beauty.model.User;
import com.beauty.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for handling user profile operations
 */
public class UserProfileServlet extends HttpServlet {
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
        
        // Get action parameter
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            // Handle delete action
            handleDeleteUser(request, response);
        } else {
            // Forward to profile page
            request.getRequestDispatcher("/Client/Client_Profile.jsp").forward(request, response);
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
        
        // Get action parameter
        String action = request.getParameter("action");
        
        if ("update".equals(action)) {
            // Handle update action
            handleUpdateProfile(request, response);
        } else if ("delete".equals(action)) {
            // Handle delete action
            handleDeleteUser(request, response);
        } else {
            // Invalid action
            request.setAttribute("error", "Invalid action");
            request.getRequestDispatcher("/Client/Client_Profile.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle update profile action
     */
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Get parameters from request
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate passwords match
        if (password != null && !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/Client/Client_Profile.jsp").forward(request, response);
            return;
        }
        
        // If password is empty, use current password
        if (password == null || password.trim().isEmpty()) {
            password = currentUser.getPassword();
        }
        
        // Update user profile
        boolean success = userService.updateUserProfile(
                currentUser.getEmail(), firstName, lastName, phoneNumber, password);
        
        if (success) {
            // Update session with new user information
            User updatedUser = userService.getUserByEmail(currentUser.getEmail());
            session.setAttribute("user", updatedUser);
            
            // Set success message
            request.setAttribute("message", "Profile updated successfully");
        } else {
            // Set error message
            request.setAttribute("error", "Failed to update profile");
        }
        
        // Forward back to profile page
        request.getRequestDispatcher("/Client/Client_Profile.jsp").forward(request, response);
    }
    
    /**
     * Handle delete user action
     */
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Delete user
        boolean success = userService.deleteUser(currentUser.getEmail());
        
        if (success) {
            // Invalidate session
            session.invalidate();
            
            // Redirect to login page with message
            response.sendRedirect(request.getContextPath() + "/Auth/SignIn.jsp?message=Account deleted successfully");
        } else {
            // Set error message
            request.setAttribute("error", "Failed to delete account");
            request.getRequestDispatcher("/Client/Client_Profile.jsp").forward(request, response);
        }
    }
}
