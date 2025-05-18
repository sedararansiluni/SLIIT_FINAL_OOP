<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - Beauty Salon</title>
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
        .payment-card {
            transition: all 0.3s ease;
        }
        .payment-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        .card-input:focus + .card-input-border {
            border-color: #6366f1;
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
                        <a href="./Client_Paymentgateway.html" class="flex items-center p-3 rounded-lg bg-indigo-50 text-indigo-600  hover:bg-gray-100">
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
                    <h1 class="text-2xl font-bold text-gray-800">Payment</h1>
                    <p class="text-gray-600">Complete your payment securely</p>
                </div>
                <div class="mt-4 md:mt-0">
                    <span class="text-gray-500">Order #BS-2023-0567</span>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <!-- Payment Form -->
                <div class="bg-white rounded-xl shadow-sm p-6">
                    <h2 class="text-xl font-semibold text-gray-800 mb-4">Payment Method</h2>
                    
                    <!-- Card Animation -->
                    <div class="mb-6">
                        <dotlottie-player 
                            src="https://lottie.host/1b1207ac-3a68-4288-be72-6012a3a020a6/cmhla8exhO.lottie" 
                            background="transparent" 
                            speed="1" 
                            style="width: 100%; height: 180px;" 
                            autoplay>
                        </dotlottie-player>
                    </div>

                    <!-- Card Selection -->
                    <div class="grid grid-cols-3 gap-3 mb-6">
                        <button class="payment-card border border-gray-200 rounded-lg p-3 flex items-center justify-center hover:border-indigo-300">
                            <i class="fab fa-cc-visa text-blue-600 text-2xl"></i>
                        </button>
                        <button class="payment-card border border-gray-200 rounded-lg p-3 flex items-center justify-center hover:border-indigo-300">
                            <i class="fab fa-cc-mastercard text-red-600 text-2xl"></i>
                        </button>
                        <button class="payment-card border border-gray-200 rounded-lg p-3 flex items-center justify-center hover:border-indigo-300">
                            <i class="fab fa-cc-amex text-blue-500 text-2xl"></i>
                        </button>
                    </div>

                    <!-- Card Form -->
                    <form>
                        <div class="mb-4">
                            <label class="block text-gray-700 text-sm font-medium mb-2" for="card-number">Card Number</label>
                            <div class="relative">
                                <input type="text" id="card-number" placeholder="1234 5678 9012 3456" class="card-input w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-1 focus:ring-indigo-500">
                                <div class="card-input-border absolute inset-0 border-2 border-transparent rounded-lg pointer-events-none"></div>
                            </div>
                        </div>

                        <div class="grid grid-cols-2 gap-4 mb-4">
                            <div>
                                <label class="block text-gray-700 text-sm font-medium mb-2" for="expiry">Expiry Date</label>
                                <input type="text" id="expiry" placeholder="MM/YY" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-1 focus:ring-indigo-500">
                            </div>
                            <div>
                                <label class="block text-gray-700 text-sm font-medium mb-2" for="cvv">CVV</label>
                                <div class="relative">
                                    <input type="text" id="cvv" placeholder="123" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-1 focus:ring-indigo-500">
                                    <i class="fas fa-question-circle absolute right-3 top-3 text-gray-400 hover:text-gray-600 cursor-pointer" title="3-digit code on back of card"></i>
                                </div>
                            </div>
                        </div>

                        <div class="mb-6">
                            <label class="block text-gray-700 text-sm font-medium mb-2" for="card-name">Name on Card</label>
                            <input type="text" id="card-name" placeholder="Sedara Ransiluni" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-1 focus:ring-indigo-500">
                        </div>

                        <div class="flex items-center mb-6">
                            <input id="save-card" type="checkbox" class="w-4 h-4 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500">
                            <label for="save-card" class="ml-2 block text-sm text-gray-700">Save this card for future payments</label>
                        </div>

                        <button type="submit" class="w-full bg-indigo-600 text-white py-3 px-4 rounded-lg font-medium hover:bg-indigo-700 transition flex items-center justify-center">
                            <i class="fas fa-lock mr-2"></i> Pay $85.00
                        </button>
                    </form>
                </div>

                <!-- Order Summary -->
                <div class="bg-white rounded-xl shadow-sm p-6 h-fit">
                    <h2 class="text-xl font-semibold text-gray-800 mb-4">Order Summary</h2>
                    
                    <div class="border-b border-gray-200 pb-4 mb-4">
                        <div class="flex justify-between items-center mb-2">
                            <h3 class="font-medium">Hair Coloring</h3>
                            <span class="font-medium">$85.00</span>
                        </div>
                        <p class="text-sm text-gray-500">with Emma Wilson - Today, 2:00 PM</p>
                    </div>

                    <div class="mb-4">
                        <div class="flex justify-between text-gray-600 mb-2">
                            <span>Subtotal</span>
                            <span>$85.00</span>
                        </div>
                        <div class="flex justify-between text-gray-600 mb-2">
                            <span>Tax (10%)</span>
                            <span>$8.50</span>
                        </div>
                        <div class="flex justify-between text-gray-600">
                            <span>Loyalty Discount</span>
                            <span class="text-green-600">-$12.75</span>
                        </div>
                    </div>

                    <div class="border-t border-gray-200 pt-4 mb-6">
                        <div class="flex justify-between font-bold text-lg">
                            <span>Total</span>
                            <span>$80.75</span>
                        </div>
                    </div>

                    <div class="bg-indigo-50 rounded-lg p-4 mb-6">
                        <div class="flex items-start">
                            <i class="fas fa-gem text-indigo-600 mt-1 mr-3"></i>
                            <div>
                                <h4 class="font-medium text-indigo-800">Gold Member Benefit</h4>
                                <p class="text-sm text-gray-600">You saved 15% with your Gold membership!</p>
                            </div>
                        </div>
                    </div>

                    <div class="bg-gray-50 rounded-lg p-4">
                        <h4 class="font-medium mb-2">Need help?</h4>
                        <p class="text-sm text-gray-600 mb-2">Contact our support team for any payment issues.</p>
                        <button class="text-indigo-600 hover:text-indigo-800 text-sm font-medium">
                            <i class="fas fa-headset mr-1"></i> Contact Support
                        </button>
                    </div>
                </div>
            </div>

            <!-- Security Badges -->
            <div class="mt-6 flex flex-wrap items-center justify-center gap-4">
                <div class="bg-white p-3 rounded-lg shadow-xs">
                    <i class="fas fa-lock text-green-500 text-2xl"></i>
                    <span class="ml-2 text-sm font-medium">SSL Secure</span>
                </div>
                <div class="bg-white p-3 rounded-lg shadow-xs">
                    <i class="fas fa-shield-alt text-blue-500 text-2xl"></i>
                    <span class="ml-2 text-sm font-medium">PCI Compliant</span>
                </div>
                <div class="bg-white p-3 rounded-lg shadow-xs">
                    <i class="fas fa-credit-card text-purple-500 text-2xl"></i>
                    <span class="ml-2 text-sm font-medium">3D Secure</span>
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
            // Format card number input
            const cardNumberInput = document.getElementById('card-number');
            
            cardNumberInput.addEventListener('input', function(e) {
                // Remove all non-digit characters
                let value = this.value.replace(/\D/g, '');
                
                // Add space after every 4 digits
                value = value.replace(/(\d{4})(?=\d)/g, '$1 ');
                
                // Update the input value
                this.value = value;
            });

            // Format expiry date input
            const expiryInput = document.getElementById('expiry');
            
            expiryInput.addEventListener('input', function(e) {
                // Remove all non-digit characters
                let value = this.value.replace(/\D/g, '');
                
                // Add slash after 2 digits
                if (value.length > 2) {
                    value = value.substring(0, 2) + '/' + value.substring(2, 4);
                }
                
                // Update the input value
                this.value = value;
            });

            // Card selection
            const cardButtons = document.querySelectorAll('.payment-card');
            
            cardButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    // Remove active class from all buttons
                    cardButtons.forEach(btn => {
                        btn.classList.remove('border-indigo-500', 'bg-indigo-50');
                    });
                    
                    // Add active class to clicked button
                    this.classList.add('border-indigo-500', 'bg-indigo-50');
                });
            });
        });
    </script>
</body>
</html>