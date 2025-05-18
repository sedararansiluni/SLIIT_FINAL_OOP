<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.beauty.model.User" %>
<%@ page import="com.beauty.model.Appointment" %>
<%@ page import="com.beauty.service.AppointmentService" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
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
    if (!email.contains("Admin@gmail.com")) {
        // Redirect to client dashboard if not an admin
        response.sendRedirect(request.getContextPath() + "/Client/Client_Dashboard.jsp");
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

    // Read inquiries from file
    List<Map<String, String>> inquiries = new ArrayList<>();
    String inquiryFilePath = "C:\\Users\\Venura\\Desktop\\CustomerDemo\\Beauty_version 01\\Beauty\\src\\main\\webapp\\Database\\inquiry.txt";
    File inquiryFile = new File(inquiryFilePath);

    if (inquiryFile.exists()) {
        try (BufferedReader reader = new BufferedReader(new FileReader(inquiryFile))) {
            Map<String, String> currentInquiry = null;
            String line;
            StringBuilder messageBuilder = null;
            StringBuilder replyBuilder = null;
            boolean inMessage = false;
            boolean inReply = false;

            while ((line = reader.readLine()) != null) {
                if (line.startsWith("Date: ")) {
                    // Start of a new inquiry
                    if (currentInquiry != null && !currentInquiry.isEmpty()) {
                        // Save previous inquiry
                        if (messageBuilder != null) {
                            currentInquiry.put("Message", messageBuilder.toString().trim());
                        }
                        if (replyBuilder != null) {
                            currentInquiry.put("Reply", replyBuilder.toString().trim());
                        }
                        inquiries.add(currentInquiry);
                    }

                    currentInquiry = new LinkedHashMap<>();
                    currentInquiry.put("Date", line.substring(6).trim());
                    messageBuilder = null;
                    replyBuilder = null;
                    inMessage = false;
                    inReply = false;
                } else if (line.startsWith("User: ")) {
                    currentInquiry.put("User", line.substring(6).trim());
                } else if (line.startsWith("Email: ")) {
                    currentInquiry.put("Email", line.substring(7).trim());
                } else if (line.startsWith("Subject: ")) {
                    currentInquiry.put("Subject", line.substring(9).trim());
                } else if (line.startsWith("Priority: ")) {
                    currentInquiry.put("Priority", line.substring(10).trim());
                } else if (line.startsWith("Message: ")) {
                    inMessage = true;
                    inReply = false;
                    messageBuilder = new StringBuilder();
                    messageBuilder.append(line.substring(9).trim());
                } else if (line.startsWith("Status: ")) {
                    inMessage = false;
                    inReply = false;
                    currentInquiry.put("Status", line.substring(8).trim());
                } else if (line.startsWith("Reply: ")) {
                    inMessage = false;
                    inReply = true;
                    replyBuilder = new StringBuilder();
                    replyBuilder.append(line.substring(7).trim());
                } else if (line.startsWith("-----------------------------------")) {
                    // End of current inquiry section
                    inMessage = false;
                    inReply = false;
                } else {
                    // Continuation of message or reply
                    if (inMessage && messageBuilder != null) {
                        messageBuilder.append("\n").append(line);
                    } else if (inReply && replyBuilder != null) {
                        replyBuilder.append("\n").append(line);
                    }
                }
            }

            // Add the last inquiry if exists
            if (currentInquiry != null && !currentInquiry.isEmpty()) {
                if (messageBuilder != null) {
                    currentInquiry.put("Message", messageBuilder.toString().trim());
                }
                if (replyBuilder != null) {
                    currentInquiry.put("Reply", replyBuilder.toString().trim());
                }
                inquiries.add(currentInquiry);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Reverse the list to show newest inquiries first
    Collections.reverse(inquiries);

    // Get recent inquiries (last 5)
    List<Map<String, String>> recentInquiries = inquiries.size() > 5 ?
        inquiries.subList(0, 5) : inquiries;

    // Count unresolved inquiries
    int unresolvedCount = 0;
    for (Map<String, String> inquiry : inquiries) {
        String status = inquiry.get("Status");
        if (status != null && (status.equals("New") || status.equals("Pending"))) {
            unresolvedCount++;
        }
    }

    // Get appointments using AppointmentService
    AppointmentService appointmentService = new AppointmentService();
    List<Appointment> appointmentList = appointmentService.getAllAppointments();

    // Sort appointments by date and time
    Collections.sort(appointmentList, new Comparator<Appointment>() {
        @Override
        public int compare(Appointment a1, Appointment a2) {
            return a1.getDateTime().compareTo(a2.getDateTime());
        }
    });

    // Get upcoming appointments (future dates)
    List<Appointment> upcomingAppointments = new ArrayList<>();
    LocalDate today = LocalDate.now();

    for (Appointment appointment : appointmentList) {
        if (appointment.getDateTime().toLocalDate().compareTo(today) >= 0) {
            upcomingAppointments.add(appointment);
        }
    }

    // Get recent appointments (limit to 5)
    List<Appointment> recentAppointments = upcomingAppointments.size() > 5 ?
        upcomingAppointments.subList(0, 5) : upcomingAppointments;

    // Count total appointments
    int totalAppointments = appointmentList.size();

    // Count today's appointments
    int todayAppointments = 0;
    for (Appointment appointment : appointmentList) {
        if (appointment.getDateTime().toLocalDate().equals(today)) {
            todayAppointments++;
        }
    }

    // Calculate appointment growth (compare with last week)
    int lastWeekAppointments = 0;
    LocalDate lastWeek = today.minusDays(7);

    for (Appointment appointment : appointmentList) {
        LocalDate appointmentDate = appointment.getDateTime().toLocalDate();
        if (appointmentDate.compareTo(lastWeek) >= 0 &&
            appointmentDate.compareTo(today) < 0) {
            lastWeekAppointments++;
        }
    }

    // Calculate growth percentage
    int appointmentGrowth = lastWeekAppointments > 0 ?
        (int)(((float)todayAppointments / lastWeekAppointments - 1) * 100) : 0;

    // Extract unique clients
    Set<String> uniqueClients = new HashSet<>();
    for (Appointment appointment : appointmentList) {
        String clientEmail = appointment.getUserId(); // Using userId as email
        if (clientEmail != null && !clientEmail.isEmpty()) {
            uniqueClients.add(clientEmail);
        }
    }

    // Count active clients (had appointment in last 30 days)
    int activeClients = 0;
    LocalDate thirtyDaysAgo = today.minusDays(30);

    Set<String> activeClientEmails = new HashSet<>();
    for (Appointment appointment : appointmentList) {
        if (appointment.getDateTime().toLocalDate().compareTo(thirtyDaysAgo) >= 0) {
            String activeEmail = appointment.getUserId();
            if (activeEmail != null && !activeEmail.isEmpty()) {
                activeClientEmails.add(activeEmail);
            }
        }
    }
    activeClients = activeClientEmails.size();

    // Count new clients today
    int newClientsToday = 0;
    Set<String> todayClients = new HashSet<>();
    Set<String> previousClients = new HashSet<>();

    for (Appointment appointment : appointmentList) {
        String clientEmailAddr = appointment.getUserId();
        if (clientEmailAddr != null && !clientEmailAddr.isEmpty()) {
            LocalDate appointmentDate = appointment.getDateTime().toLocalDate();
            if (appointmentDate.equals(today)) {
                todayClients.add(clientEmailAddr);
            } else if (appointmentDate.compareTo(today) < 0) {
                previousClients.add(clientEmailAddr);
            }
        }
    }

    for (String todayEmail : todayClients) {
        if (!previousClients.contains(todayEmail)) {
            newClientsToday++;
        }
    }

    // Calculate monthly revenue (assuming each appointment has a service with a price)
    double monthlyRevenue = 0.0;
    LocalDate firstDayOfMonth = today.withDayOfMonth(1);

    // This is a simplified calculation - in a real app, you'd get actual prices from services
    // For now, we'll use a random price between $50 and $200 for each appointment
    Random random = new Random();
    for (Appointment appointment : appointmentList) {
        if (appointment.getDateTime().toLocalDate().compareTo(firstDayOfMonth) >= 0) {
            // Generate a random price between $50 and $200
            double price = 50 + random.nextDouble() * 150;
            monthlyRevenue += price;
        }
    }

    // Calculate revenue growth (compare with last month)
    double lastMonthRevenue = monthlyRevenue * 0.85; // Simplified: assume last month was 85% of this month
    int revenueGrowth = (int)(((monthlyRevenue / lastMonthRevenue) - 1) * 100);

    // Get recent clients (last 5 unique clients)
    List<Appointment> clientAppointments = new ArrayList<>(appointmentList);
    // Sort by date descending
    Collections.sort(clientAppointments, new Comparator<Appointment>() {
        @Override
        public int compare(Appointment a1, Appointment a2) {
            return a2.getDateTime().compareTo(a1.getDateTime());
        }
    });

    // Extract unique recent clients
    List<Appointment> recentClients = new ArrayList<>();
    Set<String> addedEmails = new HashSet<>();

    for (Appointment appointment : clientAppointments) {
        String recentEmail = appointment.getUserId();
        if (recentEmail != null && !recentEmail.isEmpty() && !addedEmails.contains(recentEmail)) {
            addedEmails.add(recentEmail);
            recentClients.add(appointment);

            if (recentClients.size() >= 5) {
                break;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Saloon - Dashboard</title>
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
                <a href="${pageContext.request.contextPath}/Admin/Admin_Dashboard.jsp" class="text-indigo-600 font-medium">Dashboard</a>
                <a href="${pageContext.request.contextPath}/adminAppointments" class="text-gray-600 hover:text-indigo-600">Appointments</a>
                <a href="${pageContext.request.contextPath}/adminUsers" class="text-gray-600 hover:text-indigo-600">Users</a>
                <a href="${pageContext.request.contextPath}/Admin/Admin_Services.jsp" class="text-gray-600 hover:text-indigo-600">Services</a>
            </nav>

            <!-- Profile Section -->
            <div class="flex items-center space-x-4">
                <button class="p-2 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200">
                    <i class="fas fa-bell"></i>
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
                <h2 class="text-lg font-semibold text-gray-700 mb-4">Quick Menu</h2>
                <ul class="space-y-2">
                    <li>
                        <a href="${pageContext.request.contextPath}/Admin/Admin_Dashboard.jsp" class="flex items-center p-3 rounded-lg bg-indigo-50 text-indigo-600">
                            <i class="fas fa-tachometer-alt mr-3"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/adminAppointments" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="far fa-calendar-alt mr-3"></i>
                            <span>Appointments</span>
                            <span class="ml-auto bg-red-100 text-red-800 text-xs px-2 py-1 rounded-full">5</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/adminUsers" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="fas fa-users mr-3"></i>
                            <span>Users</span>
                        </a>
                    </li>
                    <li>
                        <a href="Admin_Services.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="fas fa-cut mr-3"></i>
                            <span>Services</span>
                        </a>
                    </li>
                    <li>
                        <a href="Admin_Inquiries.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="fas fa-question-circle mr-3"></i>
                            <span>Inquiries</span>
                            <% if (unresolvedCount > 0) { %>
                            <span class="ml-auto bg-red-100 text-red-800 text-xs px-2 py-1 rounded-full"><%= unresolvedCount %></span>
                            <% } %>
                        </a>
                    </li>
                </ul>

                <div class="mt-8">
                    <h2 class="text-lg font-semibold text-gray-700 mb-4">Today's Stats</h2>
                    <div class="bg-indigo-50 rounded-lg p-4">
                        <div class="flex items-center justify-between mb-3">
                            <span class="text-gray-600">Appointments</span>
                            <span class="font-bold">12</span>
                        </div>
                        <div class="flex items-center justify-between mb-3">
                            <span class="text-gray-600">New Clients</span>
                            <span class="font-bold">3</span>
                        </div>
                        <div class="flex items-center justify-between">
                            <span class="text-gray-600">Revenue</span>
                            <span class="font-bold">$1,245</span>
                        </div>
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

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
                <!-- Stats Cards -->
                <div class="bg-white rounded-xl shadow-sm p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500">Total Appointments</p>
                            <h3 class="text-2xl font-bold mt-1"><%= totalAppointments %></h3>
                            <p class="<%= appointmentGrowth >= 0 ? "text-green-500" : "text-red-500" %> text-sm mt-2">
                                <i class="fas <%= appointmentGrowth >= 0 ? "fa-arrow-up" : "fa-arrow-down" %> mr-1"></i>
                                <%= Math.abs(appointmentGrowth) %>% from last week
                            </p>
                        </div>
                        <div class="w-16 h-16 bg-indigo-50 rounded-full flex items-center justify-center">
                            <i class="fas fa-calendar-check text-indigo-600 text-xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-sm p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500">Active Clients</p>
                            <h3 class="text-2xl font-bold mt-1"><%= activeClients %></h3>
                            <p class="<%= newClientsToday > 0 ? "text-green-500" : "text-gray-500" %> text-sm mt-2">
                                <i class="fas <%= newClientsToday > 0 ? "fa-user-plus" : "fa-user" %> mr-1"></i>
                                <%= newClientsToday %> new today
                            </p>
                        </div>
                        <div class="w-16 h-16 bg-indigo-50 rounded-full flex items-center justify-center">
                            <i class="fas fa-users text-indigo-600 text-xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-sm p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500">Monthly Revenue</p>
                            <h3 class="text-2xl font-bold mt-1">$<%= String.format("%,.0f", monthlyRevenue) %></h3>
                            <p class="<%= revenueGrowth >= 0 ? "text-green-500" : "text-red-500" %> text-sm mt-2">
                                <i class="fas <%= revenueGrowth >= 0 ? "fa-arrow-up" : "fa-arrow-down" %> mr-1"></i>
                                <%= Math.abs(revenueGrowth) %>% from last month
                            </p>
                        </div>
                        <div class="w-16 h-16 bg-indigo-50 rounded-full flex items-center justify-center">
                            <i class="fas fa-dollar-sign text-indigo-600 text-xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-sm p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500">Pending Inquiries</p>
                            <h3 class="text-2xl font-bold mt-1"><%= unresolvedCount %></h3>
                            <p class="<%= unresolvedCount > 0 ? "text-orange-500" : "text-green-500" %> text-sm mt-2">
                                <i class="fas <%= unresolvedCount > 0 ? "fa-exclamation-circle" : "fa-check-circle" %> mr-1"></i>
                                <%= unresolvedCount > 0 ? "Needs attention" : "All resolved" %>
                            </p>
                        </div>
                        <div class="w-16 h-16 bg-indigo-50 rounded-full flex items-center justify-center">
                            <i class="fas fa-question-circle text-indigo-600 text-xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Upcoming Appointments -->
            <div class="bg-white rounded-xl shadow-sm overflow-hidden mb-6">
                <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                    <h2 class="text-xl font-semibold text-gray-800">Upcoming Appointments</h2>
                    <a href="${pageContext.request.contextPath}/adminAppointments" class="text-indigo-600 hover:text-indigo-800 font-medium">View All</a>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Client</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Service</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Staff</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date & Time</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Action</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100">
                            <% if (recentAppointments.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="px-6 py-4 text-center text-gray-500">
                                        No upcoming appointments
                                    </td>
                                </tr>
                            <% } else { %>
                                <% for (Appointment appointment : recentAppointments) { %>
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="flex items-center">
                                                <div class="flex-shrink-0 h-10 w-10 bg-indigo-100 rounded-full flex items-center justify-center">
                                                    <i class="fas fa-user text-indigo-600"></i>
                                                </div>
                                                <div class="ml-4">
                                                    <div class="text-sm font-medium text-gray-900"><%= appointment.getUserName() %></div>
                                                    <div class="text-sm text-gray-500"><%= appointment.getUserId() %></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-900"><%= appointment.getService() %></div>
                                            <div class="text-sm text-gray-500">
                                                <%
                                                // Extract duration from service name (simplified)
                                                String service = appointment.getService();
                                                String duration = "1 hour"; // Default

                                                if (service.contains("Cut")) {
                                                    duration = "30 min";
                                                } else if (service.contains("Color")) {
                                                    duration = "2 hours";
                                                } else if (service.contains("Spa")) {
                                                    duration = "90 min";
                                                }
                                                %>
                                                <%= duration %>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-900"><%= appointment.getStylist() %></div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <%
                                            // Format date for display
                                            LocalDateTime dateTime = appointment.getDateTime();
                                            LocalDate appointmentDate = dateTime.toLocalDate();
                                            LocalDate currentDate = LocalDate.now();

                                            String displayDate;
                                            if (appointmentDate.equals(currentDate)) {
                                                displayDate = "Today";
                                            } else if (appointmentDate.equals(currentDate.plusDays(1))) {
                                                displayDate = "Tomorrow";
                                            } else {
                                                // Format date as "Mon, Jan 15"
                                                displayDate = appointmentDate.format(DateTimeFormatter.ofPattern("EEE, MMM d"));
                                            }

                                            // Format time
                                            String timeStr = dateTime.format(DateTimeFormatter.ofPattern("h:mm a"));
                                            %>
                                            <div class="text-sm text-gray-900"><%= displayDate %>, <%= timeStr %></div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <%
                                            String status = appointment.getStatus();
                                            if (status == null) status = "Scheduled";

                                            String statusClass = "bg-blue-100 text-blue-800"; // Default for Scheduled

                                            if ("Confirmed".equals(status)) {
                                                statusClass = "bg-green-100 text-green-800";
                                            } else if ("Cancelled".equals(status)) {
                                                statusClass = "bg-red-100 text-red-800";
                                            } else if ("Completed".equals(status)) {
                                                statusClass = "bg-indigo-100 text-indigo-800";
                                            } else if ("Pending".equals(status)) {
                                                statusClass = "bg-yellow-100 text-yellow-800";
                                            }
                                            %>
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full <%= statusClass %>">
                                                <%= status %>
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <button class="text-indigo-600 hover:text-indigo-900">View</button>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Recent Clients and Inquiries -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="bg-white rounded-xl shadow-sm overflow-hidden">
                    <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                        <h2 class="text-xl font-semibold text-gray-800">Recent Clients</h2>
                        <a href="${pageContext.request.contextPath}/adminUsers" class="text-indigo-600 hover:text-indigo-800 font-medium">View All</a>
                    </div>
                    <div class="divide-y divide-gray-100">
                        <% if (recentClients.isEmpty()) { %>
                            <div class="p-4">
                                <p class="text-gray-500 text-sm">No recent client activity</p>
                            </div>
                        <% } else { %>
                            <% for (Appointment client : recentClients) { %>
                                <div class="p-4 hover:bg-gray-50">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10 bg-indigo-100 rounded-full flex items-center justify-center">
                                            <i class="fas fa-user text-indigo-600"></i>
                                        </div>
                                        <div class="ml-4 flex-grow">
                                            <div class="flex justify-between">
                                                <div>
                                                    <h3 class="text-sm font-medium text-gray-900"><%= client.getUserName() %></h3>
                                                    <p class="text-sm text-gray-500"><%= client.getUserId() %></p>
                                                </div>
                                                <div>
                                                    <%
                                                    // Format date for display
                                                    LocalDate appointmentDate = client.getDateTime().toLocalDate();
                                                    LocalDate currentDate = LocalDate.now();

                                                    String displayDate;
                                                    if (appointmentDate.equals(currentDate)) {
                                                        displayDate = "Today";
                                                    } else if (appointmentDate.equals(currentDate.plusDays(1))) {
                                                        displayDate = "Tomorrow";
                                                    } else if (appointmentDate.equals(currentDate.minusDays(1))) {
                                                        displayDate = "Yesterday";
                                                    } else {
                                                        // Format date as "Mon, Jan 15"
                                                        displayDate = appointmentDate.format(DateTimeFormatter.ofPattern("MMM d"));
                                                    }
                                                    %>
                                                    <span class="text-xs text-gray-500"><%= displayDate %></span>
                                                </div>
                                            </div>
                                            <div class="mt-1">
                                                <span class="text-xs bg-indigo-50 text-indigo-700 px-2 py-1 rounded-full">
                                                    <%= client.getService() %>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        <% } %>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-sm overflow-hidden">
                    <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                        <h2 class="text-xl font-semibold text-gray-800">Recent Inquiries</h2>
                        <a href="Admin_Inquiries.jsp" class="text-indigo-600 hover:text-indigo-800 font-medium">View All</a>
                    </div>
                    <div class="divide-y divide-gray-100">
                        <% if (recentInquiries.isEmpty()) { %>
                            <div class="p-4">
                                <p class="text-gray-500 text-sm">No inquiries yet</p>
                            </div>
                        <% } else { %>
                            <% for (Map<String, String> inquiry : recentInquiries) { %>
                                <div class="p-4 hover:bg-gray-50 cursor-pointer inquiry-item"
                                     data-timestamp="<%= inquiry.get("Date") %>"
                                     data-subject="<%= inquiry.get("Subject") %>"
                                     data-user="<%= inquiry.get("User") %>"
                                     data-email="<%= inquiry.get("Email") %>"
                                     data-message="<%= inquiry.get("Message") %>"
                                     data-reply="<%= inquiry.get("Reply") != null ? inquiry.get("Reply") : "" %>"
                                     data-status="<%= inquiry.get("Status") %>"
                                     data-priority="<%= inquiry.get("Priority") %>">
                                    <div class="flex justify-between items-start">
                                        <div>
                                            <h3 class="font-medium text-gray-900"><%= inquiry.get("Subject") %></h3>
                                            <p class="text-sm text-gray-500">From: <%= inquiry.get("User") %></p>
                                            <p class="text-xs text-gray-400 mt-1"><%= inquiry.get("Date") %></p>
                                        </div>
                                        <div class="flex items-center">
                                            <%
                                            String status = inquiry.get("Status");
                                            String statusClass = "bg-gray-100 text-gray-800";

                                            if ("New".equals(status)) {
                                                statusClass = "bg-blue-100 text-blue-800";
                                            } else if ("Pending".equals(status)) {
                                                statusClass = "bg-yellow-100 text-yellow-800";
                                            } else if ("Replied".equals(status)) {
                                                statusClass = "bg-green-100 text-green-800";
                                            } else if ("Resolved".equals(status)) {
                                                statusClass = "bg-indigo-100 text-indigo-800";
                                            }
                                            %>
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full <%= statusClass %> mr-2">
                                                <%= status %>
                                            </span>
                                            <form action="${pageContext.request.contextPath}/replyInquiry" method="post" class="inline quick-delete-form">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="timestamp" value="<%= inquiry.get("Date") %>">
                                                <button type="button" class="quick-delete-btn text-red-500 hover:text-red-700">
                                                    <i class="fas fa-times-circle"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                    <p class="text-sm text-gray-600 mt-2 truncate"><%= inquiry.get("Message") %></p>
                                </div>
                            <% } %>
                        <% } %>
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


    <!-- Inquiry Detail Modal -->
    <div id="inquiryModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-30 hidden">
        <div class="bg-white rounded-xl shadow-lg w-full max-w-2xl p-6 relative">
            <button id="closeInquiryModal" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600">
                <i class="fas fa-times"></i>
            </button>

            <div class="mb-6">
                <div class="flex justify-between items-center mb-4">
                    <h2 id="modalSubject" class="text-2xl font-bold text-gray-800"></h2>
                    <div>
                        <span id="modalPriority" class="px-2 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800 mr-2"></span>
                        <span id="modalStatus" class="px-2 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800"></span>
                    </div>
                </div>

                <div class="flex items-center text-gray-600 mb-4">
                    <i class="fas fa-user mr-2"></i>
                    <span id="modalUser"></span>
                    <span class="mx-2">•</span>
                    <i class="fas fa-envelope mr-2"></i>
                    <span id="modalEmail"></span>
                    <span class="mx-2">•</span>
                    <i class="fas fa-clock mr-2"></i>
                    <span id="modalDate"></span>
                </div>

                <div class="bg-gray-50 rounded-lg p-4 mb-4">
                    <h3 class="font-medium text-gray-700 mb-2">Inquiry Message:</h3>
                    <p id="modalMessage" class="text-gray-700 whitespace-pre-line"></p>
                </div>

                <div id="replySection" class="bg-blue-50 rounded-lg p-4 mb-4 hidden">
                    <h3 class="font-medium text-gray-700 mb-2">Admin Reply:</h3>
                    <p id="modalReply" class="text-gray-700 whitespace-pre-line"></p>
                </div>

                <div class="mb-4">
                    <label for="reply" class="block text-sm font-medium text-gray-700 mb-1">Your Reply</label>
                    <textarea id="reply" name="reply" rows="4"
                              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500"
                              placeholder="Type your response here..."></textarea>
                </div>

                <div class="flex justify-between">
                    <div class="flex items-center space-x-2">
                        <!-- Status Update Form -->
                        <form id="statusForm" action="${pageContext.request.contextPath}/replyInquiry" method="post" class="inline">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" id="statusTimestamp" name="timestamp" value="">
                            <div class="flex">
                                <select name="status" class="px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 mr-2">
                                    <option value="New">New</option>
                                    <option value="Pending">Pending</option>
                                    <option value="Replied">Replied</option>
                                    <option value="Resolved">Resolved</option>
                                </select>
                                <button type="submit" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                                    Update Status
                                </button>
                            </div>
                        </form>

                        <!-- Delete Form -->
                        <form id="deleteForm" action="${pageContext.request.contextPath}/replyInquiry" method="post" class="inline">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" id="deleteTimestamp" name="timestamp" value="">
                            <button type="button" id="deleteInquiryBtn" class="px-4 py-2 border border-red-300 rounded-lg text-red-700 hover:bg-red-50">
                                <i class="fas fa-trash-alt mr-1"></i> Delete
                            </button>
                        </form>
                    </div>

                    <!-- Reply Form -->
                    <form id="replyForm" action="${pageContext.request.contextPath}/replyInquiry" method="post" class="inline">
                        <input type="hidden" name="action" value="reply">
                        <input type="hidden" id="replyTimestamp" name="timestamp" value="">
                        <input type="hidden" id="replyText" name="reply" value="">
                        <button type="button" id="sendReplyBtn" class="px-4 py-2 bg-indigo-600 rounded-lg text-white hover:bg-indigo-700">
                            Send Reply
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Auto-hide messages after 5 seconds
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

            // Inquiry modal functionality
            const inquiryModal = document.getElementById('inquiryModal');
            const closeInquiryModal = document.getElementById('closeInquiryModal');
            const inquiryItems = document.querySelectorAll('.inquiry-item');

            const modalSubject = document.getElementById('modalSubject');
            const modalUser = document.getElementById('modalUser');
            const modalEmail = document.getElementById('modalEmail');
            const modalDate = document.getElementById('modalDate');
            const modalMessage = document.getElementById('modalMessage');
            const modalReply = document.getElementById('modalReply');
            const modalStatus = document.getElementById('modalStatus');
            const modalPriority = document.getElementById('modalPriority');
            const replySection = document.getElementById('replySection');
            const replyTimestamp = document.getElementById('replyTimestamp');
            const statusTimestamp = document.getElementById('statusTimestamp');
            const deleteTimestamp = document.getElementById('deleteTimestamp');
            const deleteInquiryBtn = document.getElementById('deleteInquiryBtn');
            const deleteForm = document.getElementById('deleteForm');
            const replyTextarea = document.getElementById('reply');
            const replyText = document.getElementById('replyText');
            const sendReplyBtn = document.getElementById('sendReplyBtn');
            const replyForm = document.getElementById('replyForm');

            // Show modal when inquiry item is clicked
            inquiryItems.forEach(item => {
                item.addEventListener('click', function() {
                    // Set modal content
                    modalSubject.textContent = this.getAttribute('data-subject');
                    modalUser.textContent = this.getAttribute('data-user');
                    modalEmail.textContent = this.getAttribute('data-email');
                    modalDate.textContent = this.getAttribute('data-timestamp');
                    modalMessage.textContent = this.getAttribute('data-message');

                    const reply = this.getAttribute('data-reply');
                    if (reply && reply.trim() !== '') {
                        modalReply.textContent = reply;
                        replySection.classList.remove('hidden');
                    } else {
                        replySection.classList.add('hidden');
                    }

                    const status = this.getAttribute('data-status');
                    modalStatus.textContent = status;

                    // Set status color
                    let statusClass = "bg-gray-100 text-gray-800";
                    if (status === "New") {
                        statusClass = "bg-blue-100 text-blue-800";
                    } else if (status === "Pending") {
                        statusClass = "bg-yellow-100 text-yellow-800";
                    } else if (status === "Replied") {
                        statusClass = "bg-green-100 text-green-800";
                    } else if (status === "Resolved") {
                        statusClass = "bg-indigo-100 text-indigo-800";
                    }

                    modalStatus.className = "px-2 py-1 text-xs font-semibold rounded-full " + statusClass;

                    // Set priority
                    const priority = this.getAttribute('data-priority');
                    modalPriority.textContent = priority;

                    // Set priority color
                    let priorityClass = "bg-gray-100 text-gray-800";
                    if (priority === "High") {
                        priorityClass = "bg-orange-100 text-orange-800";
                    } else if (priority === "Urgent") {
                        priorityClass = "bg-red-100 text-red-800";
                    } else if (priority === "Low") {
                        priorityClass = "bg-blue-100 text-blue-800";
                    }

                    modalPriority.className = "px-2 py-1 text-xs font-semibold rounded-full " + priorityClass;

                    // Set form timestamp
                    const timestamp = this.getAttribute('data-timestamp');
                    replyTimestamp.value = timestamp;
                    statusTimestamp.value = timestamp;
                    deleteTimestamp.value = timestamp;

                    // Show modal
                    inquiryModal.classList.remove('hidden');
                    document.body.style.overflow = 'hidden'; // Prevent scrolling
                });
            });

            // Hide modal when close button is clicked
            closeInquiryModal.addEventListener('click', function() {
                inquiryModal.classList.add('hidden');
                document.body.style.overflow = 'auto'; // Enable scrolling
            });

            // Hide modal when clicking outside the form
            inquiryModal.addEventListener('click', function(e) {
                if (e.target === inquiryModal) {
                    inquiryModal.classList.add('hidden');
                    document.body.style.overflow = 'auto'; // Enable scrolling
                }
            });

            // Handle delete button click
            deleteInquiryBtn.addEventListener('click', function() {
                if (confirm('Are you sure you want to delete this inquiry? This action cannot be undone.')) {
                    deleteForm.submit();
                }
            });

            // Handle quick delete buttons
            const quickDeleteBtns = document.querySelectorAll('.quick-delete-btn');
            quickDeleteBtns.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.stopPropagation(); // Prevent opening the modal
                    if (confirm('Are you sure you want to delete this inquiry? This action cannot be undone.')) {
                        this.closest('form').submit();
                    }
                });
            });

            // Handle send reply button
            sendReplyBtn.addEventListener('click', function() {
                const replyContent = replyTextarea.value.trim();
                if (replyContent === '') {
                    alert('Please enter a reply message');
                    return;
                }

                // Set the reply text in the hidden input
                replyText.value = replyContent;

                // Submit the form
                replyForm.submit();
            });
        });
    </script>
</body>
</html>