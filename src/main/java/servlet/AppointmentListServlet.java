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
import java.util.List;

/**
 * Servlet for handling appointment listing
 */
public class AppointmentListServlet extends HttpServlet {
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
        
        // Get user's appointments
        List<Appointment> userAppointments = appointmentService.getUserAppointments(user);
        
        // Set appointments as request attribute
        request.setAttribute("appointments", userAppointments);
        
        // Forward to appointments page
        request.getRequestDispatcher("/Client/Client_Addappoinment.jsp").forward(request, response);
    }
}
