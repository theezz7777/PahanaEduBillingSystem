package com.pahanaedu.model;

import java.math.BigDecimal;

public class BillItem {
    private int billItemId;
    private int billId;
    private int itemId;
    private String itemName;
    private String itemDescription;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal totalPrice;

    // Default constructor
    public BillItem() {
    }

    // Constructor with basic parameters
    public BillItem(int billId, int itemId, int quantity, BigDecimal unitPrice, BigDecimal totalPrice) {
        this.billId = billId;
        this.itemId = itemId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
    }

    // Constructor with all parameters
    public BillItem(int billItemId, int billId, int itemId, int quantity,
                    BigDecimal unitPrice, BigDecimal totalPrice) {
        this.billItemId = billItemId;
        this.billId = billId;
        this.itemId = itemId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
    }

    // Constructor with item details
    public BillItem(int billId, int itemId, String itemName, String itemDescription,
                    int quantity, BigDecimal unitPrice, BigDecimal totalPrice) {
        this.billId = billId;
        this.itemId = itemId;
        this.itemName = itemName;
        this.itemDescription = itemDescription;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
    }

    // Getters and Setters
    public int getBillItemId() {
        return billItemId;
    }

    public void setBillItemId(int billItemId) {
        this.billItemId = billItemId;
    }

    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getItemDescription() {
        return itemDescription;
    }

    public void setItemDescription(String itemDescription) {
        this.itemDescription = itemDescription;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        // Recalculate total price when quantity changes
        if (unitPrice != null) {
            this.totalPrice = unitPrice.multiply(BigDecimal.valueOf(quantity));
        }
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
        // Recalculate total price when unit price changes
        if (quantity > 0) {
            this.totalPrice = unitPrice.multiply(BigDecimal.valueOf(quantity));
        }
    }

    // Convenience method for double unit price
    public void setUnitPrice(double unitPrice) {
        this.setUnitPrice(BigDecimal.valueOf(unitPrice));
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    // Convenience method for double total price
    public void setTotalPrice(double totalPrice) {
        this.totalPrice = BigDecimal.valueOf(totalPrice);
    }

    // Helper methods
    public double getUnitPriceAsDouble() {
        return unitPrice != null ? unitPrice.doubleValue() : 0.0;
    }

    public double getTotalPriceAsDouble() {
        return totalPrice != null ? totalPrice.doubleValue() : 0.0;
    }

    public String getFormattedUnitPrice() {
        return unitPrice != null ? String.format("LKR %.2f", unitPrice.doubleValue()) : "LKR 0.00";
    }

    public String getFormattedTotalPrice() {
        return totalPrice != null ? String.format("LKR %.2f", totalPrice.doubleValue()) : "LKR 0.00";
    }

    // Calculate total price based on quantity and unit price
    public void calculateTotalPrice() {
        if (unitPrice != null && quantity > 0) {
            this.totalPrice = unitPrice.multiply(BigDecimal.valueOf(quantity));
        } else {
            this.totalPrice = BigDecimal.ZERO;
        }
    }

    // Validate the bill item
    public boolean isValid() {
        return itemId > 0 && quantity > 0 && unitPrice != null &&
                unitPrice.compareTo(BigDecimal.ZERO) >= 0;
    }

    // Get item display name (use itemName if available, otherwise use itemId)
    public String getDisplayName() {
        return itemName != null && !itemName.trim().isEmpty() ?
                itemName : "Item #" + itemId;
    }

    @Override
    public String toString() {
        return "BillItem{" +
                "billItemId=" + billItemId +
                ", billId=" + billId +
                ", itemId=" + itemId +
                ", itemName='" + itemName + '\'' +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", totalPrice=" + totalPrice +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        BillItem billItem = (BillItem) o;
        return billItemId == billItem.billItemId;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(billItemId);
    }
}