<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    // Check if user is already logged in
    User user = (User) session.getAttribute("user");
    String username = (String) session.getAttribute("username");
    boolean isLoggedIn = (user != null);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Pahana Edu - Bookshop Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: white;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            text-align: center;
        }
        .header {
            margin: 50px 0;
        }
        .header h1 {
            font-size: 3rem;
            margin-bottom: 10px;
        }
        .header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        .buttons {
            margin: 30px 0;
        }
        .btn {
            display: inline-block;
            padding: 15px 30px;
            margin: 10px;
            background: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-size: 1.1rem;
            transition: background 0.3s;
        }
        .btn:hover {
            background: #45a049;
        }
        .btn-secondary {
            background: transparent;
            border: 2px solid white;
        }
        .btn-secondary:hover {
            background: rgba(255,255,255,0.1);
        }
        .welcome-back {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .features {
            background: rgba(255,255,255,0.1);
            padding: 30px;
            border-radius: 10px;
            margin: 40px 0;
            text-align: left;
        }
        .features h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .features ul {
            list-style: none;
            padding: 0;
        }
        .features li {
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }
        .features li:before {
            content: "✓ ";
            color: #4CAF50;
            font-weight: bold;
        }
        .footer {
            margin-top: 50px;
            opacity: 0.7;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header Section -->
    <div class="header">
        <h1>📚 Pahana Edu</h1>
        <p>Bookshop Management System</p>
    </div>

    <% if (isLoggedIn) { %>
    <!-- Logged In User View -->
    <div class="welcome-back">
        <h2>Welcome Back, <%= username %>!</h2>
        <p>You are successfully logged into the system.</p>
        <div class="buttons">
            <a href="dashboard.jsp" class="btn">Go to Dashboard</a>
            <a href="auth?action=logout" class="btn btn-secondary">Logout</a>
        </div>
    </div>
    <% } else { %>
    <!-- Guest User View -->
    <div class="buttons">
        <a href="login.jsp" class="btn">Login</a>
        <a href="register.jsp" class="btn btn-secondary">Register</a>
    </div>
    <% } %>

    <!-- Features Section -->
    <div class="features">
        <h2>System Features</h2>
        <ul>
            <li>Customer Account Management</li>
            <li>Book Inventory Control</li>
            <li>Automated Billing System</li>
            <li>Sales Reports & Analytics</li>
            <li>User Authentication & Security</li>
            <li>Easy-to-Use Interface</li>
        </ul>
    </div>

    <!-- About Section -->
    <div class="features">
        <h2>About Pahana Edu</h2>
        <p style="text-align: center;">
            Leading bookshop in Colombo City, serving hundreds of customers each month.
            Our management system streamlines operations and provides efficient customer service.
        </p>
    </div>

    <!-- Footer -->
    <div class="footer">
        <p>&copy; 2025 Pahana Edu Bookshop Management System</p>
    </div>
</div>

<script>
    // Auto-redirect logged in users to dashboard after 10 seconds
    <% if (isLoggedIn) { %>
    setTimeout(function() {
        if (confirm('Go to Dashboard?')) {
            window.location.href = 'dashboard.jsp';
        }
    }, 10000);
    <% } %>
</script>
</body>
</html>