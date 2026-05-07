package com.netbanking;

/**
 * Input validation logic — mirrors the original Validator.java.
 */
public class Validator {

    private static final int ACCOUNT_NUMBER_LENGTH = 10;
    private static final int MIN_PASSWORD_LENGTH   = 6;

    public static String validateAccountNumber(String accountNumber) {
        if (accountNumber == null || accountNumber.trim().isEmpty())
            return "Account number cannot be empty.";
        if (!accountNumber.matches("\\d+"))
            return "Account number must be numeric.";
        if (accountNumber.length() != ACCOUNT_NUMBER_LENGTH)
            return "Account number must be exactly " + ACCOUNT_NUMBER_LENGTH + " digits.";
        return null;
    }

    public static String validateUsername(String username) {
        if (username == null || username.trim().isEmpty())
            return "Username cannot be empty.";
        return null;
    }

    public static String validatePassword(String password) {
        if (password == null || password.trim().isEmpty())
            return "Password cannot be empty.";
        if (password.length() < MIN_PASSWORD_LENGTH)
            return "Password must be at least " + MIN_PASSWORD_LENGTH + " characters.";
        return null;
    }
}
