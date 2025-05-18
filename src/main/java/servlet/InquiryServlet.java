package com.beauty.servlet;

import com.beauty.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Servlet for handling client inquiries
 */
public class InquiryServlet extends HttpServlet {
    private static final String INQUIRY_FILE = "C:\\Users\\Venura\\Desktop\\CustomerDemo\\Beauty_version 01\\Beauty\\src\\main\\webapp\\Database\\inquiry.txt";

    /**
     * Get the full path to the inquiry file
     * @return The file path
     */
    private String getInquiryFilePath() {
        return INQUIRY_FILE;
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

        // Get form parameters
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        String priority = request.getParameter("priority");

        // Validate input
        if (subject == null || subject.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            session.setAttribute("error", "Subject and message are required");
            response.sendRedirect(request.getContextPath() + "/Client/Client_Dashboard.jsp");
            return;
        }

        // Create inquiry record
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String timestamp = dateFormat.format(new Date());

        StringBuilder inquiryRecord = new StringBuilder();
        inquiryRecord.append("Date: ").append(timestamp).append("\n");
        inquiryRecord.append("User: ").append(user.getFirstName()).append(" ").append(user.getLastName()).append("\n");
        inquiryRecord.append("Email: ").append(user.getEmail()).append("\n");
        inquiryRecord.append("Subject: ").append(subject).append("\n");
        inquiryRecord.append("Priority: ").append(priority != null ? priority : "Normal").append("\n");
        inquiryRecord.append("Message: ").append(message).append("\n");
        inquiryRecord.append("Status: New").append("\n");
        inquiryRecord.append("-----------------------------------\n\n");

        // Save to file
        try {
            saveInquiryToFile(inquiryRecord.toString());
            session.setAttribute("message", "Your inquiry has been submitted successfully. We'll get back to you soon!");
        } catch (IOException e) {
            session.setAttribute("error", "Failed to submit inquiry. Please try again later.");
            e.printStackTrace();
        }

        // Redirect back to dashboard
        response.sendRedirect(request.getContextPath() + "/Client/Client_Dashboard.jsp");
    }

    /**
     * Save inquiry to text file
     * @param inquiryRecord Formatted inquiry record
     * @throws IOException If file operation fails
     */
    private void saveInquiryToFile(String inquiryRecord) throws IOException {
        File inquiryFile = new File(getInquiryFilePath());

        // Create parent directories if they don't exist
        File parentDir = inquiryFile.getParentFile();
        if (parentDir != null && !parentDir.exists()) {
            parentDir.mkdirs();
        }

        // Create file if it doesn't exist
        if (!inquiryFile.exists()) {
            inquiryFile.createNewFile();
        }

        // Append to file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(inquiryFile, true))) {
            writer.write(inquiryRecord);
        }
    }
}
