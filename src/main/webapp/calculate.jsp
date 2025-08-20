<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pahanaedu.model.Customer" %>
<%@ page import="com.pahanaedu.model.Item" %>
<%@ page session="true" %>
<%
    // Check if user is logged in
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    List<Item> items = (List<Item>) request.getAttribute("items");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Calculate Bill - Pahana Edu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 900px;
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
        .bill-methods {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }
        .method-card {
            flex: 1;
            padding: 20px;
            border: 2px solid #ddd;
            border-radius: 5px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        .method-card:hover {
            border-color: #007bff;
            background-color: #f8f9fa;
        }
        .method-card.active {
            border-color: #007bff;
            background-color: #e3f2fd;
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
        input[type="text"], input[type="number"], select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .customer-info {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: none;
        }
        .items-section {
            display: none;
        }
        .item-row {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            align-items: center;
            padding: 10px;
            border: 1px solid #eee;
            border-radius: 5px;
        }
        .item-select {
            flex: 2;
        }
        .quantity-input {
            flex: 1;
        }
        .item-price {
            flex: 1;
            font-weight: bold;
            color: #28a745;
        }
        .remove-item {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 3px;
            cursor: pointer;
        }
        .add-item-btn {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            margin-bottom: 20px;
        }
        .bill-summary {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .total-row {
            font-weight: bold;
            font-size: 18px;
            border-top: 2px solid #007bff;
            padding-top: 10px;
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
        .required {
            color: red;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="navigation">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="BillingServlet?action=list">View Bills</a>
        <a href="CustomerServlet?action=list">Customers</a>
        <a href="ItemServlet?action=list">Items</a>
        <a href="logout">Logout</a>
    </div>

    <div class="header">
        <h2>Calculate & Create Bill</h2>
        <p>Choose billing method and create a new bill</p>
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

    <!-- Billing Method Selection -->
    <div class="bill-methods">
        <div class="method-card active" id="simple-method" onclick="selectMethod('simple')">
            <h4>Simple Billing</h4>
            <p>Bill based on units consumed</p>
        </div>
        <div class="method-card" id="item-method" onclick="selectMethod('items')">
            <h4>Item-based Billing</h4>
            <p>Bill based on purchased items</p>
        </div>
    </div>

    <!-- Customer Selection -->
    <div class="form-group">
        <label for="accountNumber">Select Customer <span class="required">*</span></label>
        <select id="accountNumber" name="accountNumber" onchange="loadCustomerInfo()" required>
            <option value="">-- Select Customer --</option>
            <% if (customers != null) {
                for (Customer customer : customers) { %>
            <option value="<%= customer.getAccountNumber() %>"
                    data-name="<%= customer.getName() %>"
                    data-address="<%= customer.getAddress() != null ? customer.getAddress() : "" %>"
                    data-phone="<%= customer.getTelephone() != null ? customer.getTelephone() : "" %>">
                <%= customer.getAccountNumber() %> - <%= customer.getName() %>
            </option>
            <% } } %>
        </select>
    </div>

    <!-- Customer Information Display -->
    <div class="customer-info" id="customer-info">
        <h4>Customer Information</h4>
        <div><strong>Name:</strong> <span id="customer-name"></span></div>
        <div><strong>Address:</strong> <span id="customer-address"></span></div>
        <div><strong>Phone:</strong> <span id="customer-phone"></span></div>
    </div>

    <!-- Simple Billing Form -->
    <form id="simple-form" method="post" action="BillingServlet">
        <input type="hidden" name="action" value="create">
        <input type="hidden" id="simple-account" name="accountNumber">

        <div class="form-group">
            <label for="units">Units Consumed <span class="required">*</span></label>
            <input type="number" id="units" name="units" min="1" required onchange="calculateSimpleTotal()">
        </div>

        <div class="form-group">
            <label for="unitPrice">Unit Price (LKR) <span class="required">*</span></label>
            <input type="number" id="unitPrice" name="unitPrice" step="0.01" min="0.01" required onchange="calculateSimpleTotal()">
        </div>

        <div class="bill-summary">
            <div class="summary-row total-row">
                <span>Total Amount:</span>
                <span id="simple-total">LKR 0.00</span>
            </div>
        </div>

        <div class="form-group" style="margin-top: 20px;">
            <button type="submit" class="btn">Create Bill</button>
            <button type="button" class="btn btn-secondary" onclick="resetForm()">Reset</button>
        </div>
    </form>

    <!-- Item-based Billing Form -->
    <form id="items-form" method="post" action="BillingServlet" style="display: none;">
        <input type="hidden" name="action" value="createWithItems">
        <input type="hidden" id="items-account" name="accountNumber">

        <div class="items-section" id="items-section">
            <h4>Select Items</h4>
            <button type="button" class="add-item-btn" onclick="addItemRow()">Add Item</button>

            <div id="item-rows">
                <!-- Item rows will be added dynamically -->
            </div>

            <div class="bill-summary">
                <div class="summary-row">
                    <span>Total Items:</span>
                    <span id="total-items">0</span>
                </div>
                <div class="summary-row">
                    <span>Total Quantity:</span>
                    <span id="total-quantity">0</span>
                </div>
                <div class="summary-row total-row">
                    <span>Total Amount:</span>
                    <span id="items-total">LKR 0.00</span>
                </div>
            </div>

            <div class="form-group" style="margin-top: 20px;">
                <button type="submit" class="btn">Create Bill</button>
                <button type="button" class="btn btn-secondary" onclick="resetForm()">Reset</button>
            </div>
        </div>
    </form>
</div>

<script>
    let currentMethod = 'simple';
    let itemRowCounter = 0;

    // Available items data
    const items = [
        <% if (items != null) {
            for (int i = 0; i < items.size(); i++) {
                Item item = items.get(i);
                if (i > 0) out.print(",");
        %>
        {
            id: <%= item.getItemId() %>,
            name: "<%= item.getName().replace("\"", "\\\"") %>",
            price: <%= item.getPriceAsDouble() %>,
            stock: <%= item.getStock() %>
        }
        <% } } %>
    ];

    function selectMethod(method) {
        currentMethod = method;

        // Update UI
        document.querySelectorAll('.method-card').forEach(card => card.classList.remove('active'));
        document.getElementById(method + '-method').classList.add('active');

        // Show/hide forms
        if (method === 'simple') {
            document.getElementById('simple-form').style.display = 'block';
            document.getElementById('items-form').style.display = 'none';
        } else {
            document.getElementById('simple-form').style.display = 'none';
            document.getElementById('items-form').style.display = 'block';
            document.getElementById('items-section').style.display = 'block';
        }
    }

    function loadCustomerInfo() {
        const select = document.getElementById('accountNumber');
        const selectedOption = select.options[select.selectedIndex];

        if (selectedOption.value) {
            // Show customer info
            document.getElementById('customer-info').style.display = 'block';
            document.getElementById('customer-name').textContent = selectedOption.dataset.name || '';
            document.getElementById('customer-address').textContent = selectedOption.dataset.address || '';
            document.getElementById('customer-phone').textContent = selectedOption.dataset.phone || '';

            // Update hidden fields
            document.getElementById('simple-account').value = selectedOption.value;
            document.getElementById('items-account').value = selectedOption.value;
        } else {
            document.getElementById('customer-info').style.display = 'none';
        }
    }

    function calculateSimpleTotal() {
        const units = parseFloat(document.getElementById('units').value) || 0;
        const unitPrice = parseFloat(document.getElementById('unitPrice').value) || 0;
        const total = units * unitPrice;

        document.getElementById('simple-total').textContent = 'LKR ' + total.toFixed(2);
    }

    function addItemRow() {
        itemRowCounter++;
        const itemsContainer = document.getElementById('item-rows');

        const itemRow = document.createElement('div');
        itemRow.className = 'item-row';
        itemRow.id = 'item-row-' + itemRowCounter;

        itemRow.innerHTML = `
                <div class="item-select">
                    <select name="itemId" onchange="updateItemPrice(${itemRowCounter})" required>
                        <option value="">-- Select Item --</option>
                        ${items.map(item =>
                            `<option value="${item.id}" data-price="${item.price}" data-stock="${item.stock}">
                                ${item.name} (Stock: ${item.stock})
                            </option>`
                        ).join('')}
                    </select>
                </div>
                <div class="quantity-input">
                    <input type="number" name="quantity" min="1" placeholder="Qty" onchange="calculateItemsTotal()" required>
                </div>
                <div class="item-price" id="price-${itemRowCounter}">LKR 0.00</div>
                <button type="button" class="remove-item" onclick="removeItemRow(${itemRowCounter})">Remove</button>
            `;

        itemsContainer.appendChild(itemRow);
    }

    function removeItemRow(rowId) {
        const row = document.getElementById('item-row-' + rowId);
        if (row) {
            row.remove();
            calculateItemsTotal();
        }
    }

    function updateItemPrice(rowId) {
        const row = document.getElementById('item-row-' + rowId);
        const select = row.querySelector('select[name="itemId"]');
        const priceDiv = document.getElementById('price-' + rowId);

        if (select.value) {
            const selectedOption = select.options[select.selectedIndex];
            const price = parseFloat(selectedOption.dataset.price) || 0;
            priceDiv.textContent = 'LKR ' + price.toFixed(2);
        } else {
            priceDiv.textContent = 'LKR 0.00';
        }

        calculateItemsTotal();
    }

    function calculateItemsTotal() {
        let totalAmount = 0;
        let totalQuantity = 0;
        let totalItems = 0;

        document.querySelectorAll('.item-row').forEach(row => {
            const select = row.querySelector('select[name="itemId"]');
            const quantityInput = row.querySelector('input[name="quantity"]');

            if (select.value && quantityInput.value) {
                const price = parseFloat(select.options[select.selectedIndex].dataset.price) || 0;
                const quantity = parseInt(quantityInput.value) || 0;

                totalAmount += price * quantity;
                totalQuantity += quantity;
                totalItems++;
            }
        });

        document.getElementById('total-items').textContent = totalItems;
        document.getElementById('total-quantity').textContent = totalQuantity;
        document.getElementById('items-total').textContent = 'LKR ' + totalAmount.toFixed(2);
    }

    function resetForm() {
        if (currentMethod === 'simple') {
            document.getElementById('simple-form').reset();
            document.getElementById('simple-total').textContent = 'LKR 0.00';
        } else {
            document.getElementById('items-form').reset();
            document.getElementById('item-rows').innerHTML = '';
            itemRowCounter = 0;
            calculateItemsTotal();
        }

        // Reset customer selection
        document.getElementById('accountNumber').value = '';
        document.getElementById('customer-info').style.display = 'none';
        document.getElementById('simple-account').value = '';
        document.getElementById('items-account').value = '';
    }

    // Initialize with one item row for item-based billing
    window.onload = function() {
        if (items.length > 0) {
            addItemRow();
        }
    };
</script>
</body>
</html>