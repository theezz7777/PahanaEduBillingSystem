<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu Bookshop - Home</title>
    <style>
        /* =====================================================
           PAHANA EDU BOOKSHOP - PROFESSIONAL CSS STYLES
           ===================================================== */

        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }

        /* Container Layouts */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .main-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            overflow: hidden;
        }

        /* Header Styles */
        .header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 100" fill="rgba(255,255,255,0.1)"><polygon points="0,0 1000,0 1000,60 0,100"/></svg>') no-repeat bottom;
            background-size: cover;
        }

        .header h1 {
            font-size: 2.8rem;
            font-weight: 300;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            position: relative;
            z-index: 1;
        }

        .header .subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
            font-weight: 300;
            position: relative;
            z-index: 1;
        }

        /* Welcome Section */
        .welcome-section {
            padding: 40px 30px;
            text-align: center;
            background: linear-gradient(145deg, #f8f9fa 0%, #e9ecef 100%);
        }

        .welcome-title {
            font-size: 2.2rem;
            color: #2c3e50;
            margin-bottom: 20px;
            font-weight: 300;
        }

        .welcome-description {
            font-size: 1.1rem;
            color: #666;
            margin-bottom: 30px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Quick Actions Grid */
        .quick-actions {
            padding: 30px;
            background: white;
        }

        .quick-actions h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 1.8rem;
            font-weight: 300;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .action-card {
            background: linear-gradient(145deg, #ffffff 0%, #f8f9fa 100%);
            border-radius: 12px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .action-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(103, 126, 234, 0.1), transparent);
            transform: rotate(45deg);
            transition: all 0.5s ease;
            opacity: 0;
        }

        .action-card:hover::before {
            opacity: 1;
            animation: shimmer 1.5s ease-in-out;
        }

        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(103, 126, 234, 0.2);
            border-color: rgba(103, 126, 234, 0.3);
        }

        .action-icon {
            font-size: 2.5rem;
            color: #667eea;
            margin-bottom: 15px;
            display: block;
        }

        .action-title {
            font-size: 1.3rem;
            color: #2c3e50;
            margin-bottom: 10px;
            font-weight: 500;
        }

        .action-description {
            color: #666;
            font-size: 0.95rem;
            margin-bottom: 20px;
        }

        /* Buttons */
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s ease;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(103, 126, 234, 0.4);
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
        }

        /* Stats Section */
        .stats-section {
            padding: 30px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-top: 1px solid rgba(0, 0, 0, 0.1);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 300;
            color: #667eea;
            margin-bottom: 10px;
        }

        .stat-label {
            color: #666;
            font-size: 1rem;
            font-weight: 500;
        }

        /* Footer */
        .footer {
            background: #2c3e50;
            color: white;
            text-align: center;
            padding: 20px;
            font-size: 0.9rem;
        }

        .footer p {
            opacity: 0.8;
        }

        /* Animations */
        @keyframes shimmer {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-in-up {
            animation: fadeInUp 0.8s ease forwards;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            .header h1 {
                font-size: 2.2rem;
            }

            .welcome-title {
                font-size: 1.8rem;
            }

            .actions-grid {
                grid-template-columns: 1fr;
            }

            .action-card {
                padding: 20px;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 20px;
            }

            .header h1 {
                font-size: 1.8rem;
            }

            .welcome-section {
                padding: 25px 20px;
            }

            .quick-actions {
                padding: 20px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Additional Professional Touches */
        .glass-effect {
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .shadow-lg {
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }

        .text-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="main-container">
        <!-- Header -->
        <header class="header">
            <h1>📚 Pahana Edu Bookshop</h1>
            <p class="subtitle">Your Premier Educational Resource Center in Colombo</p>
        </header>

        <!-- Welcome Section -->
        <section class="welcome-section fade-in-up">
            <h2 class="welcome-title text-gradient">Welcome to Our Digital Management System</h2>
            <p class="welcome-description">
                Experience seamless customer account management, efficient billing, and comprehensive
                inventory control. Our professional system serves hundreds of customers monthly with
                precision and reliability.
            </p>
            <a href="login.jsp" class="btn btn-primary">Get Started</a>
        </section>

        <!-- Quick Actions -->
        <section class="quick-actions">
            <h2>System Features</h2>
            <div class="actions-grid">
                <div class="action-card fade-in-up">
                    <span class="action-icon">👥</span>
                    <h3 class="action-title">Customer Management</h3>
                    <p class="action-description">
                        Register new customers, edit account information, and maintain comprehensive customer records
                    </p>
                    <a href="login.jsp" class="btn btn-primary">Access Now</a>
                </div>

                <div class="action-card fade-in-up">
                    <span class="action-icon">📦</span>
                    <h3 class="action-title">Inventory Control</h3>
                    <p class="action-description">
                        Manage book inventory, update stock levels, and track item availability in real-time
                    </p>
                    <a href="login.jsp" class="btn btn-primary">Manage Items</a>
                </div>

                <div class="action-card fade-in-up">
                    <span class="action-icon">🧾</span>
                    <h3 class="action-title">Billing System</h3>
                    <p class="action-description">
                        Generate professional bills, calculate totals automatically, and maintain billing history
                    </p>
                    <a href="login.jsp" class="btn btn-primary">Create Bills</a>
                </div>

                <div class="action-card fade-in-up">
                    <span class="action-icon">📊</span>
                    <h3 class="action-title">Reports & Analytics</h3>
                    <p class="action-description">
                        View comprehensive reports, track sales performance, and analyze customer patterns
                    </p>
                    <a href="login.jsp" class="btn btn-primary">View Reports</a>
                </div>
            </div>
        </section>

        <!-- Statistics -->
        <section class="stats-section">
            <div class="stats-grid">
                <div class="stat-card fade-in-up">
                    <div class="stat-number">500+</div>
                    <div class="stat-label">Happy Customers</div>
                </div>
                <div class="stat-card fade-in-up">
                    <div class="stat-number">1000+</div>
                    <div class="stat-label">Books Available</div>
                </div>
                <div class="stat-card fade-in-up">
                    <div class="stat-number">24/7</div>
                    <div class="stat-label">System Availability</div>
                </div>
                <div class="stat-card fade-in-up">
                    <div class="stat-number">99.9%</div>
                    <div class="stat-label">Accuracy Rate</div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer">
            <p>&copy; 2025 Pahana Edu Bookshop. All rights reserved. | Colombo City's Leading Educational Resource Center</p>
        </footer>
    </div>
</div>

<script>
    // Add subtle animations and interactions
    document.addEventListener('DOMContentLoaded', function() {
        // Stagger animation for cards
        const cards = document.querySelectorAll('.fade-in-up');
        cards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.2}s`;
        });

        // Add hover effects for better interactivity
        const actionCards = document.querySelectorAll('.action-card');
        actionCards.forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px) scale(1.02)';
            });

            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
    });
</script>
</body>
</html>