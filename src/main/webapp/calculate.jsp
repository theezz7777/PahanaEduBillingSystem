<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.math.BigDecimal" %>
<%@ page import="com.pahanaedu.model.*, com.pahanaedu.dao.*, com.pahanaedu.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calculate Bill - Pahana Edu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .card-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .item-card { transition: all 0.3s ease; }
        .item-card:hover { transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .bill-summary { background: #f8f9fa; border: 1px solid #dee2e6; }
        .total-row { font-size: 1.2em; font-weight: bold; }
        .discount-badge { background: #28a745; }
        .error-msg { color: #dc3545; font-size: 0.875em; }
    </style>
</head>
<body class="bg-light">
<div class="container-fluid mt-4">
    <div class="row">
        <!-- Customer Selection & Items -->
        <div class="col-lg-8">
            <div class="card shadow">
                <div class="card-header">
                    <h4 class="mb-0"><i class="fas fa-calculator me-2"></i>Calculate Bill</h4>
                </div>
                <div class="card-body">
                    <!-- Customer Selection -->
                    <form id="billForm" method="post" action="">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label for="customerSelect" class="form-label">Select Customer</label>
                                <select id="customerSelect" name="accountNumber" class="form-select" required>
                                    <option value="">Choose a customer...</option>
                                    <%
                                        CustomerDAO customerDAO = new CustomerDAO();
                                        List<Customer> customers = customerDAO.getAllCustomers();
                                        for (Customer customer : customers) {
                                    %>
                                    <option value="<%= customer.getAccountNumber() %>"
                                            <% if (request.getParameter("accountNumber") != null &&
                                                    request.getParameter("accountNumber").equals(customer.getAccountNumber())) { %>
                                            selected
                                            <% } %>>
                                        <%= customer.getAccountNumber() %> - <%= customer.getName() %>
                                    </option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Bill Date</label>
                                <input type="date" class="form-control" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" readonly>
                            </div>
                        </div>

                        <!-- Available Items -->
                        <h5 class="mb-3">Available Items</h5>
                        <div class="row" id="itemsContainer">
                            <%
                                ItemDAO itemDAO = new ItemDAO();
                                List<Item> items = itemDAO.getAllItems();
                                for (Item item : items) {
                            %>
                            <div class="col-md-6 col-lg-4 mb-3">
                                <div class="card item-card h-100">
                                    <div class="card-body">
                                        <h6 class="card-title"><%= item.getName() %></h6>
                                        <p class="card-text text-muted small"><%= item.getDescription() %></p>
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span class="text-success fw-bold">Rs. <%= String.format("%.2f", item.getPrice()) %></span>
                                            <small class="text-muted">Stock: <%= item.getStock() %></small>
                                        </div>
                                        <div class="input-group input-group-sm">
                                            <span class="input-group-text">Qty</span>
                                            <input type="number"
                                                   class="form-control quantity-input"
                                                   name="quantity_<%= item.getItemId() %>"
                                                   min="0"
                                                   max="<%= item.getStock() %>"
                                                   value="0"
                                                   data-item-id="<%= item.getItemId() %>"
                                                   data-price="<%= item.getPrice() %>"
                                                   data-name="<%= item.getName() %>"
                                                   data-stock="<%= item.getStock() %>"
                                                   onchange="updateBill()">
                                            <button type="button" class="btn btn-outline-primary btn-sm" onclick="addToCart(<%= item.getItemId() %>)">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </div>
                                        <div class="error-msg" id="error_<%= item.getItemId() %>"></div>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Bill Summary -->
        <div class="col-lg-4">
            <div class="card shadow">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-receipt me-2"></i>Bill Summary</h5>
                </div>
                <div class="card-body">
                    <div id="billItems">
                        <p class="text-muted text-center">No items selected</p>
                    </div>

                    <hr>

                    <div class="bill-summary p-3 rounded">
                        <div class="row">
                            <div class="col">Subtotal:</div>
                            <div class="col text-end" id="subtotal">Rs. 0.00</div>
                        </div>
                        <div class="row">
                            <div class="col">
                                Discount:
                                <span class="badge discount-badge" id="discountBadge">0%</span>
                            </div>
                            <div class="col text-end" id="discount">Rs. 0.00</div>
                        </div>
                        <div class="row">
                            <div class="col">Tax (15%):</div>
                            <div class="col text-end" id="tax">Rs. 0.00</div>
                        </div>
                        <hr>
                        <div class="row total-row text-primary">
                            <div class="col">Total:</div>
                            <div class="col text-end" id="finalTotal">Rs. 0.00</div>
                        </div>
                    </div>

                    <div class="d-grid gap-2 mt-3">
                        <button type="button" class="btn btn-primary" onclick="generateBill()" id="generateBillBtn" disabled>
                            <i class="fas fa-file-invoice me-2"></i>Generate Bill
                        </button>
                        <button type="button" class="btn btn-outline-secondary" onclick="clearBill()">
                            <i class="fas fa-trash me-2"></i>Clear All
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let billItems = [];

    function addToCart(itemId) {
        const quantityInput = document.querySelector(`input[data-item-id="${itemId}"]`);
        const currentQty = parseInt(quantityInput.value) || 0;
        const maxStock = parseInt(quantityInput.getAttribute('max'));

        if (currentQty < maxStock) {
            quantityInput.value = currentQty + 1;
            updateBill();
        }
    }

    function updateBill() {
        billItems = [];
        const quantityInputs = document.querySelectorAll('.quantity-input');
        const billItemsContainer = document.getElementById('billItems');
        let billItemsHtml = '';

        quantityInputs.forEach(input => {
            const quantity = parseInt(input.value) || 0;
            const itemId = input.getAttribute('data-item-id');
            const price = parseFloat(input.getAttribute('data-price'));
            const name = input.getAttribute('data-name');
            const stock = parseInt(input.getAttribute('data-stock'));
            const errorDiv = document.getElementById(`error_${itemId}`);

            // Clear previous error
            errorDiv.textContent = '';

            // Validate stock
            if (quantity > stock) {
                errorDiv.textContent = `Only ${stock} items available`;
                input.value = stock;
                return;
            }

            if (quantity > 0) {
                const total = quantity * price;
                billItems.push({
                    itemId: itemId,
                    name: name,
                    quantity: quantity,
                    unitPrice: price,
                    totalPrice: total
                });

                billItemsHtml += `
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div>
                                <small class="fw-bold">${name}</small><br>
                                <small class="text-muted">${quantity} × Rs. ${price.toFixed(2)}</small>
                            </div>
                            <div class="text-end">
                                <strong>Rs. ${total.toFixed(2)}</strong>
                            </div>
                        </div>
                    `;
            }
        });

        if (billItemsHtml === '') {
            billItemsHtml = '<p class="text-muted text-center">No items selected</p>';
        }

        billItemsContainer.innerHTML = billItemsHtml;
        calculateTotals();
    }

    function calculateTotals() {
        let subtotal = 0;

        billItems.forEach(item => {
            subtotal += item.totalPrice;
        });

        // Calculate discount
        let discountRate = 0;
        let discountPercent = '0%';
        if (subtotal >= 10000) {
            discountRate = 0.10;
            discountPercent = '10%';
        } else if (subtotal >= 5000) {
            discountRate = 0.05;
            discountPercent = '5%';
        }

        const discount = subtotal * discountRate;
        const taxableAmount = subtotal - discount;
        const tax = taxableAmount * 0.15;
        const finalTotal = taxableAmount + tax;

        // Update display
        document.getElementById('subtotal').textContent = `Rs. ${subtotal.toFixed(2)}`;
        document.getElementById('discount').textContent = `Rs. ${discount.toFixed(2)}`;
        document.getElementById('tax').textContent = `Rs. ${tax.toFixed(2)}`;
        document.getElementById('finalTotal').textContent = `Rs. ${finalTotal.toFixed(2)}`;
        document.getElementById('discountBadge').textContent = discountPercent;

        // Enable/disable generate bill button
        const generateBtn = document.getElementById('generateBillBtn');
        const customerSelect = document.getElementById('customerSelect');
        generateBtn.disabled = billItems.length === 0 || !customerSelect.value;
    }

    function clearBill() {
        document.querySelectorAll('.quantity-input').forEach(input => {
            input.value = 0;
        });
        document.querySelectorAll('.error-msg').forEach(div => {
            div.textContent = '';
        });
        billItems = [];
        updateBill();
    }

    function generateBill() {
        const customerSelect = document.getElementById('customerSelect');
        if (!customerSelect.value) {
            alert('Please select a customer');
            return;
        }

        if (billItems.length === 0) {
            alert('Please select at least one item');
            return;
        }

        // Prepare data for bill generation
        const billData = {
            accountNumber: customerSelect.value,
            items: billItems
        };

        // Send to servlet for processing
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'BillingServlet';

        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'generateBill';
        form.appendChild(actionInput);

        const dataInput = document.createElement('input');
        dataInput.type = 'hidden';
        dataInput.name = 'billData';
        dataInput.value = JSON.stringify(billData);
        form.appendChild(dataInput);

        document.body.appendChild(form);
        form.submit();
    }

    // Update bill when customer changes
    document.getElementById('customerSelect').addEventListener('change', function() {
        calculateTotals();
    });

    // Initialize
    updateBill();
</script>
</body>
</html>