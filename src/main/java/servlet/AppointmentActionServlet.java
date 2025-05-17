package com.beauty.servlet;

import com.beauty.model.Appointment;
import com.beauty.model.User;
import com.beauty.service.AppointmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Servlet for handling appointment actions (reschedule, cancel)
 */
public class AppointmentActionServlet extends HttpServlet {
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
        
        // Get action and appointment ID from request
        String action = request.getParameter("action");
        String appointmentId = request.getParameter("id");
        
        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            // Invalid appointment ID
            response.sendRedirect(request.getContextPath() + "/myAppointments");
            return;
        }
        
        if ("reschedule".equals(action)) {
            // Forward to reschedule form
            Appointment appointment = appointmentService.getAppointmentById(appointmentId);
            if (appointment == null) {
                // Appointment not found
                response.sendRedirect(request.getContextPath() + "/myAppointments");
                return;
            }
            
            request.setAttribute("appointment", appointment);
            request.getRequestDispatcher("/Client/RescheduleAppointment.jsp").forward(request, response);
        } else if ("cancel".equals(action)) {
            // Cancel appointment
            boolean success = appointmentService.cancelAppointment(appointmentId);
            
            if (success) {
                // Set success message
                session.setAttribute("message", "Appointment cancelled successfully");
            } else {
                // Set error message
                session.setAttribute("error", "Failed to cancel appointment");
            }
            
            // Redirect back to appointments page
            response.sendRedirect(request.getContextPath() + "/myAppointments");
        } else {
            // Invalid action
            response.sendRedirect(request.getContextPath() + "/myAppointments");
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
        
        // Get action and appointment ID from request
        String action = request.getParameter("action");
        String appointmentId = request.getParameter("id");
        
        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            // Invalid appointment ID
            response.sendRedirect(request.getContextPath() + "/myAppointments");
            return;
        }
        
        if ("reschedule".equals(action)) {
            // Handle reschedule form submission
            String dateTimeStr = request.getParameter("dateTime");
            
            if (dateTimeStr == null || dateTimeStr.trim().isEmpty()) {
                // Invalid date/time
                request.setAttribute("error", "Please select a valid date and time");
                
                // Get appointment for form
                Appointment appointment = appointmentService.getAppointmentById(appointmentId);
                request.setAttribute("appointment", appointment);
                
                request.getRequestDispatcher("/Client/RescheduleAppointment.jsp").forward(request, response);
                return;
            }
            
            try {
                // Parse date and time
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                LocalDateTime dateTime = LocalDateTime.parse(dateTimeStr, formatter);
                
                // Reschedule appointment
                boolean success = appointmentService.rescheduleAppointment(appointmentId, dateTime);
                
                if (success) {
                    // Set success message
                    session.setAttribute("message", "Appointment rescheduled successfully");
                } else {
                    // Set error message
                    session.setAttribute("error", "Failed to reschedule appointment");
                }
                
                // Redirect back to appointments page
                response.sendRedirect(request.getContextPath() + "/myAppointments");
            } catch (Exception e) {
                // Invalid date/time format
                request.setAttribute("error", "Invalid date and time format");
                
                // Get appointment for form
                Appointment appointment = appointmentService.getAppointmentById(appointmentId);
                request.setAttribute("appointment", appointment);
                
                request.getRequestDispatcher("/Client/RescheduleAppointment.jsp").forward(request, response);
            }
        } else {
            // Invalid action
            response.sendRedirect(request.getContextPath() + "/myAppointments");
        }
    }
}
