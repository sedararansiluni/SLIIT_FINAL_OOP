<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.beauty.model.User" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
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

    // Read inquiries from file
    List<Map<String, String>> inquiries = new ArrayList<>();
    String inquiryFilePath = "C:\\Users\\Venura\\Desktop\\CustomerDemo\\Beauty_version 01\\Beauty\\src\\main\\webapp\\Database\\inquiry.txt";
    File inquiryFile = new File(inquiryFilePath);

    if (inquiryFile.exists()) {
        try (BufferedReader reader = new BufferedReader(new FileReader(inquiryFile))) {
            Map<String, String> currentInquiry = null;
            String line;

            while ((line = reader.readLine()) != null) {
                if (line.startsWith("Date: ")) {
                    // Start of a new inquiry
                    currentInquiry = new LinkedHashMap<>();
                    currentInquiry.put("Date", line.substring(6).trim());
                } else if (line.startsWith("User: ")) {
                    currentInquiry.put("User", line.substring(6).trim());
                } else if (line.startsWith("Email: ")) {
                    currentInquiry.put("Email", line.substring(7).trim());
                } else if (line.startsWith("Subject: ")) {
                    currentInquiry.put("Subject", line.substring(9).trim());
                } else if (line.startsWith("Priority: ")) {
                    currentInquiry.put("Priority", line.substring(10).trim());
                } else if (line.startsWith("Message: ")) {
                    currentInquiry.put("Message", line.substring(9).trim());
                } else if (line.startsWith("Status: ")) {
                    currentInquiry.put("Status", line.substring(8).trim());
                } else if (line.startsWith("-----------------------------------")) {
                    // End of current inquiry
                    if (currentInquiry != null) {
                        inquiries.add(currentInquiry);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Reverse the list to show newest inquiries first
    Collections.reverse(inquiries);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Inquiries</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                <h1 class="text-xl font-bold text-indigo-900">Beauty Salon Admin</h1>
            </div>

            <!-- Profile Section -->
            <div class="flex items-center space-x-4">
                <div class="flex items-center space-x-2">
                    <div class="w-10 h-10 rounded-full bg-indigo-100 flex items-center justify-center">
                        <i class="fas fa-user-shield text-indigo-600"></i>
                    </div>
                    <span class="hidden md:inline text-gray-700">Administrator</span>
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
        <aside class="w-64 bg-white shadow-sm fixed left-0 top-16 bottom-0 overflow-y-auto">
            <div class="p-4">
                <h2 class="text-lg font-semibold text-gray-700 mb-4">Admin Menu</h2>
                <ul class="space-y-2">
                    <li>
                        <a href="Admin_Dashboard.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="fas fa-tachometer-alt mr-3"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="Admin_Users.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
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
                        <a href="Admin_Appointments.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
                            <i class="far fa-calendar-alt mr-3"></i>
                            <span>Appointments</span>
                        </a>
                    </li>
                    <li>
                        <a href="Admin_Inquiries.jsp" class="flex items-center bg-indigo-50 text-indigo-600 p-3 rounded-lg">
                            <i class="fas fa-question-circle mr-3"></i>
                            <span>Inquiries</span>
                            <% if (!inquiries.isEmpty()) { %>
                            <span class="ml-auto bg-red-500 text-white text-xs px-2 py-1 rounded-full"><%= inquiries.size() %></span>
                            <% } %>
                        </a>
                    </li>
                </ul>
            </div>
        </aside>

        <!-- Main Content Area -->
        <main class="flex-1 ml-64 p-6">
            <h1 class="text-2xl font-bold text-gray-800 mb-6">Customer Inquiries</h1>

            <% if (inquiries.isEmpty()) { %>
                <div class="bg-white rounded-xl shadow-sm p-8 text-center">
                    <div class="w-20 h-20 mx-auto bg-indigo-50 rounded-full flex items-center justify-center mb-4">
                        <i class="fas fa-inbox text-indigo-600 text-2xl"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-800 mb-2">No inquiries yet</h3>
                    <p class="text-gray-600">When customers submit inquiries, they will appear here.</p>
                </div>
            <% } else { %>
                <div class="bg-white rounded-xl shadow-sm overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">User</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Subject</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Priority</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                    <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <% for (Map<String, String> inquiry : inquiries) { %>
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= inquiry.get("Date") %></td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm font-medium text-gray-900"><%= inquiry.get("User") %></div>
                                        <div class="text-sm text-gray-500"><%= inquiry.get("Email") %></div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><%= inquiry.get("Subject") %></td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <%
                                        String priority = inquiry.get("Priority");
                                        String priorityClass = "bg-gray-100 text-gray-800";

                                        if ("High".equals(priority)) {
                                            priorityClass = "bg-orange-100 text-orange-800";
                                        } else if ("Urgent".equals(priority)) {
                                            priorityClass = "bg-red-100 text-red-800";
                                        } else if ("Low".equals(priority)) {
                                            priorityClass = "bg-blue-100 text-blue-800";
                                        }
                                        %>
                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full <%= priorityClass %>">
                                            <%= priority %>
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                            <%= inquiry.get("Status") %>
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                        <button class="view-inquiry text-indigo-600 hover:text-indigo-900 mr-2"
                                                data-message="<%= inquiry.get("Message") %>"
                                                data-subject="<%= inquiry.get("Subject") %>"
                                                data-user="<%= inquiry.get("User") %>"
                                                data-email="<%= inquiry.get("Email") %>"
                                                data-timestamp="<%= inquiry.get("Date") %>"
                                                data-priority="<%= inquiry.get("Priority") %>"
                                                data-status="<%= inquiry.get("Status") %>"
                                                data-reply="<%= inquiry.get("Reply") != null ? inquiry.get("Reply") : "" %>">
                                            View Details
                                        </button>
                                        <form action="${pageContext.request.contextPath}/replyInquiry" method="post" class="inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="timestamp" value="<%= inquiry.get("Date") %>">
                                            <button type="button" class="delete-inquiry-btn text-red-600 hover:text-red-900">
                                                Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            <% } %>
        </main>
    </div>

    <!-- Inquiry Details Modal -->
    <div id="inquiryModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-30 hidden">
        <div class="bg-white rounded-xl shadow-lg w-full max-w-lg p-6 relative">
            <button id="closeInquiryModal" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600">
                <i class="fas fa-times"></i>
            </button>

            <div class="mb-6">
                <h2 id="modalSubject" class="text-2xl font-bold text-gray-800 mb-2"></h2>
                <div class="flex items-center text-gray-600 mb-4">
                    <i class="fas fa-user mr-2"></i>
                    <span id="modalUser"></span>
                    <span class="mx-2">•</span>
                    <i class="fas fa-envelope mr-2"></i>
                    <span id="modalEmail"></span>
                </div>
                <div class="bg-gray-50 rounded-lg p-4 mb-4">
                    <p id="modalMessage" class="text-gray-700 whitespace-pre-line"></p>
                </div>

                <div class="flex justify-end space-x-3">
                    <button class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                        Mark as Resolved
                    </button>
                    <button class="px-4 py-2 bg-indigo-600 rounded-lg text-white hover:bg-indigo-700">
                        Reply
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteConfirmModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-40 hidden">
        <div class="bg-white rounded-xl shadow-lg w-full max-w-md p-6 relative">
            <h2 class="text-xl font-bold text-gray-800 mb-4">Confirm Deletion</h2>
            <p class="text-gray-600 mb-6">Are you sure you want to delete this inquiry? This action cannot be undone.</p>

            <form id="confirmDeleteForm" action="${pageContext.request.contextPath}/replyInquiry" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" id="confirmDeleteTimestamp" name="timestamp" value="">

                <div class="flex justify-end space-x-3">
                    <button type="button" id="cancelDeleteBtn" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                        Cancel
                    </button>
                    <button type="submit" class="px-4 py-2 bg-red-600 rounded-lg text-white hover:bg-red-700">
                        Delete
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Inquiry modal functionality
            const inquiryModal = document.getElementById('inquiryModal');
            const closeInquiryModal = document.getElementById('closeInquiryModal');
            const viewInquiryButtons = document.querySelectorAll('.view-inquiry');

            const modalSubject = document.getElementById('modalSubject');
            const modalUser = document.getElementById('modalUser');
            const modalEmail = document.getElementById('modalEmail');
            const modalMessage = document.getElementById('modalMessage');

            // Delete confirmation modal
            const deleteConfirmModal = document.getElementById('deleteConfirmModal');
            const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
            const confirmDeleteTimestamp = document.getElementById('confirmDeleteTimestamp');
            const deleteInquiryBtns = document.querySelectorAll('.delete-inquiry-btn');

            // Show modal when view details is clicked
            viewInquiryButtons.forEach(button => {
                button.addEventListener('click', function() {
                    modalSubject.textContent = this.getAttribute('data-subject');
                    modalUser.textContent = this.getAttribute('data-user');
                    modalEmail.textContent = this.getAttribute('data-email');
                    modalMessage.textContent = this.getAttribute('data-message');

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

            // Handle delete button clicks
            deleteInquiryBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const form = this.closest('form');
                    const timestamp = form.querySelector('input[name="timestamp"]').value;

                    // Set the timestamp in the confirmation modal
                    confirmDeleteTimestamp.value = timestamp;

                    // Show the confirmation modal
                    deleteConfirmModal.classList.remove('hidden');
                    document.body.style.overflow = 'hidden'; // Prevent scrolling
                });
            });

            // Cancel delete
            cancelDeleteBtn.addEventListener('click', function() {
                deleteConfirmModal.classList.add('hidden');
                document.body.style.overflow = 'auto'; // Enable scrolling
            });

            // Hide delete confirmation modal when clicking outside
            deleteConfirmModal.addEventListener('click', function(e) {
                if (e.target === deleteConfirmModal) {
                    deleteConfirmModal.classList.add('hidden');
                    document.body.style.overflow = 'auto'; // Enable scrolling
                }
            });
        });
    </script>
</body>
</html>
