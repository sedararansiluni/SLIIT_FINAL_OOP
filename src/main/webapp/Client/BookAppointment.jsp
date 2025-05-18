<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.beauty.model.User" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        // Redirect to login page if not logged in
        response.sendRedirect(request.getContextPath() + "/Auth/SignIn.jsp");
        return;
    }
    
    // Check if user is an admin
    String email = user.getEmail();
    if (email.contains("Admin@gmail.com")) {
        // Redirect to admin dashboard if user is an admin
        response.sendRedirect(request.getContextPath() + "/Admin/Admin_Dashboard.jsp");
        return;
    }
    
    // Get error message if any
    String errorMessage = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - Beauty Salon</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
        }
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen">
    <!-- Header -->
    <header class="bg-white shadow-sm fixed top-0 left-0 right-0 z-10">
        <div class="flex items-center justify-between px-6 py-3">
            <!-- Logo and Name -->
            <div class="flex items-center space-x-3">
                <div class="w-10 h-10 bg-indigo-100 rounded-lg flex items-center justify-center">
                    <i class="fas fa-scissors text-indigo-600"></i>
                </div>
                <h1 class="text-xl font-bold text-indigo-900">Beauty Salon</h1>
            </div>

            <!-- Navigation -->
            <nav class="hidden md:flex items-center space-x-8">
                <a href="Client_Dashboard.jsp" class="text-gray-600 hover:text-indigo-600">Dashboard</a>
                <a href="#" class="text-indigo-600 font-medium">Book Appointment</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600">My Appointments</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600">Services</a>
            </nav>

            <!-- Profile Section -->
            <div class="flex items-center space-x-4">
                <div class="flex items-center space-x-2">
                    <div class="w-10 h-10 rounded-full bg-indigo-100 flex items-center justify-center">
                        <i class="fas fa-user text-indigo-600"></i>
                    </div>
                    <span class="hidden md:inline text-gray-700"><%= user.getFirstName() %> <%= user.getLastName() %></span>
                    <a href="${pageContext.request.contextPath}/logout" class="ml-2 text-red-500 hover:text-red-700">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-4 py-8 pt-24">
        <div class="max-w-3xl mx-auto">
            <div class="bg-white rounded-xl shadow-md overflow-hidden">
                <div class="p-6 border-b border-gray-100">
                    <h2 class="text-2xl font-semibold text-gray-800">Book New Appointment</h2>
                    <p class="text-gray-600 mt-1">Fill out the form below to schedule your appointment</p>
                </div>
                
                <% if (errorMessage != null) { %>
                <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 m-6" role="alert">
                    <p><%= errorMessage %></p>
                </div>
                <% } %>
                
                <div class="p-6">
                    <form action="${pageContext.request.contextPath}/bookAppointment" method="post">
                        <!-- Service Selection -->
                        <div class="mb-6">
                            <label for="service" class="block text-gray-700 text-sm font-medium mb-2">Service</label>
                            <select id="service" name="service" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-200" required>
                                <option value="" disabled selected>Select a service</option>
                                <option value="Haircut">Haircut</option>
                                <option value="Hair Coloring">Hair Coloring</option>
                                <option value="Manicure">Manicure</option>
                                <option value="Pedicure">Pedicure</option>
                                <option value="Facial">Facial</option>
                                <option value="Massage">Massage</option>
                                <option value="Waxing">Waxing</option>
                                <option value="Makeup">Makeup</option>
                            </select>
                        </div>
                        
                        <!-- Stylist Selection -->
                        <div class="mb-6">
                            <label for="stylist" class="block text-gray-700 text-sm font-medium mb-2">Stylist</label>
                            <select id="stylist" name="stylist" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-200" required>
                                <option value="" disabled selected>Select a stylist</option>
                                <option value="Emma Wilson">Emma Wilson</option>
                                <option value="Sophia Martinez">Sophia Martinez</option>
                                <option value="Michael Johnson">Michael Johnson</option>
                                <option value="Olivia Brown">Olivia Brown</option>
                                <option value="James Davis">James Davis</option>
                            </select>
                        </div>
                        
                        <!-- Date and Time -->
                        <div class="mb-6">
                            <label for="dateTime" class="block text-gray-700 text-sm font-medium mb-2">Date and Time</label>
                            <input type="datetime-local" id="dateTime" name="dateTime" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-200" required>
                        </div>
                        
                        <!-- Notes -->
                        <div class="mb-6">
                            <label for="notes" class="block text-gray-700 text-sm font-medium mb-2">Additional Notes (Optional)</label>
                            <textarea id="notes" name="notes" rows="3" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-200" placeholder="Any special requests or information we should know..."></textarea>
                        </div>
                        
                        <!-- Submit Button -->
                        <div class="flex justify-end">
                            <a href="Client_Dashboard.jsp" class="px-6 py-3 rounded-lg text-gray-700 hover:bg-gray-100 mr-2">Cancel</a>
                            <button type="submit" class="px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition duration-200">
                                Book Appointment
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
    
    <!-- Footer -->
    <footer class="bg-white shadow-sm py-6 mt-8">
        <div class="container mx-auto px-4 text-center">
            <p class="text-gray-600 text-sm">&copy; 2025 Beauty Salon. All rights reserved.</p>
            <div class="mt-2 flex justify-center space-x-6">
                <a href="#" class="text-gray-600 hover:text-indigo-600 text-sm">Privacy Policy</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600 text-sm">Terms of Service</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600 text-sm">Contact Us</a>
            </div>
        </div>
    </footer>
    
    <script>
        // Set minimum date to today
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date();
            const year = today.getFullYear();
            const month = String(today.getMonth() + 1).padStart(2, '0');
            const day = String(today.getDate()).padStart(2, '0');
            const minDate = `${year}-${month}-${day}T09:00`;
            
            document.getElementById('dateTime').setAttribute('min', minDate);
        });
    </script>
</body>
</html>
