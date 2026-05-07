# BharatBank – Net Banking JSP Website

Converted from your console-based Java project to a full JSP dynamic website.

## Project Structure

```
NetBankingJSP/
├── pom.xml                                     ← Maven build (Jakarta EE 10)
└── src/main/
    ├── java/com/netbanking/
    │   ├── User.java                           ← User bean (stored in session)
    │   ├── Validator.java                      ← Input validation (ported from original)
    │   ├── LoginServlet.java                   ← POST /login – auth + session
    │   └── LogoutServlet.java                  ← GET  /logout – invalidates session
    └── webapp/
        ├── login.jsp                           ← Login page with attempt tracking
        ├── dashboard.jsp                       ← Post-login banking dashboard
        ├── css/style.css                       ← Shared stylesheet
        └── WEB-INF/web.xml                     ← Deployment descriptor
```

## Features Ported from Console App

| Console feature                        | Web equivalent                                 |
|----------------------------------------|------------------------------------------------|
| 3 login attempts before lockout        | Session-tracked, red dots UI                   |
| Account number validation (10 digits)  | `Validator.validateAccountNumber()` on server  |
| Username / password validation         | `Validator.validateUsername/Password()`        |
| Specific mismatch messages             | "Incorrect username" / "Invalid password"      |
| Seeded user list (anu, rahul, priya)   | `LoginServlet` static list (swap with DB)      |
| Check balance                          | Dashboard card + detail tile                   |
| View account details                   | Dashboard tile                                 |
| Logout                                 | `LogoutServlet` → session.invalidate()         |

## Test Credentials

| Account Number | Username | Password    | Balance      |
|----------------|----------|-------------|--------------|
| 1234567890     | anu      | 123456      | ₹50,000.00   |
| 9876543210     | rahul    | securePass  | ₹1,20,000.75 |
| 1111111111     | priya    | priya@99    | ₹75,000.50   |

## Setup & Run

### Requirements
- JDK 17+
- Maven 3.8+
- Apache Tomcat 10.x (Jakarta EE 10)

### Build
```bash
cd NetBankingJSP
mvn clean package
```
This produces `target/NetBankingJSP-1.0.war`.

### Deploy on Tomcat
```bash
cp target/NetBankingJSP-1.0.war $TOMCAT_HOME/webapps/
$TOMCAT_HOME/bin/startup.sh
```
Open: http://localhost:8080/NetBankingJSP-1.0/login.jsp

### Quick run with Maven Tomcat plugin (optional)
Add to `pom.xml` plugins section:
```xml
<plugin>
  <groupId>org.apache.tomcat.maven</groupId>
  <artifactId>tomcat10-maven-plugin</artifactId>
  <version>2.0-beta-1</version>
</plugin>
```
Then: `mvn tomcat10:run`

## Next Steps / Extend
- Replace static user list in `LoginServlet` with a JDBC DAO
- Add CSRF token to the login form
- Hash passwords with BCrypt
- Add JSP pages for Fund Transfer, Bill Pay, Statement download
- Use JSTL `<c:if>` / `<c:forEach>` instead of raw scriptlets
