<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Print Bill - Pahana Edu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: #fff;
            color: #000;
            font-size: 14px;
            line-height: 1.4;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: #fff;
            padding: 0;
        }

        .header {
            display: none;
        }

        .bill-container {
            border: 1px solid #000;
            padding: 20px;
            margin: 0;
        }

        .company-header {
            text-align: center;
            border-bottom: 1px solid #000;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }

        .company-name {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .company-tagline {
            font-size: 14px;
            margin-bottom: 5px;
        }

        .company-details {
            font-size: 12px;
            margin-bottom: 2px;
        }

        .bill-title {
            text-align: center;
            font-size: 20px;
            font-weight: bold;
            margin: 20px 0;
            text-transform: uppercase;
        }

        .bill-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
        }

        .customer-info, .bill-details {
            width: 48%;
        }

        .info-section-title {
            font-weight: bold;
            margin-bottom: 10px;
            text-decoration: underline;
        }

        .info-row {
            margin-bottom: 5px;
        }

        .info-label {
            font-weight: bold;
            display: inline-block;
            width: 100px;
        }

        .items-section {
            margin-bottom: 30px;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid #000;
        }

        .items-table th,
        .items-table td {
            border: 1px solid #000;
            padding: 8px;
            text-align: left;
        }

        .items-table th {
            background: #f0f0f0;
            font-weight: bold;
            text-align: center;
        }

        .number-col {
            text-align: center;
            width: 40px;
        }

        .qty-col {
            text-align: center;
            width: 60px;
        }

        .price-col, .total-col {
            text-align: right;
            width: 100px;
        }

        .item-name {
            font-weight: bold;
        }

        .item-description {
            font-size: 12px;
            color: #666;
            font-style: italic;
        }

        .total-section {
            float: right;
            width: 250px;
            border: 1px solid #000;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 10px;
            border-bottom: 1px solid #ccc;
        }

        .total-row:last-child {
            border-bottom: none;
        }

        .grand-total {
            background: #f0f0f0;
            font-weight: bold;
            font-size: 16px;
        }

        .footer {
            clear: both;
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #000;
            font-size: 12px;
        }

        .footer-thanks {
            font-weight: bold;
            margin-bottom: 10px;
        }

        .generation-info {
            margin-top: 15px;
            color: #666;
        }

        .no-print {
            text-align: center;
            margin: 20px 0;
            padding: 20px;
            background: #f5f5f5;
            border: 1px solid #ddd;
        }

        .search-form {
            max-width: 600px;
            margin: 0 auto;
            padding: 30px;
            background: #f9f9f9;
            border: 1px solid #ddd;
        }

        .search-form h3 {
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }

        select, input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border: none;
            cursor: pointer;
            margin: 5px;
        }

        .btn:hover {
            background: #0056b3;
        }

        .btn-print {
            background: #28a745;
        }

        .btn-print:hover {
            background: #218838;
        }

        .error {
            background: #dc3545;
            color: white;
            padding: 15px;
            margin: 20px;
            text-align: center;
        }

        .no-items-message {
            text-align: center;
            padding: 20px;
            font-style: italic;
            color: #666;
        }

        @media print {
            body {
                font-size: 12px;
                margin: 0;
                padding: 0;
            }

            .no-print {
                display: none !important;
            }

            .container {
                margin: 0;
                padding: 0;
            }

            .bill-container {
                border: 1px solid #000;
                page-break-inside: avoid;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header no-print">
        <h1>📄 Print Bill</h1>
        <p>Professional Invoice Generation System</p>
    </div>

    <%
        String dbURL = "jdbc:mysql://localhost:3306/pahana_edu";
        String dbUser = "root";
        String dbPassword = "root";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String billId = request.getParameter("billId");
        String searchAction = request.getParameter("searchAction");

        if (billId == null || billId.trim().isEmpty()) {
    %>
    <div class="search-form no-print">
        <h3>🔍 Search Bill to Print</h3>
        <form method="get" action="printBill.jsp">
            <input type="hidden" name="searchAction" value="search">
            <div class="form-group">
                <label for="billSelect">Select Bill:</label>
                <select name="billId" id="billSelect" required>
                    <option value="">-- Select a Bill to Print --</option>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                            String billListSql = "SELECT b.bill_id, b.account_number, c.name, b.bill_date, b.total_amount " +
                                    "FROM bills b JOIN customers c ON b.account_number = c.account_number " +
                                    "ORDER BY b.bill_date DESC LIMIT 50";
                            pstmt = conn.prepareStatement(billListSql);
                            rs = pstmt.executeQuery();

                            while (rs.next()) {
                                int id = rs.getInt("bill_id");
                                String accountNum = rs.getString("account_number");
                                String customerName = rs.getString("name");
                                Timestamp billDate = rs.getTimestamp("bill_date");
                                double total = rs.getDouble("total_amount");

                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    %>
                    <option value="<%= id %>">
                        Bill #<%= id %> - <%= customerName %> (<%= accountNum %>) -
                        <%= sdf.format(billDate) %> - LKR <%= String.format("%.2f", total) %>
                    </option>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<option>Error loading bills: " + e.getMessage() + "</option>");
                        }
                    %>
                </select>
            </div>
            <button type="submit" class="btn btn-print">🖨️ Load Bill for Printing</button>
            <a href="dashboard.jsp" class="btn">🏠 Back to Dashboard</a>
        </form>
    </div>
    <%
    } else {
        // Display the selected bill
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Get bill and customer information
            String billSql = "SELECT b.*, c.name as customer_name, c.address, c.telephone " +
                    "FROM bills b JOIN customers c ON b.account_number = c.account_number " +
                    "WHERE b.bill_id = ?";
            pstmt = conn.prepareStatement(billSql);
            pstmt.setInt(1, Integer.parseInt(billId));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String accountNumber = rs.getString("account_number");
                String customerName = rs.getString("customer_name");
                String address = rs.getString("address");
                String telephone = rs.getString("telephone");
                Timestamp billDate = rs.getTimestamp("bill_date");
                double totalAmount = rs.getDouble("total_amount");

                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
    %>
    <div class="bill-container">
        <div class="company-header">
            <div class="company-name">PAHANA EDU</div>
            <div class="company-tagline">Leading Educational Bookshop</div>
            <div class="company-details">📍 Colombo City, Sri Lanka</div>
            <div class="company-details">📞 +94 11 234 5678 | ✉️ Theekshana@pahanaedu.lk</div>
        </div>

        <div class="bill-title">INVOICE</div>

        <div class="bill-info">
            <div class="customer-info">
                <div class="info-section-title">Bill To</div>
                <div class="info-row">
                    <span class="info-label">Customer:</span>
                    <span class="info-value"><%= customerName %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Account No:</span>
                    <span class="info-value"><%= accountNumber %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Address:</span>
                    <span class="info-value"><%= address != null ? address : "N/A" %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Phone:</span>
                    <span class="info-value"><%= telephone != null ? telephone : "N/A" %></span>
                </div>
            </div>
            <div class="bill-details">
                <div class="info-section-title">Invoice Details</div>
                <div class="info-row">
                    <span class="info-label">Invoice No:</span>
                    <span class="info-value">INV-<%= String.format("%06d", Integer.parseInt(billId)) %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Bill ID:</span>
                    <span class="info-value"># <%= billId %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Bill Date:</span>
                    <span class="info-value"><%= dateFormat.format(billDate) %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Bill Time:</span>
                    <span class="info-value"><%= timeFormat.format(billDate) %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Calculated:</span>
                    <span class="info-value"><%= new SimpleDateFormat("dd/MM/yyyy HH:mm").format(billDate) %></span>
                </div>
            </div>
        </div>

        <div class="items-section">
            <table class="items-table">
                <thead>
                <tr>
                    <th class="number-col">#</th>
                    <th>Item Description</th>
                    <th class="qty-col">Qty</th>
                    <th class="price-col">Unit Price</th>
                    <th class="total-col">Total</th>
                </tr>
                </thead>
                <tbody>
                <%
                    // Get bill items - only show items that were actually selected (quantity > 0)
                    String itemsSql = "SELECT bi.*, i.name as item_name, i.description " +
                            "FROM bill_items bi JOIN items i ON bi.item_id = i.item_id " +
                            "WHERE bi.bill_id = ? AND bi.quantity > 0 " +
                            "ORDER BY bi.bill_item_id";
                    PreparedStatement itemsStmt = conn.prepareStatement(itemsSql);
                    itemsStmt.setInt(1, Integer.parseInt(billId));
                    ResultSet itemsRs = itemsStmt.executeQuery();

                    int itemCount = 1;
                    double subtotal = 0.0;
                    boolean hasItems = false;

                    while (itemsRs.next()) {
                        hasItems = true;
                        String itemName = itemsRs.getString("item_name");
                        String description = itemsRs.getString("description");
                        int quantity = itemsRs.getInt("quantity");
                        double unitPrice = itemsRs.getDouble("unit_price");
                        double itemTotal = itemsRs.getDouble("total_price");
                        subtotal += itemTotal;
                %>
                <tr>
                    <td class="number-col"><%= itemCount++ %></td>
                    <td>
                        <div class="item-name"><%= itemName %></div>
                        <% if (description != null && !description.trim().isEmpty()) { %>
                        <div class="item-description"><%= description %></div>
                        <% } %>
                    </td>
                    <td class="qty-col"><%= quantity %></td>
                    <td class="price-col">LKR <%= String.format("%.2f", unitPrice) %></td>
                    <td class="total-col">LKR <%= String.format("%.2f", itemTotal) %></td>
                </tr>
                <%
                    }
                    itemsRs.close();
                    itemsStmt.close();

                    // Show message if no items found
                    if (!hasItems) {
                %>
                <tr>
                    <td colspan="5">
                        <div class="no-items-message">
                            📦 No items found for this bill.<br>
                            <small>Please check if the bill was properly calculated.</small>
                        </div>
                    </td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>

        <div class="total-section">
            <% if (hasItems) { %>
            <div class="total-calculations">
                <div class="total-row subtotal-row">
                    <span>Subtotal:</span>
                    <span>LKR <%= String.format("%.2f", subtotal) %></span>
                </div>
                <div class="total-row tax-row">
                    <span>Tax (0%):</span>
                    <span>LKR 0.00</span>
                </div>
                <div class="total-row grand-total">
                    <span>GRAND TOTAL:</span>
                    <span class="amount">LKR <%= String.format("%.2f", totalAmount) %></span>
                </div>
            </div>
            <% } else { %>
            <div class="no-items-message">
                No items to calculate total for this bill.
            </div>
            <% } %>
        </div>

        <div class="footer">
            <div class="footer-thanks">Thank you for your business! 🙏</div>
            <div class="footer-note">This is a computer-generated invoice and does not require a signature.</div>
            <div class="footer-note">For any queries, please contact us at +94 11 234 5678 or info@pahanaedu.lk</div>
            <div class="generation-info">
                Generated on: <%= new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()) %>
            </div>
        </div>
    </div>
    <%
    } else {
    %>
    <div class="error">
        ❌ Bill not found with ID: <%= billId %>
    </div>
    <%
        }
    } catch (Exception e) {
    %>
    <div class="error">
        ⚠️ Error loading bill: <%= e.getMessage() %>
    </div>
    <%
            }
        }
    %>

    <div class="no-print">
        <% if (billId != null && !billId.trim().isEmpty()) { %>
        <button onclick="window.print()" class="btn btn-print">🖨️ Print Bill</button>
        <a href="printBill.jsp" class="btn">🔍 Load Another Bill</a>
        <a href="calculate.jsp" class="btn">➕ New Bill</a>
        <% } %>
        <a href="dashboard.jsp" class="btn">🏠 Dashboard</a>
    </div>
</div>

<script>
    // Auto-focus on bill selection
    document.addEventListener('DOMContentLoaded', function() {
        var billSelect = document.getElementById('billSelect');
        if (billSelect) {
            billSelect.focus();
        }
    });

    // Keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Ctrl+P for print
        if (e.ctrlKey && e.key === 'p') {
            e.preventDefault();
            if (document.querySelector('.bill-container')) {
                window.print();
            }
        }
    });
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