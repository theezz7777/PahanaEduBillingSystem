<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Pahana Edu</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; background-color: #f4f4f4; }
        .container { max-width: 400px; margin: 0 auto; background: white; padding: 30px; border-radius: 5px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="password"] { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 3px; box-sizing: border-box; }
        .btn { width: 100%; padding: 12px; background-color: #4CAF50; color: white; border: none; border-radius: 3px; cursor: pointer; }
        .btn:hover { background-color: #45a049; }
        .error { color: red; margin-bottom: 15px; padding: 10px; background-color: #ffe6e6; border-radius: 3px; }
        .success { color: green; margin-bottom: 15px; padding: 10px; background-color: #e6ffe6; border-radius: 3px; }
        .links { text-align: center; margin-top: 20px; }
        .links a { color: #4CAF50; text-decoration: none; }
    </style>
</head>
<body>
<div class="container">
    <h2>Pahana Edu - Login</h2>

    <!-- Error Message -->
    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <!-- Success Message -->
    <% String success = (String) request.getAttribute("success"); %>
    <% if (success != null) { %>
    <div class="success"><%= success %></div>
    <% } %>

    <form action="auth" method="post">
        <input type="hidden" name="action" value="login">

        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text"
                   id="username"
                   name="username"
                   value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                   required>
        </div>

        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>

        <button type="submit" class="btn">Login</button>
    </form>

    <div class="links">
        <p>Don't have an account? <a href="register.jsp">Register here</a></p>
    </div>
</div>
</body>
</html>