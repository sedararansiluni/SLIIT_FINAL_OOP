<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.beauty.model.User" %>
<%@ page import="com.beauty.model.Service" %>
<%@ page import="java.util.List" %>
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
        // Redirect to client dashboard if user is not an admin
        response.sendRedirect(request.getContextPath() + "/Client/Client_Dashboard.jsp");
        return;
    }

    // Get services from request attribute
    List<Service> services = (List<Service>) request.getAttribute("services");

    // Get service for edit/view mode
    Service serviceToEdit = (Service) request.getAttribute("service");
    boolean viewMode = request.getAttribute("viewMode") != null && (boolean) request.getAttribute("viewMode");

    // Get success or error messages from session
    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");

    // Clear messages after retrieving them
    session.removeAttribute("message");
    session.removeAttribute("error");

    // If services is null (direct access to JSP), redirect to the servlet
    if (services == null) {
        response.sendRedirect(request.getContextPath() + "/services");
        return;
    }

    // Get filter parameters
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedSort = (String) request.getAttribute("selectedSort");
    String searchQuery = (String) request.getAttribute("searchQuery");

    if (selectedCategory == null) selectedCategory = "All Categories";
    if (selectedSort == null) selectedSort = "Sort by: Popularity";
    if (searchQuery == null) searchQuery = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Salon - Services</title>
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
                <h1 class="text-xl font-bold text-indigo-900">Beauty Salon</h1>
            </div>

            <!-- Navigation -->
            <nav class="hidden md:flex items-center space-x-8">
                <a href="${pageContext.request.contextPath}/Admin/Admin_Dashboard.jsp" class="text-gray-600 hover:text-indigo-600">Dashboard</a>
                <a href="${pageContext.request.contextPath}/adminAppointments" class="text-gray-600 hover:text-indigo-600">Appointments</a>
                <a href="${pageContext.request.contextPath}/adminUsers" class="text-gray-600 hover:text-indigo-600">Users</a>
                <a href="${pageContext.request.contextPath}/services" class="text-indigo-600 font-medium">Services</a>
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
                    <span class="hidden md:inline text-gray-700">Admin</span>
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
                <h2 class="text-lg font-semibold text-gray-700 mb-4">Quick Menu</h2>
                <ul class="space-y-2">
                    <li>
                        <a href="${pageContext.request.contextPath}/Admin/Admin_Dashboard.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="fas fa-tachometer-alt mr-3"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/adminAppointments" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="far fa-calendar-alt mr-3"></i>
                            <span>Appointments</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/adminUsers" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="fas fa-users mr-3"></i>
                            <span>Users</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/services" class="flex items-center p-3 rounded-lg bg-indigo-50 text-indigo-600 hover:bg-gray-100">
                            <i class="fas fa-cut mr-3"></i>
                            <span>Services</span>
                        </a>
                    </li>

                </ul>

                <div class="mt-8">
                    <h2 class="text-lg font-semibold text-gray-700 mb-4">Service Stats</h2>
                    <div class="bg-indigo-50 rounded-lg p-4">
                        <%
                            int totalServices = services.size();
                            int activeServices = 0;
                            int premiumServices = 0;

                            for (Service s : services) {
                                if (s.getStatus().equals("Active")) {
                                    activeServices++;
                                } else if (s.getStatus().equals("Premium")) {
                                    premiumServices++;
                                }
                            }
                        %>
                        <div class="flex items-center justify-between mb-3">
                            <span class="text-gray-600">Total Services</span>
                            <span class="font-bold"><%= totalServices %></span>
                        </div>
                        <div class="flex items-center justify-between mb-3">
                            <span class="text-gray-600">Active Services</span>
                            <span class="font-bold"><%= activeServices %></span>
                        </div>
                        <div class="flex items-center justify-between">
                            <span class="text-gray-600">Premium Services</span>
                            <span class="font-bold"><%= premiumServices %></span>
                        </div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Content Area -->
        <main class="content-area flex-1 ml-64 p-6">
            <!-- Page Header -->
            <div class="flex justify-between items-center mb-6">
                <div>
                    <h1 class="text-2xl font-bold text-gray-800">Services Management</h1>
                    <p class="text-gray-600">Manage all your salon services and pricing</p>
                </div>
                <div class="flex space-x-3">
                    <button id="toggleFilters" class="px-4 py-2 bg-white border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 flex items-center">
                        <i class="fas fa-filter mr-2"></i>
                        <span>Filter</span>
                    </button>
                    <button id="addServiceBtn" class="px-4 py-2 bg-indigo-600 rounded-lg text-white hover:bg-indigo-700 flex items-center">
                        <i class="fas fa-plus mr-2"></i>
                        <span>Add Service</span>
                    </button>
                </div>
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

            <!-- Search and Filter -->
            <div id="filterSection" class="bg-white rounded-xl shadow-sm p-4 mb-6">
                <div class="flex flex-col space-y-4">
                    <!-- Search Bar -->
                    <div class="relative w-full">
                        <input type="text" id="searchInput" placeholder="Search services..." value="<%= searchQuery %>" class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                        <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                    </div>

                    <!-- Filter Options -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <!-- Category Filter -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Category</label>
                            <select id="categoryFilter" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                                <option value="All Categories">All Categories</option>
                                <option value="Hair Services">Hair Services</option>
                                <option value="Nail Services">Nail Services</option>
                                <option value="Skin Care">Skin Care</option>
                                <option value="Makeup">Makeup</option>
                            </select>
                        </div>

                        <!-- Status Filter -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                            <select id="statusFilter" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                                <option value="All">All Statuses</option>
                                <option value="Active">Active Only</option>
                                <option value="Premium">Premium Only</option>
                                <option value="Inactive">Inactive Only</option>
                            </select>
                        </div>

                        <!-- Price Range Filter -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Price Range</label>
                            <div class="flex items-center space-x-2">
                                <input type="number" id="minPrice" placeholder="Min" min="0" class="w-1/2 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                                <span class="text-gray-500">-</span>
                                <input type="number" id="maxPrice" placeholder="Max" min="0" class="w-1/2 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                            </div>
                        </div>
                    </div>

                    <!-- Duration and Sort Options -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <!-- Duration Filter -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Duration (minutes)</label>
                            <div class="flex items-center space-x-2">
                                <input type="number" id="minDuration" placeholder="Min" min="0" class="w-1/2 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                                <span class="text-gray-500">-</span>
                                <input type="number" id="maxDuration" placeholder="Max" min="0" class="w-1/2 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                            </div>
                        </div>

                        <!-- Sort Options -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Sort By</label>
                            <select id="sortOptions" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                                <option value="name-asc">Name (A-Z)</option>
                                <option value="name-desc">Name (Z-A)</option>
                                <option value="price-asc">Price (Low-High)</option>
                                <option value="price-desc">Price (High-Low)</option>
                                <option value="duration-asc">Duration (Short-Long)</option>
                                <option value="duration-desc">Duration (Long-Short)</option>
                            </select>
                        </div>
                    </div>

                    <!-- Filter Actions -->
                    <div class="flex justify-end space-x-2">
                        <button id="resetFilters" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                            <i class="fas fa-redo-alt mr-1"></i> Reset Filters
                        </button>
                        <button id="applyFilters" class="px-4 py-2 bg-indigo-600 rounded-lg text-white hover:bg-indigo-700">
                            <i class="fas fa-filter mr-1"></i> Apply Filters
                        </button>
                    </div>
                </div>
            </div>

            <!-- Services Table -->
            <div class="bg-white rounded-xl shadow-sm overflow-hidden">
                <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                    <h2 class="text-xl font-semibold text-gray-800">All Services</h2>
                    <span class="text-sm text-gray-500">Showing <%= services.size() %> Services</span>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Service</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Category</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Duration</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Price</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100">
                            <% if (services.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="px-6 py-4 text-center text-gray-500">No services found</td>
                                </tr>
                            <% } else { %>
                                <% for (Service s : services) { %>
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="flex items-center">
                                                <div class="flex-shrink-0 h-10 w-10 bg-indigo-100 rounded-lg flex items-center justify-center">
                                                    <i class="<%= s.getIcon() %> text-indigo-600"></i>
                                                </div>
                                                <div class="ml-4">
                                                    <div class="text-sm font-medium text-gray-900"><%= s.getName() %></div>
                                                    <div class="text-sm text-gray-500">ID: #<%= s.getId() %></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-900"><%= s.getCategory() %></div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-900"><%= s.getDuration() %> min</div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-900">$<%= String.format("%.2f", s.getPrice()) %></div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <% if (s.getStatus().equals("Active")) { %>
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Active</span>
                                            <% } else if (s.getStatus().equals("Premium")) { %>
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-purple-100 text-purple-800">Premium</span>
                                            <% } else { %>
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">Inactive</span>
                                            <% } %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <a href="${pageContext.request.contextPath}/services?action=view&id=<%= s.getId() %>" class="text-indigo-600 hover:text-indigo-900 mr-3"><i class="fas fa-eye"></i></a>
                                            <a href="#" class="edit-btn text-indigo-600 hover:text-indigo-900 mr-3"
                                               data-id="<%= s.getId() %>"
                                               data-name="<%= s.getName() %>"
                                               data-category="<%= s.getCategory() %>"
                                               data-duration="<%= s.getDuration() %>"
                                               data-price="<%= s.getPrice() %>"
                                               data-status="<%= s.getStatus() %>"
                                               data-icon="<%= s.getIcon() %>"
                                               data-description="<%= s.getDescription() != null ? s.getDescription().replace("\"", "&quot;") : "" %>">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="#" onclick="confirmDelete('<%= s.getId() %>')" class="text-red-600 hover:text-red-900"><i class="fas fa-trash-alt"></i></a>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination (simplified for now) -->
                <div class="px-6 py-4 border-t border-gray-100 flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-700">
                            Showing <span class="font-medium"><%= services.size() %></span> services
                        </p>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Add Service Modal -->
    <div id="addServiceModal" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center z-50 hidden">
        <div class="bg-white rounded-xl shadow-lg w-full max-w-2xl max-h-screen overflow-y-auto">
            <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                <h2 class="text-xl font-semibold text-gray-800">Add New Service</h2>
                <button id="closeAddModal" class="text-gray-400 hover:text-gray-500">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form action="${pageContext.request.contextPath}/services" method="post" class="p-6">
                <input type="hidden" name="action" value="add">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Service Name</label>
                        <input type="text" id="name" name="name" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                    </div>
                    <div>
                        <label for="category" class="block text-sm font-medium text-gray-700 mb-1">Category</label>
                        <select id="category" name="category" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                            <option value="">Select Category</option>
                            <option value="Hair Services">Hair Services</option>
                            <option value="Nail Services">Nail Services</option>
                            <option value="Skin Care">Skin Care</option>
                            <option value="Makeup">Makeup</option>
                        </select>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label for="duration" class="block text-sm font-medium text-gray-700 mb-1">Duration (minutes)</label>
                        <input type="number" id="duration" name="duration" min="5" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                    </div>
                    <div>
                        <label for="price" class="block text-sm font-medium text-gray-700 mb-1">Price ($)</label>
                        <input type="number" id="price" name="price" min="0" step="0.01" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label for="status" class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                        <select id="status" name="status" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                            <option value="Active">Active</option>
                            <option value="Premium">Premium</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                    </div>
                    <div>
                        <label for="icon" class="block text-sm font-medium text-gray-700 mb-1">Icon (Font Awesome)</label>
                        <select id="icon" name="icon" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                            <option value="fas fa-cut">Scissors (Hair)</option>
                            <option value="fas fa-spa">Spa</option>
                            <option value="fas fa-paint-brush">Paint Brush (Nails)</option>
                            <option value="fas fa-magic">Magic (Makeup)</option>
                            <option value="fas fa-hands">Hands (Massage)</option>
                        </select>
                    </div>
                </div>

                <div class="mb-6">
                    <label for="description" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                    <textarea id="description" name="description" rows="3" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500"></textarea>
                </div>

                <div class="flex justify-end space-x-3">
                    <button type="button" id="cancelAddBtn" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">Cancel</button>
                    <button type="submit" class="px-4 py-2 bg-indigo-600 rounded-lg text-white hover:bg-indigo-700">Add Service</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Service Modal -->
    <div id="editServiceModal" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center z-50 <%= serviceToEdit != null && !viewMode ? "" : "hidden" %>">
        <div class="bg-white rounded-xl shadow-lg w-full max-w-2xl max-h-screen overflow-y-auto">
            <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                <h2 class="text-xl font-semibold text-gray-800">Edit Service</h2>
                <button id="closeEditModal" class="text-gray-400 hover:text-gray-500">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form id="editServiceForm" action="${pageContext.request.contextPath}/services" method="post" class="p-6">
                <input type="hidden" name="action" value="update">
                <input type="hidden" id="edit-id" name="id" value="<%= serviceToEdit != null ? serviceToEdit.getId() : "" %>">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label for="edit-name" class="block text-sm font-medium text-gray-700 mb-1">Service Name</label>
                        <input type="text" id="edit-name" name="name" required value="<%= serviceToEdit != null ? serviceToEdit.getName() : "" %>" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                    </div>
                    <div>
                        <label for="edit-category" class="block text-sm font-medium text-gray-700 mb-1">Category</label>
                        <select id="edit-category" name="category" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                            <option value="">Select Category</option>
                            <option value="Hair Services" <%= serviceToEdit != null && "Hair Services".equals(serviceToEdit.getCategory()) ? "selected" : "" %>>Hair Services</option>
                            <option value="Nail Services" <%= serviceToEdit != null && "Nail Services".equals(serviceToEdit.getCategory()) ? "selected" : "" %>>Nail Services</option>
                            <option value="Skin Care" <%= serviceToEdit != null && "Skin Care".equals(serviceToEdit.getCategory()) ? "selected" : "" %>>Skin Care</option>
                            <option value="Makeup" <%= serviceToEdit != null && "Makeup".equals(serviceToEdit.getCategory()) ? "selected" : "" %>>Makeup</option>
                        </select>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label for="edit-duration" class="block text-sm font-medium text-gray-700 mb-1">Duration (minutes)</label>
                        <input type="number" id="edit-duration" name="duration" min="5" required value="<%= serviceToEdit != null ? serviceToEdit.getDuration() : "" %>" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                    </div>
                    <div>
                        <label for="edit-price" class="block text-sm font-medium text-gray-700 mb-1">Price ($)</label>
                        <input type="number" id="edit-price" name="price" min="0" step="0.01" required value="<%= serviceToEdit != null ? serviceToEdit.getPrice() : "" %>" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label for="edit-status" class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                        <select id="edit-status" name="status" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                            <option value="Active" <%= serviceToEdit != null && "Active".equals(serviceToEdit.getStatus()) ? "selected" : "" %>>Active</option>
                            <option value="Premium" <%= serviceToEdit != null && "Premium".equals(serviceToEdit.getStatus()) ? "selected" : "" %>>Premium</option>
                            <option value="Inactive" <%= serviceToEdit != null && "Inactive".equals(serviceToEdit.getStatus()) ? "selected" : "" %>>Inactive</option>
                        </select>
                    </div>
                    <div>
                        <label for="edit-icon" class="block text-sm font-medium text-gray-700 mb-1">Icon (Font Awesome)</label>
                        <select id="edit-icon" name="icon" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                            <option value="fas fa-cut" <%= serviceToEdit != null && "fas fa-cut".equals(serviceToEdit.getIcon()) ? "selected" : "" %>>Scissors (Hair)</option>
                            <option value="fas fa-spa" <%= serviceToEdit != null && "fas fa-spa".equals(serviceToEdit.getIcon()) ? "selected" : "" %>>Spa</option>
                            <option value="fas fa-paint-brush" <%= serviceToEdit != null && "fas fa-paint-brush".equals(serviceToEdit.getIcon()) ? "selected" : "" %>>Paint Brush (Nails)</option>
                            <option value="fas fa-magic" <%= serviceToEdit != null && "fas fa-magic".equals(serviceToEdit.getIcon()) ? "selected" : "" %>>Magic (Makeup)</option>
                            <option value="fas fa-hands" <%= serviceToEdit != null && "fas fa-hands".equals(serviceToEdit.getIcon()) ? "selected" : "" %>>Hands (Massage)</option>
                        </select>
                    </div>
                </div>

                <div class="mb-6">
                    <label for="edit-description" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                    <textarea id="edit-description" name="description" rows="3" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500"><%= serviceToEdit != null ? serviceToEdit.getDescription() : "" %></textarea>
                </div>

                <div class="flex justify-end space-x-3">
                    <button type="button" id="cancelEditBtn" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">Cancel</button>
                    <button type="submit" class="px-4 py-2 bg-indigo-600 rounded-lg text-white hover:bg-indigo-700">Update Service</button>
                </div>
            </form>
        </div>
    </div>

    <!-- View Service Modal -->
    <div id="viewServiceModal" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center z-50 <%= serviceToEdit != null && viewMode ? "" : "hidden" %>">
        <div class="bg-white rounded-xl shadow-lg w-full max-w-2xl max-h-screen overflow-y-auto">
            <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                <h2 class="text-xl font-semibold text-gray-800">Service Details</h2>
                <a href="${pageContext.request.contextPath}/services" class="text-gray-400 hover:text-gray-500">
                    <i class="fas fa-times"></i>
                </a>
            </div>
            <div class="p-6">
                <% if (serviceToEdit != null && viewMode) { %>
                    <div class="flex items-center mb-6">
                        <div class="w-16 h-16 bg-indigo-100 rounded-lg flex items-center justify-center mr-4">
                            <i class="<%= serviceToEdit.getIcon() %> text-indigo-600 text-2xl"></i>
                        </div>
                        <div>
                            <h3 class="text-xl font-semibold text-gray-800"><%= serviceToEdit.getName() %></h3>
                            <p class="text-gray-500">ID: #<%= serviceToEdit.getId() %></p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                            <h4 class="text-sm font-medium text-gray-500 mb-1">Category</h4>
                            <p class="text-gray-900"><%= serviceToEdit.getCategory() %></p>
                        </div>
                        <div>
                            <h4 class="text-sm font-medium text-gray-500 mb-1">Status</h4>
                            <p>
                                <% if (serviceToEdit.getStatus().equals("Active")) { %>
                                    <span class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded-full">Active</span>
                                <% } else if (serviceToEdit.getStatus().equals("Premium")) { %>
                                    <span class="px-2 py-1 bg-purple-100 text-purple-800 text-xs rounded-full">Premium</span>
                                <% } else { %>
                                    <span class="px-2 py-1 bg-gray-100 text-gray-800 text-xs rounded-full">Inactive</span>
                                <% } %>
                            </p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                            <h4 class="text-sm font-medium text-gray-500 mb-1">Duration</h4>
                            <p class="text-gray-900"><%= serviceToEdit.getDuration() %> minutes</p>
                        </div>
                        <div>
                            <h4 class="text-sm font-medium text-gray-500 mb-1">Price</h4>
                            <p class="text-gray-900">$<%= String.format("%.2f", serviceToEdit.getPrice()) %></p>
                        </div>
                    </div>

                    <div class="mb-6">
                        <h4 class="text-sm font-medium text-gray-500 mb-1">Description</h4>
                        <p class="text-gray-900"><%= serviceToEdit.getDescription() != null && !serviceToEdit.getDescription().isEmpty() ? serviceToEdit.getDescription() : "No description available" %></p>
                    </div>

                    <div class="flex justify-end space-x-3">
                        <a href="${pageContext.request.contextPath}/services" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">Back to List</a>
                        <a href="${pageContext.request.contextPath}/services?action=edit&id=<%= serviceToEdit.getId() %>" class="px-4 py-2 bg-indigo-600 rounded-lg text-white hover:bg-indigo-700">Edit Service</a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteConfirmModal" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center z-50 hidden">
        <div class="bg-white rounded-xl shadow-lg w-full max-w-md">
            <div class="p-6 border-b border-gray-100">
                <h2 class="text-xl font-semibold text-gray-800">Confirm Deletion</h2>
            </div>
            <div class="p-6">
                <p class="text-gray-700 mb-6">Are you sure you want to delete this service? This action cannot be undone.</p>
                <div class="flex justify-end space-x-3">
                    <button id="cancelDeleteBtn" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">Cancel</button>
                    <a id="confirmDeleteBtn" href="#" class="px-4 py-2 bg-red-600 rounded-lg text-white hover:bg-red-700">Delete Service</a>
                </div>
            </div>
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
            // Add Service Modal
            const addServiceBtn = document.getElementById('addServiceBtn');
            const addServiceModal = document.getElementById('addServiceModal');
            const closeAddModal = document.getElementById('closeAddModal');
            const cancelAddBtn = document.getElementById('cancelAddBtn');

            if (addServiceBtn) {
                addServiceBtn.addEventListener('click', function() {
                    addServiceModal.classList.remove('hidden');
                });
            }

            if (closeAddModal) {
                closeAddModal.addEventListener('click', function() {
                    addServiceModal.classList.add('hidden');
                });
            }

            if (cancelAddBtn) {
                cancelAddBtn.addEventListener('click', function() {
                    addServiceModal.classList.add('hidden');
                });
            }

            // Edit Service Modal
            const editServiceModal = document.getElementById('editServiceModal');
            const closeEditModal = document.getElementById('closeEditModal');
            const cancelEditBtn = document.getElementById('cancelEditBtn');
            const editButtons = document.querySelectorAll('.edit-btn');

            // Edit form fields
            const editIdField = document.getElementById('edit-id');
            const editNameField = document.getElementById('edit-name');
            const editCategoryField = document.getElementById('edit-category');
            const editDurationField = document.getElementById('edit-duration');
            const editPriceField = document.getElementById('edit-price');
            const editStatusField = document.getElementById('edit-status');
            const editIconField = document.getElementById('edit-icon');
            const editDescriptionField = document.getElementById('edit-description');

            // Add event listeners to all edit buttons
            if (editButtons.length > 0) {
                editButtons.forEach(button => {
                    button.addEventListener('click', function(e) {
                        e.preventDefault();

                        // Get service data from data attributes
                        const id = this.getAttribute('data-id');
                        const name = this.getAttribute('data-name');
                        const category = this.getAttribute('data-category');
                        const duration = this.getAttribute('data-duration');
                        const price = this.getAttribute('data-price');
                        const status = this.getAttribute('data-status');
                        const icon = this.getAttribute('data-icon');
                        const description = this.getAttribute('data-description');

                        // Populate the edit form
                        editIdField.value = id;
                        editNameField.value = name;
                        editCategoryField.value = category;
                        editDurationField.value = duration;
                        editPriceField.value = price;
                        editStatusField.value = status;
                        editIconField.value = icon;
                        editDescriptionField.value = description;

                        // Show the edit modal
                        editServiceModal.classList.remove('hidden');
                    });
                });
            }

            if (closeEditModal) {
                closeEditModal.addEventListener('click', function() {
                    editServiceModal.classList.add('hidden');
                });
            }

            if (cancelEditBtn) {
                cancelEditBtn.addEventListener('click', function() {
                    editServiceModal.classList.add('hidden');
                });
            }

            // Delete Confirmation Modal
            const deleteConfirmModal = document.getElementById('deleteConfirmModal');
            const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
            const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');

            if (cancelDeleteBtn) {
                cancelDeleteBtn.addEventListener('click', function() {
                    deleteConfirmModal.classList.add('hidden');
                });
            }

            // Toggle Filters
            const toggleFiltersBtn = document.getElementById('toggleFilters');
            const filterSection = document.getElementById('filterSection');

            if (toggleFiltersBtn && filterSection) {
                toggleFiltersBtn.addEventListener('click', function() {
                    filterSection.classList.toggle('hidden');
                });
            }

            // Client-side filtering
            const searchInput = document.getElementById('searchInput');
            const categoryFilter = document.getElementById('categoryFilter');
            const statusFilter = document.getElementById('statusFilter');
            const minPrice = document.getElementById('minPrice');
            const maxPrice = document.getElementById('maxPrice');
            const minDuration = document.getElementById('minDuration');
            const maxDuration = document.getElementById('maxDuration');
            const sortOptions = document.getElementById('sortOptions');
            const applyFiltersBtn = document.getElementById('applyFilters');
            const resetFiltersBtn = document.getElementById('resetFilters');

            // Get all service rows
            const serviceRows = document.querySelectorAll('tbody tr');

            // Apply filters function
            function applyFilters() {
                const searchTerm = searchInput.value.toLowerCase();
                const category = categoryFilter.value;
                const status = statusFilter.value;
                const minPriceValue = minPrice.value ? parseFloat(minPrice.value) : 0;
                const maxPriceValue = maxPrice.value ? parseFloat(maxPrice.value) : Infinity;
                const minDurationValue = minDuration.value ? parseInt(minDuration.value) : 0;
                const maxDurationValue = maxDuration.value ? parseInt(maxDuration.value) : Infinity;

                // Count visible rows
                let visibleCount = 0;

                // Filter rows
                serviceRows.forEach(row => {
                    const rowText = row.textContent.toLowerCase();
                    const rowCategory = row.querySelector('td:nth-child(2)').textContent.trim();

                    // Get status from the badge class
                    let rowStatus = '';
                    if (row.querySelector('.bg-green-100')) {
                        rowStatus = 'Active';
                    } else if (row.querySelector('.bg-purple-100')) {
                        rowStatus = 'Premium';
                    } else if (row.querySelector('.bg-gray-100')) {
                        rowStatus = 'Inactive';
                    }

                    // Get price from the row
                    const priceText = row.querySelector('td:nth-child(4)').textContent.trim();
                    const price = parseFloat(priceText.replace('$', ''));

                    // Get duration from the row
                    const durationText = row.querySelector('td:nth-child(3)').textContent.trim();
                    const duration = parseInt(durationText.replace(' min', ''));

                    // Check if row matches all filters
                    const matchesSearch = rowText.includes(searchTerm);
                    const matchesCategory = category === 'All Categories' || rowCategory === category;
                    const matchesStatus = status === 'All' || rowStatus === status;
                    const matchesPrice = price >= minPriceValue && price <= maxPriceValue;
                    const matchesDuration = duration >= minDurationValue && duration <= maxDurationValue;

                    // Show/hide row based on filter matches
                    if (matchesSearch && matchesCategory && matchesStatus && matchesPrice && matchesDuration) {
                        row.style.display = '';
                        visibleCount++;
                    } else {
                        row.style.display = 'none';
                    }
                });

                // Update the count in the table header
                const tableHeader = document.querySelector('.bg-white.rounded-xl h2');
                if (tableHeader) {
                    if (visibleCount === serviceRows.length) {
                        tableHeader.textContent = 'All Services';
                    } else {
                        tableHeader.textContent = `Filtered Services (${visibleCount} of ${serviceRows.length})`;
                    }
                }

                // Update the count in the pagination section
                const paginationCount = document.querySelector('.px-6.py-4.border-t p');
                if (paginationCount) {
                    paginationCount.innerHTML = `Showing <span class="font-medium">${visibleCount}</span> services`;
                }

                // Add active filter indicators
                updateFilterIndicators();
            }

            // Sort function
            function sortServices() {
                const sortValue = sortOptions.value;
                const tbody = document.querySelector('tbody');
                const rows = Array.from(serviceRows);

                rows.sort((a, b) => {
                    if (sortValue === 'name-asc' || sortValue === 'name-desc') {
                        const nameA = a.querySelector('td:nth-child(1) .text-sm.font-medium').textContent.trim().toLowerCase();
                        const nameB = b.querySelector('td:nth-child(1) .text-sm.font-medium').textContent.trim().toLowerCase();

                        return sortValue === 'name-asc' ? nameA.localeCompare(nameB) : nameB.localeCompare(nameA);
                    } else if (sortValue === 'price-asc' || sortValue === 'price-desc') {
                        const priceA = parseFloat(a.querySelector('td:nth-child(4)').textContent.trim().replace('$', ''));
                        const priceB = parseFloat(b.querySelector('td:nth-child(4)').textContent.trim().replace('$', ''));

                        return sortValue === 'price-asc' ? priceA - priceB : priceB - priceA;
                    } else if (sortValue === 'duration-asc' || sortValue === 'duration-desc') {
                        const durationA = parseInt(a.querySelector('td:nth-child(3)').textContent.trim().replace(' min', ''));
                        const durationB = parseInt(b.querySelector('td:nth-child(3)').textContent.trim().replace(' min', ''));

                        return sortValue === 'duration-asc' ? durationA - durationB : durationB - durationA;
                    }

                    return 0;
                });

                // Remove all rows
                rows.forEach(row => row.remove());

                // Add sorted rows back
                rows.forEach(row => tbody.appendChild(row));

                // Re-apply filters after sorting
                applyFilters();
            }

            // Update filter indicators
            function updateFilterIndicators() {
                // Check if any filters are active
                const hasSearch = searchInput.value.trim() !== '';
                const hasCategory = categoryFilter.value !== 'All Categories';
                const hasStatus = statusFilter.value !== 'All';
                const hasMinPrice = minPrice.value !== '';
                const hasMaxPrice = maxPrice.value !== '';
                const hasMinDuration = minDuration.value !== '';
                const hasMaxDuration = maxDuration.value !== '';

                // Update search input styling
                if (hasSearch) {
                    searchInput.classList.add('border-indigo-500', 'bg-indigo-50');
                } else {
                    searchInput.classList.remove('border-indigo-500', 'bg-indigo-50');
                }

                // Update category filter styling
                if (hasCategory) {
                    categoryFilter.classList.add('border-indigo-500', 'bg-indigo-50');
                } else {
                    categoryFilter.classList.remove('border-indigo-500', 'bg-indigo-50');
                }

                // Update status filter styling
                if (hasStatus) {
                    statusFilter.classList.add('border-indigo-500', 'bg-indigo-50');
                } else {
                    statusFilter.classList.remove('border-indigo-500', 'bg-indigo-50');
                }

                // Update price inputs styling
                if (hasMinPrice || hasMaxPrice) {
                    minPrice.classList.add('border-indigo-500', 'bg-indigo-50');
                    maxPrice.classList.add('border-indigo-500', 'bg-indigo-50');
                } else {
                    minPrice.classList.remove('border-indigo-500', 'bg-indigo-50');
                    maxPrice.classList.remove('border-indigo-500', 'bg-indigo-50');
                }

                // Update duration inputs styling
                if (hasMinDuration || hasMaxDuration) {
                    minDuration.classList.add('border-indigo-500', 'bg-indigo-50');
                    maxDuration.classList.add('border-indigo-500', 'bg-indigo-50');
                } else {
                    minDuration.classList.remove('border-indigo-500', 'bg-indigo-50');
                    maxDuration.classList.remove('border-indigo-500', 'bg-indigo-50');
                }

                // Update reset button styling
                if (hasSearch || hasCategory || hasStatus || hasMinPrice || hasMaxPrice || hasMinDuration || hasMaxDuration) {
                    resetFiltersBtn.classList.remove('bg-gray-50', 'text-gray-700');
                    resetFiltersBtn.classList.add('bg-indigo-100', 'text-indigo-700');
                } else {
                    resetFiltersBtn.classList.add('bg-gray-50', 'text-gray-700');
                    resetFiltersBtn.classList.remove('bg-indigo-100', 'text-indigo-700');
                }
            }

            // Reset filters function
            function resetFilters() {
                searchInput.value = '';
                categoryFilter.value = 'All Categories';
                statusFilter.value = 'All';
                minPrice.value = '';
                maxPrice.value = '';
                minDuration.value = '';
                maxDuration.value = '';

                // Reset all rows to visible
                serviceRows.forEach(row => {
                    row.style.display = '';
                });

                // Reset the count in the table header
                const tableHeader = document.querySelector('.bg-white.rounded-xl h2');
                if (tableHeader) {
                    tableHeader.textContent = 'All Services';
                }

                // Reset the count in the pagination section
                const paginationCount = document.querySelector('.px-6.py-4.border-t p');
                if (paginationCount) {
                    paginationCount.innerHTML = `Showing <span class="font-medium">${serviceRows.length}</span> services`;
                }

                // Reset filter indicators
                updateFilterIndicators();
            }

            // Add event listeners for filters
            if (searchInput) {
                searchInput.addEventListener('input', applyFilters);
            }

            if (categoryFilter) {
                categoryFilter.addEventListener('change', applyFilters);
            }

            if (statusFilter) {
                statusFilter.addEventListener('change', applyFilters);
            }

            if (minPrice) {
                minPrice.addEventListener('input', applyFilters);
            }

            if (maxPrice) {
                maxPrice.addEventListener('input', applyFilters);
            }

            if (minDuration) {
                minDuration.addEventListener('input', applyFilters);
            }

            if (maxDuration) {
                maxDuration.addEventListener('input', applyFilters);
            }

            if (sortOptions) {
                sortOptions.addEventListener('change', sortServices);
            }

            if (applyFiltersBtn) {
                applyFiltersBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    applyFilters();
                });
            }

            if (resetFiltersBtn) {
                resetFiltersBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    resetFilters();
                });
            }

            // Initialize filters
            updateFilterIndicators();
        });

        // Function to confirm service deletion
        function confirmDelete(serviceId) {
            const deleteConfirmModal = document.getElementById('deleteConfirmModal');
            const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');

            // Show the confirmation modal
            deleteConfirmModal.classList.remove('hidden');

            // Set the delete link
            confirmDeleteBtn.href = '${pageContext.request.contextPath}/services?action=delete&id=' + serviceId;
        }
    </script>
</body>
</html>