<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help - Pahana Edu Bookshop</title>
    <style>
        /* =====================================================
           PAHANA EDU BOOKSHOP - HELP SECTION CSS
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

        .header h1 {
            font-size: 2.5rem;
            font-weight: 300;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }

        .header .subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            font-weight: 300;
        }

        /* Navigation Breadcrumb */
        .breadcrumb {
            background: #f8f9fa;
            padding: 15px 30px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        }

        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        /* Main Content */
        .help-content {
            padding: 40px 30px;
        }

        .help-intro {
            text-align: center;
            margin-bottom: 40px;
            padding: 30px;
            background: linear-gradient(145deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 12px;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .help-intro h2 {
            color: #2c3e50;
            font-size: 2rem;
            margin-bottom: 15px;
            font-weight: 300;
        }

        .help-intro p {
            color: #666;
            font-size: 1.1rem;
            max-width: 800px;
            margin: 0 auto;
        }

        /* Search Box */
        .search-section {
            margin-bottom: 40px;
            text-align: center;
        }

        .search-box {
            position: relative;
            max-width: 500px;
            margin: 0 auto;
        }

        .search-input {
            width: 100%;
            padding: 15px 50px 15px 20px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .search-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(103, 126, 234, 0.1);
        }

        .search-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
            font-size: 1.2rem;
        }

        /* Help Categories */
        .help-categories {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .category-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .category-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(103, 126, 234, 0.15);
        }

        .category-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            display: block;
            color: #667eea;
        }

        .category-title {
            font-size: 1.4rem;
            color: #2c3e50;
            margin-bottom: 15px;
            font-weight: 500;
        }

        .category-description {
            color: #666;
            margin-bottom: 20px;
            font-size: 0.95rem;
        }

        /* FAQ Section */
        .faq-section {
            margin-bottom: 40px;
        }

        .faq-title {
            font-size: 2rem;
            color: #2c3e50;
            margin-bottom: 30px;
            text-align: center;
            font-weight: 300;
        }

        .faq-item {
            background: white;
            border-radius: 12px;
            margin-bottom: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(0, 0, 0, 0.05);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .faq-question {
            padding: 20px 25px;
            cursor: pointer;
            background: linear-gradient(145deg, #f8f9fa 0%, #e9ecef 100%);
            border: none;
            width: 100%;
            text-align: left;
            font-size: 1.1rem;
            font-weight: 500;
            color: #2c3e50;
            transition: all 0.3s ease;
            position: relative;
        }

        .faq-question::after {
            content: '+';
            position: absolute;
            right: 25px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.5rem;
            color: #667eea;
            transition: transform 0.3s ease;
        }

        .faq-question.active::after {
            transform: translateY(-50%) rotate(45deg);
        }

        .faq-question:hover {
            background: linear-gradient(145deg, #e9ecef 0%, #dee2e6 100%);
        }

        .faq-answer {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
            background: white;
        }

        .faq-answer.active {
            max-height: 200px;
        }

        .faq-answer-content {
            padding: 20px 25px;
            color: #666;
            line-height: 1.6;
        }

        /* Quick Links */
        .quick-links {
            background: linear-gradient(145deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 40px;
        }

        .quick-links h3 {
            color: #2c3e50;
            font-size: 1.5rem;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .links-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }

        .quick-link {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            background: white;
            border-radius: 8px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .quick-link:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 15px rgba(103, 126, 234, 0.15);
            border-color: #667eea;
            color: #667eea;
        }

        .quick-link-icon {
            margin-right: 12px;
            font-size: 1.2rem;
            color: #667eea;
        }

        /* Contact Support */
        .contact-support {
            background: white;
            border-radius: 12px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .contact-support h3 {
            color: #2c3e50;
            font-size: 1.6rem;
            margin-bottom: 15px;
            font-weight: 500;
        }

        .contact-support p {
            color: #666;
            margin-bottom: 25px;
            font-size: 1.1rem;
        }

        .contact-methods {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .contact-method {
            padding: 20px;
            background: linear-gradient(145deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 10px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .contact-method:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .contact-icon {
            font-size: 2rem;
            color: #667eea;
            margin-bottom: 10px;
            display: block;
        }

        .contact-label {
            font-weight: 500;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .contact-info {
            color: #666;
            font-size: 0.9rem;
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

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
        }

        /* Animations */
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
            animation: fadeInUp 0.6s ease forwards;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            .header {
                padding: 20px;
            }

            .header h1 {
                font-size: 2rem;
            }

            .help-content {
                padding: 20px 15px;
            }

            .help-categories {
                grid-template-columns: 1fr;
            }

            .links-grid {
                grid-template-columns: 1fr;
            }

            .contact-methods {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 480px) {
            .header h1 {
                font-size: 1.6rem;
            }

            .category-card {
                padding: 20px;
            }

            .faq-question {
                padding: 15px 20px;
                font-size: 1rem;
            }

            .faq-answer-content {
                padding: 15px 20px;
            }
        }

        /* Print Styles */
        @media print {
            .header {
                background: #2c3e50 !important;
                -webkit-print-color-adjust: exact;
            }

            .btn {
                display: none;
            }

            .search-section {
                display: none;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="main-container">
        <!-- Header -->
        <header class="header">
            <h1>📚 Help & Support</h1>
            <p class="subtitle">Pahana Edu Bookshop Management System Guide</p>
        </header>

        <!-- Breadcrumb Navigation -->
        <nav class="breadcrumb">
            <a href="index.jsp">🏠 Home</a> > <span>Help & Support</span>
        </nav>

        <!-- Main Help Content -->
        <main class="help-content">
            <!-- Introduction -->
            <section class="help-intro fade-in-up">
                <h2>Welcome to Our Help Center</h2>
                <p>Find comprehensive guides, tutorials, and answers to frequently asked questions about using our bookshop management system effectively.</p>
            </section>

            <!-- Search Section -->
            <section class="search-section fade-in-up">
                <div class="search-box">
                    <input type="text" class="search-input" placeholder="Search for help topics..." id="helpSearch">
                    <span class="search-icon">🔍</span>
                </div>
            </section>

            <!-- Help Categories -->
            <section class="help-categories fade-in-up">
                <div class="category-card">
                    <span class="category-icon">🚀</span>
                    <h3 class="category-title">Getting Started</h3>
                    <p class="category-description">Learn the basics of logging in, navigating the system, and understanding the main dashboard features.</p>
                    <a href="#getting-started" class="btn btn-primary">Learn More</a>
                </div>

                <div class="category-card">
                    <span class="category-icon">👥</span>
                    <h3 class="category-title">Customer Management</h3>
                    <p class="category-description">Complete guide on adding, editing, and managing customer accounts and their information.</p>
                    <a href="#customer-management" class="btn btn-primary">View Guide</a>
                </div>

                <div class="category-card">
                    <span class="category-icon">📦</span>
                    <h3 class="category-title">Inventory Management</h3>
                    <p class="category-description">Learn how to add, update, and track book inventory, manage stock levels, and handle item information.</p>
                    <a href="#inventory-management" class="btn btn-primary">Explore</a>
                </div>

                <div class="category-card">
                    <span class="category-icon">🧾</span>
                    <h3 class="category-title">Billing System</h3>
                    <p class="category-description">Step-by-step instructions for creating bills, calculating totals, and printing customer invoices.</p>
                    <a href="#billing-system" class="btn btn-primary">Get Started</a>
                </div>

                <div class="category-card">
                    <span class="category-icon">📊</span>
                    <h3 class="category-title">Reports & Analytics</h3>
                    <p class="category-description">Understanding system reports, viewing analytics, and generating business insights.</p>
                    <a href="#reports-analytics" class="btn btn-primary">View Reports</a>
                </div>

                <div class="category-card">
                    <span class="category-icon">⚙️</span>
                    <h3 class="category-title">System Settings</h3>
                    <p class="category-description">Configure system preferences, manage user accounts, and customize system behavior.</p>
                    <a href="#system-settings" class="btn btn-primary">Configure</a>
                </div>
            </section>

            <!-- FAQ Section -->
            <section class="faq-section fade-in-up">
                <h2 class="faq-title">Frequently Asked Questions</h2>

                <div class="faq-item">
                    <button class="faq-question" onclick="toggleFAQ(this)">
                        How do I log into the system?
                    </button>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            To log into the system, navigate to the login page, enter your username and password provided by the administrator. Default credentials are available in the documentation. Make sure to change your password after first login for security.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <button class="faq-question" onclick="toggleFAQ(this)">
                        How do I add a new customer account?
                    </button>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Go to Customer Management > Add New Customer. Fill in all required fields including account number, name, address, and telephone. The account number must be unique. Click 'Save' to create the account.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <button class="faq-question" onclick="toggleFAQ(this)">
                        How do I update book inventory?
                    </button>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Navigate to Item Management > Update Items. Select the book you want to update, modify the details such as price, stock quantity, or description. Save changes to update the inventory system.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <button class="faq-question" onclick="toggleFAQ(this)">
                        How do I generate and print a bill?
                    </button>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Go to Billing > Calculate Bill. Select the customer account, add items and quantities. The system will automatically calculate totals. Review the bill and click 'Print' to generate a professional invoice.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <button class="faq-question" onclick="toggleFAQ(this)">
                        What should I do if I forget my password?
                    </button>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Contact the system administrator to reset your password. For security reasons, passwords cannot be recovered but can be reset. Provide your username and a new temporary password will be assigned.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <button class="faq-question" onclick="toggleFAQ(this)">
                        How do I view system reports?
                    </button>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Access Reports section from the main menu. Choose from various report types including sales reports, customer reports, and inventory reports. Select date ranges and filter options as needed before generating.
                        </div>
                    </div>
                </div>
            </section>

            <!-- Quick Links -->
            <section class="quick-links fade-in-up">
                <h3>Quick Access Links</h3>
                <div class="links-grid">
                    <a href="login.jsp" class="quick-link">
                        <span class="quick-link-icon">🔐</span>
                        System Login
                    </a>
                    <a href="dashboard.jsp" class="quick-link">
                        <span class="quick-link-icon">📊</span>
                        Dashboard
                    </a>
                    <a href="AddNewCustomer.jsp" class="quick-link">
                        <span class="quick-link-icon">👤</span>
                        Add Customer
                    </a>
                    <a href="AddNewItems.jsp" class="quick-link">
                        <span class="quick-link-icon">📚</span>
                        Add Items
                    </a>
                    <a href="calculate.jsp" class="quick-link">
                        <span class="quick-link-icon">🧾</span>
                        Create Bill
                    </a>
                    <a href="reports.jsp" class="quick-link">
                        <span class="quick-link-icon">📈</span>
                        View Reports
                    </a>
                </div>
            </section>

            <!-- Contact Support -->
            <section class="contact-support fade-in-up">
                <h3>Still Need Help?</h3>
                <p>Our support team is here to assist you with any questions or issues you may have.</p>

                <div class="contact-methods">
                    <div class="contact-method">
                        <span class="contact-icon">📧</span>
                        <div class="contact-label">Email Support</div>
                        <div class="contact-info">support@pahanaedu.lk</div>
                    </div>
                    <div class="contact-method">
                        <span class="contact-icon">📞</span>
                        <div class="contact-label">Phone Support</div>
                        <div class="contact-info">+94 11 234 5678</div>
                    </div>
                    <div class="contact-method">
                        <span class="contact-icon">🕒</span>
                        <div class="contact-label">Business Hours</div>
                        <div class="contact-info">Mon-Fri 9AM-6PM</div>
                    </div>
                </div>

                <a href="index.jsp" class="btn btn-secondary">Back to Home</a>
            </section>
        </main>
    </div>
</div>

<script>
    // FAQ Toggle Functionality
    function toggleFAQ(element) {
        const answer = element.nextElementSibling;
        const isActive = element.classList.contains('active');

        // Close all FAQ items
        document.querySelectorAll('.faq-question').forEach(q => q.classList.remove('active'));
        document.querySelectorAll('.faq-answer').forEach(a => a.classList.remove('active'));

        // Open clicked item if it wasn't active
        if (!isActive) {
            element.classList.add('active');
            answer.classList.add('active');
        }
    }

    // Search Functionality
    document.getElementById('helpSearch').addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        const categories = document.querySelectorAll('.category-card');
        const faqs = document.querySelectorAll('.faq-item');

        // Filter categories
        categories.forEach(category => {
            const title = category.querySelector('.category-title').textContent.toLowerCase();
            const description = category.querySelector('.category-description').textContent.toLowerCase();

            if (title.includes(searchTerm) || description.includes(searchTerm) || searchTerm === '') {
                category.style.display = 'block';
            } else {
                category.style.display = 'none';
            }
        });

        // Filter FAQs
        faqs.forEach(faq => {
            const question = faq.querySelector('.faq-question').textContent.toLowerCase();
            const answer = faq.querySelector('.faq-answer-content').textContent.toLowerCase();

            if (question.includes(searchTerm) || answer.includes(searchTerm) || searchTerm === '') {
                faq.style.display = 'block';
            } else {
                faq.style.display = 'none';
            }
        });
    });

    // Animation on scroll
    document.addEventListener('DOMContentLoaded', function() {
        const fadeElements = document.querySelectorAll('.fade-in-up');
        fadeElements.forEach((element, index) => {
            element.style.animationDelay = `${index * 0.1}s`;
        });
    });

    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
</script>
</body>
</html>