package com.pahanaedu.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.pahanaedu.dao.BillingDAO;
import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;
import com.pahanaedu.model.Customer;
import com.pahanaedu.model.Item;

@WebServlet("/BillingServlet")
public class BillingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BillingDAO billingDAO;
    private CustomerDAO customerDAO;
    private ItemDAO itemDAO;

    public BillingServlet() {
        super();
        this.billingDAO = new BillingDAO();
        this.customerDAO = new CustomerDAO();
        this.itemDAO = new ItemDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            if (action == null || action.equals("list")) {
                listBills(request, response);
            } else if (action.equals("create")) {
                showCreateForm(request, response);
            } else if (action.equals("view")) {
                viewBill(request, response);
            } else if (action.equals("print")) {
                printBill(request, response);
            } else if (action.equals("delete")) {
                deleteBill(request, response);
            } else if (action.equals("customer")) {
                getBillsByCustomer(request, response);
            } else {
                listBills(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("calculate.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            if (action != null && action.equals("create")) {
                createBill(request, response);
            } else if (action != null && action.equals("createWithItems")) {
                createBillWithItems(request, response);
            } else {
                response.sendRedirect("BillingServlet?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing: " + e.getMessage());
            request.getRequestDispatcher("calculate.jsp").forward(request, response);
        }
    }

    private void createBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters from form
            String accountNumber = request.getParameter("accountNumber");
            String unitsStr = request.getParameter("units");
            String unitPriceStr = request.getParameter("unitPrice");

            // Validate input
            if (accountNumber == null || accountNumber.trim().isEmpty()) {
                request.setAttribute("error", "Account number is required.");
                showCreateForm(request, response);
                return;
            }

            // Check if customer exists
            Customer customer = customerDAO.getCustomerByAccountNumber(accountNumber.trim());
            if (customer == null) {
                request.setAttribute("error", "Customer with account number " + accountNumber + " not found.");
                showCreateForm(request, response);
                return;
            }

            int units = 0;
            BigDecimal unitPrice = BigDecimal.ZERO;

            try {
                units = Integer.parseInt(unitsStr);
                if (units <= 0) {
                    throw new NumberFormatException("Units must be positive");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid units. Please enter a positive number.");
                showCreateForm(request, response);
                return;
            }

            try {
                unitPrice = new BigDecimal(unitPriceStr);
                if (unitPrice.compareTo(BigDecimal.ZERO) <= 0) {
                    throw new NumberFormatException("Unit price must be positive");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid unit price. Please enter a positive number.");
                showCreateForm(request, response);
                return;
            }

            // Calculate total amount
            BigDecimal totalAmount = unitPrice.multiply(BigDecimal.valueOf(units));

            // Create bill object
            Bill bill = new Bill();
            bill.setAccountNumber(accountNumber.trim());
            bill.setUnits(units);
            bill.setUnitPrice(unitPrice);
            bill.setTotalAmount(totalAmount);

            // Save bill to database
            int billId = billingDAO.createBill(bill);

            if (billId > 0) {
                response.sendRedirect("BillingServlet?action=view&billId=" + billId + "&success=Bill created successfully");
            } else {
                request.setAttribute("error", "Failed to create bill. Please try again.");
                showCreateForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    private void createBillWithItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String accountNumber = request.getParameter("accountNumber");
            String[] itemIds = request.getParameterValues("itemId");
            String[] quantities = request.getParameterValues("quantity");

            if (accountNumber == null || accountNumber.trim().isEmpty()) {
                request.setAttribute("error", "Account number is required.");
                showCreateForm(request, response);
                return;
            }

            // Check if customer exists
            Customer customer = customerDAO.getCustomerByAccountNumber(accountNumber.trim());
            if (customer == null) {
                request.setAttribute("error", "Customer not found.");
                showCreateForm(request, response);
                return;
            }

            if (itemIds == null || itemIds.length == 0) {
                request.setAttribute("error", "At least one item must be selected.");
                showCreateForm(request, response);
                return;
            }

            // Create bill
            Bill bill = new Bill();
            bill.setAccountNumber(accountNumber.trim());

            List<BillItem> billItems = new ArrayList<>();
            BigDecimal totalAmount = BigDecimal.ZERO;
            int totalUnits = 0;

            // Process each item
            for (int i = 0; i < itemIds.length; i++) {
                if (itemIds[i] != null && !itemIds[i].trim().isEmpty()) {
                    int itemId = Integer.parseInt(itemIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);

                    if (quantity > 0) {
                        Item item = itemDAO.getItemById(itemId);
                        if (item != null) {
                            BillItem billItem = new BillItem();
                            billItem.setItemId(itemId);
                            billItem.setItemName(item.getName());
                            billItem.setItemDescription(item.getDescription());
                            billItem.setQuantity(quantity);
                            billItem.setUnitPrice(item.getPrice());
                            billItem.calculateTotalPrice();

                            billItems.add(billItem);
                            totalAmount = totalAmount.add(billItem.getTotalPrice());
                            totalUnits += quantity;
                        }
                    }
                }
            }

            if (billItems.isEmpty()) {
                request.setAttribute("error", "No valid items selected.");
                showCreateForm(request, response);
                return;
            }

            bill.setBillItems(billItems);
            bill.setUnits(totalUnits);
            bill.setUnitPrice(totalAmount.divide(BigDecimal.valueOf(totalUnits), 2, BigDecimal.ROUND_HALF_UP));
            bill.setTotalAmount(totalAmount);

            // Save bill with items
            int billId = billingDAO.createBillWithItems(bill);

            if (billId > 0) {
                response.sendRedirect("BillingServlet?action=view&billId=" + billId + "&success=Bill created successfully");
            } else {
                request.setAttribute("error", "Failed to create bill with items.");
                showCreateForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error creating bill: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    private void listBills(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Bill> bills = billingDAO.getAllBills();
            request.setAttribute("bills", bills);

            // Handle success/error messages
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null) request.setAttribute("success", success);
            if (error != null) request.setAttribute("error", error);

            request.getRequestDispatcher("reports.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading bills: " + e.getMessage());
            request.getRequestDispatcher("reports.jsp").forward(request, response);
        }
    }

    private void viewBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String billIdStr = request.getParameter("billId");
            if (billIdStr != null && !billIdStr.isEmpty()) {
                int billId = Integer.parseInt(billIdStr);
                Bill bill = billingDAO.getBillById(billId);

                if (bill != null) {
                    request.setAttribute("bill", bill);

                    // Handle success message
                    String success = request.getParameter("success");
                    if (success != null) request.setAttribute("success", success);

                    request.getRequestDispatcher("printBill.jsp").forward(request, response);
                } else {
                    response.sendRedirect("BillingServlet?action=list&error=Bill not found");
                }
            } else {
                response.sendRedirect("BillingServlet?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("BillingServlet?action=list&error=Error loading bill");
        }
    }

    private void printBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String billIdStr = request.getParameter("billId");
            if (billIdStr != null && !billIdStr.isEmpty()) {
                int billId = Integer.parseInt(billIdStr);
                Bill bill = billingDAO.getBillById(billId);

                if (bill != null) {
                    request.setAttribute("bill", bill);
                    request.setAttribute("printMode", true);
                    request.getRequestDispatcher("printBill.jsp").forward(request, response);
                } else {
                    response.sendRedirect("BillingServlet?action=list&error=Bill not found");
                }
            } else {
                response.sendRedirect("BillingServlet?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("BillingServlet?action=list&error=Error loading bill for printing");
        }
    }

    private void deleteBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String billIdStr = request.getParameter("billId");
            if (billIdStr != null && !billIdStr.isEmpty()) {
                int billId = Integer.parseInt(billIdStr);
                boolean success = billingDAO.deleteBill(billId);

                if (success) {
                    response.sendRedirect("BillingServlet?action=list&success=Bill deleted successfully");
                } else {
                    response.sendRedirect("BillingServlet?action=list&error=Failed to delete bill");
                }
            } else {
                response.sendRedirect("BillingServlet?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("BillingServlet?action=list&error=Error deleting bill");
        }
    }

    private void getBillsByCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String accountNumber = request.getParameter("accountNumber");
            if (accountNumber != null && !accountNumber.trim().isEmpty()) {
                List<Bill> bills = billingDAO.getBillsByAccountNumber(accountNumber.trim());
                Customer customer = customerDAO.getCustomerByAccountNumber(accountNumber.trim());

                request.setAttribute("bills", bills);
                request.setAttribute("customer", customer);
                request.setAttribute("accountNumber", accountNumber.trim());

                request.getRequestDispatcher("reports.jsp").forward(request, response);
            } else {
                response.sendRedirect("BillingServlet?action=list&error=Account number is required");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("BillingServlet?action=list&error=Error loading customer bills");
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load customers and items for the form
            List<Customer> customers = customerDAO.getAllCustomers();
            List<Item> items = itemDAO.getAllItems();

            request.setAttribute("customers", customers);
            request.setAttribute("items", items);

            request.getRequestDispatcher("calculate.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading form dataaaaaaaaaaaaaaaaaaaaa: " + e.getMessage());
            request.getRequestDispatcher("calculate.jsp").forward(request, response);
        }
    }
}