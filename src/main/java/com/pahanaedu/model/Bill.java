package com.pahanaedu.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.ArrayList;

public class Bill {
    private int billId;
    private String accountNumber;
    private Timestamp billDate;
    private int units;
    private BigDecimal unitPrice;
    private BigDecimal totalAmount;
    private String customerName;
    private String customerAddress;
    private String customerPhone;
    private List<BillItem> billItems;

    // Default constructor
    public Bill() {
        this.billItems = new ArrayList<>();
        this.billDate = new Timestamp(System.currentTimeMillis());
    }

    // Constructor with basic parameters
    public Bill(String accountNumber, int units, BigDecimal unitPrice, BigDecimal totalAmount) {
        this();
        this.accountNumber = accountNumber;
        this.units = units;
        this.unitPrice = unitPrice;
        this.totalAmount = totalAmount;
    }

    // Constructor with all parameters
    public Bill(int billId, String accountNumber, Timestamp billDate, int units,
                BigDecimal unitPrice, BigDecimal totalAmount) {
        this();
        this.billId = billId;
        this.accountNumber = accountNumber;
        this.billDate = billDate;
        this.units = units;
        this.unitPrice = unitPrice;
        this.totalAmount = totalAmount;
    }

    // Getters and Setters
    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public Timestamp getBillDate() {
        return billDate;
    }

    public void setBillDate(Timestamp billDate) {
        this.billDate = billDate;
    }

    public int getUnits() {
        return units;
    }

    public void setUnits(int units) {
        this.units = units;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    // Convenience method for double unit price
    public void setUnitPrice(double unitPrice) {
        this.unitPrice = BigDecimal.valueOf(unitPrice);
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    // Convenience method for double total amount
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = BigDecimal.valueOf(totalAmount);
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerAddress() {
        return customerAddress;
    }

    public void setCustomerAddress(String customerAddress) {
        this.customerAddress = customerAddress;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public List<BillItem> getBillItems() {
        return billItems;
    }

    public void setBillItems(List<BillItem> billItems) {
        this.billItems = billItems != null ? billItems : new ArrayList<>();
    }

    // Helper methods
    public String getFormattedBillDate() {
        if (billDate != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            return sdf.format(billDate);
        }
        return "";
    }

    public String getFormattedBillDateOnly() {
        if (billDate != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            return sdf.format(billDate);
        }
        return "";
    }

    public String getFormattedUnitPrice() {
        return unitPrice != null ? String.format("LKR %.2f", unitPrice.doubleValue()) : "LKR 0.00";
    }

    public String getFormattedTotalAmount() {
        return totalAmount != null ? String.format("LKR %.2f", totalAmount.doubleValue()) : "LKR 0.00";
    }

    public double getUnitPriceAsDouble() {
        return unitPrice != null ? unitPrice.doubleValue() : 0.0;
    }

    public double getTotalAmountAsDouble() {
        return totalAmount != null ? totalAmount.doubleValue() : 0.0;
    }

    // Calculate total from bill items
    public BigDecimal calculateTotalFromItems() {
        BigDecimal total = BigDecimal.ZERO;
        if (billItems != null) {
            for (BillItem item : billItems) {
                if (item.getTotalPrice() != null) {
                    total = total.add(item.getTotalPrice());
                }
            }
        }
        return total;
    }

    // Add bill item
    public void addBillItem(BillItem billItem) {
        if (billItems == null) {
            billItems = new ArrayList<>();
        }
        billItems.add(billItem);
    }

    // Remove bill item
    public boolean removeBillItem(int itemId) {
        if (billItems != null) {
            return billItems.removeIf(item -> item.getItemId() == itemId);
        }
        return false;
    }

    // Get total quantity of items
    public int getTotalItemQuantity() {
        int total = 0;
        if (billItems != null) {
            for (BillItem item : billItems) {
                total += item.getQuantity();
            }
        }
        return total;
    }

    // Get number of different items
    public int getItemCount() {
        return billItems != null ? billItems.size() : 0;
    }

    @Override
    public String toString() {
        return "Bill{" +
                "billId=" + billId +
                ", accountNumber='" + accountNumber + '\'' +
                ", billDate=" + billDate +
                ", units=" + units +
                ", unitPrice=" + unitPrice +
                ", totalAmount=" + totalAmount +
                ", customerName='" + customerName + '\'' +
                ", itemCount=" + getItemCount() +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Bill bill = (Bill) o;
        return billId == bill.billId;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(billId);
    }
}