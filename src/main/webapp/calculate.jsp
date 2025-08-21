<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill Calculator - Pahana Edu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
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
        select, input[type="number"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .btn {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin: 5px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .btn-success {
            background-color: #28a745;
        }
        .btn-success:hover {
            background-color: #218838;
        }
        .bill-summary {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
            border-left: 4px solid #007bff;
        }
        .item-row {
            background-color: #fff;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .error {
            color: #dc3545;
            background-color: #f8d7da;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .success {
            color: #155724;
            background-color: #d4edda;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .total {
            font-size: 18px;
            font-weight: bold;
            color: #007bff;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Bill Calculator</h1>

    <%
        String dbURL = "jdbc:mysql://localhost:3306/pahana_edu";
        String dbUser = "root";
        String dbPassword = "root";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String action = request.getParameter("action");
        String message = "";
        String messageType = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Handle bill calculation and saving
            if ("calculate".equals(action)) {
                String accountNumber = request.getParameter("customer");
                String[] itemIds = request.getParameterValues("itemId");
                String[] quantities = request.getParameterValues("quantity");

                if (accountNumber != null && itemIds != null && quantities != null) {
                    double totalAmount = 0.0;

                    // Insert into bills table
                    String billSql = "INSERT INTO bills (account_number, units, unit_price, total_amount) VALUES (?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(billSql, Statement.RETURN_GENERATED_KEYS);
                    pstmt.setString(1, accountNumber);
                    pstmt.setInt(2, 1); // Default units
                    pstmt.setDouble(3, 0.0); // Will be calculated
                    pstmt.setDouble(4, 0.0); // Will be updated
                    pstmt.executeUpdate();

                    ResultSet generatedKeys = pstmt.getGeneratedKeys();
                    int billId = 0;
                    if (generatedKeys.next()) {
                        billId = generatedKeys.getInt(1);
                    }

                    // Insert bill items and calculate total
                    String billItemSql = "INSERT INTO bill_items (bill_id, item_id, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?)";
                    PreparedStatement billItemStmt = conn.prepareStatement(billItemSql);

                    for (int i = 0; i < itemIds.length; i++) {
                        if (itemIds[i] != null && !itemIds[i].isEmpty() && quantities[i] != null && !quantities[i].isEmpty()) {
                            int itemId = Integer.parseInt(itemIds[i]);
                            int quantity = Integer.parseInt(quantities[i]);

                            // Get item price
                            String itemSql = "SELECT price FROM items WHERE item_id = ?";
                            PreparedStatement itemStmt = conn.prepareStatement(itemSql);
                            itemStmt.setInt(1, itemId);
                            ResultSet itemRs = itemStmt.executeQuery();

                            if (itemRs.next()) {
                                double unitPrice = itemRs.getDouble("price");
                                double totalPrice = unitPrice * quantity;
                                totalAmount += totalPrice;

                                billItemStmt.setInt(1, billId);
                                billItemStmt.setInt(2, itemId);
                                billItemStmt.setInt(3, quantity);
                                billItemStmt.setDouble(4, unitPrice);
                                billItemStmt.setDouble(5, totalPrice);
                                billItemStmt.executeUpdate();

                                // Update item stock
                                String updateStockSql = "UPDATE items SET stock = stock - ? WHERE item_id = ?";
                                PreparedStatement stockStmt = conn.prepareStatement(updateStockSql);
                                stockStmt.setInt(1, quantity);
                                stockStmt.setInt(2, itemId);
                                stockStmt.executeUpdate();
                                stockStmt.close();
                            }
                            itemStmt.close();
                        }
                    }

                    // Update total amount in bills table
                    String updateBillSql = "UPDATE bills SET total_amount = ? WHERE bill_id = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateBillSql);
                    updateStmt.setDouble(1, totalAmount);
                    updateStmt.setInt(2, billId);
                    updateStmt.executeUpdate();
                    updateStmt.close();

                    billItemStmt.close();
                    message = "Bill calculated and saved successfully! Bill ID: " + billId + " | Total Amount: LKR " + String.format("%.2f", totalAmount);
                    messageType = "success";
                }
            }

        } catch (Exception e) {
            message = "Error: " + e.getMessage();
            messageType = "error";
        }
    %>

    <% if (!message.isEmpty()) { %>
    <div class="<%= messageType %>">
        <%= message %>
    </div>
    <% } %>

    <form method="post" action="calculate.jsp">
        <input type="hidden" name="action" value="calculate">

        <div class="form-group">
            <label for="customer">Select Customer:</label>
            <select name="customer" id="customer" required>
                <option value="">-- Select Customer --</option>
                <%
                    try {
                        if (conn == null) {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                        }

                        String customerSql = "SELECT account_number, name FROM customers ORDER BY name";
                        pstmt = conn.prepareStatement(customerSql);
                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                            String accountNumber = rs.getString("account_number");
                            String customerName = rs.getString("name");
                %>
                <option value="<%= accountNumber %>"><%= accountNumber %> - <%= customerName %></option>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<option>Error loading customers</option>");
                    }
                %>
            </select>
        </div>

        <h3>Select Items:</h3>
        <div id="itemsContainer">
            <%
                try {
                    String itemSql = "SELECT item_id, name, price, stock FROM items WHERE stock > 0 ORDER BY name";
                    pstmt = conn.prepareStatement(itemSql);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        int itemId = rs.getInt("item_id");
                        String itemName = rs.getString("name");
                        double price = rs.getDouble("price");
                        int stock = rs.getInt("stock");
            %>
            <div class="item-row">
                <div>
                    <strong><%= itemName %></strong><br>
                    <small>Price: LKR <%= String.format("%.2f", price) %> | Stock: <%= stock %></small>
                </div>
                <div>
                    <input type="hidden" name="itemId" value="<%= itemId %>">
                    <label>Quantity:</label>
                    <input type="number" name="quantity" min="0" max="<%= stock %>" value="0"
                           style="width: 80px; margin-left: 10px;"
                           onchange="calculatePreview()">
                </div>
            </div>
            <%
                    }
                } catch (Exception e) {
                    out.println("<div class='error'>Error loading items: " + e.getMessage() + "</div>");
                }
            %>
        </div>

        <div class="bill-summary">
            <h3>Bill Preview</h3>
            <div id="billPreview">
                <p>Select items and quantities to see bill preview</p>
            </div>
            <div class="total">
                Total Amount: LKR <span id="totalAmount">0.00</span>
            </div>
        </div>

        <div style="text-align: center; margin-top: 20px;">
            <button type="submit" class="btn btn-success">Calculate & Save Bill</button>
            <button type="button" class="btn" onclick="window.location.href='dashboard.jsp'">Back to Dashboard</button>
        </div>
    </form>
</div>

<script>
    function calculatePreview() {
        let total = 0;
        let billItems = [];
        let quantityInputs = document.querySelectorAll('input[name="quantity"]');
        let itemIds = document.querySelectorAll('input[name="itemId"]');

        for (let i = 0; i < quantityInputs.length; i++) {
            let quantity = parseInt(quantityInputs[i].value) || 0;
            if (quantity > 0) {
                let itemRow = quantityInputs[i].closest('.item-row');
                let itemName = itemRow.querySelector('strong').textContent;
                let priceText = itemRow.querySelector('small').textContent;
                let price = parseFloat(priceText.match(/Price: LKR ([\d.]+)/)[1]);
                let itemTotal = price * quantity;
                total += itemTotal;

                billItems.push({
                    name: itemName,
                    quantity: quantity,
                    price: price,
                    total: itemTotal
                });
            }
        }

        let previewDiv = document.getElementById('billPreview');
        if (billItems.length > 0) {
            let html = '<table style="width: 100%; border-collapse: collapse;">';
            html += '<tr style="border-bottom: 1px solid #ddd;"><th>Item</th><th>Qty</th><th>Price</th><th>Total</th></tr>';

            billItems.forEach(item => {
                html += '<tr style="border-bottom: 1px solid #eee;">';
                html += '<td>' + item.name + '</td>';
                html += '<td>' + item.quantity + '</td>';
                html += '<td>LKR ' + item.price.toFixed(2) + '</td>';
                html += '<td>LKR ' + item.total.toFixed(2) + '</td>';
                html += '</tr>';
            });

            html += '</table>';
            previewDiv.innerHTML = html;
        } else {
            previewDiv.innerHTML = '<p>Select items and quantities to see bill preview</p>';
        }

        document.getElementById('totalAmount').textContent = total.toFixed(2);
    }

    // Initialize preview on page load
    document.addEventListener('DOMContentLoaded', calculatePreview);
</script>
</body>
</html>

<%
    try {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>