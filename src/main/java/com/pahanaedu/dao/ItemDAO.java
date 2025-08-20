package com.pahanaedu.dao;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import com.pahanaedu.model.Item;
import com.pahanaedu.util.DBConnection;

public class ItemDAO {

    // Add a new item
    public boolean addItem(Item item) {
        String sql = "INSERT INTO items (name, description, price, stock) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, item.getName());
            pstmt.setString(2, item.getDescription());
            pstmt.setBigDecimal(3, item.getPrice());
            pstmt.setInt(4, item.getStock());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error adding item: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Get all items
    public List<Item> getAllItems() {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT item_id, name, description, price, stock, created_at FROM items ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setStock(rs.getInt("stock"));
                item.setCreatedAt(rs.getTimestamp("created_at"));

                items.add(item);
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving items: " + e.getMessage());
            e.printStackTrace();
        }

        return items;
    }

    // Get item by ID
    public Item getItemById(int itemId) {
        String sql = "SELECT item_id, name, description, price, stock, created_at FROM items WHERE item_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, itemId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Item item = new Item();
                    item.setItemId(rs.getInt("item_id"));
                    item.setName(rs.getString("name"));
                    item.setDescription(rs.getString("description"));
                    item.setPrice(rs.getBigDecimal("price"));
                    item.setStock(rs.getInt("stock"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));

                    return item;
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving item by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // Update an existing item
    public boolean updateItem(Item item) {
        String sql = "UPDATE items SET name = ?, description = ?, price = ?, stock = ? WHERE item_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, item.getName());
            pstmt.setString(2, item.getDescription());
            pstmt.setBigDecimal(3, item.getPrice());
            pstmt.setInt(4, item.getStock());
            pstmt.setInt(5, item.getItemId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating item: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Delete an item
    public boolean deleteItem(int itemId) {
        String sql = "DELETE FROM items WHERE item_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, itemId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting item: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Search items by name
    public List<Item> searchItemsByName(String searchTerm) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT item_id, name, description, price, stock, created_at FROM items WHERE name LIKE ? ORDER BY name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, "%" + searchTerm + "%");

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();
                    item.setItemId(rs.getInt("item_id"));
                    item.setName(rs.getString("name"));
                    item.setDescription(rs.getString("description"));
                    item.setPrice(rs.getBigDecimal("price"));
                    item.setStock(rs.getInt("stock"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));

                    items.add(item);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error searching items: " + e.getMessage());
            e.printStackTrace();
        }

        return items;
    }

    // Update item stock
    public boolean updateItemStock(int itemId, int newStock) {
        String sql = "UPDATE items SET stock = ? WHERE item_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, newStock);
            pstmt.setInt(2, itemId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating item stock: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Get items with low stock (stock <= threshold)
    public List<Item> getLowStockItems(int threshold) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT item_id, name, description, price, stock, created_at FROM items WHERE stock <= ? ORDER BY stock ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, threshold);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();
                    item.setItemId(rs.getInt("item_id"));
                    item.setName(rs.getString("name"));
                    item.setDescription(rs.getString("description"));
                    item.setPrice(rs.getBigDecimal("price"));
                    item.setStock(rs.getInt("stock"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));

                    items.add(item);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving low stock items: " + e.getMessage());
            e.printStackTrace();
        }

        return items;
    }
}