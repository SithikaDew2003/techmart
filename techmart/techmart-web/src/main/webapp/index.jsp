<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.sithikaDev.techmart.entity.Users" %>
<%@ page import="lk.sithikaDev.techmart.entity.Product" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Techmart | Premium Tech Components</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        :root {
            --primary: #00d2ff;
            --primary-dark: #00a1c2;
            --accent: #ffcc00;
            --dark-bg: #0a0a0b;
            --card-bg: #141416;
            --text-main: #ffffff;
            --text-white: #a1a1a6;
            --border-color: rgba(255, 255, 255, 0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--dark-bg);
            color: var(--text-main);
            margin: 0;
            overflow-x: hidden;
        }

        .navbar {
            background-color: rgba(10, 10, 11, 0.8);
            backdrop-filter: saturate(180%) blur(20px);
            border-bottom: 1px solid var(--border-color);
            padding: 1rem 0;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            letter-spacing: -0.5px;
            color: var(--primary) !important;
        }

        .nav-link {
            font-weight: 500;
            color: var(--text-white) !important;
            transition: color 0.2s;
        }

        .nav-link:hover {
            color: var(--text-main) !important;
        }

        .hero-section {
            padding: 120px 0 80px;
            background: radial-gradient(circle at 80% 20%, rgba(0, 210, 255, 0.15) 0%, transparent 40%),
                        radial-gradient(circle at 20% 80%, rgba(255, 204, 0, 0.1) 0%, transparent 40%);
        }

        .hero-badge {
            display: inline-block;
            padding: 6px 16px;
            background: rgba(0, 210, 255, 0.1);
            border: 1px solid rgba(0, 210, 255, 0.2);
            border-radius: 100px;
            color: var(--primary);
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 24px;
        }

        .hero-title {
            font-size: 4.5rem;
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 24px;
            letter-spacing: -2px;
        }

        .hero-subtitle {
            font-size: 1.25rem;
            color: var(--text-white);
            max-width: 600px;
            margin-bottom: 40px;
            line-height: 1.6;
        }

        .btn-primary-custom {
            background-color: var(--primary);
            color: #000;
            padding: 14px 32px;
            font-weight: 600;
            border-radius: 12px;
            border: none;
            transition: transform 0.2s, background-color 0.2s;
        }

        .btn-primary-custom:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
            color: #000;
        }

        .btn-secondary-custom {
            background-color: rgba(255, 255, 255, 0.05);
            color: #fff;
            padding: 14px 32px;
            font-weight: 600;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            transition: background-color 0.2s;
        }

        .btn-secondary-custom:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: #fff;
        }

        .section-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 40px;
        }

        .product-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 24px;
            transition: transform 0.3s ease, border-color 0.3s ease;
            height: 100%;
        }

        .product-card:hover {
            transform: translateY(-10px);
            border-color: rgba(0, 210, 255, 0.3);
        }

        .product-img-wrapper {
            background: #1c1c1e;
            border-radius: 16px;
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            overflow: hidden;
        }

        .product-img-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .product-category {
            color: var(--primary);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }

        .product-name {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .product-price {
            font-size: 1.5rem;
            font-weight: 700;
        }

        .feature-icon {
            font-size: 2.5rem;
            color: var(--primary);
            margin-bottom: 20px;
        }

        .footer {
            padding: 80px 0 40px;
            border-top: 1px solid var(--border-color);
            margin-top: 80px;
        }

        .footer-logo {
            color: var(--primary);
            font-weight: 700;
            font-size: 1.5rem;
            margin-bottom: 20px;
            display: block;
            text-decoration: none;
        }

        .footer-link {
            color: var(--text-white);
            text-decoration: none;
            display: block;
            margin-bottom: 12px;
            transition: color 0.2s;
        }

        .footer-link:hover {
            color: var(--primary);
        }
    </style>
</head>
<body>

<%
    Users user = (Users) session.getAttribute("user");
    List<Product> featuredProducts = (List<Product>) request.getAttribute("featuredProducts");
%>

<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="home">TECHMART</a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav align-items-center">
                <li class="nav-item"><a class="nav-link px-3" href="shop">Shop</a></li>
                <li class="nav-item"><a class="nav-link px-3" href="#">Build Guide</a></li>
                <li class="nav-item"><a class="nav-link px-3" href="#">Support</a></li>
                <% if (user != null) { %>
                    <li class="nav-item"><a class="nav-link px-3" href="dashboard">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link px-3 position-relative" href="cart">
                        <i class="bi bi-cart3 fs-5"></i>
                    </a></li>
                    <li class="nav-item dropdown ms-3">
                        <a class="btn btn-outline-light btn-sm dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <%= user.getFirstName() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end">
                            <li><a class="dropdown-item" href="logout">Logout</a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <li class="nav-item ms-lg-3"><a class="nav-link" href="login.jsp">Log In</a></li>
                    <li class="nav-item ms-lg-2"><a class="btn btn-primary-custom btn-sm" href="signup.jsp">Sign Up</a></li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<main>
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-7">
                    <span class="hero-badge">NEW ARRIVALS: RTX 50 SERIES NOW IN STOCK</span>
                    <h1 class="hero-title">Elevate Your Digital Craft.</h1>
                    <p class="hero-subtitle">High-performance components for creators, gamers, and professionals. Build your dream setup with Techmart.</p>
                    <div class="d-flex gap-3">
                        <a href="shop" class="btn btn-primary-custom btn-lg">Explore Shop</a>
                        <a href="#" class="btn btn-secondary-custom btn-lg">Build Your PC</a>
                    </div>
                </div>
                <div class="col-lg-5 d-none d-lg-block">
                    <img src="https://images.unsplash.com/photo-1591488320449-011701bb6704?auto=format&fit=crop&q=80&w=800" alt="PC Build" class="img-fluid rounded-4 shadow-lg">
                </div>
            </div>
        </div>
    </section>

    <section class="py-5">
        <div class="container">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h2 class="section-title mb-0">Featured Components</h2>
                    <p class="text-white mt-2">Hand-picked gear for maximum performance.</p>
                </div>
                <a href="shop" class="text-primary text-decoration-none fw-bold">View All <i class="bi bi-arrow-right"></i></a>
            </div>
            <div class="row g-4">
                <% if (featuredProducts != null) { 
                    for (Product p : featuredProducts) { %>
                    <div class="col-md-6 col-lg-3">
                        <div class="product-card">
                            <div class="product-img-wrapper">
                                <% if (p.getImagePath() != null && !p.getImagePath().isEmpty()) { 
                                       String imageSrc = p.getImagePath().startsWith("http") ? p.getImagePath() : request.getContextPath() + "/" + p.getImagePath(); %>
                                    <img src="<%= imageSrc %>" alt="<%= p.getName() %>">
                                <% } else { %>
                                    <i class="bi bi-cpu text-white fs-1"></i>
                                <% } %>
                            </div>
                            <div class="product-category">Component</div>
                            <h3 class="product-name"><%= p.getName() %></h3>
                            <div class="d-flex justify-content-between align-items-center mt-4">
                                <span class="product-price">$<%= p.getPrice() %></span>
                                <form action="cart" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                                    <button type="submit" class="btn btn-outline-primary btn-sm rounded-pill px-3">Add</button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } } else { %>
                    <div class="col-12 text-center py-5">
                        <p class="text-white">Loading featured products...</p>
                        <script>window.location.href='home';</script>
                    </div>
                <% } %>
            </div>
        </div>
    </section>

    <section class="py-5 bg-black bg-opacity-25">
        <div class="container">
            <div class="row g-5">
                <div class="col-md-4">
                    <i class="bi bi-truck feature-icon"></i>
                    <h4>Global Shipping</h4>
                    <p class="text-white">Fast and secure delivery to over 50 countries worldwide with real-time tracking.</p>
                </div>
                <div class="col-md-4">
                    <i class="bi bi-shield-check feature-icon"></i>
                    <h4>Extended Warranty</h4>
                    <p class="text-white">Every component comes with a minimum 2-year warranty and premium support.</p>
                </div>
                <div class="col-md-4">
                    <i class="bi bi-headset feature-icon"></i>
                    <h4>Expert Support</h4>
                    <p class="text-white">Our team of PC building experts is available 24/7 to help you with your build.</p>
                </div>
            </div>
        </div>
    </section>
</main>

<footer class="footer">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4">
                <a href="home" class="footer-logo">TECHMART</a>
                <p class="text-white pe-lg-5">Premium technology components for the next generation of computing. Build better, perform faster.</p>
                <div class="d-flex gap-3 mt-4">
                    <a href="#" class="text-white fs-5"><i class="bi bi-twitter-x"></i></a>
                    <a href="#" class="text-white fs-5"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="text-white fs-5"><i class="bi bi-github"></i></a>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <h6 class="fw-bold mb-4">Shop</h6>
                <a href="shop" class="footer-link">All Products</a>
                <a href="#" class="footer-link">CPUs</a>
                <a href="#" class="footer-link">GPUs</a>
                <a href="#" class="footer-link">Storage</a>
            </div>
            <div class="col-6 col-lg-2">
                <h6 class="fw-bold mb-4">Resources</h6>
                <a href="#" class="footer-link">PC Builder</a>
                <a href="#" class="footer-link">Build Guides</a>
                <a href="#" class="footer-link">Blog</a>
            </div>
            <div class="col-lg-4">
                <h6 class="fw-bold mb-4">Newsletter</h6>
                <p class="text-white mb-4">Get the latest tech news and exclusive offers.</p>
                <div class="input-group mb-3">
                    <input type="text" class="form-control bg-dark border-secondary text-white" placeholder="Email address">
                    <button class="btn btn-primary" type="button">Join</button>
                </div>
            </div>
        </div>
        <div class="pt-5 mt-5 border-top border-secondary border-opacity-25 d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
            <p class="text-white small mb-0">&copy; 2026 Techmart Inc. All rights reserved.</p>
            <div class="d-flex gap-4">
                <a href="#" class="text-white small text-decoration-none">Privacy Policy</a>
                <a href="#" class="text-white small text-decoration-none">Terms of Service</a>
                <a href="admin-login" class="text-white small text-decoration-none"><i class="bi bi-shield-lock"></i> Admin</a>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
