<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Saloon - Appointments</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/@dotlottie/player-component@latest/dist/dotlottie-player.mjs" type="module"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
        }
        .calendar-day {
            transition: all 0.2s ease;
        }
        .calendar-day:hover {
            transform: scale(1.05);
        }
        .appointment-card:hover {
            transform: translateY(-2px);
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
                <a href="Admin_Dashboard.jsp" class="text-gray-600 hover:text-indigo-600">Dashboard</a>
                <a href="Admin_Appoinments.html" class="text-indigo-600 font-medium">Appointments</a>
                <a href="Admin_Clients.jsp" class="text-gray-600 hover:text-indigo-600">Clients</a>
                <a href="Admin_Services.jsp" class="text-gray-600 hover:text-indigo-600">Services</a>
            </nav>

            <!-- Profile Section -->
            <div class="flex items-center space-x-4">
                <button class="p-2 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200">
                    <i class="fas fa-bell"></i>
                    <span class="absolute top-2 right-2 h-2 w-2 rounded-full bg-red-500"></span>
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
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-lg font-semibold text-gray-700">Appointments</h2>
                    <button class="p-2 bg-indigo-600 text-white rounded-full hover:bg-indigo-700 transition">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
                
                <!-- Calendar Widget -->
                <div class="bg-white border border-gray-200 rounded-lg p-4 mb-6">
                    <div class="flex justify-between items-center mb-4">
                        <button class="text-gray-500 hover:text-indigo-600">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <span class="font-medium">October 2023</span>
                        <button class="text-gray-500 hover:text-indigo-600">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                    <div class="grid grid-cols-7 gap-1 mb-2">
                        <div class="text-xs text-center text-gray-500">Sun</div>
                        <div class="text-xs text-center text-gray-500">Mon</div>
                        <div class="text-xs text-center text-gray-500">Tue</div>
                        <div class="text-xs text-center text-gray-500">Wed</div>
                        <div class="text-xs text-center text-gray-500">Thu</div>
                        <div class="text-xs text-center text-gray-500">Fri</div>
                        <div class="text-xs text-center text-gray-500">Sat</div>
                    </div>
                    <div class="grid grid-cols-7 gap-1">
                        <!-- Calendar days would be generated here -->
                        <div class="calendar-day h-8 flex items-center justify-center text-sm rounded-full text-gray-400">29</div>
                        <div class="calendar-day h-8 flex items-center justify-center text-sm rounded-full text-gray-400">30</div>
                        <div class="calendar-day h-8 flex items-center justify-center text-sm rounded-full hover:bg-gray-100">1</div>
                        <div class="calendar-day h-8 flex items-center justify-center text-sm rounded-full hover:bg-gray-100">2</div>
                        <div class="calendar-day h-8 flex items-center justify-center text-sm rounded-full hover:bg-gray-100">3</div>
                        <div class="calendar-day h-8 flex items-center justify-center text-sm rounded-full hover:bg-gray-100">4</div>
                        <div class="calendar-day h-8 flex items-center justify-center text-sm rounded-full hover:bg-gray-100">5</div>
                        <!-- More days... -->
                        <div class="calendar-day h-8 flex items-center justify-center text-sm rounded-full bg-indigo-100 text-indigo-600 font-medium">6</div>
                        <!-- Today's date highlighted -->
                    </div>
                </div>

                <!-- Quick Filters -->
                <div class="mb-6">
                    <h3 class="text-sm font-medium text-gray-700 mb-2">Filters</h3>
                    <div class="space-y-1">
                        <button class="w-full text-left px-3 py-2 text-sm rounded-lg bg-indigo-50 text-indigo-600">All Appointments</button>
                        <button class="w-full text-left px-3 py-2 text-sm rounded-lg text-gray-600 hover:bg-gray-100">Confirmed</button>
                        <button class="w-full text-left px-3 py-2 text-sm rounded-lg text-gray-600 hover:bg-gray-100">Pending</button>
                        <button class="w-full text-left px-3 py-2 text-sm rounded-lg text-gray-600 hover:bg-gray-100">Cancelled</button>
                    </div>
                </div>

                <!-- Staff Availability -->
                <div>
                    <h3 class="text-sm font-medium text-gray-700 mb-2">Staff Availability</h3>
                    <div class="space-y-3">
                        <div class="flex items-center">
                            <div class="w-3 h-3 rounded-full bg-green-500 mr-2"></div>
                            <span class="text-sm text-gray-600">Emma Wilson</span>
                        </div>
                        <div class="flex items-center">
                            <div class="w-3 h-3 rounded-full bg-yellow-500 mr-2"></div>
                            <span class="text-sm text-gray-600">James Rodriguez</span>
                        </div>
                        <div class="flex items-center">
                            <div class="w-3 h-3 rounded-full bg-green-500 mr-2"></div>
                            <span class="text-sm text-gray-600">Sophia Chen</span>
                        </div>
                        <div class="flex items-center">
                            <div class="w-3 h-3 rounded-full bg-red-500 mr-2"></div>
                            <span class="text-sm text-gray-600">Michael Brown</span>
                        </div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Content Area -->
        <main class="content-area flex-1 ml-64 p-6">
            <!-- Date and Action Buttons -->
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800">Today's Appointments</h2>
                    <p class="text-gray-600">Thursday, October 6, 2023</p>
                </div>
                <div class="flex space-x-3 mt-3 md:mt-0">
                    <button class="px-4 py-2 bg-white border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 flex items-center">
                        <i class="fas fa-calendar-alt mr-2"></i>
                        <span>Calendar View</span>
                    </button>
                    <button class="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 flex items-center">
                        <i class="fas fa-plus mr-2"></i>
                        <span>New Appointment</span>
                    </button>
                </div>
            </div>

            <!-- Time Slots -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Morning Column -->
                <div>
                    <h3 class="text-lg font-semibold text-gray-700 mb-4 flex items-center">
                        <i class="fas fa-sun text-yellow-400 mr-2"></i>
                        Morning (9AM - 12PM)
                    </h3>
                    <div class="space-y-4">
                        <!-- Appointment Card -->
                        <div class="appointment-card bg-white rounded-xl shadow-sm p-4 border-l-4 border-indigo-500 transition">
                            <div class="flex justify-between items-start mb-2">
                                <div>
                                    <h4 class="font-medium">Sarah Johnson</h4>
                                    <p class="text-sm text-gray-500">Hair Coloring</p>
                                </div>
                                <span class="text-xs px-2 py-1 rounded-full bg-green-100 text-green-800">Confirmed</span>
                            </div>
                            <div class="flex items-center text-sm text-gray-600 mb-3">
                                <i class="far fa-clock mr-2"></i>
                                <span>9:30 AM - 10:30 AM</span>
                            </div>
                            <div class="flex items-center text-sm text-gray-600">
                                <i class="fas fa-user-tie mr-2"></i>
                                <span>Emma Wilson</span>
                            </div>
                            <div class="flex justify-end mt-3 space-x-2">
                                <button class="p-2 text-gray-500 hover:text-indigo-600">
                                    <i class="far fa-edit"></i>
                                </button>
                                <button class="p-2 text-gray-500 hover:text-red-600">
                                    <i class="far fa-trash-alt"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Another Appointment Card -->
                        <div class="appointment-card bg-white rounded-xl shadow-sm p-4 border-l-4 border-yellow-500 transition">
                            <div class="flex justify-between items-start mb-2">
                                <div>
                                    <h4 class="font-medium">Michael Brown</h4>
                                    <p class="text-sm text-gray-500">Beard Trim</p>
                                </div>
                                <span class="text-xs px-2 py-1 rounded-full bg-yellow-100 text-yellow-800">Pending</span>
                            </div>
                            <div class="flex items-center text-sm text-gray-600 mb-3">
                                <i class="far fa-clock mr-2"></i>
                                <span>11:00 AM - 11:30 AM</span>
                            </div>
                            <div class="flex items-center text-sm text-gray-600">
                                <i class="fas fa-user-tie mr-2"></i>
                                <span>James Rodriguez</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Afternoon Column -->
                <div>
                    <h3 class="text-lg font-semibold text-gray-700 mb-4 flex items-center">
                        <i class="fas fa-sun text-orange-400 mr-2"></i>
                        Afternoon (12PM - 4PM)
                    </h3>
                    <div class="space-y-4">
                        <!-- Appointment Card -->
                        <div class="appointment-card bg-white rounded-xl shadow-sm p-4 border-l-4 border-indigo-500 transition">
                            <div class="flex justify-between items-start mb-2">
                                <div>
                                    <h4 class="font-medium">Jessica Lee</h4>
                                    <p class="text-sm text-gray-500">Haircut & Styling</p>
                                </div>
                                <span class="text-xs px-2 py-1 rounded-full bg-green-100 text-green-800">Confirmed</span>
                            </div>
                            <div class="flex items-center text-sm text-gray-600 mb-3">
                                <i class="far fa-clock mr-2"></i>
                                <span>2:00 PM - 3:00 PM</span>
                            </div>
                            <div class="flex items-center text-sm text-gray-600">
                                <i class="fas fa-user-tie mr-2"></i>
                                <span>Sophia Chen</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Evening Column -->
                <div>
                    <h3 class="text-lg font-semibold text-gray-700 mb-4 flex items-center">
                        <i class="fas fa-moon text-indigo-400 mr-2"></i>
                        Evening (4PM - 8PM)
                    </h3>
                    <div class="space-y-4">
                        <!-- Appointment Card -->
                        <div class="appointment-card bg-white rounded-xl shadow-sm p-4 border-l-4 border-red-500 transition">
                            <div class="flex justify-between items-start mb-2">
                                <div>
                                    <h4 class="font-medium">David Wilson</h4>
                                    <p class="text-sm text-gray-500">Hair Treatment</p>
                                </div>
                                <span class="text-xs px-2 py-1 rounded-full bg-red-100 text-red-800">Cancelled</span>
                            </div>
                            <div class="flex items-center text-sm text-gray-600 mb-3">
                                <i class="far fa-clock mr-2"></i>
                                <span>5:30 PM - 6:30 PM</span>
                            </div>
                            <div class="flex items-center text-sm text-gray-600">
                                <i class="fas fa-user-tie mr-2"></i>
                                <span>Emma Wilson</span>
                            </div>
                        </div>

                        <!-- Another Appointment Card -->
                        <div class="appointment-card bg-white rounded-xl shadow-sm p-4 border-l-4 border-indigo-500 transition">
                            <div class="flex justify-between items-start mb-2">
                                <div>
                                    <h4 class="font-medium">Olivia Martinez</h4>
                                    <p class="text-sm text-gray-500">Manicure & Pedicure</p>
                                </div>
                                <span class="text-xs px-2 py-1 rounded-full bg-green-100 text-green-800">Confirmed</span>
                            </div>
                            <div class="flex items-center text-sm text-gray-600 mb-3">
                                <i class="far fa-clock mr-2"></i>
                                <span>7:00 PM - 8:00 PM</span>
                            </div>
                            <div class="flex items-center text-sm text-gray-600">
                                <i class="fas fa-user-tie mr-2"></i>
                                <span>Sophia Chen</span>
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
        // Mobile menu toggle functionality can be added here
        document.addEventListener('DOMContentLoaded', function() {
            // Any JavaScript for appointments functionality
        });
    </script>
</body>
</html>