<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.beauty.model.User" %>
<%@ page import="com.beauty.model.Appointment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
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

    // Get appointments from request attribute
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");

    // Get success or error messages from session
    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");

    // Clear messages after retrieving them
    session.removeAttribute("message");
    session.removeAttribute("error");

    // If appointments is null (direct access to JSP), redirect to the servlet
    if (appointments == null) {
        response.sendRedirect(request.getContextPath() + "/myAppointments");
        return;
    }

    // Create formatter for displaying dates
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("h:mm a");

    // Filter appointments by status
    List<Appointment> upcomingAppointments = new java.util.ArrayList<>();
    List<Appointment> completedAppointments = new java.util.ArrayList<>();
    List<Appointment> cancelledAppointments = new java.util.ArrayList<>();

    LocalDateTime now = LocalDateTime.now();

    for (Appointment appointment : appointments) {
        String status = appointment.getStatus();
        if (status.equalsIgnoreCase("Scheduled") || status.equalsIgnoreCase("Confirmed")) {
            if (appointment.getDateTime().isAfter(now)) {
                upcomingAppointments.add(appointment);
            } else {
                // If the appointment date is in the past but status is still scheduled/confirmed,
                // consider it as completed
                completedAppointments.add(appointment);
            }
        } else if (status.equalsIgnoreCase("Completed")) {
            completedAppointments.add(appointment);
        } else if (status.equalsIgnoreCase("Cancelled")) {
            cancelledAppointments.add(appointment);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments - Beauty Salon</title>
    <script src="https://cdn.tailwindcss.com"></script>
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
                <a href="${pageContext.request.contextPath}/Client/Client_Dashboard.jsp" class="text-gray-600 hover:text-indigo-600">Dashboard</a>
                <a href="${pageContext.request.contextPath}/myAppointments" class="text-indigo-600 font-medium">My Appointments</a>
                <a href="${pageContext.request.contextPath}/Client/Client_ServiceCart.jsp" class="text-gray-600 hover:text-indigo-600">Services</a>
                <a href="${pageContext.request.contextPath}/userProfile" class="text-gray-600 hover:text-indigo-600">Profile</a>
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
                        <a href="${pageContext.request.contextPath}/Client/Client_Dashboard.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="fas fa-tachometer-alt mr-3"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/myAppointments" class="flex items-center bg-indigo-50 text-indigo-600 p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="far fa-calendar-alt mr-3"></i>
                            <span>My Appointments</span>
                            <span class="ml-auto bg-indigo-100 text-indigo-800 text-xs px-2 py-1 rounded-full"><%= upcomingAppointments.size() %></span>
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
            <!-- Page Header -->
            <div class="flex flex-col md:flex-row items-start md:items-center justify-between mb-6">
                <div>
                    <h1 class="text-2xl font-bold text-gray-800">My Appointments</h1>
                    <p class="text-gray-600">View and manage your upcoming and past appointments</p>
                </div>
                <a href="${pageContext.request.contextPath}/bookAppointment" class="mt-4 md:mt-0 bg-indigo-600 text-white px-4 py-2 rounded-lg font-medium hover:bg-indigo-700 transition inline-block">
                    <i class="fas fa-plus mr-2"></i> Book New Appointment
                </a>
            </div>

            <!-- Messages -->
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

            <!-- Tabs -->
            <div class="border-b border-gray-200 mb-6">
                <nav class="-mb-px flex space-x-8">
                    <a href="#" id="upcoming-tab" class="border-indigo-500 text-indigo-600 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" role="tab" aria-selected="true">Upcoming (<%= upcomingAppointments.size() %>)</a>
                    <a href="#" id="completed-tab" class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" role="tab" aria-selected="false">Completed (<%= completedAppointments.size() %>)</a>
                    <a href="#" id="cancelled-tab" class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" role="tab" aria-selected="false">Cancelled (<%= cancelledAppointments.size() %>)</a>
                </nav>
            </div>

            <!-- Upcoming Appointments List -->
            <div id="upcoming-content" class="bg-white rounded-xl shadow-sm overflow-hidden mb-6">
                <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                    <h2 class="text-xl font-semibold text-gray-800">Upcoming Appointments (<%= upcomingAppointments.size() %>)</h2>
                    <div class="flex items-center space-x-2">
                        <button class="text-gray-500 hover:text-gray-700">
                            <i class="fas fa-filter"></i>
                        </button>
                        <button class="text-gray-500 hover:text-gray-700">
                            <i class="fas fa-sort"></i>
                        </button>
                    </div>
                </div>

                <% if (upcomingAppointments.isEmpty()) { %>
                <!-- Empty State -->
                <div class="p-12 text-center">
                    <div class="mx-auto w-32 h-32 bg-gray-100 rounded-full flex items-center justify-center mb-4">
                        <i class="far fa-calendar text-gray-400 text-4xl"></i>
                    </div>
                    <h3 class="text-lg font-medium text-gray-900 mb-1">No upcoming appointments</h3>
                    <p class="text-gray-500 mb-4">You don't have any appointments scheduled yet.</p>
                    <a href="${pageContext.request.contextPath}/bookAppointment" class="bg-indigo-600 text-white px-4 py-2 rounded-lg font-medium hover:bg-indigo-700 transition inline-block">
                        <i class="fas fa-plus mr-2"></i> Book New Appointment
                    </a>
                </div>
                <% } else { %>
                    <% for (Appointment appointment : upcomingAppointments) { %>
                    <!-- Appointment Item -->
                    <div class="p-6 border-b border-gray-100">
                        <div class="flex flex-col md:flex-row md:items-center justify-between">
                            <div class="flex items-start space-x-4 mb-4 md:mb-0">
                                <div class="w-16 h-16 bg-indigo-100 rounded-lg flex items-center justify-center">
                                    <% if (appointment.getService().toLowerCase().contains("hair")) { %>
                                        <i class="fas fa-cut text-indigo-600 text-xl"></i>
                                    <% } else if (appointment.getService().toLowerCase().contains("spa") || appointment.getService().toLowerCase().contains("facial")) { %>
                                        <i class="fas fa-spa text-indigo-600 text-xl"></i>
                                    <% } else if (appointment.getService().toLowerCase().contains("manicure") || appointment.getService().toLowerCase().contains("pedicure")) { %>
                                        <i class="fas fa-hand-sparkles text-indigo-600 text-xl"></i>
                                    <% } else if (appointment.getService().toLowerCase().contains("massage")) { %>
                                        <i class="fas fa-hands text-indigo-600 text-xl"></i>
                                    <% } else { %>
                                        <i class="fas fa-concierge-bell text-indigo-600 text-xl"></i>
                                    <% } %>
                                </div>
                                <div>
                                    <h3 class="font-medium text-lg"><%= appointment.getService() %></h3>
                                    <p class="text-gray-600">with <%= appointment.getStylist() %></p>
                                    <div class="mt-2 flex items-center space-x-2">
                                        <% if (appointment.getStatus().equalsIgnoreCase("Confirmed")) { %>
                                            <span class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded-full">Confirmed</span>
                                        <% } else { %>
                                            <span class="px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded-full">Scheduled</span>
                                        <% } %>
                                        <span class="text-gray-500 text-sm"><i class="far fa-clock mr-1"></i> 1 hour</span>
                                    </div>
                                </div>
                            </div>

                            <div class="flex flex-col md:items-end">
                                <div class="text-lg font-medium mb-2">
                                    <%= appointment.getDateTime().format(dateFormatter) %>,
                                    <%= appointment.getDateTime().format(timeFormatter) %>
                                </div>
                                <div class="flex space-x-2">
                                    <a href="${pageContext.request.contextPath}/appointmentAction?action=reschedule&id=<%= appointment.getId() %>" class="px-3 py-1 bg-indigo-600 text-white rounded-lg text-sm hover:bg-indigo-700 inline-block">
                                        <i class="fas fa-calendar-check mr-1"></i> Reschedule
                                    </a>
                                    <a href="#" onclick="confirmCancel('<%= appointment.getId() %>')" class="px-3 py-1 bg-white border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 inline-block">
                                        <i class="fas fa-times mr-1"></i> Cancel
                                    </a>
                                    <button class="px-3 py-1 bg-white border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50">
                                        <i class="fas fa-info-circle mr-1"></i> Details
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                <% } %>
            </div>

            <!-- Completed Appointments List -->
            <div id="completed-content" class="bg-white rounded-xl shadow-sm overflow-hidden mb-6 hidden">
                <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                    <h2 class="text-xl font-semibold text-gray-800">Completed Appointments (<%= completedAppointments.size() %>)</h2>
                    <div class="flex items-center space-x-2">
                        <button class="text-gray-500 hover:text-gray-700">
                            <i class="fas fa-filter"></i>
                        </button>
                        <button class="text-gray-500 hover:text-gray-700">
                            <i class="fas fa-sort"></i>
                        </button>
                    </div>
                </div>

                <% if (completedAppointments.isEmpty()) { %>
                <!-- Empty State -->
                <div class="p-12 text-center">
                    <div class="mx-auto w-32 h-32 bg-gray-100 rounded-full flex items-center justify-center mb-4">
                        <i class="far fa-calendar-check text-gray-400 text-4xl"></i>
                    </div>
                    <h3 class="text-lg font-medium text-gray-900 mb-1">No completed appointments</h3>
                    <p class="text-gray-500 mb-4">You haven't completed any appointments yet.</p>
                </div>
                <% } else { %>
                    <% for (Appointment appointment : completedAppointments) { %>
                    <!-- Completed Appointment Item -->
                    <div class="p-6 border-b border-gray-100">
                        <div class="flex flex-col md:flex-row md:items-center justify-between">
                            <div class="flex items-start space-x-4 mb-4 md:mb-0">
                                <div class="w-16 h-16 bg-gray-100 rounded-lg flex items-center justify-center">
                                    <% if (appointment.getService().toLowerCase().contains("hair")) { %>
                                        <i class="fas fa-cut text-gray-500 text-xl"></i>
                                    <% } else if (appointment.getService().toLowerCase().contains("spa") || appointment.getService().toLowerCase().contains("facial")) { %>
                                        <i class="fas fa-spa text-gray-500 text-xl"></i>
                                    <% } else if (appointment.getService().toLowerCase().contains("manicure") || appointment.getService().toLowerCase().contains("pedicure")) { %>
                                        <i class="fas fa-hand-sparkles text-gray-500 text-xl"></i>
                                    <% } else if (appointment.getService().toLowerCase().contains("massage")) { %>
                                        <i class="fas fa-hands text-gray-500 text-xl"></i>
                                    <% } else { %>
                                        <i class="fas fa-concierge-bell text-gray-500 text-xl"></i>
                                    <% } %>
                                </div>
                                <div>
                                    <h3 class="font-medium text-lg"><%= appointment.getService() %></h3>
                                    <p class="text-gray-600">with <%= appointment.getStylist() %></p>
                                    <div class="mt-2 flex items-center space-x-2">
                                        <span class="px-2 py-1 bg-gray-100 text-gray-800 text-xs rounded-full">Completed</span>
                                        <span class="text-gray-500 text-sm"><i class="far fa-clock mr-1"></i> 1 hour</span>
                                    </div>
                                </div>
                            </div>

                            <div class="flex flex-col md:items-end">
                                <div class="text-lg font-medium mb-2">
                                    <%= appointment.getDateTime().format(dateFormatter) %>,
                                    <%= appointment.getDateTime().format(timeFormatter) %>
                                </div>
                                <div class="flex space-x-2">
                                    <a href="${pageContext.request.contextPath}/bookAppointment" class="px-3 py-1 bg-indigo-600 text-white rounded-lg text-sm hover:bg-indigo-700 inline-block">
                                        <i class="fas fa-redo mr-1"></i> Book Again
                                    </a>
                                    <button class="px-3 py-1 bg-white border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50">
                                        <i class="fas fa-info-circle mr-1"></i> Details
                                    </button>
                                    <button class="px-3 py-1 bg-white border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50">
                                        <i class="fas fa-star mr-1"></i> Rate
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                <% } %>
            </div>

            <!-- Cancelled Appointments List -->
            <div id="cancelled-content" class="bg-white rounded-xl shadow-sm overflow-hidden mb-6 hidden">
                <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                    <h2 class="text-xl font-semibold text-gray-800">Cancelled Appointments (<%= cancelledAppointments.size() %>)</h2>
                    <div class="flex items-center space-x-2">
                        <button class="text-gray-500 hover:text-gray-700">
                            <i class="fas fa-filter"></i>
                        </button>
                        <button class="text-gray-500 hover:text-gray-700">
                            <i class="fas fa-sort"></i>
                        </button>
                    </div>
                </div>

                <% if (cancelledAppointments.isEmpty()) { %>
                <!-- Empty State -->
                <div class="p-12 text-center">
                    <div class="mx-auto w-32 h-32 bg-gray-100 rounded-full flex items-center justify-center mb-4">
                        <i class="fas fa-calendar-times text-gray-400 text-4xl"></i>
                    </div>
                    <h3 class="text-lg font-medium text-gray-900 mb-1">No cancelled appointments</h3>
                    <p class="text-gray-500 mb-4">You don't have any cancelled appointments.</p>
                </div>
                <% } else { %>
                    <% for (Appointment appointment : cancelledAppointments) { %>
                    <!-- Cancelled Appointment Item -->
                    <div class="p-6 border-b border-gray-100">
                        <div class="flex flex-col md:flex-row md:items-center justify-between">
                            <div class="flex items-start space-x-4 mb-4 md:mb-0">
                                <div class="w-16 h-16 bg-gray-100 rounded-lg flex items-center justify-center">
                                    <% if (appointment.getService().toLowerCase().contains("hair")) { %>
                                        <i class="fas fa-cut text-gray-500 text-xl"></i>
                                    <% } else if (appointment.getService().toLowerCase().contains("spa") || appointment.getService().toLowerCase().contains("facial")) { %>
                                        <i class="fas fa-spa text-gray-500 text-xl"></i>
                                    <% } else if (appointment.getService().toLowerCase().contains("manicure") || appointment.getService().toLowerCase().contains("pedicure")) { %>
                                        <i class="fas fa-hand-sparkles text-gray-500 text-xl"></i>
                                    <% } else if (appointment.getService().toLowerCase().contains("massage")) { %>
                                        <i class="fas fa-hands text-gray-500 text-xl"></i>
                                    <% } else { %>
                                        <i class="fas fa-concierge-bell text-gray-500 text-xl"></i>
                                    <% } %>
                                </div>
                                <div>
                                    <h3 class="font-medium text-lg"><%= appointment.getService() %></h3>
                                    <p class="text-gray-600">with <%= appointment.getStylist() %></p>
                                    <div class="mt-2 flex items-center space-x-2">
                                        <span class="px-2 py-1 bg-red-100 text-red-800 text-xs rounded-full">Cancelled</span>
                                        <span class="text-gray-500 text-sm"><i class="far fa-clock mr-1"></i> 1 hour</span>
                                    </div>
                                </div>
                            </div>

                            <div class="flex flex-col md:items-end">
                                <div class="text-lg font-medium mb-2">
                                    <%= appointment.getDateTime().format(dateFormatter) %>,
                                    <%= appointment.getDateTime().format(timeFormatter) %>
                                </div>
                                <div class="flex space-x-2">
                                    <a href="${pageContext.request.contextPath}/bookAppointment" class="px-3 py-1 bg-indigo-600 text-white rounded-lg text-sm hover:bg-indigo-700 inline-block">
                                        <i class="fas fa-redo mr-1"></i> Book Again
                                    </a>
                                    <button class="px-3 py-1 bg-white border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50">
                                        <i class="fas fa-info-circle mr-1"></i> Details
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                <% } %>
            </div>

            <!-- Past Appointments Section -->
            <div class="bg-white rounded-xl shadow-sm overflow-hidden">
                <div class="p-6 border-b border-gray-100">
                    <h2 class="text-xl font-semibold text-gray-800">Past Appointments</h2>
                </div>

                <!-- Past Appointment Item -->
                <div class="p-6 border-b border-gray-100">
                    <div class="flex flex-col md:flex-row md:items-center justify-between">
                        <div class="flex items-start space-x-4 mb-4 md:mb-0">
                            <div class="w-16 h-16 bg-gray-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-cut text-gray-500 text-xl"></i>
                            </div>
                            <div>
                                <h3 class="font-medium text-lg">Haircut & Styling</h3>
                                <p class="text-gray-600">with Emma Wilson</p>
                                <div class="mt-2 flex items-center space-x-2">
                                    <span class="px-2 py-1 bg-gray-100 text-gray-800 text-xs rounded-full">Completed</span>
                                    <span class="text-gray-500 text-sm"><i class="far fa-clock mr-1"></i> 45 min</span>
                                    <span class="text-gray-500 text-sm"><i class="fas fa-dollar-sign mr-1"></i> 45.00</span>
                                </div>
                            </div>
                        </div>

                        <div class="flex flex-col md:items-end">
                            <div class="text-lg font-medium mb-2">May 25, 2023, 3:00 PM</div>
                            <div class="flex space-x-2">
                                <button class="px-3 py-1 bg-indigo-600 text-white rounded-lg text-sm hover:bg-indigo-700">
                                    <i class="fas fa-redo mr-1"></i> Book Again
                                </button>
                                <button class="px-3 py-1 bg-white border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50">
                                    <i class="fas fa-info-circle mr-1"></i> Details
                                </button>
                                <button class="px-3 py-1 bg-white border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50">
                                    <i class="fas fa-star mr-1"></i> Rate
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Another Past Appointment -->
                <div class="p-6">
                    <div class="flex flex-col md:flex-row md:items-center justify-between">
                        <div class="flex items-start space-x-4 mb-4 md:mb-0">
                            <div class="w-16 h-16 bg-gray-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-spa text-gray-500 text-xl"></i>
                            </div>
                            <div>
                                <h3 class="font-medium text-lg">Facial Treatment</h3>
                                <p class="text-gray-600">with Sophia Martinez</p>
                                <div class="mt-2 flex items-center space-x-2">
                                    <span class="px-2 py-1 bg-gray-100 text-gray-800 text-xs rounded-full">Completed</span>
                                    <span class="text-gray-500 text-sm"><i class="far fa-clock mr-1"></i> 1 hour</span>
                                    <span class="text-gray-500 text-sm"><i class="fas fa-dollar-sign mr-1"></i> 75.00</span>
                                </div>
                            </div>
                        </div>

                        <div class="flex flex-col md:items-end">
                            <div class="text-lg font-medium mb-2">May 15, 2023, 10:00 AM</div>
                            <div class="flex space-x-2">
                                <button class="px-3 py-1 bg-indigo-600 text-white rounded-lg text-sm hover:bg-indigo-700">
                                    <i class="fas fa-redo mr-1"></i> Book Again
                                </button>
                                <button class="px-3 py-1 bg-white border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50">
                                    <i class="fas fa-info-circle mr-1"></i> Details
                                </button>
                                <button class="px-3 py-1 bg-white border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50">
                                    <i class="fas fa-star mr-1"></i> Rate
                                </button>
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
            const tabs = document.querySelectorAll('[role="tab"]');
            const tabContents = {
                'upcoming-tab': document.getElementById('upcoming-content'),
                'completed-tab': document.getElementById('completed-content'),
                'cancelled-tab': document.getElementById('cancelled-content')
            };

            tabs.forEach(tab => {
                tab.addEventListener('click', (e) => {
                    e.preventDefault();

                    // Remove all current selected tabs
                    tabs.forEach(t => {
                        t.setAttribute('aria-selected', 'false');
                        t.classList.remove('border-indigo-500', 'text-indigo-600');
                        t.classList.add('border-transparent', 'text-gray-500');
                    });

                    // Set this tab as selected
                    tab.setAttribute('aria-selected', 'true');
                    tab.classList.add('border-indigo-500', 'text-indigo-600');
                    tab.classList.remove('border-transparent', 'text-gray-500');

                    // Hide all tab contents
                    Object.values(tabContents).forEach(content => {
                        content.classList.add('hidden');
                    });

                    // Show the selected tab content
                    const tabId = tab.id;
                    tabContents[tabId].classList.remove('hidden');
                });
            });
        });

        // Function to confirm appointment cancellation
        function confirmCancel(appointmentId) {
            if (confirm('Are you sure you want to cancel this appointment? This action cannot be undone.')) {
                // Redirect to the cancel action URL
                window.location.href = '${pageContext.request.contextPath}/appointmentAction?action=cancel&id=' + appointmentId;
            }
        }
    </script>
</body>
</html>