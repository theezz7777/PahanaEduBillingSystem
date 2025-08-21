<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pahanaedu.model.Customer" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Customer - Pahana Edu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 600px;
            margin: 0 auto;
        }
        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"], input[type="number"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }
        input[type="text"]:focus, input[type="number"]:focus {
            border-color: #007bff;
            outline: none;
        }
        input[readonly] {
            background-color: #e9ecef;
            color: #6c757d;
        }
        .btn {
            background-color: #007bff;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-danger {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        .alert-success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        .nav-links {
            text-align: center;
            margin-bottom: 20px;
        }
        .nav-links a {
            color: #007bff;
            text-decoration: none;
            margin: 0 10px;
        }
        .nav-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/dashboard.jsp">Dashboard</a> |
        <a href="${pageContext.request.contextPath}/customer/list">View All Customers</a>
    </div>

    <h2>Edit Customer Information</h2>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success">
        <%= request.getAttribute("success") %>
    </div>
    <% } %>

    <%
        Customer customer = (Customer) request.getAttribute("customer");
        if (customer != null) {
    %>

    <form method="post" action="${pageContext.request.contextPath}/customer/edit">
        <div class="form-group">
            <label for="accountNumber">Account Number</label>
            <input type="text" id="accountNumber" name="accountNumber"
                   value="<%= customer.getAccountNumber() %>" required>
        </div>

        <div class="form-group">
            <label for="name">Customer Name *</label>
            <input type="text" id="name" name="name"
                   value="<%= customer.getName() != null ? customer.getName() : "" %>" required>
        </div>

        <div class="form-group">
            <label for="address">Address</label>
            <input type="text" id="address" name="address"
                   value="<%= customer.getAddress() != null ? customer.getAddress() : "" %>">
        </div>

        <div class="form-group">
            <label for="telephone">Telephone</label>
            <input type="text" id="telephone" name="telephone"
                   value="<%= customer.getTelephone() != null ? customer.getTelephone() : "" %>">
        </div>

        <div class="form-group">
            <label for="unitsConsumed">Units Consumed</label>
            <input type="number" id="unitsConsumed" name="unitsConsumed"
                   value="<%= customer.getUnitsConsumed() %>" min="0">
        </div>

        <button type="submit" class="btn">Update Customer</button>
        <button type="button" class="btn btn-secondary"
                onclick="window.location.href='${pageContext.request.contextPath}/customer/list'">
            Cancel
        </button>
    </form>

    <%
    } else {
    %>
    <div class="alert alert-danger">
        Customer not found.
    </div>
    <a href="${pageContext.request.contextPath}/customer/list" class="btn">
        Back to Customer List
    </a>
    <%
        }
    %>
</div>
</body>
</html>