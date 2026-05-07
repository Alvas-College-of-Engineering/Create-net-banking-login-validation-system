<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // If already logged in, go to dashboard
    HttpSession s = request.getSession(false);
    if (s != null && s.getAttribute("currentUser") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }

    boolean lockout  = Boolean.TRUE.equals(request.getAttribute("lockout"));
    String  error    = (String)  request.getAttribute("error");
    Integer attLeft  = (Integer) request.getAttribute("attempts");
    int     remaining = (attLeft != null) ? attLeft : 3;

    String enteredAcc  = (String) request.getAttribute("enteredAcc");
    String enteredUser = (String) request.getAttribute("enteredUser");
    if (enteredAcc  == null) enteredAcc  = "";
    if (enteredUser == null) enteredUser = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>BharatBank – Internet Banking Login</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<header class="bank-header">
  <span class="bank-logo">&#x2297; BHARATBANK</span>
  <span class="bank-tagline">INTERNET BANKING &middot; SECURE ACCESS</span>
</header>

<main class="page-wrap">
  <div class="login-card">

    <div class="login-card-header">
      <h2>Customer Login</h2>
      <p>Please enter your credentials to continue</p>
    </div>

    <div class="login-card-body">

      <%-- Attempt dots --%>
      <div class="attempts-bar">
        <span class="attempt-dot <%= remaining < 3 ? "used" : "" %>"></span>
        <span class="attempt-dot <%= remaining < 2 ? "used" : "" %>"></span>
        <span class="attempt-dot <%= remaining < 1 ? "used" : "" %>"></span>
        <span class="attempts-label">
          <% if (!lockout) { %>
            <%= remaining %> attempt<%= remaining == 1 ? "" : "s" %> remaining
          <% } else { %>
            Account locked
          <% } %>
        </span>
      </div>

      <%-- Error message --%>
      <% if (error != null && !lockout) { %>
        <div class="error-msg"><%= error %></div>
      <% } %>

      <%-- Lockout message --%>
      <% if (lockout) { %>
        <div class="lockout-msg">
          &#9888; Maximum login attempts reached.<br>
          Your account has been temporarily locked.<br>
          Please contact the bank for assistance.
        </div>
      <% } else { %>

      <%-- Login form --%>
      <form method="POST" action="${pageContext.request.contextPath}/login" novalidate>
        <div class="field">
          <label for="accountNumber">Account Number</label>
          <input type="text" id="accountNumber" name="accountNumber"
                 value="<%= enteredAcc %>"
                 placeholder="10-digit account number"
                 maxlength="10" autocomplete="off" required />
        </div>
        <div class="field">
          <label for="username">Username</label>
          <input type="text" id="username" name="username"
                 value="<%= enteredUser %>"
                 placeholder="Enter your username"
                 autocomplete="username" required />
        </div>
        <div class="field">
          <label for="password">Password</label>
          <input type="password" id="password" name="password"
                 placeholder="Minimum 6 characters"
                 autocomplete="current-password" required />
        </div>
        <button type="submit" class="login-btn">Sign In &rarr;</button>
      </form>

      <% } %>

    </div><%-- end card-body --%>
  </div>
</main>

<footer class="bank-footer">
  &copy; 2025 BharatBank Ltd &middot; All rights reserved &middot; 1800-XXX-XXXX
</footer>

</body>
</html>
