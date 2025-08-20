package com.pahanaedu.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Item {
    private int itemId;
    private String name;
    private String description;
    private BigDecimal price;
    private int stock;
    private Timestamp createdAt;

    // Default constructor
    public Item() {
    }

    // Constructor with parameters (double price)
    public Item(String name, String description, double price, int stock) {
        this.name = name;
        this.description = description;
        this.price = BigDecimal.valueOf(price);
        this.stock = stock;
    }

    // Constructor with parameters (BigDecimal price)
    public Item(String name, String description, BigDecimal price, int stock) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.stock = stock;
    }

    // Constructor with all parameters including ID (double price)
    public Item(int itemId, String name, String description, double price, int stock) {
        this.itemId = itemId;
        this.name = name;
        this.description = description;
        this.price = BigDecimal.valueOf(price);
        this.stock = stock;
    }

    // Constructor with all parameters including ID (BigDecimal price)
    public Item(int itemId, String name, String description, BigDecimal price, int stock) {
        this.itemId = itemId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stock = stock;
    }

    // Getters and Setters
    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    // Convenience method to set price from double
    public void setPrice(double price) {
        this.price = BigDecimal.valueOf(price);
    }

    // Convenience method to get price as double
    public double getPriceAsDouble() {
        return price != null ? price.doubleValue() : 0.0;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Helper method to format the creation date
    public String getFormattedCreatedAt() {
        if (createdAt != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            return sdf.format(createdAt);
        }
        return "";
    }

    // Helper method to format the creation date (date only)
    public String getFormattedCreatedDate() {
        if (createdAt != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            return sdf.format(createdAt);
        }
        return "";
    }

    // Helper method to format price with currency
    public String getFormattedPrice() {
        return String.format("LKR %.2f", getPriceAsDouble());
    }

    // Helper method to check if item is in stock
    public boolean isInStock() {
        return stock > 0;
    }

    // Helper method to check if stock is low (less than 5)
    public boolean isLowStock() {
        return stock < 5 && stock > 0;
    }

    // Helper method to check if item is out of stock
    public boolean isOutOfStock() {
        return stock == 0;
    }

    // Helper method to get stock status as string
    public String getStockStatus() {
        if (isOutOfStock()) {
            return "Out of Stock";
        } else if (isLowStock()) {
            return "Low Stock";
        } else {
            return "In Stock";
        }
    }

    // Helper method to get stock status CSS class
    public String getStockStatusClass() {
        if (isOutOfStock()) {
            return "text-danger";
        } else if (isLowStock()) {
            return "text-warning";
        } else {
            return "text-success";
        }
    }

    // toString method for debugging
    @Override
    public String toString() {
        return "Item{" +
                "itemId=" + itemId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", stock=" + stock +
                ", createdAt=" + createdAt +
                '}';
    }

    // equals method
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Item item = (Item) o;
        return itemId == item.itemId;
    }

    // hashCode method
    @Override
    public int hashCode() {
        return Integer.hashCode(itemId);
    }
}