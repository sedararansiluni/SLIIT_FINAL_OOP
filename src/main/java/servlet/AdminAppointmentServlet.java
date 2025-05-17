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
 * Servlet for handling admin appointment listing and sorting
 */
public class AdminAppointmentServlet extends HttpServlet {
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
        
        // Get sort parameter
        String sortBy = request.getParameter("sort");
        
        // Get all appointments
        List<Appointment> allAppointments = appointmentService.getAllAppointments();
        
        // Sort appointments using quick sort
        List<Appointment> sortedAppointments = appointmentService.sortAppointments(allAppointments, sortBy);
        
        // Set appointments as request attribute
        request.setAttribute("appointments", sortedAppointments);
        
        // Forward to admin appointments page
        request.getRequestDispatcher("/Admin/Admin_Appointments.jsp").forward(request, response);
    }
}
