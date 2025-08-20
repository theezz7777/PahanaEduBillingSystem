<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pahanaedu.model.Item" %>
<%@ page import="com.pahanaedu.dao.ItemDAO" %>
<%@ page import="java.sql.SQLException" %>

<%
    // Check if user is logged in
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Fetch all items from database
    List<Item> itemList = null;
    String errorMessage = null;

    try {
        ItemDAO itemDAO = new ItemDAO();
        itemList = itemDAO.getAllItems();
    } catch (Exception e) {
        errorMessage = "Error retrieving items: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Item List - Pahana Edu Bookshop</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(45deg, #2c3e50, #3498db);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .content {
            padding: 30px;
        }

        .top-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .search-box {
            flex: 1;
            max-width: 300px;
        }

        .search-box input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 25px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        .search-box input:focus {
            outline: none;
            border-color: #3498db;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
            font-weight: 500;
        }

        .btn-primary {
            background: linear-gradient(45deg, #3498db, #2980b9);
            color: white;
        }

        .btn-success {
            background: linear-gradient(45deg, #27ae60, #229954);
            color: white;
        }

        .btn-warning {
            background: linear-gradient(45deg, #f39c12, #e67e22);
            color: white;
        }

        .btn-danger {
            background: linear-gradient(45deg, #e74c3c, #c0392b);
            color: white;
        }

        .btn-secondary {
            background: linear-gradient(45deg, #95a5a6, #7f8c8d);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .alert-error {
            background: #fee;
            border: 1px solid #fcc;
            color: #c33;
        }

        .alert-info {
            background: #e3f2fd;
            border: 1px solid #bbdefb;
            color: #1565c0;
        }

        .stats-bar {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 20px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #3498db;
        }

        .stat-label {
            color: #666;
            margin-top: 5px;
        }

        .table-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: linear-gradient(45deg, #34495e, #2c3e50);
            color: white;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 0.5px;
        }

        tbody tr:hover {
            background: #f8f9fa;
            transform: scale(1.01);
            transition: all 0.3s;
        }

        .price {
            font-weight: bold;
            color: #27ae60;
        }

        .stock {
            font-weight: bold;
        }

        .stock.low {
            color: #e74c3c;
        }

        .stock.medium {
            color: #f39c12;
        }

        .stock.high {
            color: #27ae60;
        }

        .description {
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .no-items {
            text-align: center;
            padding: 50px;
            color: #666;
        }

        .no-items i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #ddd;
        }

        @media (max-width: 768px) {
            .top-actions {
                flex-direction: column;
            }

            .search-box {
                max-width: 100%;
            }

            table {
                font-size: 14px;
            }

            th, td {
                padding: 10px;
            }

            .description {
                max-width: 150px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>📚 Item Inventory</h1>
        <p>Manage your bookshop inventory efficiently</p>
    </div>

    <div class="content">
        <!-- Top Actions Bar -->
        <div class="top-actions">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="🔍 Search items..." onkeyup="searchItems()">
            </div>
            <div class="action-buttons">
                <a href="AddNewItems.jsp" class="btn btn-success">➕ Add New Item</a>
                <a href="dashboard.jsp" class="btn btn-secondary">🏠 Dashboard</a>
            </div>
        </div>

        <!-- Error Message -->
        <% if (errorMessage != null) { %>
        <div class="alert alert-error">
            <strong>Error:</strong> <%= errorMessage %>
        </div>
        <% } %>

        <!-- Statistics Bar -->
        <% if (itemList != null && !itemList.isEmpty()) {
            int totalItems = itemList.size();
            int lowStockItems = 0;
            double totalValue = 0;

            for (Item item : itemList) {
                if (item.getStock() <= 5) lowStockItems++;
                totalValue += item.getPrice().doubleValue() * item.getStock();
            }
        %>
        <div class="stats-bar">
            <div class="stat-item">
                <div class="stat-number"><%= totalItems %></div>
                <div class="stat-label">Total Items</div>
            </div>
            <div class="stat-item">
                <div class="stat-number"><%= lowStockItems %></div>
                <div class="stat-label">Low Stock</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">Rs. <%= String.format("%.2f", totalValue) %></div>
                <div class="stat-label">Total Value</div>
            </div>
        </div>
        <% } %>

        <!-- Items Table -->
        <div class="table-container">
            <% if (itemList != null && !itemList.isEmpty()) { %>
            <table id="itemsTable">
                <thead>
                <tr>
                    <th>Item ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Price (Rs.)</th>
                    <th>Stock</th>
                    <th>Created Date</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Item item : itemList) {
                    String stockClass = "high";
                    if (item.getStock() <= 5) stockClass = "low";
                    else if (item.getStock() <= 15) stockClass = "medium";
                %>
                <tr>
                    <td><strong>ID-<%= item.getItemId() %></strong></td>
                    <td><strong><%= item.getName() %></strong></td>
                    <td>
                        <div class="description" title="<%= item.getDescription() != null ? item.getDescription() : "No description" %>">
                            <%= item.getDescription() != null ? item.getDescription() : "No description" %>
                        </div>
                    </td>
                    <td class="price">Rs. <%= String.format("%.2f", item.getPrice().doubleValue()) %></td>
                    <td class="stock <%= stockClass %>">
                        <%= item.getStock() %>
                        <% if (item.getStock() <= 5) { %>
                        <small style="color: #e74c3c;">(Low)</small>
                        <% } %>
                    </td>
                    <td><%= item.getCreatedAt() != null ? item.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                    <td>
                        <a href="UpdateItems.jsp?id=<%= item.getItemId() %>" class="btn btn-warning" style="padding: 8px 16px; font-size: 14px;">
                            ✏️ Edit
                        </a>
                        <button onclick="deleteItem(<%= item.getItemId() %>, '<%= item.getName() %>')"
                                class="btn btn-danger" style="padding: 8px 16px; font-size: 14px; margin-left: 5px;">
                            🗑️ Delete
                        </button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="no-items">
                <div style="font-size: 4rem; margin-bottom: 20px;">📚</div>
                <h3>No items found</h3>
                <p>Start by adding your first item to the inventory.</p>
                <a href="AddNewItems.jsp" class="btn btn-success" style="margin-top: 20px;">
                    ➕ Add Your First Item
                </a>
            </div>
            <% } %>
        </div>

        <!-- Low Stock Alert -->
        <% if (itemList != null && !itemList.isEmpty()) {
            boolean hasLowStock = false;
            for (Item item : itemList) {
                if (item.getStock() <= 5) {
                    if (!hasLowStock) {
                        hasLowStock = true;
        %>
        <div class="alert alert-info" style="margin-top: 20px;">
            <strong>📊 Low Stock Alert:</strong> The following items need restocking:<br>
            <%          }
            %>
            <strong><%= item.getName() %></strong> (Stock: <%= item.getStock() %>)<br>
            <%      }
            }
                if (hasLowStock) {
            %>
        </div>
        <%  }
        } %>
    </div>
</div>

<script>
    // Search functionality
    function searchItems() {
        const input = document.getElementById('searchInput');
        const filter = input.value.toLowerCase();
        const table = document.getElementById('itemsTable');

        if (!table) return;

        const rows = table.getElementsByTagName('tr');

        for (let i = 1; i < rows.length; i++) {
            const row = rows[i];
            const cells = row.getElementsByTagName('td');
            let found = false;

            for (let j = 0; j < cells.length - 1; j++) { // Exclude actions column
                const cellText = cells[j].textContent || cells[j].innerText;
                if (cellText.toLowerCase().indexOf(filter) > -1) {
                    found = true;
                    break;
                }
            }

            row.style.display = found ? '' : 'none';
        }
    }

    // Delete item functionality
    function deleteItem(itemId, itemName) {
        if (confirm(`Are you sure you want to delete "${itemName}"?\n\nThis action cannot be undone and will also remove this item from all associated bills.`)) {
            // Create form and submit
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'ItemServlet';

            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'delete';

            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'itemId';
            idInput.value = itemId;

            form.appendChild(actionInput);
            form.appendChild(idInput);
            document.body.appendChild(form);

            form.submit();
        }
    }

    // Auto-refresh every 30 seconds for real-time updates
    setTimeout(function() {
        location.reload();
    }, 30000);

    // Add some interactive effects
    document.addEventListener('DOMContentLoaded', function() {
        // Add hover effects to table rows
        const rows = document.querySelectorAll('tbody tr');
        rows.forEach(row => {
            row.addEventListener('mouseenter', function() {
                this.style.boxShadow = '0 4px 8px rgba(0,0,0,0.1)';
            });
            row.addEventListener('mouseleave', function() {
                this.style.boxShadow = 'none';
            });
        });
    });
</script>
</body>
</html>