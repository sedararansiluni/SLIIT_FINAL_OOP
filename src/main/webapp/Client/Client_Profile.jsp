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

    // Get error or success message if any
    String errorMessage = (String) request.getAttribute("error");
    String successMessage = (String) request.getAttribute("message");

    // Flag to show edit form
    boolean showEditForm = "edit".equals(request.getParameter("mode"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Beauty Salon</title>
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
        .profile-section {
            transition: all 0.3s ease;
        }
        .profile-section:hover {
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .tab-active {
            border-bottom: 2px solid #6366f1;
            color: #6366f1;
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
                <a href="Client_Dashboard.jsp" class="text-gray-600 hover:text-indigo-600">Dashboard</a>
                <a href="Client_Addappoinment.jsp" class="text-gray-600 hover:text-indigo-600">My Appointments</a>
                <a href="Client_ServiceCart.jsp" class="text-gray-600 hover:text-indigo-600">Services</a>
                <a href="./Client_Profile.html" class="text-indigo-600 font-medium">Profile</a>
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
                    <i class="fas fa-chevron-down text-gray-500"></i>
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
                        <a href="Client_Dashboard.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="fas fa-tachometer-alt mr-3"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="Client_Addappoinment.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="far fa-calendar-alt mr-3"></i>
                            <span>My Appointments</span>
                            <span class="ml-auto bg-indigo-100 text-indigo-800 text-xs px-2 py-1 rounded-full">2</span>
                        </a>
                    </li>
                    <li>
                        <a href="Client_ServiceCart.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="fas fa-cut mr-3"></i>
                            <span>Services</span>
                        </a>
                    </li>
                    <li>
                        <a href="Client_Favorites.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="far fa-heart mr-3"></i>
                            <span>Favorites</span>
                        </a>
                    </li>
                    <li>
                        <a href="Client_Paymentgateway.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="far fa-credit-card mr-3"></i>
                            <span>Payments</span>
                        </a>
                    </li>
                    <li>
                        <a href="./Client_Profile.html" class="flex items-center p-3 rounded-lg bg-indigo-50 text-indigo-600  hover:bg-gray-100">
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
            <!-- Profile Header -->
            <div class="flex flex-col md:flex-row items-start md:items-center justify-between mb-6">
                <div>
                    <h1 class="text-2xl font-bold text-gray-800">My Profile</h1>
                    <p class="text-gray-600">Manage your account information and preferences</p>
                </div>
                <div class="mt-4 md:mt-0">
                    <% if (!showEditForm) { %>
                    <a href="${pageContext.request.contextPath}/userProfile?mode=edit" class="bg-indigo-600 text-white px-4 py-2 rounded-lg font-medium hover:bg-indigo-700 transition inline-block">
                        <i class="fas fa-user-edit mr-2"></i> Edit Profile
                    </a>
                    <% } else { %>
                    <a href="${pageContext.request.contextPath}/userProfile" class="bg-gray-500 text-white px-4 py-2 rounded-lg font-medium hover:bg-gray-600 transition inline-block">
                        <i class="fas fa-times mr-2"></i> Cancel
                    </a>
                    <% } %>
                </div>
            </div>

            <% if (errorMessage != null) { %>
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6" role="alert">
                <p><%= errorMessage %></p>
            </div>
            <% } %>

            <% if (successMessage != null) { %>
            <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6" role="alert">
                <p><%= successMessage %></p>
            </div>
            <% } %>

            <!-- Tabs -->
            <div class="border-b border-gray-200 mb-6">
                <nav class="flex space-x-8">
                    <button id="personal-tab" class="tab-active py-4 px-1 font-medium text-sm">Personal Info</button>
                    <button id="preferences-tab" class="text-gray-500 hover:text-gray-700 py-4 px-1 font-medium text-sm">Preferences</button>
                    <button id="security-tab" class="text-gray-500 hover:text-gray-700 py-4 px-1 font-medium text-sm">Security</button>
                    <button id="history-tab" class="text-gray-500 hover:text-gray-700 py-4 px-1 font-medium text-sm">History</button>
                </nav>
            </div>

            <!-- Personal Info Tab Content -->
            <div id="personal-content" class="profile-content">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                    <!-- Profile Card -->
                    <div class="profile-section bg-white rounded-xl shadow-sm p-6 col-span-1">
                        <div class="flex flex-col items-center">
                            <div class="relative mb-4">
                                <div class="w-32 h-32 rounded-full bg-indigo-100 flex items-center justify-center overflow-hidden">
                                    <dotlottie-player
                                        src="https://lottie.host/5f277ad7-fdb6-4578-b7c7-8d2ce6e84377/RwgMz8Ajqp.lottie"
                                        background="transparent"
                                        speed="1"
                                        style="width: 128px; height: 128px;"
                                        loop
                                        autoplay>
                                    </dotlottie-player>
                                </div>
                                <button class="absolute bottom-0 right-0 bg-white p-2 rounded-full shadow-sm border border-gray-200 hover:bg-gray-50">
                                    <i class="fas fa-camera text-indigo-600"></i>
                                </button>
                            </div>
                            <h2 class="text-xl font-bold text-gray-800"><%= user.getFirstName() %> <%= user.getLastName() %></h2>
                            <p class="text-gray-500 mb-4">Member</p>
                            <div class="w-full bg-gray-200 rounded-full h-2 mb-2">
                                <div class="bg-indigo-600 h-2 rounded-full" style="width: 65%"></div>
                            </div>
                            <p class="text-xs text-gray-500 mb-4">650 points to Platinum</p>
                        </div>
                    </div>

                    <!-- Account Details -->
                    <div class="profile-section bg-white rounded-xl shadow-sm p-6 col-span-2">
                        <h2 class="text-xl font-semibold text-gray-800 mb-4">Account Details</h2>

                        <% if (!showEditForm) { %>
                        <!-- View Mode -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                            <div>
                                <label class="block text-gray-700 text-sm font-medium mb-1">First Name</label>
                                <div class="bg-gray-50 px-4 py-2 rounded-lg"><%= user.getFirstName() %></div>
                            </div>
                            <div>
                                <label class="block text-gray-700 text-sm font-medium mb-1">Last Name</label>
                                <div class="bg-gray-50 px-4 py-2 rounded-lg"><%= user.getLastName() %></div>
                            </div>
                            <div>
                                <label class="block text-gray-700 text-sm font-medium mb-1">Email</label>
                                <div class="bg-gray-50 px-4 py-2 rounded-lg"><%= user.getEmail() %></div>
                            </div>
                            <div>
                                <label class="block text-gray-700 text-sm font-medium mb-1">Phone</label>
                                <div class="bg-gray-50 px-4 py-2 rounded-lg"><%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "Not provided" %></div>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/userProfile?mode=edit" class="text-indigo-600 hover:text-indigo-800 font-medium">
                            <i class="fas fa-pencil-alt mr-1"></i> Edit Details
                        </a>
                        <% } else { %>
                        <!-- Edit Mode -->
                        <form action="${pageContext.request.contextPath}/userProfile" method="post">
                            <input type="hidden" name="action" value="update">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                                <div>
                                    <label for="firstName" class="block text-gray-700 text-sm font-medium mb-1">First Name</label>
                                    <input type="text" id="firstName" name="firstName" value="<%= user.getFirstName() %>" class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500" required>
                                </div>
                                <div>
                                    <label for="lastName" class="block text-gray-700 text-sm font-medium mb-1">Last Name</label>
                                    <input type="text" id="lastName" name="lastName" value="<%= user.getLastName() %>" class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500" required>
                                </div>
                                <div>
                                    <label for="email" class="block text-gray-700 text-sm font-medium mb-1">Email</label>
                                    <input type="email" id="email" value="<%= user.getEmail() %>" class="w-full px-4 py-2 rounded-lg bg-gray-100" readonly>
                                    <p class="text-xs text-gray-500 mt-1">Email cannot be changed</p>
                                </div>
                                <div>
                                    <label for="phoneNumber" class="block text-gray-700 text-sm font-medium mb-1">Phone</label>
                                    <input type="tel" id="phoneNumber" name="phoneNumber" value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>" class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500">
                                </div>
                                <div>
                                    <label for="password" class="block text-gray-700 text-sm font-medium mb-1">New Password</label>
                                    <input type="password" id="password" name="password" class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500">
                                    <p class="text-xs text-gray-500 mt-1">Leave blank to keep current password</p>
                                </div>
                                <div>
                                    <label for="confirmPassword" class="block text-gray-700 text-sm font-medium mb-1">Confirm Password</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500">
                                </div>
                            </div>
                            <div class="flex justify-between">
                                <button type="submit" class="bg-indigo-600 text-white px-4 py-2 rounded-lg font-medium hover:bg-indigo-700 transition">
                                    <i class="fas fa-save mr-1"></i> Save Changes
                                </button>
                                <button type="button" onclick="confirmDelete()" class="bg-red-600 text-white px-4 py-2 rounded-lg font-medium hover:bg-red-700 transition">
                                    <i class="fas fa-trash-alt mr-1"></i> Delete Account
                                </button>
                            </div>
                        </form>
                        <% } %>
                    </div>
                </div>


            </div>

            <!-- Preferences Tab Content (Hidden by default) -->
            <div id="preferences-content" class="profile-content hidden">
                <div class="profile-section bg-white rounded-xl shadow-sm p-6 mb-6">
                    <h2 class="text-xl font-semibold text-gray-800 mb-4">Service Preferences</h2>
                    <div class="mb-6">
                        <label class="block text-gray-700 text-sm font-medium mb-2">Preferred Stylist</label>
                        <div class="flex items-center space-x-3 bg-gray-50 px-4 py-3 rounded-lg">
                            <div class="w-10 h-10 rounded-full bg-indigo-100 flex items-center justify-center">
                                <i class="fas fa-user-tie text-indigo-600"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Emma Wilson</h4>
                                <p class="text-sm text-gray-500">Senior Hair Stylist</p>
                            </div>
                        </div>
                    </div>
                    <div class="mb-6">
                        <label class="block text-gray-700 text-sm font-medium mb-2">Preferred Services</label>
                        <div class="flex flex-wrap gap-2">
                            <span class="bg-indigo-100 text-indigo-800 px-3 py-1 rounded-full text-sm">Hair Coloring</span>
                            <span class="bg-indigo-100 text-indigo-800 px-3 py-1 rounded-full text-sm">Spa Treatments</span>
                            <span class="bg-indigo-100 text-indigo-800 px-3 py-1 rounded-full text-sm">Manicure</span>
                        </div>
                    </div>
                    <div class="mb-6">
                        <label class="block text-gray-700 text-sm font-medium mb-2">Preferred Time Slots</label>
                        <div class="flex flex-wrap gap-2">
                            <span class="bg-indigo-100 text-indigo-800 px-3 py-1 rounded-full text-sm">Morning (9am-12pm)</span>
                            <span class="bg-indigo-100 text-indigo-800 px-3 py-1 rounded-full text-sm">Weekends</span>
                        </div>
                    </div>
                    <button class="text-indigo-600 hover:text-indigo-800 font-medium">
                        <i class="fas fa-pencil-alt mr-1"></i> Edit Preferences
                    </button>
                </div>

                <div class="profile-section bg-white rounded-xl shadow-sm p-6">
                    <h2 class="text-xl font-semibold text-gray-800 mb-4">Communication Preferences</h2>
                    <div class="space-y-4">
                        <div class="flex items-center justify-between">
                            <div>
                                <h4 class="font-medium">Email Notifications</h4>
                                <p class="text-sm text-gray-500">Receive updates and promotions via email</p>
                            </div>
                            <label class="relative inline-flex items-center cursor-pointer">
                                <input type="checkbox" value="" class="sr-only peer" checked>
                                <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-indigo-600"></div>
                            </label>
                        </div>
                        <div class="flex items-center justify-between">
                            <div>
                                <h4 class="font-medium">SMS Notifications</h4>
                                <p class="text-sm text-gray-500">Receive appointment reminders via SMS</p>
                            </div>
                            <label class="relative inline-flex items-center cursor-pointer">
                                <input type="checkbox" value="" class="sr-only peer" checked>
                                <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-indigo-600"></div>
                            </label>
                        </div>
                        <div class="flex items-center justify-between">
                            <div>
                                <h4 class="font-medium">Promotional Offers</h4>
                                <p class="text-sm text-gray-500">Receive special offers and discounts</p>
                            </div>
                            <label class="relative inline-flex items-center cursor-pointer">
                                <input type="checkbox" value="" class="sr-only peer">
                                <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-indigo-600"></div>
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Security Tab Content (Hidden by default) -->
            <div id="security-content" class="profile-content hidden">
                <div class="profile-section bg-white rounded-xl shadow-sm p-6 mb-6">
                    <h2 class="text-xl font-semibold text-gray-800 mb-4">Password & Security</h2>
                    <div class="mb-6">
                        <label class="block text-gray-700 text-sm font-medium mb-2">Email</label>
                        <div class="bg-gray-50 px-4 py-2 rounded-lg mb-2">Sedra.Ransiluni.G.K.@example.com</div>
                        <p class="text-xs text-gray-500">Your email is also used for logging in</p>
                    </div>
                    <div class="mb-6">
                        <label class="block text-gray-700 text-sm font-medium mb-2">Password</label>
                        <div class="flex items-center justify-between bg-gray-50 px-4 py-2 rounded-lg">
                            <span>••••••••</span>
                            <button class="text-indigo-600 hover:text-indigo-800 text-sm font-medium">
                                Change Password
                            </button>
                        </div>
                    </div>
                    <div>
                        <label class="block text-gray-700 text-sm font-medium mb-2">Two-Factor Authentication</label>
                        <div class="flex items-center justify-between">
                            <div>
                                <span class="text-gray-600">Disabled</span>
                                <p class="text-xs text-gray-500">Add an extra layer of security to your account</p>
                            </div>
                            <button class="bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-indigo-700">
                                Enable
                            </button>
                        </div>
                    </div>
                </div>

                <div class="profile-section bg-white rounded-xl shadow-sm p-6">
                    <h2 class="text-xl font-semibold text-gray-800 mb-4">Connected Devices</h2>
                    <div class="space-y-4">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-3">
                                <i class="fas fa-desktop text-indigo-600 text-xl"></i>
                                <div>
                                    <h4 class="font-medium">MacBook Pro</h4>
                                    <p class="text-sm text-gray-500">Last active: Today, 10:24 AM</p>
                                </div>
                            </div>
                            <button class="text-red-600 hover:text-red-800 text-sm font-medium">
                                Sign Out
                            </button>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-3">
                                <i class="fas fa-mobile-alt text-indigo-600 text-xl"></i>
                                <div>
                                    <h4 class="font-medium">iPhone 13</h4>
                                    <p class="text-sm text-gray-500">Last active: Yesterday, 3:45 PM</p>
                                </div>
                            </div>
                            <button class="text-red-600 hover:text-red-800 text-sm font-medium">
                                Sign Out
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- History Tab Content (Hidden by default) -->
            <div id="history-content" class="profile-content hidden">
                <div class="profile-section bg-white rounded-xl shadow-sm p-6 mb-6">
                    <h2 class="text-xl font-semibold text-gray-800 mb-4">Appointment History</h2>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Service</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Stylist</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Amount</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200">
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">May 25, 2023</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">Haircut & Styling</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">Emma Wilson</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">$45.00</td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">Completed</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">May 15, 2023</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">Facial Treatment</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">Sophia Martinez</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">$75.00</td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">Completed</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">April 28, 2023</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">Manicure & Pedicure</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">Jessica Lee</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">$65.00</td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">Completed</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="profile-section bg-white rounded-xl shadow-sm p-6">
                    <h2 class="text-xl font-semibold text-gray-800 mb-4">Loyalty Points History</h2>
                    <div class="space-y-4">
                        <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                            <div class="flex items-center space-x-3">
                                <div class="w-10 h-10 bg-indigo-100 rounded-full flex items-center justify-center">
                                    <i class="fas fa-cut text-indigo-600"></i>
                                </div>
                                <div>
                                    <h4 class="font-medium">Hair Coloring</h4>
                                    <p class="text-sm text-gray-500">May 25, 2023</p>
                                </div>
                            </div>
                            <div class="text-right">
                                <span class="font-medium text-green-600">+50 points</span>
                                <p class="text-sm text-gray-500">Total: 1,250</p>
                            </div>
                        </div>
                        <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                            <div class="flex items-center space-x-3">
                                <div class="w-10 h-10 bg-indigo-100 rounded-full flex items-center justify-center">
                                    <i class="fas fa-spa text-indigo-600"></i>
                                </div>
                                <div>
                                    <h4 class="font-medium">Spa Treatment</h4>
                                    <p class="text-sm text-gray-500">May 15, 2023</p>
                                </div>
                            </div>
                            <div class="text-right">
                                <span class="font-medium text-green-600">+30 points</span>
                                <p class="text-sm text-gray-500">Total: 1,200</p>
                            </div>
                        </div>
                        <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                            <div class="flex items-center space-x-3">
                                <div class="w-10 h-10 bg-indigo-100 rounded-full flex items-center justify-center">
                                    <i class="fas fa-hand-sparkles text-indigo-600"></i>
                                </div>
                                <div>
                                    <h4 class="font-medium">Manicure</h4>
                                    <p class="text-sm text-gray-500">April 28, 2023</p>
                                </div>
                            </div>
                            <div class="text-right">
                                <span class="font-medium text-green-600">+20 points</span>
                                <p class="text-sm text-gray-500">Total: 1,170</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
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
            // Tab functionality
            const tabs = {
                personal: {
                    tab: document.getElementById('personal-tab'),
                    content: document.getElementById('personal-content')
                },
                preferences: {
                    tab: document.getElementById('preferences-tab'),
                    content: document.getElementById('preferences-content')
                },
                security: {
                    tab: document.getElementById('security-tab'),
                    content: document.getElementById('security-content')
                },
                history: {
                    tab: document.getElementById('history-tab'),
                    content: document.getElementById('history-content')
                }
            };

            // Function to switch tabs
            function switchTab(activeTab) {
                // Remove active class from all tabs
                Object.values(tabs).forEach(tab => {
                    tab.tab.classList.remove('tab-active', 'text-indigo-600');
                    tab.tab.classList.add('text-gray-500');
                    tab.content.classList.add('hidden');
                });

                // Add active class to clicked tab
                activeTab.tab.classList.add('tab-active', 'text-indigo-600');
                activeTab.tab.classList.remove('text-gray-500');
                activeTab.content.classList.remove('hidden');
            }

            // Add click event listeners to tabs
            Object.values(tabs).forEach(tab => {
                tab.tab.addEventListener('click', () => switchTab(tab));
            });

            // Initialize with personal tab active
            switchTab(tabs.personal);
        });

        // Function to confirm account deletion
        function confirmDelete() {
            if (confirm("Are you sure you want to delete your account? This action cannot be undone.")) {
                // Create a form to submit the delete action
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/userProfile';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';

                form.appendChild(actionInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>