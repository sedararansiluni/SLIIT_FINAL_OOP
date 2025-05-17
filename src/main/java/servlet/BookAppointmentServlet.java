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
 * Servlet for handling appointment booking
 */
public class BookAppointmentServlet extends HttpServlet {
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
        
        // Forward to appointment booking form
        request.getRequestDispatcher("/Client/BookAppointment.jsp").forward(request, response);
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
        
        // Get user from session
        User user = (User) session.getAttribute("user");
        
        // Get parameters from request
        String service = request.getParameter("service");
        String stylist = request.getParameter("stylist");
        String dateTime = request.getParameter("dateTime");
        String notes = request.getParameter("notes");
        
        // Book appointment
        boolean success = appointmentService.bookAppointment(user, service, stylist, dateTime, notes);
        
        if (success) {
            // Set success message and redirect to client dashboard
            session.setAttribute("message", "Appointment booked successfully!");
            response.sendRedirect(request.getContextPath() + "/Client/Client_Dashboard.jsp");
        } else {
            // Set error message and forward back to booking form
            request.setAttribute("error", "Failed to book appointment. Please try again.");
            request.getRequestDispatcher("/Client/BookAppointment.jsp").forward(request, response);
        }
    }
}
