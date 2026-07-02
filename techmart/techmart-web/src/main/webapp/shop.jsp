<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.sithikaDev.techmart.entity.Product" %>
<%@ page import="lk.sithikaDev.techmart.entity.Users" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop | Techmart</title>
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
            --text-muted: #a1a1a6;
            --border-color: rgba(255, 255, 255, 0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--dark-bg);
            color: var(--text-main);
            margin: 0;
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
            color: var(--primary) !important;
        }

        .product-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 24px;
            transition: transform 0.3s ease, border-color 0.3s ease;
            height: 100%;
            display: flex;
            flex-column: column;
        }

        .product-card:hover {
            transform: translateY(-8px);
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

        .product-name {
            font-size: 1.15rem;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text-main);
        }

        .product-description {
            font-size: 0.875rem;
            color: var(--text-muted);
            margin-bottom: 20px;
            flex-grow: 1;
        }

        .product-price {
            font-size: 1.25rem;
            font-weight: 700;
        }

        .btn-add-cart {
            background-color: var(--primary);
            color: #000;
            border: none;
            font-weight: 600;
            border-radius: 10px;
            padding: 10px;
            width: 100%;
            margin-top: 15px;
            transition: all 0.2s;
        }

        .btn-add-cart:hover {
            background-color: var(--primary-dark);
            color: #000;
        }

        .sidebar {
            background-color: var(--card-bg);
            border-radius: 20px;
            padding: 24px;
            border: 1px solid var(--border-color);
            position: sticky;
            top: 100px;
        }

        .filter-title {
            font-size: 1rem;
            font-weight: 700;
            margin-bottom: 16px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .filter-link {
            display: block;
            color: var(--text-muted);
            text-decoration: none;
            margin-bottom: 10px;
            transition: color 0.2s;
        }

        .filter-link:hover, .filter-link.active {
            color: var(--primary);
        }

        .footer {
            padding: 60px 0 30px;
            border-top: 1px solid var(--border-color);
            margin-top: 80px;
            background-color: rgba(0,0,0,0.3);
        }
    </style>
</head>
<body>

<%
    Users user = (Users) session.getAttribute("user");
%>

<nav class="navbar navbar-expand-lg sticky-top mb-5">
    <div class="container">
        <a class="navbar-brand" href="home">TECHMART</a>
        <div class="ms-auto d-flex align-items-center">
            <a href="cart" class="text-white me-4 position-relative">
                <i class="bi bi-cart3 fs-4"></i>
            </a>
            <a href="home" class="btn btn-outline-light btn-sm px-3 rounded-pill">Home</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="row g-4">
        <div class="col-lg-3 d-none d-lg-block">
            <div class="sidebar">
                <h5 class="filter-title">Categories</h5>
                <a href="#" class="filter-link active">All Products</a>
                <a href="#" class="filter-link">Processors</a>
                <a href="#" class="filter-link">Graphics Cards</a>
                <a href="#" class="filter-link">Motherboards</a>
                <a href="#" class="filter-link">Memory</a>
                <a href="#" class="filter-link">Storage</a>
                
                <h5 class="filter-title mt-4">Price Range</h5>
                <div class="mt-2">
                    <input type="range" class="form-range" min="0" max="5000" id="priceRange">
                    <div class="d-flex justify-content-between small text-muted">
                        <span>$0</span>
                        <span>$5000</span>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold mb-0">Products</h2>
                <div class="dropdown">
                    <button class="btn btn-secondary btn-sm dropdown-toggle rounded-pill" type="button" data-bs-toggle="dropdown">
                        Sort by: Featured
                    </button>
                    <ul class="dropdown-menu dropdown-menu-dark">
                        <li><a class="dropdown-item" href="#">Price: Low to High</a></li>
                        <li><a class="dropdown-item" href="#">Price: High to Low</a></li>
                        <li><a class="dropdown-item" href="#">Newest First</a></li>
                    </ul>
                </div>
            </div>

            <div class="row g-4">
                <%
                    List<Product> products = (List<Product>) request.getAttribute("products");
                    if (products != null && !products.isEmpty()) {
                        for (Product p : products) {
                %>
                <div class="col-md-6 col-lg-4">
                    <div class="product-card d-flex flex-column">
                        <div class="product-img-wrapper">
                            <% if (p.getImagePath() != null && !p.getImagePath().isEmpty()) { %>
                                <img src="<%= p.getImagePath() %>" alt="<%= p.getName() %>">
                            <% } else { %>
                                <i class="bi bi-cpu text-muted fs-1"></i>
                            <% } %>
                        </div>
                        <h5 class="product-name"><%= p.getName() %></h5>
                        <p class="product-description"><%= p.getDescription() %></p>
                        <div class="mt-auto">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="product-price">$<%= p.getPrice() %></span>
                                <span class="badge rounded-pill bg-dark text-muted border border-secondary border-opacity-25">Stock: <%= p.getStockQuantity() %></span>
                            </div>
                            <form action="cart" method="post">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="<%= p.getId() %>">
                                <button type="submit" class="btn btn-add-cart">Add to Cart</button>
                            </form>
                        </div>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="col-12 text-center py-5">
                    <div class="bg-card p-5 rounded-4 border border-secondary border-opacity-10">
                        <i class="bi bi-search fs-1 text-muted mb-3 d-block"></i>
                        <p class="text-muted">No products available at the moment.</p>
                        <a href="home" class="btn btn-primary mt-3">Back to Home</a>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</div>

<footer class="footer">
    <div class="container text-center">
        <p class="text-muted small mb-0">&copy; 2026 Techmart Inc. Premium Tech Components.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
