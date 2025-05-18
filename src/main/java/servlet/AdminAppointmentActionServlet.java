package com.beauty.servlet;

import com.beauty.model.User;
import com.beauty.service.AppointmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for handling admin appointment actions (confirm, complete, cancel)
 */
public class AdminAppointmentActionServlet extends HttpServlet {
    private AppointmentService appointmentService;
    
    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentService();
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
        
        // Get action and appointment ID from request
        String action = request.getParameter("action");
        String appointmentId = request.getParameter("id");
        
        if (appointmentId == null || appointmentId.trim().isEmpty() || action == null || action.trim().isEmpty()) {
            // Invalid parameters
            session.setAttribute("error", "Invalid request parameters");
            response.sendRedirect(request.getContextPath() + "/adminAppointments");
            return;
        }
        
        boolean success = false;
        String message = "";
        
        // Process the action
        switch (action) {
            case "confirm":
                success = appointmentService.updateAppointmentStatus(appointmentId, "Confirmed");
                message = "Appointment confirmed successfully";
                break;
            case "complete":
                success = appointmentService.updateAppointmentStatus(appointmentId, "Completed");
                message = "Appointment marked as completed";
                break;
            case "cancel":
                success = appointmentService.updateAppointmentStatus(appointmentId, "Cancelled");
                message = "Appointment cancelled successfully";
                break;
            default:
                session.setAttribute("error", "Invalid action");
                response.sendRedirect(request.getContextPath() + "/adminAppointments");
                return;
        }
        
        if (success) {
            session.setAttribute("message", message);
        } else {
            session.setAttribute("error", "Failed to update appointment status");
        }
        
        // Redirect back to appointments page
        response.sendRedirect(request.getContextPath() + "/adminAppointments");
    }
}
