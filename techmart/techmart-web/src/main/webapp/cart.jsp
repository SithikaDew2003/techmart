<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.sithikaDev.techmart.entity.Product" %>
<%@ page import="lk.sithikaDev.techmart.entity.Users" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart | Techmart</title>
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
            min-height: 100vh;
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

        .cart-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 30px;
        }

        .item-row {
            border-bottom: 1px solid var(--border-color);
            padding: 24px 0;
        }

        .item-row:last-child {
            border-bottom: none;
        }

        .product-img-thumb {
            width: 80px;
            height: 80px;
            background: #1c1c1e;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .product-img-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .btn-checkout {
            background-color: var(--primary);
            color: #000;
            font-weight: 600;
            padding: 14px;
            border: none;
            border-radius: 12px;
            width: 100%;
            transition: all 0.2s;
        }

        .btn-checkout:hover {
            background-color: var(--primary-dark);
            color: #000;
        }

        a.btn-checkout {
            display: inline-block;
            width: 100%;
            text-decoration: none;
            text-align: center;
        }

        a.btn-checkout:hover {
            text-decoration: none;
            color: #000;
        }
    </style>
</head>
<body>

<%
    Users user = (Users) session.getAttribute("user");
    Map<Integer, Integer> cartItems = (Map<Integer, Integer>) request.getAttribute("cartItems");
    List<Product> products = (List<Product>) request.getAttribute("products");
    
    if (cartItems == null) {
        response.sendRedirect("cart");
        return;
    }
%>

<nav class="navbar navbar-expand-lg sticky-top mb-5">
    <div class="container">
        <a class="navbar-brand" href="home">TECHMART</a>
        <div class="ms-auto">
            <a href="shop" class="btn btn-outline-light btn-sm px-4 rounded-pill">Continue Shopping</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="d-flex align-items-center mb-4">
        <h2 class="fw-bold mb-0">Your Cart</h2>
        <span class="badge bg-secondary ms-3 rounded-pill"><%= cartItems.size() %> Items</span>
    </div>

    <div class="row g-4">
        <div class="col-lg-8">
            <div class="cart-card">
                <%
                    if (products != null && !products.isEmpty()) {
                        double total = 0;
                        for (Product p : products) {
                            if (p != null) {
                                Integer qty = cartItems.get(p.getId());
                                double subtotal = p.getPrice().doubleValue() * qty;
                                total += subtotal;
                %>
                <div class="item-row d-flex align-items-center">
                    <div class="product-img-thumb me-4">
                        <% if (p.getImagePath() != null) { %>
                            <img src="<%= p.getImagePath() %>" alt="<%= p.getName() %>">
                        <% } else { %>
                            <i class="bi bi-cpu text-muted fs-3"></i>
                        <% } %>
                    </div>
                    <div class="flex-grow-1">
                        <h5 class="mb-1 fw-semibold"><%= p.getName() %></h5>
                        <p class="text-muted small mb-0">Unit Price: $<%= p.getPrice() %></p>
                    </div>
                    <div class="text-end" style="min-width: 120px;">
                        <div class="mb-2">
                            <span class="text-muted small me-2">Qty:</span>
                            <span class="fw-bold"><%= qty %></span>
                        </div>
                        <h6 class="mb-2 fw-bold">$<%= String.format("%.2f", subtotal) %></h6>
                        <form action="cart" method="post">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="productId" value="<%= p.getId() %>">
                            <button type="submit" class="btn btn-link text-danger p-0 text-decoration-none small">Remove</button>
                        </form>
                    </div>
                </div>
                <%
                            }
                        }
                %>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="cart-card">
                <h4 class="fw-bold mb-4">Order Summary</h4>
                <div class="d-flex justify-content-between mb-3">
                    <span class="text-muted">Subtotal</span>
                    <span>$<%= String.format("%.2f", total) %></span>
                </div>
                <div class="d-flex justify-content-between mb-4">
                    <span class="text-muted">Shipping</span>
                    <span class="text-primary fw-medium">FREE</span>
                </div>
                <hr class="border-secondary border-opacity-25 mb-4">
                <div class="d-flex justify-content-between align-items-center mb-5">
                    <span class="fs-5 fw-bold">Total</span>
                    <span class="fs-4 fw-bold text-primary">$<%= String.format("%.2f", total) %></span>
                </div>
                
                <% if (user != null) { %>
                    <form action="checkout" method="post">
                        <button type="submit" class="btn btn-checkout">Proceed to Checkout</button>
                    </form>
                <% } else { %>
                    <div class="alert alert-info alert-dismissible fade show mb-3" role="alert">
                        <i class="bi bi-info-circle me-2"></i>
                        <strong>Sign in required!</strong> You must sign in or create an account to complete your purchase.
                    </div>
                    <a href="login" class="btn btn-checkout mb-3" style="display: inline-block; width: 100%; text-decoration: none; text-align: center; cursor: pointer;">Sign In to Checkout</a>
                    <p class="text-center text-muted small mb-0 mt-3">Don't have an account? <a href="signup" class="text-primary fw-semibold">Sign up here</a></p>
                <% } %>
                
                <div class="mt-4 text-center">
                    <p class="text-muted small mb-0"><i class="bi bi-shield-lock me-1"></i> Secure Checkout Guaranteed</p>
                </div>
            </div>
        </div>
        <%
                    } else {
        %>
        <div class="col-12">
            <div class="cart-card text-center py-5">
                <i class="bi bi-cart-x text-muted display-1 mb-4"></i>
                <h3 class="fw-bold">Your cart is empty</h3>
                <p class="text-muted mb-4">Looks like you haven't added anything to your cart yet.</p>
                <a href="shop" class="btn btn-primary px-5 py-3 rounded-pill fw-bold">Start Shopping</a>
            </div>
        </div>
        <%
                    }
        %>
    </div>
</div>

<footer class="mt-5 py-4 border-top border-secondary border-opacity-10 text-center">
    <p class="text-muted small mb-0">&copy; 2026 Techmart. All rights reserved.</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
