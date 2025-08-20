package com.pahanaedu.controller;

import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.model.Item;
import java.util.List;

@WebServlet("/ItemServlet")
public class ItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ItemDAO itemDAO;

    public ItemServlet() {
        super();
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
                listItems(request, response);
            } else if (action.equals("add")) {
                showAddForm(request, response);
            } else if (action.equals("edit")) {
                showEditForm(request, response);
            } else if (action.equals("delete")) {
                deleteItem(request, response);
            } else {
                listItems(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("ViewItemList.jsp").forward(request, response);
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
            if (action != null && action.equals("add")) {
                addItem(request, response);
            } else if (action != null && action.equals("update")) {
                updateItem(request, response);
            } else {
                response.sendRedirect("ItemServlet?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing: " + e.getMessage());
            if (action != null && action.equals("add")) {
                request.getRequestDispatcher("AddNewItems.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("ViewItemList.jsp").forward(request, response);
            }
        }
    }

    private void addItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters from form
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");

            // Validate input
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Item name is required.");
                request.getRequestDispatcher("AddNewItems.jsp").forward(request, response);
                return;
            }

            if (priceStr == null || priceStr.trim().isEmpty()) {
                request.setAttribute("error", "Item price is required.");
                request.getRequestDispatcher("AddNewItems.jsp").forward(request, response);
                return;
            }

            BigDecimal price = null;
            int stock = 0;

            try {
                price = new BigDecimal(priceStr);
                if (price.compareTo(BigDecimal.ZERO) < 0) {
                    throw new NumberFormatException("Price cannot be negative");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid price format. Please enter a valid number.");
                request.getRequestDispatcher("AddNewItems.jsp").forward(request, response);
                return;
            }

            if (stockStr != null && !stockStr.trim().isEmpty()) {
                try {
                    stock = Integer.parseInt(stockStr);
                    if (stock < 0) {
                        throw new NumberFormatException("Stock cannot be negative");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid stock format. Please enter a valid number.");
                    request.getRequestDispatcher("AddNewItems.jsp").forward(request, response);
                    return;
                }
            }

            // Create item object
            Item item = new Item();
            item.setName(name.trim());
            item.setDescription(description != null ? description.trim() : "");
            item.setPrice(price);
            item.setStock(stock);

            // Add item to database
            boolean success = itemDAO.addItem(item);

            if (success) {
                request.setAttribute("success", "Item added successfully!");
                response.sendRedirect("ItemServlet?action=list&success=Item added successfully");
            } else {
                request.setAttribute("error", "Failed to add item. Please try again.");
                request.getRequestDispatcher("AddNewItems.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("AddNewItems.jsp").forward(request, response);
        }
    }

    private void updateItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String itemIdStr = request.getParameter("itemId");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");

            if (itemIdStr == null || itemIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Item ID is required.");
                response.sendRedirect("ItemServlet?action=list");
                return;
            }

            int itemId = Integer.parseInt(itemIdStr);
            BigDecimal price = new BigDecimal(priceStr);
            int stock = Integer.parseInt(stockStr);

            Item item = new Item();
            item.setItemId(itemId);
            item.setName(name.trim());
            item.setDescription(description != null ? description.trim() : "");
            item.setPrice(price);
            item.setStock(stock);

            boolean success = itemDAO.updateItem(item);

            if (success) {
                response.sendRedirect("ItemServlet?action=list&success=Item updated successfully");
            } else {
                request.setAttribute("error", "Failed to update item.");
                response.sendRedirect("ItemServlet?action=list");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating item: " + e.getMessage());
            response.sendRedirect("ItemServlet?action=list");
        }
    }

    private void deleteItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String itemIdStr = request.getParameter("itemId");
            if (itemIdStr != null && !itemIdStr.isEmpty()) {
                int itemId = Integer.parseInt(itemIdStr);
                boolean success = itemDAO.deleteItem(itemId);

                if (success) {
                    response.sendRedirect("ItemServlet?action=list&success=Item deleted successfully");
                } else {
                    response.sendRedirect("ItemServlet?action=list&error=Failed to delete item");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ItemServlet?action=list&error=Error deleting item");
        }
    }

    private void listItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Item> items = itemDAO.getAllItems();
            request.setAttribute("items", items);

            // Handle success/error messages from redirects
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null) request.setAttribute("success", success);
            if (error != null) request.setAttribute("error", error);

            request.getRequestDispatcher("ViewItemList.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading items: " + e.getMessage());
            request.getRequestDispatcher("ViewItemList.jsp").forward(request, response);
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("AddNewItems.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String itemIdStr = request.getParameter("itemId");
            if (itemIdStr != null && !itemIdStr.isEmpty()) {
                int itemId = Integer.parseInt(itemIdStr);
                Item item = itemDAO.getItemById(itemId);
                if (item != null) {
                    request.setAttribute("item", item);
                    request.getRequestDispatcher("UpdateItems.jsp").forward(request, response);
                } else {
                    response.sendRedirect("ItemServlet?action=list&error=Item not found");
                }
            } else {
                response.sendRedirect("ItemServlet?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ItemServlet?action=list&error=Error loading item");
        }
    }
}