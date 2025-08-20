<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Item - Pahana Edu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container {
            max-width: 800px;
            margin-top: 50px;
        }
        .card {
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .card-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
        }
        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
        }
        .btn-success:hover {
            background: linear-gradient(135deg, #20c997 0%, #28a745 100%);
        }
        .search-section {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body class="bg-light">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <!-- Search Section -->
            <div class="search-section">
                <h5><i class="fas fa-search me-2"></i>Search Item to Update</h5>
                <form action="ItemServlet" method="get" class="row g-3">
                    <input type="hidden" name="action" value="getForUpdate">
                    <div class="col-md-8">
                        <input type="text" class="form-control" name="itemId"
                               placeholder="Enter Item ID" value="${param.itemId}">
                    </div>
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-info w-100">
                            <i class="fas fa-search me-1"></i>Search Item
                        </button>
                    </div>
                </form>
            </div>

            <div class="card">
                <div class="card-header text-center">
                    <h3 class="mb-0">
                        <i class="fas fa-edit me-2"></i>Update Item Information
                    </h3>
                </div>
                <div class="card-body">
                    <!-- Display messages -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${not empty item}">
                            <!-- Update Form -->
                            <form action="ItemServlet" method="post" id="updateItemForm">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="itemId" value="${item.itemId}">

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="itemId" class="form-label">
                                                <i class="fas fa-id-badge me-1"></i>Item ID
                                            </label>
                                            <input type="text" class="form-control" id="itemId"
                                                   value="${item.itemId}" readonly>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="createdAt" class="form-label">
                                                <i class="fas fa-calendar me-1"></i>Created Date
                                            </label>
                                            <input type="text" class="form-control" id="createdAt"
                                                   value="${item.createdAt}" readonly>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="itemName" class="form-label">
                                                <i class="fas fa-book me-1"></i>Item Name <span class="text-danger">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="itemName" name="name"
                                                   value="${item.name}" required maxlength="150">
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="price" class="form-label">
                                                <i class="fas fa-tag me-1"></i>Price (Rs.) <span class="text-danger">*</span>
                                            </label>
                                            <input type="number" class="form-control" id="price" name="price"
                                                   value="${item.price}" step="0.01" min="0" required>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="stock" class="form-label">
                                                <i class="fas fa-boxes me-1"></i>Stock Quantity <span class="text-danger">*</span>
                                            </label>
                                            <input type="number" class="form-control" id="stock" name="stock"
                                                   value="${item.stock}" min="0" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">
                                                <i class="fas fa-info-circle me-1"></i>Stock Status
                                            </label>
                                            <div class="form-control-plaintext">
                                                <c:choose>
                                                    <c:when test="${item.stock > 10}">
                                                        <span class="badge bg-success">In Stock</span>
                                                    </c:when>
                                                    <c:when test="${item.stock > 0 && item.stock <= 10}">
                                                        <span class="badge bg-warning">Low Stock</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger">Out of Stock</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="description" class="form-label">
                                        <i class="fas fa-align-left me-1"></i>Description
                                    </label>
                                    <textarea class="form-control" id="description" name="description"
                                              rows="4" maxlength="1000">${item.description}</textarea>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <a href="dashboard.jsp" class="btn btn-secondary me-md-2">
                                        <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                                    </a>
                                    <a href="ViewItemList.jsp" class="btn btn-info me-md-2">
                                        <i class="fas fa-list me-1"></i>View Items
                                    </a>
                                    <button type="button" class="btn btn-danger me-md-2" onclick="confirmDelete()">
                                        <i class="fas fa-trash me-1"></i>Delete Item
                                    </button>
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-save me-1"></i>Update Item
                                    </button>
                                </div>
                            </form>

                            <!-- Hidden Delete Form -->
                            <form id="deleteForm" action="ItemServlet" method="post" style="display: none;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="itemId" value="${item.itemId}">
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-search fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">Search for an item to update</h5>
                                <p class="text-muted">Enter an Item ID in the search box above to load item details.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS and FontAwesome -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://kit.fontawesome.com/your-fontawesome-kit.js"></script>

<script>
    function confirmDelete() {
        if (confirm('Are you sure you want to delete this item? This action cannot be undone.')) {
            document.getElementById('deleteForm').submit();
        }
    }

    // Form validation
    document.getElementById('updateItemForm')?.addEventListener('submit', function(e) {
        const name = document.getElementById('itemName').value.trim();
        const price = parseFloat(document.getElementById('price').value);
        const stock = parseInt(document.getElementById('stock').value);

        if (!name) {
            alert('Item name is required!');
            e.preventDefault();
            return;
        }

        if (isNaN(price) || price < 0) {
            alert('Please enter a valid price!');
            e.preventDefault();
            return;
        }

        if (isNaN(stock) || stock < 0) {
            alert('Please enter a valid stock quantity!');
            e.preventDefault();
            return;
        }
    });

    // Auto-dismiss alerts
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);
</script>
</body>
</html>