<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if there's an error message to display
    String errorMessage = (String) request.getAttribute("error");

    // Check if there's a success message from URL parameter (e.g., after account deletion)
    String successMessage = request.getParameter("message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Saloon - Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/@dotlottie/player-component@2.7.12/dist/dotlottie-player.mjs" type="module"></script>
    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .login-container {
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body class="gradient-bg min-h-screen flex items-center justify-center p-4">
<div class="login-container bg-white rounded-2xl overflow-hidden w-full max-w-4xl flex flex-col md:flex-row">
    <!-- Animation Section -->
    <div class="w-full md:w-1/2 bg-indigo-50 p-8 flex flex-col items-center justify-center">
        <div class="mb-4 text-center">
            <h1 class="text-3xl font-bold text-indigo-900">Beauty Saloon</h1>
            <p class="text-indigo-700 mt-2">Professional Beauty Management</p>
        </div>

        <iframe
                background="transparent"
                speed="1"
                style="width: 300px; height: 300px;"
                loop
                autoplay
                src="https://lottie.host/embed/e4a73700-295e-4e1f-878d-b8a9ef86f739/IOikfIS0P7.json">
        </iframe>
    </div>

    <!-- Login Form Section -->
    <div class="w-full md:w-1/2 p-10 flex flex-col justify-center">
        <h2 class="text-2xl font-bold text-gray-800 mb-2">Welcome Back</h2>
        <p class="text-gray-600 mb-8">Sign in to your Beauty Saloon account</p>

        <% if (errorMessage != null) { %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4" role="alert">
            <span class="block sm:inline"><%= errorMessage %></span>
        </div>
        <% } %>

        <% if (successMessage != null) { %>
        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4" role="alert">
            <span class="block sm:inline"><%= successMessage %></span>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/signin" method="post">
            <div class="mb-4">
                <label for="email" class="block text-gray-700 text-sm font-medium mb-2">Email</label>
                <input type="email" id="email" name="email" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-200" placeholder="your@email.com" required>
            </div>

            <div class="mb-6">
                <label for="password" class="block text-gray-700 text-sm font-medium mb-2">Password</label>
                <input type="password" id="password" name="password" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-200" placeholder="••••••••" required>
            </div>

            <div class="flex items-center justify-between mb-6">
                <div class="flex items-center">
                    <input id="remember-me" type="checkbox" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded">
                    <label for="remember-me" class="ml-2 block text-sm text-gray-700">Remember me</label>
                </div>
                <a href="#" class="text-sm text-indigo-600 hover:text-indigo-500">Forgot password?</a>
            </div>

            <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-3 px-4 rounded-lg transition duration-200 flex items-center justify-center">
                <span>Sign In</span>
                <!-- dotLottie Animation - Arrow (on hover) -->
                <dotlottie-player
                        src="https://lottie.host/829b7696-1851-4428-bbcb-2efa39c0f686/ai55froXtO.lottie"
                        background="transparent"
                        speed="2"
                        style="width: 30px; height: 25px; display: none;"
                        loop
                        hover>
                </dotlottie-player>
            </button>

            <div class="mt-6 text-center">
                <p class="text-sm text-gray-600">Don't have an account? <a href="signup.jsp" class="text-indigo-600 font-medium">Sign up here</a></p>
            </div>
        </form>
    </div>
</div>

<script>
    // Show arrow animation on button hover
    document.querySelector('button').addEventListener('mouseenter', function() {
        const player = this.querySelector('dotlottie-player');
        player.style.display = 'block';
        player.play();
        this.querySelector('span').style.marginRight = '8px';
    });

    document.querySelector('button').addEventListener('mouseleave', function() {
        const player = this.querySelector('dotlottie-player');
        player.style.display = 'none';
        player.stop();
        this.querySelector('span').style.marginRight = '0';
    });
</script>
</body>
</html>