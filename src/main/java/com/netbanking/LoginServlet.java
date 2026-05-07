package com.netbanking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Handles form POST from login.jsp.
 * Validates input, authenticates, manages attempts, sets session.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final int MAX_ATTEMPTS = 3;

    /** Seed users — in production replace with DAO + DB */
    private static final List<User> USERS = new ArrayList<>();
    static {
        USERS.add(new User("1234567890", "anu",   "123456",    50000.00));
        USERS.add(new User("9876543210", "rahul", "securePass", 120000.75));
        USERS.add(new User("1111111111", "priya", "priya@99",  75000.50));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // Redirect GET /login → login page
        res.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(true);

        // ── Track attempts in session ───────────────────────────────────
        Integer attempts = (Integer) session.getAttribute("loginAttempts");
        if (attempts == null) attempts = 0;

        if (attempts >= MAX_ATTEMPTS) {
            req.setAttribute("lockout", true);
            req.getRequestDispatcher("/login.jsp").forward(req, res);
            return;
        }

        // ── Read inputs ─────────────────────────────────────────────────
        String acc   = req.getParameter("accountNumber");
        String uname = req.getParameter("username");
        String pass  = req.getParameter("password");
        if (acc  != null) acc   = acc.trim();
        if (uname != null) uname = uname.trim();

        // ── Validate ────────────────────────────────────────────────────
        String accErr  = Validator.validateAccountNumber(acc);
        String userErr = Validator.validateUsername(uname);
        String passErr = Validator.validatePassword(pass);

        if (accErr != null || userErr != null || passErr != null) {
            attempts++;
            session.setAttribute("loginAttempts", attempts);
            req.setAttribute("error",   firstNonNull(accErr, userErr, passErr));
            req.setAttribute("attempts", MAX_ATTEMPTS - attempts);
            req.setAttribute("enteredAcc",   safe(acc));
            req.setAttribute("enteredUser",  safe(uname));
            req.getRequestDispatcher("/login.jsp").forward(req, res);
            return;
        }

        // ── Authenticate ────────────────────────────────────────────────
        User authenticated = null;
        for (User u : USERS) {
            if (u.getAccountNumber().equals(acc)
                    && u.getUsername().equals(uname)
                    && u.getPassword().equals(pass)) {
                authenticated = u;
                break;
            }
        }

        if (authenticated != null) {
            session.setAttribute("loginAttempts", 0);
            session.setAttribute("currentUser", authenticated);
            res.sendRedirect(req.getContextPath() + "/dashboard.jsp");
        } else {
            // Build helpful mismatch message
            String mismatch = "Account number not found.";
            for (User u : USERS) {
                if (u.getAccountNumber().equals(acc)) {
                    mismatch = !u.getUsername().equals(uname)
                            ? "Incorrect username."
                            : "Invalid password.";
                    break;
                }
            }
            attempts++;
            session.setAttribute("loginAttempts", attempts);
            int remaining = MAX_ATTEMPTS - attempts;
            req.setAttribute("error",    "Error: " + mismatch);
            req.setAttribute("attempts", remaining);
            req.setAttribute("lockout",  remaining <= 0);
            req.setAttribute("enteredAcc",  safe(acc));
            req.setAttribute("enteredUser", safe(uname));
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        }
    }

    private static String firstNonNull(String... strs) {
        for (String s : strs) if (s != null) return s;
        return null;
    }

    private static String safe(String s) { return s == null ? "" : s; }
}
