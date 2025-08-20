package com.pahanaedu.controller;

import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.model.Customer;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/customer/*")
public class CustomerServlet extends HttpServlet {
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String action = (pathInfo == null) ? "list" : pathInfo.substring(1);

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "view":
                viewCustomer(request, response);
                break;
            case "list":
            default:
                listCustomers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String action = (pathInfo == null) ? "" : pathInfo.substring(1);

        switch (action) {
            case "add":
                addCustomer(request, response);
                break;
            case "edit":
                updateCustomer(request, response);
                break;
            case "delete":
                deleteCustomer(request, response);
                break;
            default:
                listCustomers(request, response);
                break;
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/AddNewCustomer.jsp").forward(request, response);
    }

    private void addCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accountNumber = request.getParameter("accountNumber");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");
        String unitsStr = request.getParameter("unitsConsumed");

        try {
            // Validation
            if (accountNumber == null || accountNumber.trim().isEmpty()) {
                request.setAttribute("error", "Account number is required");
                request.getRequestDispatcher("/AddNewCustomer.jsp").forward(request, response);
                return;
            }

            if (customerDAO.customerExists(accountNumber)) {
                request.setAttribute("error", "Customer with account number " + accountNumber + " already exists");
                request.getRequestDispatcher("/AddNewCustomer.jsp").forward(request, response);
                return;
            }

            int unitsConsumed = 0;
            if (unitsStr != null && !unitsStr.trim().isEmpty()) {
                unitsConsumed = Integer.parseInt(unitsStr);
            }

            Customer customer = new Customer(accountNumber, name, address, telephone, unitsConsumed);

            if (customerDAO.addCustomer(customer)) {
                request.setAttribute("success", "Customer added successfully!");
                response.sendRedirect(request.getContextPath() + "/customer/list");
                return;
            } else {
                request.setAttribute("error", "Failed to add customer");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Units consumed must be a valid number");
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }

        request.getRequestDispatcher("/AddNewCustomer.jsp").forward(request, response);
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Customer> customers = customerDAO.getAllCustomers();
        request.setAttribute("customers", customers);
        request.getRequestDispatcher("/ViewCustomerDetails.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accountNumber = request.getParameter("accountNumber");

        if (accountNumber != null) {
            Customer customer = customerDAO.getCustomer(accountNumber);
            if (customer != null) {
                request.setAttribute("customer", customer);
                request.getRequestDispatcher("/EditCustomerInfo.jsp").forward(request, response);
                return;
            }
        }

        request.setAttribute("error", "Customer not found");
        listCustomers(request, response);
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accountNumber = request.getParameter("accountNumber");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");
        String unitsStr = request.getParameter("unitsConsumed");

        try {
            int unitsConsumed = 0;
            if (unitsStr != null && !unitsStr.trim().isEmpty()) {
                unitsConsumed = Integer.parseInt(unitsStr);
            }

            Customer customer = new Customer(accountNumber, name, address, telephone, unitsConsumed);

            if (customerDAO.updateCustomer(customer)) {
                request.setAttribute("success", "Customer updated successfully!");
                response.sendRedirect(request.getContextPath() + "/customer/list");
                return;
            } else {
                request.setAttribute("error", "Failed to update customer");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Units consumed must be a valid number");
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }

        Customer customer = customerDAO.getCustomer(accountNumber);
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/EditCustomerInfo.jsp").forward(request, response);
    }

    private void viewCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accountNumber = request.getParameter("accountNumber");

        if (accountNumber != null) {
            Customer customer = customerDAO.getCustomer(accountNumber);
            if (customer != null) {
                request.setAttribute("customer", customer);
                request.getRequestDispatcher("/ViewCustomerDetails.jsp").forward(request, response);
                return;
            }
        }

        request.setAttribute("error", "Customer not found");
        listCustomers(request, response);
    }

    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accountNumber = request.getParameter("accountNumber");

        if (accountNumber != null && customerDAO.deleteCustomer(accountNumber)) {
            request.setAttribute("success", "Customer deleted successfully!");
        } else {
            request.setAttribute("error", "Failed to delete customer");
        }

        listCustomers(request, response);
    }
}