<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Print Bill - Pahana Edu</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .bill-container { max-width: 600px; margin: 0 auto; border: 2px solid #000; padding: 20px; }
        .header { text-align: center; border-bottom: 2px solid #000; padding-bottom: 15px; margin-bottom: 20px; }
        .company-name { font-size: 24px; font-weight: bold; color: #2E8B57; }
        .company-info { font-size: 12px; margin-top: 5px; }
        .bill-info { display: flex; justify-content: space-between; margin-bottom: 20px; }
        .customer-info { margin-bottom: 20px; }
        .customer-info h3 { margin-bottom: 10px; border-bottom: 1px solid #ddd; padding-bottom: 5px; }
        .items-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .items-table th, .items-table td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        .items-table th { background-color: #f2f2f2; font-weight: bold; }
        .total-section { border-top: 2px solid #000; padding-top: 10px; }
        .total-amount { font-size: 18px; font-weight: bold; text-align: right; }
        .footer { text-align: center; margin-top: 30px; font-size: 12px; border-top: 1px solid #ddd; padding-top: 15px; }
        .print-button { margin: 20px 0; text-align: center; }
        .print-button button { background-color: #4CAF50; color: white; padding: 10px 20px; border: none; cursor: pointer; }
        .no-print { display: block; }

        @media print {
            .no-print { display: none !important; }
            .bill-container { border: 1px solid #000; margin: 0; }
            body { margin: 0; }
        }
    </style>
</head>
<body>
<div class="bill-container">
    <div class="header">
        <div class="company-name">PAHANA EDU BOOKSHOP</div>
        <div class="company-info">
            Leading Bookshop in Colombo City<br>
            Phone: +94-11-1234567 | Email: info@pahanaedu.com
        </div>
    </div>

    <div class="bill-info">
        <div>
            <strong>Bill No:</strong> #${bill.billId}<br>
            <strong>Date:</strong> <fmt:formatDate value="${bill.billDate}" pattern="dd/MM/yyyy HH:mm"/>
        </div>
        <div style="text-align: right;">
            <strong>INVOICE</strong>
        </div>
    </div>

    <div class="customer-info">
        <h3>Customer Information</h3>
        <strong>Account No:</strong> ${customer.accountNumber}<br>
        <strong>Name:</strong> ${customer.name}<br>
        <strong>Address:</strong> ${customer.address}<br>
        <strong>Phone:</strong> ${customer.telephone}
    </div>

    <table class="items-table">
        <thead>
        <tr>
            <th>Item Description</th>
            <th style="text-align: center;">Quantity</th>
            <th style="text-align: right;">Unit Price (Rs.)</th>
            <th style="text-align: right;">Total (Rs.)</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="billItem" items="${bill.billItems}">
            <tr>
                <td>${billItem.itemName}</td>
                <td style="text-align: center;">${billItem.quantity}</td>
                <td style="text-align: right;">
                    <fmt:formatNumber value="${billItem.unitPrice}" pattern="#,##0.00"/>
                </td>
                <td style="text-align: right;">
                    <fmt:formatNumber value="${billItem.totalPrice}" pattern="#,##0.00"/>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <div class="total-section">
        <div class="total-amount">
            <strong>TOTAL AMOUNT: Rs. <fmt:formatNumber value="${bill.totalAmount}" pattern="#,##0.00"/></strong>
        </div>
    </div>

    <div class="footer">
        <p>Thank you for your business!</p>
        <p>Visit us again for all your educational book needs.</p>
        <hr style="margin: 15px 0;">
        <small>This is a computer-generated bill.</small>
    </div>
</div>

<div class="print-button no-print">
    <button onclick="window.print()">Print Bill</button>
    <button onclick="window.close()">Close</button>
</div>

<div class="no-print" style="text-align: center; margin-top: 20px;">
    <a href="billing">Create Another Bill</a> |
    <a href="billing?action=viewBills">View All Bills</a> |
    <a href="dashboard.jsp">Back to Dashboard</a>
</div>

<script>
    // Auto-focus for easy printing
    window.onload = function() {
        window.focus();
    };
</script>
</body>
</html>