<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pahanaedu.model.Customer" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Customer Details - Pahana Edu</title>
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
      max-width: 1200px;
      margin: 0 auto;
    }
    h2 {
      color: #333;
      text-align: center;
      margin-bottom: 30px;
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
    .btn {
      background-color: #007bff;
      color: white;
      padding: 8px 16px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      font-size: 14px;
      margin: 2px;
    }
    .btn:hover {
      background-color: #0056b3;
    }
    .btn-success {
      background-color: #28a745;
    }
    .btn-success:hover {
      background-color: #1e7e34;
    }
    .btn-warning {
      background-color: #ffc107;
      color: #212529;
    }
    .btn-warning:hover {
      background-color: #e0a800;
    }
    .btn-danger {
      background-color: #dc3545;
    }
    .btn-danger:hover {
      background-color: #c82333;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      border: 1px solid #ddd;
      padding: 12px;
      text-align: left;
    }
    th {
      background-color: #007bff;
      color: white;
    }
    tr:nth-child(even) {
      background-color: #f8f9fa;
    }
    tr:hover {
      background-color: #e8f4f8;
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
    .actions {
      margin-bottom: 20px;
    }
    .no-customers {
      text-align: center;
      color: #666;
      font-style: italic;
      padding: 40px;
    }
  </style>
  <script>
    function confirmDelete(accountNumber, customerName) {
      if (confirm('Are you sure you want to delete customer "' + customerName + '" (Account: ' + accountNumber + ')?')) {
        document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/customer/delete';
        document.getElementById('deleteAccountNumber').value = accountNumber;
        document.getElementById('deleteForm').submit();
      }
    }
  </script>
</head>
<body>
<div class="container">
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/dashboard.jsp">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/customer/add">Add New Customer</a>
  </div>

  <h2>Customer Management</h2>

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

  <div class="actions">
    <a href="${pageContext.request.contextPath}/customer/add" class="btn btn-success">
      Add New Customer
    </a>
  </div>

  <%
    @SuppressWarnings("unchecked")
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    if (customers != null && !customers.isEmpty()) {
  %>

  <table>
    <thead>
    <tr>
      <th>Account Number</th>
      <th>Name</th>
      <th>Address</th>
      <th>Telephone</th>
      <th>Units Consumed</th>
      <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
      for (Customer customer : customers) {
    %>
    <tr>
      <td><%= customer.getAccountNumber() %></td>
      <td><%= customer.getName() != null ? customer.getName() : "-" %></td>
      <td><%= customer.getAddress() != null ? customer.getAddress() : "-" %></td>
      <td><%= customer.getTelephone() != null ? customer.getTelephone() : "-" %></td>
      <td><%= customer.getUnitsConsumed() %></td>
      <td>
        <a href="${pageContext.request.contextPath}/customer/edit?accountNumber=<%= customer.getAccountNumber() %>"
           class="btn btn-warning">Edit</a>
        <button onclick="confirmDelete('<%= customer.getAccountNumber() %>', '<%= customer.getName() != null ? customer.getName().replace("'", "\\'") : "" %>')"
                class="btn btn-danger">Delete</button>
      </td>
    </tr>
    <%
      }
    %>
    </tbody>
  </table>

  <%
  } else {
  %>
  <div class="no-customers">
    <p>No customers found. <a href="${pageContext.request.contextPath}/customer/add">Add your first customer</a></p>
  </div>
  <%
    }
  %>

  <!-- Hidden form for delete operation -->
  <form id="deleteForm" method="post" style="display: none;">
    <input type="hidden" id="deleteAccountNumber" name="accountNumber">
  </form>
</div>
</body>
</html>