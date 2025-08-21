<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("auth");
        return;
    }

    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    // Get current time for greeting
    java.time.LocalTime currentTime = java.time.LocalTime.now();
    String greeting = currentTime.getHour() < 12 ? "Good Morning" :
            currentTime.getHour() < 17 ? "Good Afternoon" : "Good Evening";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Pahana Edu</title>
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
            color: #2c3e50;
        }

        .header {
            background: rgba(44, 62, 80, 0.95);
            backdrop-filter: blur(10px);
            color: white;
            padding: 20px 0;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-content {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 30px;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logo h1 {
            font-size: 2em;
            font-weight: 700;
            background: linear-gradient(135deg, #3498db, #2ecc71);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
            font-size: 14px;
        }

        .user-details {
            text-align: right;
        }

        .username {
            font-weight: 600;
            font-size: 16px;
        }

        .role-badge {
            display: inline-block;
            padding: 4px 12px;
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            border-radius: 15px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 2px;
        }

        .logout-btn {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 2px solid transparent;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 12px;
        }

        .logout-btn:hover {
            background: linear-gradient(135deg, #c0392b, #a93226);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.4);
            text-decoration: none;
            color: white;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px;
        }

        .welcome-section {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .welcome-section::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: repeating-linear-gradient(
                    45deg,
                    transparent,
                    transparent 20px,
                    rgba(52, 152, 219, 0.03) 20px,
                    rgba(52, 152, 219, 0.03) 40px
            );
            animation: slide 20s linear infinite;
        }

        @keyframes slide {
            0% { transform: translateX(-100%) translateY(-100%); }
            100% { transform: translateX(100%) translateY(100%); }
        }

        .welcome-content {
            position: relative;
            z-index: 2;
        }

        .greeting {
            font-size: 2.5em;
            font-weight: 700;
            margin-bottom: 15px;
            background: linear-gradient(135deg, #2c3e50, #3498db);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .welcome-message {
            font-size: 1.2em;
            color: #7f8c8d;
            margin-bottom: 10px;
        }

        .system-info {
            font-size: 1em;
            color: #95a5a6;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .stat-icon {
            font-size: 2.5em;
            margin-bottom: 15px;
        }

        .stat-number {
            font-size: 2em;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 0.9em;
            color: #7f8c8d;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
        }

        .menu-section {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }

        .section-title {
            font-size: 2em;
            font-weight: 700;
            text-align: center;
            margin-bottom: 40px;
            color: #2c3e50;
        }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
        }

        .menu-category {
            margin-bottom: 40px;
        }

        .category-title {
            font-size: 1.5em;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 3px solid #3498db;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .menu-item {
            background: linear-gradient(135deg, #ffffff, #f8f9fa);
            padding: 25px;
            border-radius: 15px;
            text-decoration: none;
            color: #2c3e50;
            transition: all 0.3s ease;
            border: 2px solid transparent;
            position: relative;
            overflow: hidden;
            display: block;
        }

        .menu-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(52, 152, 219, 0.1), transparent);
            transition: left 0.5s;
        }

        .menu-item:hover::before {
            left: 100%;
        }

        .menu-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
            border-color: #3498db;
            text-decoration: none;
            color: #2c3e50;
        }

        .menu-icon {
            font-size: 2.5em;
            margin-bottom: 15px;
            display: block;
            text-align: center;
        }

        .menu-title {
            font-size: 1.3em;
            font-weight: 600;
            margin-bottom: 10px;
            text-align: center;
            color: #2c3e50;
        }

        .menu-description {
            font-size: 0.9em;
            color: #7f8c8d;
            text-align: center;
            line-height: 1.5;
        }

        .quick-actions {
            position: fixed;
            bottom: 30px;
            right: 30px;
            display: flex;
            flex-direction: column;
            gap: 15px;
            z-index: 1000;
        }

        .quick-btn {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5em;
            box-shadow: 0 10px 30px rgba(52, 152, 219, 0.3);
            transition: all 0.3s ease;
        }

        .quick-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 15px 40px rgba(52, 152, 219, 0.5);
            text-decoration: none;
            color: white;
        }

        .time-display {
            position: absolute;
            top: 20px;
            right: 20px;
            background: rgba(255, 255, 255, 0.1);
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 20px;
                padding: 0 20px;
            }

            .container {
                padding: 20px;
            }

            .welcome-section {
                padding: 30px 20px;
            }

            .greeting {
                font-size: 2em;
            }

            .menu-section {
                padding: 30px 20px;
            }

            .menu-grid {
                grid-template-columns: 1fr;
            }

            .quick-actions {
                position: static;
                flex-direction: row;
                justify-content: center;
                margin-top: 30px;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .logo h1 {
                font-size: 1.5em;
            }
        }

        .fade-in {
            animation: fadeIn 0.8s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .notification-dot {
            position: absolute;
            top: -5px;
            right: -5px;
            width: 12px;
            height: 12px;
            background: #e74c3c;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.2); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>
<!-- Header -->
<div class="header">
    <div class="header-content">
        <div class="logo">
            <h1>📚 Pahana Edu</h1>
        </div>
        <div class="user-info">
            <div class="user-details">
                <div class="username"><%= greeting %>, <%= username %>!</div>
                <div class="role-badge"><%= role %></div>
            </div>
            <a href="auth?action=logout" class="logout-btn">🚪 Logout</a>
        </div>
    </div>
    <div class="time-display" id="currentTime"></div>
</div>

<div class="container">
    <!-- Welcome Section -->
    <div class="welcome-section fade-in">
        <div class="welcome-content">
            <div class="greeting">Welcome to Your Dashboard</div>
            <div class="welcome-message">
                You are logged in as <strong><%= username %></strong> with <strong><%= role %></strong> privileges.
            </div>
            <div class="system-info">
                Pahana Edu Management System - Your complete bookshop solution
            </div>
        </div>
    </div>

    <!-- Statistics -->
    <div class="stats-grid fade-in">
        <div class="stat-card">
            <div class="stat-icon">👥</div>
            <div class="stat-number" id="customerCount">-</div>
            <div class="stat-label">Total Customers</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">📚</div>
            <div class="stat-number" id="itemCount">-</div>
            <div class="stat-label">Items in Stock</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">💰</div>
            <div class="stat-number" id="billCount">-</div>
            <div class="stat-label">Bills Generated</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">⭐</div>
            <div class="stat-number">A+</div>
            <div class="stat-label">System Status</div>
        </div>
    </div>

    <!-- Menu Section -->
    <div class="menu-section fade-in">
        <div class="section-title">🚀 System Functions</div>

        <!-- Customer Management -->
        <div class="menu-category">
            <div class="category-title">👥 Customer Management</div>
            <div class="menu-grid">
                <a href="AddNewCustomer.jsp" class="menu-item">
                    <div class="menu-icon">➕</div>
                    <h3 class="menu-title">Add New Customer</h3>
                    <p class="menu-description">Register new customer accounts with their details and information</p>
                </a>

                <a href="ViewCustomerDetails.jsp" class="menu-item">
                    <div class="menu-icon">👁️</div>
                    <h3 class="menu-title">View Customers</h3>
                    <p class="menu-description">View and search existing customer information and records</p>
                </a>

                <a href="EditCustomerInfo.jsp" class="menu-item">
                    <div class="menu-icon">✏️</div>
                    <h3 class="menu-title">Edit Customer</h3>
                    <p class="menu-description">Update and modify customer information and details</p>
                </a>
            </div>
        </div>

        <!-- Item Management -->
        <div class="menu-category">
            <div class="category-title">📦 Inventory Management</div>
            <div class="menu-grid">
                <a href="AddNewItems.jsp" class="menu-item">
                    <div class="menu-icon">📚</div>
                    <h3 class="menu-title">Add New Items</h3>
                    <p class="menu-description">Add new books and items to your inventory system</p>
                </a>

                <a href="ViewItemList.jsp" class="menu-item">
                    <div class="menu-icon">📋</div>
                    <h3 class="menu-title">View Items</h3>
                    <p class="menu-description">Browse and manage your complete inventory catalog</p>
                </a>

                <a href="UpdateItems.jsp" class="menu-item">
                    <div class="menu-icon">🔄</div>
                    <h3 class="menu-title">Update Items</h3>
                    <p class="menu-description">Modify item details, pricing, and stock information</p>
                </a>
            </div>
        </div>

        <!-- Billing & Reports -->
        <div class="menu-category">
            <div class="category-title">💼 Business Operations</div>
            <div class="menu-grid">
                <a href="calculate.jsp" class="menu-item">
                    <div class="menu-icon">🧮</div>
                    <h3 class="menu-title">Calculate Bill</h3>
                    <p class="menu-description">Generate bills for customer purchases and transactions</p>
                </a>

                <a href="printBill.jsp" class="menu-item">
                    <div class="menu-icon">🖨️</div>
                    <h3 class="menu-title">Print Bill</h3>
                    <p class="menu-description">Print and manage billing documents and receipts</p>
                </a>

                <a href="reports.jsp" class="menu-item">
                    <div class="menu-icon">📊</div>
                    <h3 class="menu-title">Reports</h3>
                    <p class="menu-description">View comprehensive sales reports and business analytics</p>
                    <div class="notification-dot"></div>
                </a>

                <a href="help.jsp" class="menu-item">
                    <div class="menu-icon">❓</div>
                    <h3 class="menu-title">Help & Support</h3>
                    <p class="menu-description">System usage guidelines and troubleshooting support</p>
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Quick Actions -->
<div class="quick-actions">
    <a href="AddNewCustomer.jsp" class="quick-btn" title="Quick Add Customer">👥</a>
    <a href="calculate.jsp" class="quick-btn" title="Quick Bill">💰</a>
    <a href="help.jsp" class="quick-btn" title="Help">❓</a>
</div>

<script>
    // Update current time
    function updateTime() {
        const now = new Date();
        const timeString = now.toLocaleTimeString();
        const dateString = now.toLocaleDateString();
        document.getElementById('currentTime').textContent = `${dateString} ${timeString}`;
    }

    // Update time every second
    setInterval(updateTime, 1000);
    updateTime();

    // Simulate loading statistics (replace with actual data from server)
    setTimeout(() => {
        document.getElementById('customerCount').textContent = '50+';
        document.getElementById('itemCount').textContent = '200+';
        document.getElementById('billCount').textContent = '150+';
    }, 1000);

    // Add staggered animation to menu items
    document.addEventListener('DOMContentLoaded', function() {
        const menuItems = document.querySelectorAll('.menu-item');
        menuItems.forEach((item, index) => {
            item.style.animationDelay = `${index * 0.1}s`;
            item.classList.add('fade-in');
        });
    });

    // Add keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        if (e.altKey) {
            switch(e.key) {
                case '1':
                    window.location.href = 'AddNewCustomer.jsp';
                    break;
                case '2':
                    window.location.href = 'ViewCustomerDetails.jsp';
                    break;
                case '3':
                    window.location.href = 'calculate.jsp';
                    break;
                case 'h':
                    window.location.href = 'help.jsp';
                    break;
            }
        }
    });

    // Add welcome animation
    setTimeout(() => {
        const greeting = document.querySelector('.greeting');
        if (greeting) {
            greeting.style.transform = 'scale(1.05)';
            setTimeout(() => {
                greeting.style.transform = 'scale(1)';
            }, 200);
        }
    }, 500);

    // Add hover sound effect (optional)
    document.querySelectorAll('.menu-item, .quick-btn').forEach(item => {
        item.addEventListener('mouseenter', function() {
            // You can add a subtle sound effect here if needed
            this.style.transform += ' scale(1.02)';
        });

        item.addEventListener('mouseleave', function() {
            this.style.transform = this.style.transform.replace(' scale(1.02)', '');
        });
    });
</script>
</body>
</html>