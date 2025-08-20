package com.pahanaedu.dao;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;
import com.pahanaedu.util.DBConnection;

public class BillingDAO {

    // Create a new bill
    public int createBill(Bill bill) {
        String sql = "INSERT INTO bills (account_number, units, unit_price, total_amount) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, bill.getAccountNumber());
            pstmt.setInt(2, bill.getUnits());
            pstmt.setBigDecimal(3, bill.getUnitPrice());
            pstmt.setBigDecimal(4, bill.getTotalAmount());

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int billId = generatedKeys.getInt(1);
                        bill.setBillId(billId);
                        return billId;
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("Error creating bill: " + e.getMessage());
            e.printStackTrace();
        }

        return -1;
    }

    // Create bill with items
    public int createBillWithItems(Bill bill) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Create the main bill
            int billId = createBillInTransaction(conn, bill);
            if (billId <= 0) {
                conn.rollback();
                return -1;
            }

            // Add bill items
            if (bill.getBillItems() != null && !bill.getBillItems().isEmpty()) {
                for (BillItem item : bill.getBillItems()) {
                    item.setBillId(billId);
                    if (!addBillItemInTransaction(conn, item)) {
                        conn.rollback();
                        return -1;
                    }
                }
            }

            conn.commit();
            return billId;

        } catch (SQLException e) {
            System.err.println("Error creating bill with items: " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                System.err.println("Error rolling back transaction: " + ex.getMessage());
            }
            return -1;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }

    private int createBillInTransaction(Connection conn, Bill bill) throws SQLException {
        String sql = "INSERT INTO bills (account_number, units, unit_price, total_amount) VALUES (?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, bill.getAccountNumber());
            pstmt.setInt(2, bill.getUnits());
            pstmt.setBigDecimal(3, bill.getUnitPrice());
            pstmt.setBigDecimal(4, bill.getTotalAmount());

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int billId = generatedKeys.getInt(1);
                        bill.setBillId(billId);
                        return billId;
                    }
                }
            }
        }
        return -1;
    }

    private boolean addBillItemInTransaction(Connection conn, BillItem billItem) throws SQLException {
        String sql = "INSERT INTO bill_items (bill_id, item_id, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, billItem.getBillId());
            pstmt.setInt(2, billItem.getItemId());
            pstmt.setInt(3, billItem.getQuantity());
            pstmt.setBigDecimal(4, billItem.getUnitPrice());
            pstmt.setBigDecimal(5, billItem.getTotalPrice());

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        billItem.setBillItemId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        }
        return false;
    }

    // Get all bills
    public List<Bill> getAllBills() {
        List<Bill> bills = new ArrayList<>();
        String sql = """
            SELECT b.bill_id, b.account_number, b.bill_date, b.units, b.unit_price, b.total_amount,
                   c.name as customer_name, c.address as customer_address, c.telephone as customer_phone
            FROM bills b 
            LEFT JOIN customers c ON b.account_number = c.account_number 
            ORDER BY b.bill_date DESC
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Bill bill = extractBillFromResultSet(rs);
                bills.add(bill);
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving bills: " + e.getMessage());
            e.printStackTrace();
        }

        return bills;
    }

    // Get bill by ID
    public Bill getBillById(int billId) {
        String sql = """
            SELECT b.bill_id, b.account_number, b.bill_date, b.units, b.unit_price, b.total_amount,
                   c.name as customer_name, c.address as customer_address, c.telephone as customer_phone
            FROM bills b 
            LEFT JOIN customers c ON b.account_number = c.account_number 
            WHERE b.bill_id = ?
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, billId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Bill bill = extractBillFromResultSet(rs);
                    // Load bill items
                    bill.setBillItems(getBillItems(billId));
                    return bill;
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving bill by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // Get bills by customer account number
    public List<Bill> getBillsByAccountNumber(String accountNumber) {
        List<Bill> bills = new ArrayList<>();
        String sql = """
            SELECT b.bill_id, b.account_number, b.bill_date, b.units, b.unit_price, b.total_amount,
                   c.name as customer_name, c.address as customer_address, c.telephone as customer_phone
            FROM bills b 
            LEFT JOIN customers c ON b.account_number = c.account_number 
            WHERE b.account_number = ?
            ORDER BY b.bill_date DESC
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, accountNumber);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Bill bill = extractBillFromResultSet(rs);
                    bills.add(bill);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving bills by account number: " + e.getMessage());
            e.printStackTrace();
        }

        return bills;
    }

    // Get bill items for a specific bill
    public List<BillItem> getBillItems(int billId) {
        List<BillItem> billItems = new ArrayList<>();
        String sql = """
            SELECT bi.bill_item_id, bi.bill_id, bi.item_id, bi.quantity, bi.unit_price, bi.total_price,
                   i.name as item_name, i.description as item_description
            FROM bill_items bi
            LEFT JOIN items i ON bi.item_id = i.item_id
            WHERE bi.bill_id = ?
            ORDER BY bi.bill_item_id
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, billId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    BillItem billItem = new BillItem();
                    billItem.setBillItemId(rs.getInt("bill_item_id"));
                    billItem.setBillId(rs.getInt("bill_id"));
                    billItem.setItemId(rs.getInt("item_id"));
                    billItem.setItemName(rs.getString("item_name"));
                    billItem.setItemDescription(rs.getString("item_description"));
                    billItem.setQuantity(rs.getInt("quantity"));
                    billItem.setUnitPrice(rs.getBigDecimal("unit_price"));
                    billItem.setTotalPrice(rs.getBigDecimal("total_price"));

                    billItems.add(billItem);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving bill items: " + e.getMessage());
            e.printStackTrace();
        }

        return billItems;
    }

    // Delete a bill (and its items due to CASCADE)
    public boolean deleteBill(int billId) {
        String sql = "DELETE FROM bills WHERE bill_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, billId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting bill: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Get bills within date range
    public List<Bill> getBillsByDateRange(Date fromDate, Date toDate) {
        List<Bill> bills = new ArrayList<>();
        String sql = """
            SELECT b.bill_id, b.account_number, b.bill_date, b.units, b.unit_price, b.total_amount,
                   c.name as customer_name, c.address as customer_address, c.telephone as customer_phone
            FROM bills b 
            LEFT JOIN customers c ON b.account_number = c.account_number 
            WHERE DATE(b.bill_date) BETWEEN ? AND ?
            ORDER BY b.bill_date DESC
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDate(1, fromDate);
            pstmt.setDate(2, toDate);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Bill bill = extractBillFromResultSet(rs);
                    bills.add(bill);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving bills by date range: " + e.getMessage());
            e.printStackTrace();
        }

        return bills;
    }

    // Get total revenue
    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) as total_revenue FROM bills";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                return rs.getBigDecimal("total_revenue");
            }

        } catch (SQLException e) {
            System.err.println("Error calculating total revenue: " + e.getMessage());
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    private Bill extractBillFromResultSet(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setBillId(rs.getInt("bill_id"));
        bill.setAccountNumber(rs.getString("account_number"));
        bill.setBillDate(rs.getTimestamp("bill_date"));
        bill.setUnits(rs.getInt("units"));
        bill.setUnitPrice(rs.getBigDecimal("unit_price"));
        bill.setTotalAmount(rs.getBigDecimal("total_amount"));
        bill.setCustomerName(rs.getString("customer_name"));
        bill.setCustomerAddress(rs.getString("customer_address"));
        bill.setCustomerPhone(rs.getString("customer_phone"));
        return bill;
    }
}