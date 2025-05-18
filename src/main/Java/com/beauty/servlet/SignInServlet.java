package com.beauty.servlet;

import com.beauty.model.User;
import com.beauty.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Servlet for handling user authentication
 */
public class SignInServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SignInServlet.class.getName());
    private static final String ADMIN_EMAIL = "Admin@gmail.com";
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate CSRF token
            String csrfToken = request.getParameter("csrfToken");
            String sessionCsrfToken = (String) request.getSession().getAttribute("csrfToken");
            if (csrfToken == null || !csrfToken.equals(sessionCsrfToken)) {
                LOGGER.warning("CSRF token validation failed");
                request.setAttribute("error", "Invalid request");
                request.getRequestDispatcher("/Auth/SignIn.jsp").forward(request, response);
                return;
            }

            // Get and validate parameters
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
                LOGGER.warning("Empty email or password attempt");
                request.setAttribute("error", "Email and password are required");
                request.getRequestDispatcher("/Auth/SignIn.jsp").forward(request, response);
                return;
            }

            // Sanitize email
            email = email.trim().toLowerCase();

            // Authenticate user
            User user = userService.authenticateUser(email, password);

            if (user != null) {
                // Create session and store user information
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout

                LOGGER.info("User authenticated: " + email);

                // Check if user is admin
                if (email.equalsIgnoreCase(ADMIN_EMAIL)) {
                    // Redirect to admin dashboard
                    response.sendRedirect(request.getContextPath() + "/Admin/Admin_Dashboard.jsp");
                } else {
                    // Redirect to client dashboard
                    response.sendRedirect(request.getContextPath() + "/Client/Client_Dashboard.jsp");
                }
            } else {
                LOGGER.warning("Failed login attempt for email: " + email);
                // Forward back to sign-in page with error message
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("/Auth/SignIn.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.severe("Error processing sign-in: " + e.getMessage());
            request.setAttribute("error", "An unexpected error occurred");
            request.getRequestDispatcher("/Auth/SignIn.jsp").forward(request, response);
        }
    }
}