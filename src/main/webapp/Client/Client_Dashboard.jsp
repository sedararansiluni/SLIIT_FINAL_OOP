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

    // Check for success message
    String message = (String) session.getAttribute("message");
    if (message != null) {
        // Remove the message from session after retrieving it
        session.removeAttribute("message");
    }

    // Check for error message
    String error = (String) session.getAttribute("error");
    if (error != null) {
        // Remove the error from session after retrieving it
        session.removeAttribute("error");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Beauty Salon - Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/@dotlottie/player-component@latest/dist/dotlottie-player.mjs" type="module"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
        }
        .sidebar {
            transition: all 0.3s ease;
        }
        .content-area {
            transition: all 0.3s ease;
        }
    </style>
</head>
<body class="bg-gray-100">
    <!-- Header -->
    <header class="bg-white shadow-sm fixed top-0 left-0 right-0 z-10">
        <div class="flex items-center justify-between px-6 py-3">
            <!-- Logo and Name -->
            <div class="flex items-center space-x-3">
                <div class="w-10 h-10 bg-indigo-100 rounded-lg flex items-center justify-center">
                    <i class="fas fa-scissors text-indigo-600"></i>
                </div>
                <h1 class="text-xl font-bold text-indigo-900">Beauty Saloon</h1>
            </div>

            <!-- Navigation -->
            <nav class="hidden md:flex items-center space-x-8">
                <a href="./Client_Dashboard.html" class="text-indigo-600 font-medium">Dashboard</a>
                <a href="Client_Addappoinment.jsp" class="text-gray-600 hover:text-indigo-600">My Appointments</a>
                <a href="Client_ServiceCart.jsp" class="text-gray-600 hover:text-indigo-600">Services</a>
                <a href="Client_Profile.jsp" class="text-gray-600 hover:text-indigo-600">Profile</a>
            </nav>

            <!-- Profile Section -->
            <div class="flex items-center space-x-4">
                <button class="p-2 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200">
                    <i class="fas fa-bell"></i>
                    <span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
                </button>
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
    <div class="flex pt-16">
        <!-- Sidebar -->
        <aside class="sidebar w-64 bg-white shadow-sm fixed left-0 top-16 bottom-0 overflow-y-auto">
            <div class="p-4">
                <div class="flex items-center space-x-3 mb-6 p-3 bg-indigo-50 rounded-lg">
                    <div class="w-12 h-12 rounded-full bg-indigo-100 flex items-center justify-center">
                        <i class="fas fa-user text-indigo-600 text-xl"></i>
                    </div>
                    <div>
                        <h3 class="font-medium"><%= user.getFirstName() %> <%= user.getLastName() %></h3>
                        <p class="text-xs text-gray-500">Gold Member</p>
                    </div>
                </div>

                <h2 class="text-lg font-semibold text-gray-700 mb-4">My Menu</h2>
                <ul class="space-y-2">
                    <li>
                        <a href="./Client_Dashboard.html" class="flex items-center bg-indigo-50 text-indigo-600 p-3 rounded-lg t hover:bg-gray-100">
                            <i class="fas fa-tachometer-alt mr-3"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/myAppointments" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="far fa-calendar-alt mr-3"></i>
                            <span>My Appointments</span>
                            <span class="ml-auto bg-indigo-100 text-indigo-800 text-xs px-2 py-1 rounded-full">2</span>
                        </a>
                    </li>
                    <li>
                        <a href="Client_ServiceCart.jsp" class="flex items-center p-3 rounded-lg text-gray-600 ">
                            <i class="fas fa-cut mr-3"></i>
                            <span>Services</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/userProfile" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="fas fa-user mr-3"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                </ul>

                <div class="mt-8">
                    <h2 class="text-lg font-semibold text-gray-700 mb-4">Membership</h2>
                    <div class="bg-indigo-50 rounded-lg p-4">
                        <div class="flex items-center justify-between mb-3">
                            <span class="text-gray-600">Points</span>
                            <span class="font-bold">1,250</span>
                        </div>
                        <div class="flex items-center justify-between mb-3">
                            <span class="text-gray-600">Level</span>
                            <span class="font-bold">Gold</span>
                        </div>
                        <div class="w-full bg-gray-200 rounded-full h-2.5 mb-3">
                            <div class="bg-indigo-600 h-2.5 rounded-full" style="width: 65%"></div>
                        </div>
                        <p class="text-xs text-gray-500">650 points to Platinum</p>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Content Area -->
        <main class="content-area flex-1 ml-64 p-6">
            <% if (message != null) { %>
            <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6" role="alert">
                <p><%= message %></p>
            </div>
            <% } %>

            <% if (error != null) { %>
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6" role="alert">
                <p><%= error %></p>
            </div>
            <% } %>

            <!-- Welcome Banner -->
            <div class="bg-gradient-to-r from-indigo-500 to-purple-600 rounded-xl shadow-sm p-6 text-white mb-6">
                <div class="flex flex-col md:flex-row items-center justify-between">
                    <div>
                        <h2 class="text-2xl font-bold mb-2">Welcome back, <%= user.getFirstName() %>!</h2>
                        <p class="mb-4">You have 2 upcoming appointments. Your favorite stylist Emma is available this weekend.</p>
                        <a href="${pageContext.request.contextPath}/bookAppointment" class="bg-white text-indigo-600 px-4 py-2 rounded-lg font-medium hover:bg-indigo-50 transition inline-block">Book New Appointment</a>
                    </div>
                    <div class="mt-4 md:mt-0">
                        <dotlottie-player src="https://lottie.host/5f277ad7-fdb6-4578-b7c7-8d2ce6e84377/RwgMz8Ajqp.lottie" background="transparent" speed="2" style="width: 150px; height: 150px;" loop autoplay></dotlottie-player>
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                <!-- Stats Cards -->
                <div class="bg-white rounded-xl shadow-sm p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500">Upcoming Appointments</p>
                            <h3 class="text-2xl font-bold mt-1">2</h3>
                            <p class="text-indigo-500 text-sm mt-2"><i class="fas fa-calendar-alt mr-1"></i> Next: Today, 2:00 PM</p>
                        </div>
                        <div class="w-16 h-16 bg-indigo-50 rounded-full flex items-center justify-center">
                            <i class="fas fa-calendar-check text-indigo-600 text-xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-sm p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500">Loyalty Points</p>
                            <h3 class="text-2xl font-bold mt-1">1,250</h3>
                            <p class="text-green-500 text-sm mt-2"><i class="fas fa-gem mr-1"></i> Gold Member</p>
                        </div>
                        <div class="w-16 h-16 bg-indigo-50 rounded-full flex items-center justify-center">
                            <i class="fas fa-award text-indigo-600 text-xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-sm p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500">Favorite Stylist</p>
                            <h3 class="text-2xl font-bold mt-1">Emma</h3>
                            <p class="text-indigo-500 text-sm mt-2"><i class="fas fa-star mr-1"></i> 4.9/5 rating</p>
                        </div>
                        <div class="w-16 h-16 bg-indigo-50 rounded-full flex items-center justify-center">
                            <i class="fas fa-user-tie text-indigo-600 text-xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Upcoming Appointments -->
            <div class="bg-white rounded-xl shadow-sm overflow-hidden mb-6">
                <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                    <h2 class="text-xl font-semibold text-gray-800">Upcoming Appointments</h2>
                    <a href="${pageContext.request.contextPath}/myAppointments" class="text-indigo-600 hover:text-indigo-800 font-medium">View All</a>
                </div>
                <div class="divide-y divide-gray-100">
                    <div class="p-6 flex items-center justify-between">
                        <div class="flex items-center space-x-4">
                            <div class="w-12 h-12 bg-indigo-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-cut text-indigo-600"></i>
                            </div>
                            <div>
                                <h3 class="font-medium">Hair Coloring</h3>
                                <p class="text-sm text-gray-500">with Emma Wilson</p>
                            </div>
                        </div>
                        <div class="text-center">
                            <p class="font-medium">Today</p>
                            <p class="text-sm text-gray-500">2:00 PM - 3:00 PM</p>
                        </div>
                        <span class="px-3 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">Confirmed</span>
                        <button class="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">View Details</button>
                    </div>

                    <div class="p-6 flex items-center justify-between">
                        <div class="flex items-center space-x-4">
                            <div class="w-12 h-12 bg-indigo-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-spa text-indigo-600"></i>
                            </div>
                            <div>
                                <h3 class="font-medium">Spa Treatment</h3>
                                <p class="text-sm text-gray-500">with Sophia Martinez</p>
                            </div>
                        </div>
                        <div class="text-center">
                            <p class="font-medium">Friday</p>
                            <p class="text-sm text-gray-500">11:00 AM - 12:30 PM</p>
                        </div>
                        <span class="px-3 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800">Scheduled</span>
                        <button class="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">View Details</button>
                    </div>
                </div>
            </div>

            <!-- Recommended Services and Special Offers -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="bg-white rounded-xl shadow-sm overflow-hidden">
                    <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                        <h2 class="text-xl font-semibold text-gray-800">Recommended For You</h2>
                        <button class="text-indigo-600 hover:text-indigo-800 font-medium">See All</button>
                    </div>
                    <div class="p-6 grid grid-cols-2 gap-4">
                        <div class="border border-gray-100 rounded-lg p-4 hover:shadow-md transition">
                            <div class="w-full h-24 bg-indigo-50 rounded-lg mb-3 flex items-center justify-center">
                                <i class="fas fa-cut text-indigo-600 text-2xl"></i>
                            </div>
                            <h3 class="font-medium">Haircut & Style</h3>
                            <p class="text-sm text-gray-500 mb-2">45 min • $45</p>
                            <button class="text-xs text-indigo-600 hover:text-indigo-800">Book Now</button>
                        </div>
                        <div class="border border-gray-100 rounded-lg p-4 hover:shadow-md transition">
                            <div class="w-full h-24 bg-indigo-50 rounded-lg mb-3 flex items-center justify-center">
                                <i class="fas fa-spa text-indigo-600 text-2xl"></i>
                            </div>
                            <h3 class="font-medium">Facial Treatment</h3>
                            <p class="text-sm text-gray-500 mb-2">60 min • $75</p>
                            <button class="text-xs text-indigo-600 hover:text-indigo-800">Book Now</button>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-sm overflow-hidden">
                    <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                        <h2 class="text-xl font-semibold text-gray-800">Special Offers</h2>
                        <button class="text-indigo-600 hover:text-indigo-800 font-medium">View All</button>
                    </div>
                    <div class="p-6">
                        <div class="bg-gradient-to-r from-purple-50 to-indigo-50 rounded-lg p-4 mb-4">
                            <div class="flex items-start">
                                <div class="bg-indigo-100 p-2 rounded-lg mr-3">
                                    <i class="fas fa-percentage text-indigo-600"></i>
                                </div>
                                <div>
                                    <h3 class="font-medium">20% Off First Spa Package</h3>
                                    <p class="text-sm text-gray-600">For Gold members only. Book before June 30.</p>
                                    <button class="mt-2 text-sm text-indigo-600 hover:text-indigo-800">Redeem Now</button>
                                </div>
                            </div>
                        </div>
                        <div class="bg-gradient-to-r from-amber-50 to-yellow-50 rounded-lg p-4">
                            <div class="flex items-start">
                                <div class="bg-amber-100 p-2 rounded-lg mr-3">
                                    <i class="fas fa-gift text-amber-600"></i>
                                </div>
                                <div>
                                    <h3 class="font-medium">Refer a Friend - Get $25</h3>
                                    <p class="text-sm text-gray-600">When they book their first appointment.</p>
                                    <button class="mt-2 text-sm text-indigo-600 hover:text-indigo-800">Share Link</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Floating Inquiry Button -->
    <button id="inquiryBtn" class="fixed bottom-20 right-6 w-14 h-14 bg-indigo-600 text-white rounded-full shadow-lg flex items-center justify-center hover:bg-indigo-700 transition-all z-20">
        <i class="fas fa-question-circle text-2xl"></i>
    </button>

    <!-- Inquiry Overlay -->
    <div id="inquiryOverlay" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-30 hidden">
        <div class="bg-white rounded-xl shadow-lg w-full max-w-md p-6 relative">
            <button id="closeInquiryBtn" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600">
                <i class="fas fa-times"></i>
            </button>

            <div class="text-center mb-6">
                <div class="w-16 h-16 bg-indigo-100 rounded-full mx-auto flex items-center justify-center mb-4">
                    <i class="fas fa-question-circle text-indigo-600 text-2xl"></i>
                </div>
                <h2 class="text-2xl font-bold text-gray-800">Send an Inquiry</h2>
                <p class="text-gray-600">We'll get back to you as soon as possible</p>
            </div>

            <form action="${pageContext.request.contextPath}/submitInquiry" method="post">
                <div class="mb-4">
                    <label for="subject" class="block text-sm font-medium text-gray-700 mb-1">Subject</label>
                    <input type="text" id="subject" name="subject" required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500"
                           placeholder="What's your inquiry about?">
                </div>

                <div class="mb-4">
                    <label for="priority" class="block text-sm font-medium text-gray-700 mb-1">Priority</label>
                    <select id="priority" name="priority"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                        <option value="Low">Low</option>
                        <option value="Normal" selected>Normal</option>
                        <option value="High">High</option>
                        <option value="Urgent">Urgent</option>
                    </select>
                </div>

                <div class="mb-6">
                    <label for="message" class="block text-sm font-medium text-gray-700 mb-1">Message</label>
                    <textarea id="message" name="message" rows="4" required
                              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500"
                              placeholder="Please describe your inquiry in detail..."></textarea>
                </div>

                <button type="submit" class="w-full bg-indigo-600 text-white py-3 rounded-lg font-medium hover:bg-indigo-700 transition">
                    Submit Inquiry
                </button>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-white shadow-sm fixed bottom-0 left-0 right-0 z-10">
        <div class="flex items-center justify-between px-6 py-3">
            <!-- Copyright -->
            <p class="text-gray-600 text-sm">&copy; 2025 Beauty Salon. All rights reserved.</p>

            <!-- Navigation -->
            <nav class="hidden md:flex items-center space-x-6">
                <a href="#" class="text-gray-600 hover:text-indigo-600 text-sm">Privacy Policy</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600 text-sm">Terms of Service</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600 text-sm">Contact Us</a>
            </nav>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Inquiry button and overlay functionality
            const inquiryBtn = document.getElementById('inquiryBtn');
            const inquiryOverlay = document.getElementById('inquiryOverlay');
            const closeInquiryBtn = document.getElementById('closeInquiryBtn');

            // Show overlay when inquiry button is clicked
            inquiryBtn.addEventListener('click', function() {
                inquiryOverlay.classList.remove('hidden');
                document.body.style.overflow = 'hidden'; // Prevent scrolling
            });

            // Hide overlay when close button is clicked
            closeInquiryBtn.addEventListener('click', function() {
                inquiryOverlay.classList.add('hidden');
                document.body.style.overflow = 'auto'; // Enable scrolling
            });

            // Hide overlay when clicking outside the form
            inquiryOverlay.addEventListener('click', function(e) {
                if (e.target === inquiryOverlay) {
                    inquiryOverlay.classList.add('hidden');
                    document.body.style.overflow = 'auto'; // Enable scrolling
                }
            });

            // Auto-hide success/error messages after 5 seconds
            const messages = document.querySelectorAll('.bg-green-100, .bg-red-100');
            if (messages.length > 0) {
                setTimeout(() => {
                    messages.forEach(message => {
                        message.style.transition = 'opacity 1s ease-out';
                        message.style.opacity = '0';
                        setTimeout(() => {
                            message.style.display = 'none';
                        }, 1000);
                    });
                }, 5000);
            }
        });
    </script>
</body>
</html>