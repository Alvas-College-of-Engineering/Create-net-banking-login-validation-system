<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.netbanking.User" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
    // Guard: must be logged in
    User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    NumberFormat inr = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
    String balanceFormatted = inr.format(user.getBalance());
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>BharatBank – Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<header class="bank-header">
  <span class="bank-logo">&#x2297; BHARATBANK</span>
  <span class="bank-tagline">INTERNET BANKING &middot; DASHBOARD</span>
  <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
</header>

<main class="dashboard-wrap">

  <div class="welcome-strip">
    <div>
      <div class="welcome-name">
        Welcome, <%= Character.toUpperCase(user.getUsername().charAt(0))
                     + user.getUsername().substring(1) %>!
      </div>
      <div class="welcome-acno">Account No: <%= user.getAccountNumber() %></div>
    </div>
  </div>

  <%-- Summary cards --%>
  <div class="cards-grid">
    <div class="info-card">
      <div class="ic-label">Available Balance</div>
      <div class="ic-value balance"><%= balanceFormatted %></div>
      <div class="ic-sub">Savings Account &middot; As of today</div>
    </div>
    <div class="info-card">
      <div class="ic-label">Account Status</div>
      <div class="ic-value status-active">&#10003; Active</div>
      <div class="ic-sub">KYC Verified</div>
    </div>
  </div>

  <%-- Menu tiles --%>
  <div class="menu-grid">

    <div class="menu-tile">
      <div class="tile-icon">&#9670;</div>
      <div class="tile-label">Check Balance</div>
      <div class="tile-detail"><%= balanceFormatted %></div>
    </div>

    <div class="menu-tile">
      <div class="tile-icon">&#9632;</div>
      <div class="tile-label">Account Details</div>
      <div class="tile-detail">
        Acc: <%= user.getAccountNumber() %><br>
        User: <%= user.getUsername() %>
      </div>
    </div>

    <div class="menu-tile">
      <div class="tile-icon">&#9650;</div>
      <div class="tile-label">Mini Statement</div>
      <div class="tile-detail tile-stmt">
        <table class="stmt-table">
          <tr><td class="stmt-date">05 May</td><td class="stmt-desc">UPI – Swiggy</td><td class="stmt-amt debit">&#8722;&#8377;340</td></tr>
          <tr><td class="stmt-date">04 May</td><td class="stmt-desc">NEFT Credit</td><td class="stmt-amt credit">+&#8377;5,000</td></tr>
          <tr><td class="stmt-date">02 May</td><td class="stmt-desc">ATM Withdrawal</td><td class="stmt-amt debit">&#8722;&#8377;2,000</td></tr>
        </table>
      </div>
    </div>

    <div class="menu-tile">
      <div class="tile-icon">&#9670;</div>
      <div class="tile-label">Fund Transfer</div>
      <div class="tile-detail coming-soon">Coming soon</div>
    </div>

    <div class="menu-tile">
      <div class="tile-icon">&#9632;</div>
      <div class="tile-label">Pay Bills</div>
      <div class="tile-detail coming-soon">Coming soon</div>
    </div>

    <div class="menu-tile">
      <div class="tile-icon">&#9650;</div>
      <div class="tile-label">Profile</div>
      <div class="tile-detail">
        <%= user.getUsername() %>
      </div>
    </div>

  </div>

</main>

<footer class="bank-footer">
  &copy; 2025 BharatBank Ltd &middot; All rights reserved &middot; 1800-XXX-XXXX
</footer>

</body>
</html>
