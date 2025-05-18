<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if there's an error message to display
    String errorMessage = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Saloon - Sign Up</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/@dotlottie/player-component@latest/dist/dotlottie-player.mjs" type="module"></script>
    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .signup-container {
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body class="gradient-bg min-h-screen flex items-center justify-center p-4">
    <div class="signup-container bg-white rounded-2xl overflow-hidden w-full max-w-4xl flex flex-col md:flex-row">
        <!-- Animation Section -->
        <div class="w-full md:w-1/2 bg-indigo-50 p-8 flex flex-col items-center justify-center">
            <div class="mb-4 text-center">
                <h1 class="text-3xl font-bold text-indigo-900">Beauty Saloon</h1>
                <p class="text-indigo-700 mt-2">Join Our Beauty Community</p>
            </div>


            <iframe
            background="transparent"
                speed="1"
                style="width: 300px; height: 300px;"
                loop
                autoplay
            src="https://lottie.host/embed/36e9c196-10d4-4d2f-b815-12ac42da454f/U9PrOcD999.lottie"></iframe>
        </div>

        <!-- Signup Form Section -->
        <div class="w-full md:w-1/2 p-10 flex flex-col justify-center">
            <h2 class="text-2xl font-bold text-gray-800 mb-2">Create Account</h2>
            <p class="text-gray-600 mb-8">Join Beauty Saloon management system</p>

            <% if (errorMessage != null) { %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4" role="alert">
                <span class="block sm:inline"><%= errorMessage %></span>
            </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/signup" method="post">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <div>
                        <label for="firstName" class="block text-gray-700 text-sm font-medium mb-2">First Name</label>
                        <input type="text" id="firstName" name="firstName" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-200" placeholder="John" required>
                    </div>
                    <div>
                        <label for="lastName" class="block text-gray-700 text-sm font-medium mb-2">Last Name</label>
                        <input type="text" id="lastName" name="lastName" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-200" placeholder="Doe" required>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="email" class="block text-gray-700 text-sm font-medium mb-2">Email</label>
                    <input type="email" id="email" name="email" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-200" placeholder="your@email.com" required>
                </div>

                <div class="mb-4">
                    <label for="phoneNumber" class="block text-gray-700 text-sm font-medium mb-2">Phone Number</label>
                    <input type="tel" id="phoneNumber" name="phoneNumber" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-200" placeholder="+94 xxxxx xxxx">
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                    <div>
                        <label for="password" class="block text-gray-700 text-sm font-medium mb-2">Password</label>
                        <input type="password" id="password" name="password" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-200" placeholder="••••••••" required>
                    </div>
                    <div>
                        <label for="confirmPassword" class="block text-gray-700 text-sm font-medium mb-2">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-200" placeholder="••••••••" required>
                    </div>
                </div>

                <div class="flex items-center mb-6">
                    <input id="terms" type="checkbox" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded">
                    <label for="terms" class="ml-2 block text-sm text-gray-700">
                        I agree to the <a href="#" class="text-indigo-600 hover:text-indigo-500">Terms of Service</a> and <a href="#" class="text-indigo-600 hover:text-indigo-500">Privacy Policy</a>
                    </label>
                </div>

                <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-3 px-4 rounded-lg transition duration-200 mb-4">
                    Create Account
                </button>

                <div class="text-center">
                    <p class="text-sm text-gray-600">Already have an account? <a href="SignIn.jsp" class="text-indigo-600 font-medium">Log in</a></p>
                </div>
            </form>
        </div>
    </div>
</body>
</html>