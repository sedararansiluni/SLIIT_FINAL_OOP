<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.beauty.model.User" %>
<%@ page import="com.beauty.model.Service" %>
<%@ page import="com.beauty.model.CartItem" %>
<%@ page import="com.beauty.util.ServiceCart" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        // Redirect to login page if not logged in
        response.sendRedirect(request.getContextPath() + "/Auth/SignIn.jsp");
        return;
    }

    // Get services from request attribute
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Integer cartSize = (Integer) request.getAttribute("cartSize");
    Double cartTotalPrice = (Double) request.getAttribute("cartTotalPrice");
    Integer cartTotalDuration = (Integer) request.getAttribute("cartTotalDuration");

    // Get selected category
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (selectedCategory == null) selectedCategory = "All Services";

    // Get success or error messages from session
    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");

    // Clear messages after retrieving them
    session.removeAttribute("message");
    session.removeAttribute("error");

    // If services is null (direct access to JSP), redirect to the servlet
    if (services == null) {
        response.sendRedirect(request.getContextPath() + "/serviceCart");
        return;
    }

    // Check if we're viewing the cart
    boolean viewingCart = "view".equals(request.getParameter("action"));

    // If cartItems is not null but services is empty, we're viewing the cart
    if (!viewingCart && (services == null || services.isEmpty()) && cartItems != null && !cartItems.isEmpty()) {
        viewingCart = true;
    }

    // Set default values for cart totals if null
    if (cartTotalPrice == null) cartTotalPrice = 0.0;
    if (cartTotalDuration == null) cartTotalDuration = 0;
    if (cartSize == null) cartSize = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Services - Beauty Salon</title>
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
        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
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
                <a href="${pageContext.request.contextPath}/Client/Client_Addappoinment.jsp" class="text-gray-600 hover:text-indigo-600">My Appointments</a>
                <a href="${pageContext.request.contextPath}/serviceCart" class="text-indigo-600 font-medium">Services</a>
                <a href="${pageContext.request.contextPath}/Client/Client_Profile.jsp" class="text-gray-600 hover:text-indigo-600">Profile</a>
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
                    <span class="hidden md:inline text-gray-700">Sedara Ransiluni</span>
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
                        <h3 class="font-medium">Sedara Ransiluni</h3>
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
                        <a href="${pageContext.request.contextPath}/Client/Client_Addappoinment.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="far fa-calendar-alt mr-3"></i>
                            <span>My Appointments</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/serviceCart" class="flex items-center p-3 rounded-lg bg-indigo-50 text-indigo-600">
                            <i class="fas fa-cut mr-3"></i>
                            <span>Services</span>
                            <% if (cartSize != null && cartSize > 0) { %>
                                <span class="ml-auto bg-indigo-100 text-indigo-800 text-xs px-2 py-1 rounded-full"><%= cartSize %></span>
                            <% } %>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/Client/Client_Profile.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
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
                    <% if (viewingCart) { %>
                        <h1 class="text-2xl font-bold text-gray-800">Your Service Cart</h1>
                        <p class="text-gray-600">Review and book your selected services</p>
                    <% } else { %>
                        <h1 class="text-2xl font-bold text-gray-800">Our Services</h1>
                        <p class="text-gray-600">Explore our wide range of beauty and wellness services</p>
                    <% } %>
                </div>
                <div class="mt-4 md:mt-0 flex items-center space-x-3">
                    <% if (!viewingCart) { %>
                        <form action="${pageContext.request.contextPath}/serviceCart" method="get" class="relative">
                            <input type="text" name="query" placeholder="Search services..." class="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500">
                            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                        </form>
                    <% } %>
                    <a href="${pageContext.request.contextPath}/serviceCart<%= viewingCart ? "" : "?action=view" %>" class="flex items-center px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">
                        <i class="<%= viewingCart ? "fas fa-arrow-left" : "fas fa-shopping-cart" %> mr-2"></i>
                        <span><%= viewingCart ? "Back to Services" : "View Cart (" + (cartSize != null ? cartSize : 0) + ")" %></span>
                    </a>
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

            <% if (!viewingCart) { %>
            <!-- Service Categories -->
            <div class="mb-6">
                <div class="flex flex-wrap gap-2">
                    <a href="${pageContext.request.contextPath}/serviceCart" class="px-4 py-2 <%= "All Services".equals(selectedCategory) ? "bg-indigo-600 text-white" : "bg-white border border-gray-300 text-gray-700 hover:bg-gray-50" %> rounded-full text-sm font-medium">All Services</a>
                    <a href="${pageContext.request.contextPath}/serviceCart?category=Hair Services" class="px-4 py-2 <%= "Hair Services".equals(selectedCategory) ? "bg-indigo-600 text-white" : "bg-white border border-gray-300 text-gray-700 hover:bg-gray-50" %> rounded-full text-sm font-medium">Hair</a>
                    <a href="${pageContext.request.contextPath}/serviceCart?category=Skin Care" class="px-4 py-2 <%= "Skin Care".equals(selectedCategory) ? "bg-indigo-600 text-white" : "bg-white border border-gray-300 text-gray-700 hover:bg-gray-50" %> rounded-full text-sm font-medium">Skin Care</a>
                    <a href="${pageContext.request.contextPath}/serviceCart?category=Nail Services" class="px-4 py-2 <%= "Nail Services".equals(selectedCategory) ? "bg-indigo-600 text-white" : "bg-white border border-gray-300 text-gray-700 hover:bg-gray-50" %> rounded-full text-sm font-medium">Nails</a>
                    <a href="${pageContext.request.contextPath}/serviceCart?category=Makeup" class="px-4 py-2 <%= "Makeup".equals(selectedCategory) ? "bg-indigo-600 text-white" : "bg-white border border-gray-300 text-gray-700 hover:bg-gray-50" %> rounded-full text-sm font-medium">Makeup</a>
                </div>
            </div>
            <% } %>

            <% if (viewingCart) { %>
            <!-- Cart View -->
            <% if (cartItems == null || cartItems.isEmpty()) { %>
                <div class="bg-white rounded-xl shadow-sm p-8 text-center">
                    <div class="w-20 h-20 mx-auto bg-indigo-50 rounded-full flex items-center justify-center mb-4">
                        <i class="fas fa-shopping-cart text-indigo-600 text-2xl"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-800 mb-2">Your cart is empty</h3>
                    <p class="text-gray-600 mb-6">Browse our services and add some to your cart</p>
                    <a href="${pageContext.request.contextPath}/serviceCart" class="px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">
                        Browse Services
                    </a>
                </div>
            <% } else { %>
                <div class="bg-white rounded-xl shadow-sm overflow-hidden">
                    <div class="p-6 border-b border-gray-100">
                        <h2 class="text-xl font-semibold text-gray-800">Your Selected Services</h2>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Service</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Category</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Quantity</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Duration</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Price</th>
                                    <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <% for (CartItem item : cartItems) {
                                    Service service = item.getService();
                                    Map<String, String> options = item.getOptions();
                                %>
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-10 w-10 bg-indigo-100 rounded-lg flex items-center justify-center">
                                                <i class="<%= service.getIcon() %> text-indigo-600"></i>
                                            </div>
                                            <div class="ml-4">
                                                <div class="text-sm font-medium text-gray-900"><%= service.getName() %></div>
                                                <div class="text-sm text-gray-500">ID: #<%= service.getId() %></div>
                                                <% if (item.getSpecialInstructions() != null && !item.getSpecialInstructions().isEmpty()) { %>
                                                    <div class="text-xs text-indigo-600 mt-1">Note: <%= item.getSpecialInstructions() %></div>
                                                <% } %>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900"><%= service.getCategory() %></div>
                                        <% if (options != null && !options.isEmpty()) { %>
                                            <% if (options.containsKey("stylist")) { %>
                                                <div class="text-xs text-gray-500 mt-1">Stylist: <%= options.get("stylist") %></div>
                                            <% } %>
                                            <% if (options.containsKey("timeSlot")) { %>
                                                <div class="text-xs text-gray-500 mt-1">Time: <%= options.get("timeSlot") %></div>
                                            <% } %>
                                        <% } %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <form id="updateForm<%= service.getId() %>" action="${pageContext.request.contextPath}/serviceCart" method="post" class="flex items-center">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="id" value="<%= service.getId() %>">
                                            <div class="flex items-center border border-gray-300 rounded-lg overflow-hidden">
                                                <button type="button" class="decrement-btn px-2 py-1 bg-gray-100 text-gray-600 hover:bg-gray-200 focus:outline-none">
                                                    <i class="fas fa-minus"></i>
                                                </button>
                                                <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" max="10" class="w-12 text-center border-0 focus:ring-0 focus:outline-none">
                                                <button type="button" class="increment-btn px-2 py-1 bg-gray-100 text-gray-600 hover:bg-gray-200 focus:outline-none">
                                                    <i class="fas fa-plus"></i>
                                                </button>
                                            </div>
                                        </form>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900"><%= item.getTotalDuration() %> min</div>
                                        <div class="text-xs text-gray-500">(<%= service.getDuration() %> min each)</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900">$<%= String.format("%.2f", item.getTotalPrice()) %></div>
                                        <div class="text-xs text-gray-500">($<%= String.format("%.2f", service.getPrice()) %> each)</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                        <button type="button" class="update-btn text-indigo-600 hover:text-indigo-900 mr-3" data-form="updateForm<%= service.getId() %>">Update</button>
                                        <button type="button" class="edit-options-btn text-indigo-600 hover:text-indigo-900 mr-3" data-id="<%= service.getId() %>">Options</button>
                                        <a href="${pageContext.request.contextPath}/serviceCart?action=remove&id=<%= service.getId() %>" class="text-red-600 hover:text-red-900">Remove</a>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                            <tfoot class="bg-gray-50">
                                <tr>
                                    <td colspan="3" class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                        Total
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                        <%= cartTotalDuration %> min
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                        $<%= String.format("%.2f", cartTotalPrice) %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                        <a href="${pageContext.request.contextPath}/serviceCart?action=clear" class="text-gray-600 hover:text-gray-900 mr-4">Clear Cart</a>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                    <div class="p-6 border-t border-gray-100 flex justify-end">
                        <a href="${pageContext.request.contextPath}/Client/Client_Addappoinment.jsp" class="px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">
                            Proceed to Book
                        </a>
                    </div>
                </div>

                <!-- Service Options Modal -->
                <div id="serviceOptionsModal" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center z-50 hidden">
                    <div class="bg-white rounded-xl shadow-lg w-full max-w-md">
                        <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                            <h2 class="text-xl font-semibold text-gray-800">Service Options</h2>
                            <button id="closeOptionsModal" class="text-gray-400 hover:text-gray-500">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <form id="optionsForm" action="${pageContext.request.contextPath}/serviceCart" method="post" class="p-6">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" id="optionsServiceId" name="id" value="">

                            <div class="mb-4">
                                <label for="stylist" class="block text-sm font-medium text-gray-700 mb-1">Preferred Stylist</label>
                                <select id="stylist" name="stylist" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                                    <option value="">No preference</option>
                                    <option value="John">John</option>
                                    <option value="Sarah">Sarah</option>
                                    <option value="Michael">Michael</option>
                                    <option value="Emily">Emily</option>
                                </select>
                            </div>

                            <div class="mb-4">
                                <label for="timeSlot" class="block text-sm font-medium text-gray-700 mb-1">Preferred Time</label>
                                <select id="timeSlot" name="timeSlot" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500">
                                    <option value="">No preference</option>
                                    <option value="Morning">Morning (9AM - 12PM)</option>
                                    <option value="Afternoon">Afternoon (12PM - 4PM)</option>
                                    <option value="Evening">Evening (4PM - 8PM)</option>
                                </select>
                            </div>

                            <div class="mb-6">
                                <label for="specialInstructions" class="block text-sm font-medium text-gray-700 mb-1">Special Instructions</label>
                                <textarea id="specialInstructions" name="specialInstructions" rows="3" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500" placeholder="Any special requests or notes..."></textarea>
                            </div>

                            <div class="flex justify-end space-x-3">
                                <button type="button" id="cancelOptionsBtn" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">Cancel</button>
                                <button type="submit" class="px-4 py-2 bg-indigo-600 rounded-lg text-white hover:bg-indigo-700">Save Options</button>
                            </div>
                        </form>
                    </div>
                </div>
            <% } %>
            <% } else { %>
            <!-- Services Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                <% if (services.isEmpty()) { %>
                    <div class="col-span-3 bg-white rounded-xl shadow-sm p-8 text-center">
                        <div class="w-20 h-20 mx-auto bg-indigo-50 rounded-full flex items-center justify-center mb-4">
                            <i class="fas fa-search text-indigo-600 text-2xl"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-800 mb-2">No services found</h3>
                        <p class="text-gray-600 mb-6">Try adjusting your search or filter criteria</p>
                        <a href="${pageContext.request.contextPath}/serviceCart" class="px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">
                            View All Services
                        </a>
                    </div>
                <% } else { %>
                    <% for (Service service : services) { %>
                        <div class="service-card bg-white rounded-xl shadow-sm p-6 transition duration-300">
                            <div class="w-full h-40 bg-indigo-50 rounded-lg mb-4 flex items-center justify-center">
                                <i class="<%= service.getIcon() %> text-indigo-600 text-4xl"></i>
                            </div>
                            <div class="flex justify-between items-start mb-2">
                                <h3 class="text-lg font-bold text-gray-800"><%= service.getName() %></h3>
                                <% if ("Premium".equals(service.getStatus())) { %>
                                    <span class="bg-purple-100 text-purple-800 text-xs px-2 py-1 rounded-full">Premium</span>
                                <% } else if ("Active".equals(service.getStatus())) { %>
                                    <span class="bg-green-100 text-green-800 text-xs px-2 py-1 rounded-full">Active</span>
                                <% } else { %>
                                    <span class="bg-gray-100 text-gray-800 text-xs px-2 py-1 rounded-full">Inactive</span>
                                <% } %>
                            </div>
                            <p class="text-gray-600 text-sm mb-4"><%= service.getDescription() %></p>
                            <div class="flex justify-between items-center">
                                <div>
                                    <span class="text-gray-500 text-sm"><i class="far fa-clock mr-1"></i> <%= service.getDuration() %> min</span>
                                    <span class="text-gray-500 text-sm ml-3"><i class="fas fa-dollar-sign mr-1"></i> <%= String.format("%.2f", service.getPrice()) %></span>
                                </div>
                                <% if (cartItems != null && ServiceCart.getInstance(user).containsService(service.getId())) { %>
                                    <a href="${pageContext.request.contextPath}/serviceCart?action=remove&id=<%= service.getId() %>" class="text-red-600 hover:text-red-800 font-medium text-sm">Remove</a>
                                <% } else { %>
                                    <button type="button" class="add-to-cart-btn text-indigo-600 hover:text-indigo-800 font-medium text-sm"
                                            data-id="<%= service.getId() %>"
                                            data-name="<%= service.getName() %>">Add to Cart</button>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>
            <% } %>

            <!-- Special Offers Section -->
            <div class="mt-12">
                <h2 class="text-xl font-semibold text-gray-800 mb-4">Special Offers</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="bg-gradient-to-r from-indigo-500 to-purple-600 rounded-xl p-6 text-white">
                        <div class="flex items-center justify-between">
                            <div>
                                <h3 class="text-lg font-bold mb-1">Spa Day Package</h3>
                                <p class="mb-3">Facial, Massage & Manicure - Save 20%</p>
                                <button class="bg-white text-indigo-600 px-4 py-2 rounded-lg font-medium hover:bg-indigo-50 transition">Book Package</button>
                            </div>
                            <div class="text-4xl font-bold">Rs 149</div>
                        </div>
                    </div>
                    <div class="bg-gradient-to-r from-amber-500 to-orange-500 rounded-xl p-6 text-white">
                        <div class="flex items-center justify-between">
                            <div>
                                <h3 class="text-lg font-bold mb-1">Gold Member Discount</h3>
                                <p class="mb-3">15% off all services this month</p>
                                <button class="bg-white text-amber-600 px-4 py-2 rounded-lg font-medium hover:bg-amber-50 transition">View All</button>
                            </div>
                            <div class="text-4xl font-bold">15% OFF</div>
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

    <!-- Add to Cart Modal -->
    <div id="addToCartModal" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center z-50 hidden">
        <div class="bg-white rounded-xl shadow-lg w-full max-w-md">
            <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                <h2 class="text-xl font-semibold text-gray-800">Add to Cart</h2>
                <button id="closeAddToCartModal" class="text-gray-400 hover:text-gray-500">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form id="addToCartForm" action="${pageContext.request.contextPath}/serviceCart" method="get" class="p-6">
                <input type="hidden" name="action" value="add">
                <input type="hidden" id="addServiceId" name="id" value="">

                <div class="mb-4">
                    <h3 id="serviceName" class="text-lg font-medium text-gray-800 mb-2"></h3>
                </div>

                <div class="mb-4">
                    <label for="addQuantity" class="block text-sm font-medium text-gray-700 mb-1">Quantity</label>
                    <div class="flex items-center border border-gray-300 rounded-lg overflow-hidden w-32">
                        <button type="button" id="decrementAddBtn" class="px-3 py-2 bg-gray-100 text-gray-600 hover:bg-gray-200 focus:outline-none">
                            <i class="fas fa-minus"></i>
                        </button>
                        <input type="number" id="addQuantity" name="quantity" value="1" min="1" max="10" class="w-full text-center border-0 focus:ring-0 focus:outline-none">
                        <button type="button" id="incrementAddBtn" class="px-3 py-2 bg-gray-100 text-gray-600 hover:bg-gray-200 focus:outline-none">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                </div>

                <div class="mb-6">
                    <label for="addSpecialInstructions" class="block text-sm font-medium text-gray-700 mb-1">Special Instructions</label>
                    <textarea id="addSpecialInstructions" name="specialInstructions" rows="3" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500" placeholder="Any special requests or notes..."></textarea>
                </div>

                <div class="flex justify-end space-x-3">
                    <button type="button" id="cancelAddToCartBtn" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">Cancel</button>
                    <button type="submit" class="px-4 py-2 bg-indigo-600 rounded-lg text-white hover:bg-indigo-700">Add to Cart</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Search functionality
            const searchInput = document.querySelector('input[name="query"]');
            if (searchInput) {
                searchInput.addEventListener('keyup', (e) => {
                    if (e.key === 'Enter') {
                        // Submit the parent form
                        searchInput.closest('form').submit();
                    }
                });
            }

            // Service card hover effect
            const serviceCards = document.querySelectorAll('.service-card');
            serviceCards.forEach(card => {
                card.addEventListener('mouseenter', () => {
                    card.classList.add('shadow-md');
                });

                card.addEventListener('mouseleave', () => {
                    card.classList.remove('shadow-md');
                });
            });

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

            // Quantity increment/decrement buttons
            const decrementBtns = document.querySelectorAll('.decrement-btn');
            const incrementBtns = document.querySelectorAll('.increment-btn');

            decrementBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const input = this.parentNode.querySelector('input[type="number"]');
                    if (input.value > 1) {
                        input.value = parseInt(input.value) - 1;
                    }
                });
            });

            incrementBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const input = this.parentNode.querySelector('input[type="number"]');
                    if (input.value < 10) {
                        input.value = parseInt(input.value) + 1;
                    }
                });
            });

            // Update quantity buttons
            const updateBtns = document.querySelectorAll('.update-btn');
            updateBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const formId = this.getAttribute('data-form');
                    const form = document.getElementById(formId);
                    if (form) {
                        form.submit();
                    }
                });
            });

            // Service options modal
            const optionsModal = document.getElementById('serviceOptionsModal');
            const closeOptionsModalBtn = document.getElementById('closeOptionsModal');
            const cancelOptionsBtn = document.getElementById('cancelOptionsBtn');
            const editOptionsBtns = document.querySelectorAll('.edit-options-btn');
            const optionsServiceIdInput = document.getElementById('optionsServiceId');

            editOptionsBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const serviceId = this.getAttribute('data-id');
                    optionsServiceIdInput.value = serviceId;
                    optionsModal.classList.remove('hidden');
                });
            });

            if (closeOptionsModalBtn) {
                closeOptionsModalBtn.addEventListener('click', function() {
                    optionsModal.classList.add('hidden');
                });
            }

            if (cancelOptionsBtn) {
                cancelOptionsBtn.addEventListener('click', function() {
                    optionsModal.classList.add('hidden');
                });
            }

            // Add to Cart modal
            const addToCartModal = document.getElementById('addToCartModal');
            const closeAddToCartModalBtn = document.getElementById('closeAddToCartModal');
            const cancelAddToCartBtn = document.getElementById('cancelAddToCartBtn');
            const addToCartBtns = document.querySelectorAll('.add-to-cart-btn');
            const addServiceIdInput = document.getElementById('addServiceId');
            const serviceNameElement = document.getElementById('serviceName');

            // Add to Cart quantity buttons
            const decrementAddBtn = document.getElementById('decrementAddBtn');
            const incrementAddBtn = document.getElementById('incrementAddBtn');
            const addQuantityInput = document.getElementById('addQuantity');

            if (decrementAddBtn) {
                decrementAddBtn.addEventListener('click', function() {
                    if (addQuantityInput.value > 1) {
                        addQuantityInput.value = parseInt(addQuantityInput.value) - 1;
                    }
                });
            }

            if (incrementAddBtn) {
                incrementAddBtn.addEventListener('click', function() {
                    if (addQuantityInput.value < 10) {
                        addQuantityInput.value = parseInt(addQuantityInput.value) + 1;
                    }
                });
            }

            addToCartBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const serviceId = this.getAttribute('data-id');
                    const serviceName = this.getAttribute('data-name');

                    addServiceIdInput.value = serviceId;
                    serviceNameElement.textContent = serviceName;
                    addToCartModal.classList.remove('hidden');
                });
            });

            if (closeAddToCartModalBtn) {
                closeAddToCartModalBtn.addEventListener('click', function() {
                    addToCartModal.classList.add('hidden');
                });
            }

            if (cancelAddToCartBtn) {
                cancelAddToCartBtn.addEventListener('click', function() {
                    addToCartModal.classList.add('hidden');
                });
            }
        });
    </script>
</body>
</html>