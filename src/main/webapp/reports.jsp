<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pahanaedu.model.Bill" %>
<%@ page import="com.pahanaedu.model.Customer" %>
<%@ page session="true" %>
<%
    // Check if user is logged in
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    Customer customer = (Customer) request.getAttribute("customer");
    String accountNumber = (String) request.getAttribute("accountNumber");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bills Report - Pahana Edu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 1200px;
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
        .navigation {
            text-align: center;
            margin-bottom: 20px;
        }
        .navigation a {
            color: #007bff;
            text-decoration: none;
            margin: 0 10px;
            padding: 5px 10px;
            border: 1px solid #007bff;
            border-radius: 3px;
        }
        .navigation a:hover {
            background-color: #007bff;
            color: white;
        }
        .filter-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .filter-form {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .form-group label {
            font-weight: bold;
            color: #555;
            font-size: 14px;
        }
        .form-group input,
        .form-group select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .customer-info {
            background-color: #e3f2fd;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #007bff;
        }
        .summary-stats {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            flex: 1;
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            text-align: center;
            border-top: 4px solid #007bff;
        }
        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: #007bff;
            margin-bottom: 5px;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        .bills-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .bills-table th,
        .bills-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .bills-table th {
            background-color: #007bff;
            color: white;
            font-weight: bold;
        }
        .bills-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        .bills-table tr:hover {
            background-color: #e3f2fd;
        }
        .text-center {
            text-align: center;
        }
        .text-right {
            text-align: right;
        }
        .btn {
            background-color: #007bff;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            margin: 2px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
        .btn-success {
            background-color: #28a745;
        }
        .btn-success:hover {
            background-color: #218838;
        }
        .btn-danger {
            background-color: #dc3545;
        }
        .btn-danger:hover {
            background-color: #c82333;
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
        .alert-info {
            color: #0c5460;
            background-color: #d1ecf1;
            border-color: #bee5eb;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        .actions {
            text-align: center;
            margin-top: 20px;
        }
        .pagination {
            text-align: center;
            margin-top: 20px;
        }
        .pagination a {
            color: #007bff;
            padding: 8px 16px;
            text-decoration: none;
            border: 1px solid #ddd;
            margin: 0 2px;
            border-radius: 4px;
        }
        .pagination a:hover {
            background-color: #007bff;
            color: white;
        }
        .pagination .current {
            background-color: #007bff;
            color: white;
            padding: 8px 16px;
            border: 1px solid #007bff;
            margin: 0 2px;
            border-radius: 4px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="navigation">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="BillingServlet?action=create">Create Bill</a>
        <a href="CustomerServlet?action=list">Customers</a>
        <a href="ItemServlet?action=list">Items</a>
        <a href="logout">Logout</a>
    </div>

    <div class="header">
        <h2>Bills Report</h2>
        <p>
            <% if (customer != null) { %>
            Bills for Customer: <%= customer.getName() %> (Account: <%= customer.getAccountNumber() %>)
            <% } else { %>
            All Bills Report
            <% } %>
        </p>
    </div>

    <!-- Display messages -->
    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success">
        <%= request.getAttribute("success") %>
    </div>
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <!-- Filter Section -->
    <div class="filter-section">
        <h4>Filter Bills</h4>
        <form class="filter-form" method="get" action="BillingServlet">
            <input type="hidden" name="action" value="customer">
            <div class="form-group">
                <label for="accountNumber">Customer Account:</label>
                <input type="text" id="accountNumber" name="accountNumber"
                       placeholder="Enter account number" value="<%= accountNumber != null ? accountNumber : "" %>">
            </div>
            <div class="form-group">
                <button type="submit" class="btn">Filter</button>
            </div>
            <div class="form-group">
                <a href="BillingServlet?action=list" class="btn btn-secondary">Show All</a>
            </div>
        </form>
    </div>

    <!-- Customer Information -->
    <% if (customer != null) { %>
    <div class="customer-info">
        <h4>Customer Details</h4>
        <strong>Name:</strong> <%= customer.getName() %> |
        <strong>Account:</strong> <%= customer.getAccountNumber() %> |
        <strong>Address:</strong> <%= customer.getAddress() != null ? customer.getAddress() : "N/A" %> |
        <strong>Phone:</strong> <%= customer.getTelephone() != null ? customer.getTelephone() : "N/A" %>
    </div>
    <% } %>

    <!-- Summary Statistics -->
    <% if (bills != null && !bills.isEmpty()) { %>
    <div class="summary-stats">
        <div class="stat-card">
            <div class="stat-number"><%= bills.size() %></div>
            <div class="stat-label">Total Bills</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">
                <%
                    double totalRevenue = 0;
                    int totalUnits = 0;
                    for (Bill bill : bills) {
                        totalRevenue += bill.getTotalAmountAsDouble();
                        totalUnits += bill.getUnits();
                    }
                %>
                LKR <%= String.format("%.2f", totalRevenue) %>
            </div>
            <div class="stat-label">Total Revenue</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><%= totalUnits %></div>
            <div class="stat-label">Total Units</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">LKR <%= String.format("%.2f", bills.isEmpty() ? 0 : totalRevenue / bills.size()) %></div>
            <div class="stat-label">Average Bill</div>
        </div>
    </div>
    <% } %>

    <!-- Bills Table -->
    <% if (bills != null && !bills.isEmpty()) { %>
    <table class="bills-table">
        <thead>
        <tr>
            <th>#</th>
            <th>Bill ID</th>
            <th>Account Number</th>
            <th>Customer Name</th>
            <th>Bill Date</th>
            <th class="text-center">Units</th>
            <th class="text-right">Unit Price</th>
            <th class="text-right">Total Amount</th>
            <th class="text-center">Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            int rowCount = 1;
            for (Bill bill : bills) {
        %>
        <tr>
            <td class="text-center"><%= rowCount++ %></td>
            <td><strong>#<%= bill.getBillId() %></strong></td>
            <td><%= bill.getAccountNumber() %></td>
            <td><%= bill.getCustomerName() != null ? bill.getCustomerName() : "Unknown" %></td>
            <td><%= bill.getFormattedBillDateOnly() %></td>
            <td class="text-center"><%= bill.getUnits() %></td>
            <td class="text-right"><%= bill.getFormattedUnitPrice() %></td>
            <td class="text-right"><strong><%= bill.getFormattedTotalAmount() %></strong></td>
            <td class="text-center">
                <a href="BillingServlet?action=view&billId=<%= bill.getBillId() %>"
                   class="btn btn-sm" title="View Details">View</a>
                <a href="BillingServlet?action=print&billId=<%= bill.getBillId() %>"
                   class="btn btn-sm btn-success" target="_blank" title="Print Bill">Print</a>
                <a href="BillingServlet?action=delete&billId=<%= bill.getBillId() %>"
                   class="btn btn-sm btn-danger" title="Delete Bill"
                   onclick="return confirm('Are you sure you want to delete this bill?')">Delete</a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    <div class="no-data">
        <div class="alert alert-info">
            <h4>No Bills Found</h4>
            <p>
                <% if (accountNumber != null && !accountNumber.isEmpty()) { %>
                No bills found for account number: <%= accountNumber %>
                <% } else { %>
                No bills have been created yet.
                <% } %>
            </p>
            <p><a href="BillingServlet?action=create" class="btn">Create First Bill</a></p>
        </div>
    </div>
    <% } %>

    <!-- Actions -->
    <div class="actions">
        <a href="BillingServlet?action=create" class="btn btn-success">Create New Bill</a>
        <% if (bills != null && !bills.isEmpty()) { %>
        <button onclick="window.print()" class="btn btn-secondary">Print Report</button>
        <button onclick="exportToCSV()" class="btn btn-secondary">Export CSV</button>
        <% } %>
    </div>
</div>

<script>
    function exportToCSV() {
        // Get table data
        const table = document.querySelector('.bills-table');
        if (!table) {
            alert('No data to export');
            return;
        }

        let csv = [];
        const rows = table.querySelectorAll('tr');

        // Get headers (excluding Actions column)
        const headerCells = rows[0].querySelectorAll('th');
        let headers = [];
        for (let i = 0; i < headerCells.length - 1; i++) { // -1 to exclude Actions column
            headers.push(headerCells[i].textContent.trim());
        }
        csv.push(headers.join(','));

        // Get data rows (excluding Actions column)
        for (let i = 1; i < rows.length; i++) {
            const cells = rows[i].querySelectorAll('td');
            let row = [];
            for (let j = 0; j < cells.length - 1; j++) { // -1 to exclude Actions column
                let cellText = cells[j].textContent.trim();
                // Remove extra whitespace and newlines
                cellText = cellText.replace(/\s+/g, ' ');
                // Escape quotes and wrap in quotes if contains comma
                if (cellText.includes(',') || cellText.includes('"')) {
                    cellText = '"' + cellText.replace(/"/g, '""') + '"';
                }
                row.push(cellText);
            }
            csv.push(row.join(','));
        }

        // Create and download CSV file
        const csvContent = csv.join('\n');
        const blob = new Blob([csvContent], { type: 'text/csv' });
        const url = window.URL.createObjectURL(blob);

        const a = document.createElement('a');
        a.style.display = 'none';
        a.href = url;
        a.download = 'bills_report_' + new Date().toISOString().split('T')[0] + '.csv';

        document.body.appendChild(a);
        a.click();

        window.URL.revokeObjectURL(url);
        document.body.removeChild(a);

        alert('Bills report exported successfully!');
    }

    // Auto-focus on account number input
    window.onload = function() {
        const accountInput = document.getElementById('accountNumber');
        if (accountInput && !accountInput.value) {
            accountInput.focus();
        }
    };

    // Print styles
    const printStyles = `
            <style>
                @media print {
                    .navigation, .filter-section, .actions, .btn { display: none !important; }
                    body { background-color: white; }
                    .container { box-shadow: none; }
                    .bills-table th:last-child, .bills-table td:last-child { display: none; }
                    .header { margin-bottom: 20px; }
                    .summary-stats { margin-bottom: 20px; }
                }
            </style>
        `;
    document.head.insertAdjacentHTML('beforeend', printStyles);
</script>
</body>
</html>