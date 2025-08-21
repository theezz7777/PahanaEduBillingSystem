<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Pahana Edu</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        /* Animated background particles */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at 20% 80%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
            radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
            radial-gradient(circle at 40% 40%, rgba(255, 255, 255, 0.05) 0%, transparent 50%);
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(2deg); }
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 25px;
            padding: 50px 40px;
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 450px;
            position: relative;
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: slideUp 0.8s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .logo {
            font-size: 3em;
            margin-bottom: 15px;
            animation: bounce 2s ease-in-out infinite;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-10px); }
            60% { transform: translateY(-5px); }
        }

        .login-title {
            font-size: 2.5em;
            font-weight: 700;
            background: linear-gradient(135deg, #2c3e50, #3498db);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }

        .login-subtitle {
            font-size: 1.1em;
            color: #7f8c8d;
            font-weight: 400;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .form-input {
            width: 100%;
            padding: 15px 20px 15px 50px;
            border: 2px solid #e9ecef;
            border-radius: 50px;
            font-size: 16px;
            background: #f8f9fa;
            transition: all 0.3s ease;
            position: relative;
        }

        .form-input:focus {
            outline: none;
            border-color: #3498db;
            background: white;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            transform: translateY(-2px);
        }

        .input-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            color: #7f8c8d;
            transition: color 0.3s ease;
            margin-top: 24px;
        }

        .form-input:focus + .input-icon {
            color: #3498db;
        }

        .login-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 2px;
            position: relative;
            overflow: hidden;
            margin-top: 10px;
        }

        .login-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .login-btn:hover::before {
            left: 100%;
        }

        .login-btn:hover {
            background: linear-gradient(135deg, #2980b9, #1abc9c);
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(52, 152, 219, 0.4);
        }

        .login-btn:active {
            transform: translateY(-1px);
        }

        .login-btn.loading {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            cursor: not-allowed;
        }

        .alert {
            padding: 15px 20px;
            border-radius: 15px;
            margin-bottom: 25px;
            font-weight: 500;
            border-left: 4px solid;
            animation: slideDown 0.5s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-error {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            border-color: #e74c3c;
            color: #c62828;
        }

        .alert-success {
            background: linear-gradient(135deg, #e8f5e8, #c8e6c9);
            border-color: #27ae60;
            color: #2e7d32;
        }

        .links {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }

        .links p {
            color: #7f8c8d;
            margin-bottom: 10px;
        }

        .register-link {
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            padding: 5px 10px;
            border-radius: 20px;
        }

        .register-link:hover {
            background: rgba(52, 152, 219, 0.1);
            text-decoration: none;
            color: #2980b9;
            transform: translateY(-1px);
        }

        .features {
            margin-top: 25px;
            text-align: center;
        }

        .feature-item {
            display: inline-flex;
            align-items: center;
            margin: 0 15px;
            color: #7f8c8d;
            font-size: 12px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .feature-icon {
            margin-right: 5px;
            font-size: 14px;
        }

        .password-toggle {
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #7f8c8d;
            font-size: 18px;
            transition: color 0.3s ease;
            margin-top: 24px;
            z-index: 1;
        }

        .password-toggle:hover {
            color: #3498db;
        }

        .forgot-password {
            text-align: right;
            margin-top: 10px;
        }

        .forgot-password a {
            color: #7f8c8d;
            text-decoration: none;
            font-size: 12px;
            transition: color 0.3s ease;
        }

        .forgot-password a:hover {
            color: #3498db;
        }

        @media (max-width: 768px) {
            .login-container {
                margin: 20px;
                padding: 40px 30px;
                max-width: none;
            }

            .login-title {
                font-size: 2em;
            }

            .features {
                display: none;
            }
        }

        /* Loading animation */
        .spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
            margin-right: 10px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Floating shapes decoration */
        .floating-shape {
            position: absolute;
            opacity: 0.1;
            animation: floatShape 8s ease-in-out infinite;
        }

        .shape-1 {
            top: 10%;
            left: 10%;
            font-size: 2em;
            animation-delay: 0s;
        }

        .shape-2 {
            top: 20%;
            right: 10%;
            font-size: 1.5em;
            animation-delay: 2s;
        }

        .shape-3 {
            bottom: 20%;
            left: 15%;
            font-size: 2.5em;
            animation-delay: 4s;
        }

        .shape-4 {
            bottom: 10%;
            right: 20%;
            font-size: 1.8em;
            animation-delay: 6s;
        }

        @keyframes floatShape {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(180deg); }
        }
    </style>
</head>
<body>
<!-- Floating decorative shapes -->
<div class="floating-shape shape-1">📚</div>
<div class="floating-shape shape-2">✨</div>
<div class="floating-shape shape-3">📖</div>
<div class="floating-shape shape-4">🎓</div>

<div class="login-container">
    <div class="login-header">
        <div class="logo">📚</div>
        <h1 class="login-title">Pahana Edu</h1>
        <p class="login-subtitle">Welcome back! Please sign in to your account</p>
    </div>

    <!-- Error Message -->
    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
    <div class="alert alert-error">
        <strong>❌ Error:</strong> <%= error %>
    </div>
    <% } %>

    <!-- Success Message -->
    <% String success = (String) request.getAttribute("success"); %>
    <% if (success != null) { %>
    <div class="alert alert-success">
        <strong>✅ Success:</strong> <%= success %>
    </div>
    <% } %>

    <form action="auth" method="post" id="loginForm">
        <input type="hidden" name="action" value="login">

        <div class="form-group">
            <label for="username" class="form-label">Username</label>
            <input type="text"
                   id="username"
                   name="username"
                   class="form-input"
                   placeholder="Enter your username"
                   value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                   required>
            <span class="input-icon">👤</span>
        </div>

        <div class="form-group">
            <label for="password" class="form-label">Password</label>
            <input type="password"
                   id="password"
                   name="password"
                   class="form-input"
                   placeholder="Enter your password"
                   required>
            <span class="input-icon">🔒</span>
            <span class="password-toggle" onclick="togglePassword()">👁️</span>
            <div class="forgot-password">
                <a href="#" onclick="alert('Please contact administrator for password reset')">Forgot password?</a>
            </div>
        </div>

        <button type="submit" class="login-btn" id="loginBtn">
            Sign In
        </button>
    </form>

    <div class="features">
        <div class="feature-item">
            <span class="feature-icon">🔐</span>
            <span>Secure</span>
        </div>
        <div class="feature-item">
            <span class="feature-icon">⚡</span>
            <span>Fast</span>
        </div>
        <div class="feature-item">
            <span class="feature-icon">📱</span>
            <span>Responsive</span>
        </div>
    </div>


<script>
    // Password toggle functionality
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const toggleBtn = document.querySelector('.password-toggle');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleBtn.textContent = '🙈';
        } else {
            passwordInput.type = 'password';
            toggleBtn.textContent = '👁️';
        }
    }

    // Form submission with loading state
    document.getElementById('loginForm').addEventListener('submit', function() {
        const loginBtn = document.getElementById('loginBtn');
        const originalText = loginBtn.innerHTML;

        loginBtn.innerHTML = '<span class="spinner"></span>Signing In...';
        loginBtn.classList.add('loading');
        loginBtn.disabled = true;

        // Re-enable button after 5 seconds (in case of errors)
        setTimeout(() => {
            loginBtn.innerHTML = originalText;
            loginBtn.classList.remove('loading');
            loginBtn.disabled = false;
        }, 5000);
    });

    // Auto-focus username field
    document.getElementById('username').focus();

    // Add Enter key support
    document.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            document.getElementById('loginForm').submit();
        }
    });

    // Input validation and styling
    document.querySelectorAll('.form-input').forEach(input => {
        input.addEventListener('input', function() {
            if (this.value.length > 0) {
                this.style.borderColor = '#27ae60';
            } else {
                this.style.borderColor = '#e9ecef';
            }
        });

        // Add floating label effect
        input.addEventListener('focus', function() {
            this.parentElement.classList.add('focused');
        });

        input.addEventListener('blur', function() {
            if (this.value === '') {
                this.parentElement.classList.remove('focused');
            }
        });
    });

    // Demo credentials helper (optional - remove in production)
    document.addEventListener('keydown', function(e) {
        if (e.ctrlKey && e.shiftKey && e.key === 'D') {
            document.getElementById('username').value = 'admin';
            document.getElementById('password').value = 'admin123';
            alert('Demo credentials filled! (Ctrl+Shift+D)');
        }
    });

    // Add smooth scrolling and animations
    window.addEventListener('load', function() {
        document.body.style.animation = 'fadeIn 0.5s ease-out';
    });

    // Prevent double submission
    let isSubmitting = false;
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        if (isSubmitting) {
            e.preventDefault();
            return false;
        }
        isSubmitting = true;
    });

    // Add ripple effect to button
    document.querySelector('.login-btn').addEventListener('click', function(e) {
        const btn = e.target;
        const rect = btn.getBoundingClientRect();
        const ripple = document.createElement('span');
        const size = Math.max(rect.width, rect.height);
        const x = e.clientX - rect.left - size / 2;
        const y = e.clientY - rect.top - size / 2;

        ripple.style.cssText = `
                position: absolute;
                border-radius: 50%;
                transform: scale(0);
                animation: ripple 600ms linear;
                background-color: rgba(255, 255, 255, 0.3);
                width: ${size}px;
                height: ${size}px;
                left: ${x}px;
                top: ${y}px;
                pointer-events: none;
            `;

        btn.appendChild(ripple);

        setTimeout(() => {
            ripple.remove();
        }, 600);
    });

    // Add CSS for ripple animation
    const style = document.createElement('style');
    style.textContent = `
            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
    document.head.appendChild(style);
</script>
</body>
</html>