<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Favorites - Beauty Salon</title>
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
        .favorite-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
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
                <a href="Client_Dashboard.jsp" class="text-indigo-600 font-medium">Dashboard</a>
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
                        <a href="Client_ServiceCart.jsp" class="flex items-center p-3 rounded-lg text-gray-600">
                            <i class="fas fa-cut mr-3"></i>
                            <span>Services</span>
                        </a>
                    </li>
                    <li>
                        <a href="./Client_Favorites.html" class="flex items-center p-3 rounded-lg bg-indigo-50 text-indigo-600  hover:bg-gray-100">
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
                        <a href="Client_Profile.jsp" class="flex items-center p-3 rounded-lg text-gray-600 hover:bg-gray-100">
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
                    <h1 class="text-2xl font-bold text-gray-800">My Favorites</h1>
                    <p class="text-gray-600">Your saved services and stylists</p>
                </div>
                <div class="mt-4 md:mt-0 flex space-x-2">
                    <button class="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg font-medium hover:bg-gray-50 transition">
                        <i class="fas fa-sliders mr-2"></i> Filter
                    </button>
                    <button class="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg font-medium hover:bg-gray-50 transition">
                        <i class="fas fa-sort mr-2"></i> Sort
                    </button>
                </div>
            </div>

            <!-- Tabs -->
            <div class="border-b border-gray-200 mb-6">
                <nav class="-mb-px flex space-x-8">
                    <a href="#" class="border-indigo-500 text-indigo-600 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm">Services (3)</a>
                    <a href="#" class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm">Stylists (1)</a>
                </nav>
            </div>

            <!-- Favorites Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mb-6">
                <!-- Favorite Service 1 -->
                <div class="favorite-card bg-white rounded-xl shadow-sm p-6 transition duration-300 relative">
                    <button class="absolute top-4 right-4 text-red-500 hover:text-red-700">
                        <i class="fas fa-heart"></i>
                    </button>
                    <div class="w-full h-40 bg-indigo-50 rounded-lg mb-4 flex items-center justify-center">
                        <i class="fas fa-cut text-indigo-600 text-4xl"></i>
                    </div>
                    <h3 class="text-lg font-bold text-gray-800 mb-2">Hair Coloring</h3>
                    <p class="text-gray-600 text-sm mb-4">Full hair coloring service with premium products and expert application.</p>
                    <div class="flex justify-between items-center">
                        <div>
                            <span class="text-gray-500 text-sm"><i class="far fa-clock mr-1"></i> 1.5 hours</span>
                            <span class="text-gray-500 text-sm ml-3"><i class="fas fa-dollar-sign mr-1"></i> 85</span>
                        </div>
                        <button class="px-3 py-1 bg-indigo-600 text-white rounded-lg text-sm hover:bg-indigo-700">Book Now</button>
                    </div>
                </div>

                <!-- Favorite Service 2 -->
                <div class="favorite-card bg-white rounded-xl shadow-sm p-6 transition duration-300 relative">
                    <button class="absolute top-4 right-4 text-red-500 hover:text-red-700">
                        <i class="fas fa-heart"></i>
                    </button>
                    <div class="w-full h-40 bg-indigo-50 rounded-lg mb-4 flex items-center justify-center">
                        <i class="fas fa-spa text-indigo-600 text-4xl"></i>
                    </div>
                    <h3 class="text-lg font-bold text-gray-800 mb-2">Signature Facial</h3>
                    <p class="text-gray-600 text-sm mb-4">Deep cleansing facial with exfoliation, extractions, and customized mask.</p>
                    <div class="flex justify-between items-center">
                        <div>
                            <span class="text-gray-500 text-sm"><i class="far fa-clock mr-1"></i> 1 hour</span>
                            <span class="text-gray-500 text-sm ml-3"><i class="fas fa-dollar-sign mr-1"></i> 75</span>
                        </div>
                        <button class="px-3 py-1 bg-indigo-600 text-white rounded-lg text-sm hover:bg-indigo-700">Book Now</button>
                    </div>
                </div>

                <!-- Favorite Service 3 -->
                <div class="favorite-card bg-white rounded-xl shadow-sm p-6 transition duration-300 relative">
                    <button class="absolute top-4 right-4 text-red-500 hover:text-red-700">
                        <i class="fas fa-heart"></i>
                    </button>
                    <div class="w-full h-40 bg-indigo-50 rounded-lg mb-4 flex items-center justify-center">
                        <i class="fas fa-hand-sparkles text-indigo-600 text-4xl"></i>
                    </div>
                    <h3 class="text-lg font-bold text-gray-800 mb-2">Manicure & Pedicure</h3>
                    <p class="text-gray-600 text-sm mb-4">Complete nail care including shaping, cuticle care, and polish.</p>
                    <div class="flex justify-between items-center">
                        <div>
                            <span class="text-gray-500 text-sm"><i class="far fa-clock mr-1"></i> 1.25 hours</span>
                            <span class="text-gray-500 text-sm ml-3"><i class="fas fa-dollar-sign mr-1"></i> 65</span>
                        </div>
                        <button class="px-3 py-1 bg-indigo-600 text-white rounded-lg text-sm hover:bg-indigo-700">Book Now</button>
                    </div>
                </div>
            </div>

            <!-- Favorite Stylists Section -->
            <div class="bg-white rounded-xl shadow-sm overflow-hidden">
                <div class="p-6 border-b border-gray-100">
                    <h2 class="text-xl font-semibold text-gray-800">Favorite Stylists (1)</h2>
                </div>
                <div class="p-6">
                    <div class="flex items-center justify-between">
                        <div class="flex items-center space-x-4">
                            <div class="w-16 h-16 rounded-full bg-indigo-100 flex items-center justify-center">
                                <i class="fas fa-user-tie text-indigo-600 text-xl"></i>
                            </div>
                            <div>
                                <h3 class="font-medium">Emma Wilson</h3>
                                <p class="text-sm text-gray-500">Senior Hair Stylist</p>
                                <div class="flex items-center mt-1">
                                    <div class="flex text-amber-400">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star-half-alt"></i>
                                    </div>
                                    <span class="text-xs text-gray-500 ml-1">4.8 (124)</span>
                                </div>
                            </div>
                        </div>
                        <div class="flex space-x-2">
                            <button class="px-4 py-2 bg-indigo-600 text-white rounded-lg font-medium hover:bg-indigo-700">
                                <i class="fas fa-calendar-alt mr-2"></i> Book Appointment
                            </button>
                            <button class="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg font-medium hover:bg-gray-50">
                                <i class="fas fa-heart text-red-500 mr-2"></i> Favorited
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Empty State (hidden when favorites exist) -->
            <div class="p-12 text-center hidden">
                <div class="mx-auto w-32 h-32 bg-gray-100 rounded-full flex items-center justify-center mb-4">
                    <i class="far fa-heart text-gray-400 text-4xl"></i>
                </div>
                <h3 class="text-lg font-medium text-gray-900 mb-1">No favorites yet</h3>
                <p class="text-gray-500 mb-4">Save your favorite services and stylists to find them quickly later.</p>
                <button class="bg-indigo-600 text-white px-4 py-2 rounded-lg font-medium hover:bg-indigo-700 transition">
                    <i class="fas fa-cut mr-2"></i> Browse Services
                </button>
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
            // Favorite toggle functionality
            const favoriteButtons = document.querySelectorAll('.favorite-card button');
            
            favoriteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const icon = this.querySelector('i');
                    if (icon.classList.contains('fas')) {
                        icon.classList.remove('fas');
                        icon.classList.add('far');
                        this.classList.remove('text-red-500');
                        this.classList.add('text-gray-400');
                    } else {
                        icon.classList.remove('far');
                        icon.classList.add('fas');
                        this.classList.remove('text-gray-400');
                        this.classList.add('text-red-500');
                    }
                    // Here you would typically update favorites in your backend
                });
            });
            
            // Tab functionality
            const tabs = document.querySelectorAll('[role="tab"]');
            
            tabs.forEach(tab => {
                tab.addEventListener('click', () => {
                    // Remove all current selected tabs
                    tabs.forEach(t => {
                        t.classList.remove('border-indigo-500', 'text-indigo-600');
                        t.classList.add('border-transparent', 'text-gray-500');
                    });
                    
                    // Set this tab as selected
                    tab.classList.add('border-indigo-500', 'text-indigo-600');
                    tab.classList.remove('border-transparent', 'text-gray-500');
                    
                    // Here you would typically load the content for the selected tab
                    // For this example, we're just changing the UI state
                });
            });
        });
    </script>
</body>
</html>