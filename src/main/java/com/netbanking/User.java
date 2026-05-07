package com.netbanking;

import java.io.Serializable;

/**
 * Represents a bank user — stored in session after login.
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private String accountNumber;
    private String username;
    private String password;
    private double balance;

    public User(String accountNumber, String username, String password, double balance) {
        this.accountNumber = accountNumber;
        this.username      = username;
        this.password      = password;
        this.balance       = balance;
    }

    public String getAccountNumber() { return accountNumber; }
    public String getUsername()      { return username; }
    public String getPassword()      { return password; }
    public double getBalance()       { return balance; }
}
