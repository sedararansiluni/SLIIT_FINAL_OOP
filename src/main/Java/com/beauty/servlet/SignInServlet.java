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
 * Servlet for handling user authentication
 */
public class SignInServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters from request
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Authenticate user
        User user = userService.authenticateUser(email, password);

        if (user != null) {
            // Create session and store user information
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Check if the email contains "Admin@gmail.com"
            email = user.getEmail();
            if (email.contains("Admin@gmail.com")) {
                // Redirect to admin dashboard
                response.sendRedirect(request.getContextPath() + "/Admin/Admin_Dashboard.jsp");
            } else {
                // Redirect to client dashboard
                response.sendRedirect(request.getContextPath() + "/Client/Client_Dashboard.jsp");
            }
        } else {
            // Forward back to sign-in page with error message
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/Auth/SignIn.jsp").forward(request, response);
        }
    }
}
