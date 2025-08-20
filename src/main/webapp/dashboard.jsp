<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("auth");
        return;
    }

    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Pahana Edu</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background-color: #f4f4f4; }
        .header { background-color: #333; color: white; padding: 1rem; display: flex; justify-content: space-between; align-items: center; }
        .header h1 { margin: 0; }
        .user-info { font-size: 14px; }
        .logout-btn { background: #dc3545; color: white; padding: 8px 15px; text-decoration: none; border-radius: 3px; }
        .logout-btn:hover { background: #c82333; }
        .container { max-width: 1200px; margin: 20px auto; padding: 0 20px; }
        .welcome { background: white; padding: 20px; border-radius: 5px; margin-bottom: 20px; }
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; }
        .menu-item { background: white; padding: 20px; border-radius: 5px; text-align: center; text-decoration: none; color: #333; transition: transform 0.2s; }
        .menu-item:hover { transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .menu-item h3 { margin: 10px 0; color: #4CAF50; }
        .menu-item p { margin: 0; font-size: 14px; color: #666; }
        .icon { font-size: 2rem; margin-bottom: 10px; }
    </style>
</head>
<body>
<!-- Header -->
<div class="header">
    <h1>📚 Pahana Edu Dashboard</h1>
    <div class="user-info">
        Welcome, <strong><%= username %></strong> (<%= role %>) |
        <a href="auth?action=logout" class="logout-btn">Logout</a>
    </div>
</div>

<div class="container">
    <!-- Welcome Section -->
    <div class="welcome">
        <h2>Welcome to Pahana Edu Management System</h2>
        <p>You are logged in as <strong><%= username %></strong> with <strong><%= role %></strong> privileges.</p>
        <p>Use the menu below to navigate through different system functions.</p>
    </div>

    <!-- Menu Grid -->
    <div class="menu-grid">
        <!-- Customer Management -->
        <a href="AddNewCustomer.jsp" class="menu-item">
            <div class="icon">👥</div>
            <h3>Add New Customer</h3>
            <p>Register new customer accounts with their details</p>
        </a>

        <a href="ViewCustomerDetails.jsp" class="menu-item">
            <div class="icon">📋</div>
            <h3>View Customers</h3>
            <p>View and manage existing customer information</p>
        </a>

        <a href="EditCustomerInfo.jsp" class="menu-item">
            <div class="icon">✏️</div>
            <h3>Edit Customer</h3>
            <p>Update customer information and details</p>
        </a>

        <!-- Item Management -->
        <a href="AddNewItems.jsp" class="menu-item">
            <div class="icon">📦</div>
            <h3>Add New Items</h3>
            <p>Add new books and items to inventory</p>
        </a>

        <a href="ViewItemList.jsp" class="menu-item">
            <div class="icon">📚</div>
            <h3>View Items</h3>
            <p>Browse and manage inventory items</p>
        </a>

        <a href="UpdateItems.jsp" class="menu-item">
            <div class="icon">🔄</div>
            <h3>Update Items</h3>
            <p>Modify item details and pricing</p>
        </a>

        <!-- Billing -->
        <a href="calculate.jsp" class="menu-item">
            <div class="icon">🧮</div>
            <h3>Calculate Bill</h3>
            <p>Generate bills for customer purchases</p>
        </a>

        <a href="printBill.jsp" class="menu-item">
            <div class="icon">🖨️</div>
            <h3>Print Bill</h3>
            <p>Print and manage billing documents</p>
        </a>

        <!-- Reports -->
        <a href="reports.jsp" class="menu-item">
            <div class="icon">📊</div>
            <h3>Reports</h3>
            <p>View sales reports and analytics</p>
        </a>

        <!-- Help -->
        <a href="help.jsp" class="menu-item">
            <div class="icon">❓</div>
            <h3>Help</h3>
            <p>System usage guidelines and support</p>
        </a>
    </div>
</div>
</body>
</html>