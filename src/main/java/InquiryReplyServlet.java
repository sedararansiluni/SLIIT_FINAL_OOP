package com.beauty.servlet;

import com.beauty.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Servlet for handling admin replies to inquiries
 */
public class InquiryReplyServlet extends HttpServlet {
    private static final String INQUIRY_FILE = "inquiry.txt";

    /**
     * Get the full path to the inquiry file
     * @return The file path
     */
    private String getInquiryFilePath() {
        return getServletContext().getRealPath("/") + "Database/" + INQUIRY_FILE;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Auth/SignIn.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.getEmail().contains("Admin@gmail.com")) {
            response.sendRedirect(request.getContextPath() + "/Client/Client_Dashboard.jsp");
            return;
        }

        // Get form parameters
        String action = request.getParameter("action");
        String timestamp = request.getParameter("timestamp");
        String reply = request.getParameter("reply");
        String status = request.getParameter("status");

        // Validate input
        if (timestamp == null || timestamp.trim().isEmpty()) {
            session.setAttribute("error", "Invalid inquiry reference");
            response.sendRedirect(request.getContextPath() + "/Admin/Admin_Dashboard.jsp");
            return;
        }

        if ("reply".equals(action) && (reply == null || reply.trim().isEmpty())) {
            session.setAttribute("error", "Reply message cannot be empty");
            response.sendRedirect(request.getContextPath() + "/Admin/Admin_Dashboard.jsp");
            return;
        }

        // Process the inquiry file
        try {
            if ("reply".equals(action)) {
                addReplyToInquiry(timestamp, reply, user);
                session.setAttribute("message", "Reply added successfully");
            } else if ("updateStatus".equals(action) && status != null) {
                updateInquiryStatus(timestamp, status);
                session.setAttribute("message", "Inquiry status updated to " + status);
            } else if ("delete".equals(action)) {
                deleteInquiry(timestamp);
                session.setAttribute("message", "Inquiry deleted successfully");
            }
        } catch (IOException e) {
            session.setAttribute("error", "Failed to process inquiry. Please try again.");
            e.printStackTrace();
        }

        // Redirect back to dashboard
        response.sendRedirect(request.getContextPath() + "/Admin/Admin_Dashboard.jsp");
    }

    /**
     * Add a reply to an existing inquiry
     * @param timestamp Timestamp of the inquiry to reply to
     * @param reply Reply message
     * @param admin Admin user who is replying
     * @throws IOException If file operation fails
     */
    private void addReplyToInquiry(String timestamp, String reply, User admin) throws IOException {
        File inquiryFile = new File(getInquiryFilePath());

        if (!inquiryFile.exists()) {
            throw new IOException("Inquiry file not found");
        }

        // Read the entire file
        StringBuilder fileContent = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new FileReader(inquiryFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                fileContent.append(line).append("\n");
            }
        }

        // Find the inquiry by timestamp
        String content = fileContent.toString();
        String inquiryPattern = "Date: " + Pattern.quote(timestamp) + "[\\s\\S]*?-----------------------------------";
        Pattern pattern = Pattern.compile(inquiryPattern);
        Matcher matcher = pattern.matcher(content);

        if (matcher.find()) {
            // Found the inquiry
            String inquiryBlock = matcher.group(0);

            // Check if there's already a reply
            if (inquiryBlock.contains("Reply: ")) {
                // Append to existing reply
                String updatedInquiry = inquiryBlock.replaceFirst(
                    "(Reply: [\\s\\S]*?)(\n-----------------------------------)",
                    "$1\n\nAdditional reply by " + admin.getFirstName() + " " + admin.getLastName() +
                    " on " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + ":\n" + reply + "$2"
                );
                content = content.replace(inquiryBlock, updatedInquiry);
            } else {
                // Add new reply before the separator
                String updatedInquiry = inquiryBlock.replace(
                    "-----------------------------------",
                    "Reply: " + admin.getFirstName() + " " + admin.getLastName() +
                    " on " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + ":\n" + reply +
                    "\n-----------------------------------"
                );
                content = content.replace(inquiryBlock, updatedInquiry);
            }

            // Update the status to "Replied"
            content = updateStatusInContent(content, timestamp, "Replied");

            // Write back to file
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(inquiryFile))) {
                writer.write(content);
            }
        } else {
            throw new IOException("Inquiry not found with timestamp: " + timestamp);
        }
    }

    /**
     * Update the status of an inquiry
     * @param timestamp Timestamp of the inquiry to update
     * @param newStatus New status value
     * @throws IOException If file operation fails
     */
    private void updateInquiryStatus(String timestamp, String newStatus) throws IOException {
        File inquiryFile = new File(getInquiryFilePath());

        if (!inquiryFile.exists()) {
            throw new IOException("Inquiry file not found");
        }

        // Read the entire file
        StringBuilder fileContent = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new FileReader(inquiryFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                fileContent.append(line).append("\n");
            }
        }

        // Update the status
        String content = updateStatusInContent(fileContent.toString(), timestamp, newStatus);

        // Write back to file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(inquiryFile))) {
            writer.write(content);
        }
    }

    /**
     * Helper method to update status in the file content
     * @param content File content
     * @param timestamp Timestamp of the inquiry
     * @param newStatus New status value
     * @return Updated content
     */
    private String updateStatusInContent(String content, String timestamp, String newStatus) {
        String inquiryPattern = "Date: " + Pattern.quote(timestamp) + "[\\s\\S]*?Status: [^\\n]*";
        Pattern pattern = Pattern.compile(inquiryPattern);
        Matcher matcher = pattern.matcher(content);

        if (matcher.find()) {
            String inquiryBlock = matcher.group(0);
            String updatedInquiry = inquiryBlock.replaceFirst(
                "Status: [^\\n]*",
                "Status: " + newStatus
            );
            return content.replace(inquiryBlock, updatedInquiry);
        }

        return content;
    }

    /**
     * Delete an inquiry from the file
     * @param timestamp Timestamp of the inquiry to delete
     * @throws IOException If file operation fails
     */
    private void deleteInquiry(String timestamp) throws IOException {
        File inquiryFile = new File(getInquiryFilePath());

        if (!inquiryFile.exists()) {
            throw new IOException("Inquiry file not found");
        }

        // Read the entire file
        StringBuilder fileContent = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new FileReader(inquiryFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                fileContent.append(line).append("\n");
            }
        }

        // Find and remove the inquiry by timestamp
        String content = fileContent.toString();
        String inquiryPattern = "Date: " + Pattern.quote(timestamp) + "[\\s\\S]*?-----------------------------------\n\n";
        Pattern pattern = Pattern.compile(inquiryPattern);
        Matcher matcher = pattern.matcher(content);

        if (matcher.find()) {
            // Found the inquiry, remove it
            String updatedContent = content.replace(matcher.group(0), "");

            // Write back to file
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(inquiryFile))) {
                writer.write(updatedContent);
            }
        } else {
            // Try alternative pattern (last inquiry in file might not have trailing newlines)
            inquiryPattern = "Date: " + Pattern.quote(timestamp) + "[\\s\\S]*?-----------------------------------";
            pattern = Pattern.compile(inquiryPattern);
            matcher = pattern.matcher(content);

            if (matcher.find()) {
                // Found the inquiry, remove it
                String updatedContent = content.replace(matcher.group(0), "");

                // Write back to file
                try (BufferedWriter writer = new BufferedWriter(new FileWriter(inquiryFile))) {
                    writer.write(updatedContent);
                }
            } else {
                throw new IOException("Inquiry not found with timestamp: " + timestamp);
            }
        }
    }
}
