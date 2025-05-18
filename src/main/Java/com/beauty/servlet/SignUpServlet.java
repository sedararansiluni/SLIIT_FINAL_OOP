package com.beauty.servlet;

import com.beauty.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;
import java.util.regex.Pattern;

/**
 * Servlet for handling user registration
 */
public class SignUpServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SignUpServlet.class.getName());
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d@$!%*?&]{8,}$");
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
                request.getRequestDispatcher("/Auth/signup.jsp").forward(request, response);
                return;
            }

            // Get and validate parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validate required fields
            if (firstName == null || firstName.trim().isEmpty() ||
                    lastName == null || lastName.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    phoneNumber == null || phoneNumber.trim().isEmpty() ||
                    password == null || password.isEmpty() ||
                    confirmPassword == null || confirmPassword.isEmpty()) {
                LOGGER.warning("Missing required fields in signup attempt");
                request.setAttribute("error", "All fields are required");
                request.getRequestDispatcher("/Auth/signup.jsp").forward(request, response);
                return;
            }

            // Validate email format
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                LOGGER.warning("Invalid email format: " + email);
                request.setAttribute("error", "Invalid email format");
                request.getRequestDispatcher("/Auth/signup.jsp").forward(request, response);
                return;
            }

            // Validate password strength
            if (!PASSWORD_PATTERN.matcher(password).matches()) {
                LOGGER.warning("Weak password attempt for email: " + email);
                request.setAttribute("error", "Password must be at least 8 characters long and contain letters and numbers");
                request.getRequestDispatcher("/Auth/signup.jsp").forward(request, response);
                return;
            }

            // Validate passwords match
            if (!password.equals(confirmPassword)) {
                LOGGER.warning("Password mismatch for email: " + email);
                request.setAttribute("error", "Passwords do not match");
                request.getRequestDispatcher("/Auth/signup.jsp").forward(request, response);
                return;
            }

            // Sanitize inputs
            firstName = firstName.trim();
            lastName = lastName.trim();
            email = email.trim().toLowerCase();
            phoneNumber = phoneNumber.trim();

            // Check if user already exists
            if (userService.userExists(email)) {
                LOGGER.warning("User already exists: " + email);
                request.setAttribute("error", "User with this email already exists");
                request.getRequestDispatcher("/Auth/signup.jsp").forward(request, response);
                return;
            }

            // Register user
            boolean success = userService.registerUser(firstName, lastName, email, phoneNumber, password);

            if (success) {
                LOGGER.info("User registered successfully: " + email);
                // Create session and set timeout
                HttpSession session = request.getSession();
                session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout
                // Redirect to sign-in page on success
                response.sendRedirect(request.getContextPath() + "/Auth/SignIn.jsp");
            } else {
                LOGGER.warning("Registration failed for email: " + email);
                // Forward back to sign-up page with error message
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/Auth/signup.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.severe("Error processing signup: " + e.getMessage());
            request.setAttribute("error", "An unexpected error occurred");
            request.getRequestDispatcher("/Auth/signup.jsp").forward(request, response);
        }
    }
}