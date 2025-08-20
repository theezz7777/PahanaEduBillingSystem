package com.pahanaedu.util;

import java.util.regex.Pattern;

public class Validator {

    // Phone number pattern for Sri Lankan numbers
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(\\+94|0)?[1-9][0-9]{8}$");

    // Email pattern
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    // Account number pattern (alphanumeric, 3-20 characters)
    private static final Pattern ACCOUNT_PATTERN = Pattern.compile("^[A-Za-z0-9]{3,20}$");

    /**
     * Check if string is not null and not empty
     */
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    /**
     * Validate account number format
     */
    public static boolean isValidAccountNumber(String accountNumber) {
        return isNotEmpty(accountNumber) && ACCOUNT_PATTERN.matcher(accountNumber).matches();
    }

    /**
     * Validate phone number (Sri Lankan format)
     */
    public static boolean isValidPhoneNumber(String phone) {
        return isNotEmpty(phone) && PHONE_PATTERN.matcher(phone).matches();
    }

    /**
     * Validate email format
     */
    public static boolean isValidEmail(String email) {
        return isNotEmpty(email) && EMAIL_PATTERN.matcher(email).matches();
    }

    /**
     * Validate name (only letters and spaces, 2-100 characters)
     */
    public static boolean isValidName(String name) {
        return isNotEmpty(name) &&
                name.length() >= 2 &&
                name.length() <= 100 &&
                name.matches("^[A-Za-z\\s]+$");
    }

    /**
     * Validate positive integer
     */
    public static boolean isValidPositiveInteger(String str) {
        if (!isNotEmpty(str)) return false;
        try {
            int value = Integer.parseInt(str);
            return value > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Validate positive decimal number
     */
    public static boolean isValidPositiveDecimal(String str) {
        if (!isNotEmpty(str)) return false;
        try {
            double value = Double.parseDouble(str);
            return value > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Validate username (alphanumeric and underscore, 3-50 characters)
     */
    public static boolean isValidUsername(String username) {
        return isNotEmpty(username) &&
                username.length() >= 3 &&
                username.length() <= 50 &&
                username.matches("^[A-Za-z0-9_]+$");
    }

    /**
     * Validate password (at least 6 characters)
     */
    public static boolean isValidPassword(String password) {
        return isNotEmpty(password) && password.length() >= 6;
    }

    /**
     * Validate address (2-255 characters)
     */
    public static boolean isValidAddress(String address) {
        return isNotEmpty(address) &&
                address.length() >= 2 &&
                address.length() <= 255;
    }

    /**
     * Validate item name (2-150 characters)
     */
    public static boolean isValidItemName(String itemName) {
        return isNotEmpty(itemName) &&
                itemName.length() >= 2 &&
                itemName.length() <= 150;
    }

    /**
     * Validate stock quantity (non-negative integer)
     */
    public static boolean isValidStock(String str) {
        if (!isNotEmpty(str)) return false;
        try {
            int value = Integer.parseInt(str);
            return value >= 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}