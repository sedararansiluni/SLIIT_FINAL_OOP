package com.beauty.servlet;

import com.beauty.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet for handling user registration
 */
public class SignUpServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters from request
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate passwords match
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/Auth/signup.jsp").forward(request, response);
            return;
        }

        // Check if user already exists
        if (userService.userExists(email)) {
            request.setAttribute("error", "User with this email already exists");
            request.getRequestDispatcher("/Auth/signup.jsp").forward(request, response);
            return;
        }

        // Register user
        boolean success = userService.registerUser(firstName, lastName, email, phoneNumber, password);

        if (success) {
            // Redirect to sign-in page on success
            response.sendRedirect(request.getContextPath() + "/Auth/SignIn.jsp");
        } else {
            // Forward back to sign-up page with error message
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/Auth/signup.jsp").forward(request, response);
        }
    }
}
