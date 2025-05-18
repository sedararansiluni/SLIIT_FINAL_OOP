package com.beauty.servlet;

import com.beauty.model.User;
import com.beauty.util.CartStorage;
import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;


public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the current session
        HttpSession session = request.getSession(false);

        // Save cart data before invalidating session
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                // We don't need to delete the cart file, as it will be loaded next time the user logs in
                // If you want to clear the cart on logout, uncomment the following line:
                // CartStorage.deleteCart(user.getEmail());
            }

            // Invalidate session
            session.invalidate();
        }

        // Redirect to login page
        response.sendRedirect(request.getContextPath() + "/Auth/SignIn.jsp");
    }
}
