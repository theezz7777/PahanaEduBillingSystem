<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    // Check if user is logged in
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Item - Pahana Edu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"], input[type="number"], textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        textarea {
            height: 80px;
            resize: vertical;
        }
        .btn {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
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
            border: 1px solid transparent;
            border-radius: 4px;
        }
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
        .navigation {
            text-align: center;
            margin-bottom: 20px;
        }
        .navigation a {
            color: #007bff;
            text-decoration: none;
            margin: 0 10px;
        }
        .navigation a:hover {
            text-decoration: underline;
        }
        .required {
            color: red;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="navigation">
        <a href="dashboard.jsp">Dashboard</a> |
        <a href="ItemServlet?action=list">View Items</a> |
        <a href="logout">Logout</a>
    </div>

    <div class="header">
        <h2>Add New Item</h2>
        <p>Enter the details of the new item below</p>
    </div>

    <!-- Display success message -->
    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success">
        <%= request.getAttribute("success") %>
    </div>
    <% } %>

    <!-- Display error message -->
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form method="post" action="ItemServlet" onsubmit="return validateForm()">
        <input type="hidden" name="action" value="add">

        <div class="form-group">
            <label for="name">Item Name <span class="required">*</span></label>
            <input type="text" id="name" name="name" required
                   value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>">
        </div>

        <div class="form-group">
            <label for="description">Description</label>
            <textarea id="description" name="description" placeholder="Enter item description..."><%= request.getParameter("description") != null ? request.getParameter("description") : "" %></textarea>
        </div>

        <div class="form-group">
            <label for="price">Price (LKR) <span class="required">*</span></label>
            <input type="number" id="price" name="price" step="0.01" min="0" required
                   value="<%= request.getParameter("price") != null ? request.getParameter("price") : "" %>">
        </div>

        <div class="form-group">
            <label for="stock">Stock Quantity</label>
            <input type="number" id="stock" name="stock" min="0" value="0"
                   value="<%= request.getParameter("stock") != null ? request.getParameter("stock") : "0" %>">
        </div>

        <div class="form-group">
            <button type="submit" class="btn">Add Item</button>
            <button type="button" class="btn btn-secondary" onclick="resetForm()">Reset</button>
            <button type="button" class="btn btn-secondary" onclick="goBack()">Cancel</button>
        </div>
    </form>
</div>

<script>
    function validateForm() {
        const name = document.getElementById('name').value.trim();
        const price = document.getElementById('price').value;
        const stock = document.getElementById('stock').value;

        if (name === '') {
            alert('Item name is required!');
            return false;
        }

        if (price === '' || parseFloat(price) < 0) {
            alert('Please enter a valid price!');
            return false;
        }

        if (stock !== '' && (parseInt(stock) < 0 || isNaN(parseInt(stock)))) {
            alert('Please enter a valid stock quantity!');
            return false;
        }

        return true;
    }

    function resetForm() {
        if (confirm('Are you sure you want to reset the form?')) {
            document.querySelector('form').reset();
        }
    }

    function goBack() {
        window.location.href = 'ItemServlet?action=list';
    }

    // Focus on the first input field when page loads
    window.onload = function() {
        document.getElementById('name').focus();
    };
</script>
</body>
</html>