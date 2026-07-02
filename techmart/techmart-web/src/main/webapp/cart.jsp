<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.sithikaDev.techmart.entity.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart | Techmart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        :root {
            --dark-bg: #0f0f0f;
            --dark-card: #1a1a1a;
            --golden-yellow: #ffcc00;
            --text-light: #f8f9fa;
            --text-dim: #adb5bd;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--dark-bg);
            color: var(--text-light);
            background-image: radial-gradient(circle at 50% 50%, #1a1a1a 0%, #0f0f0f 100%);
            min-height: 100vh;
        }

        .navbar {
            background-color: rgba(15, 15, 15, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 204, 0, 0.1);
        }

        .cart-card {
            background-color: var(--dark-card);
            border: 1px solid rgba(255, 204, 0, 0.1);
            border-radius: 12px;
        }

        .item-row {
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            padding: 20px 0;
        }

        .item-row:last-child {
            border-bottom: none;
        }

        .btn-checkout {
            background-color: var(--golden-yellow);
            color: #000;
            font-weight: 600;
            padding: 12px 30px;
            border: none;
        }

        .btn-checkout:hover {
            background-color: #e6b800;
        }
    </style>
</head>
<body>

<%
    Map<Integer, Integer> cartItems = (Map<Integer, Integer>) request.getAttribute("cartItems");
    List<Product> products = (List<Product>) request.getAttribute("products");
    
    // Redirect to servlet if accessed directly without attributes
    if (cartItems == null) {
        response.sendRedirect("cart");
        return;
    }
%>

<nav class="navbar navbar-expand-lg sticky-top mb-5">
    <div class="container">
        <a class="navbar-brand text-warning fw-bold" href="index.jsp">TECHMART</a>
        <div class="ms-auto">
            <a href="shop" class="btn btn-outline-warning btn-sm">Continue Shopping</a>
        </div>
    </div>
</nav>

<div class="container">
    <h2 class="mb-4 text-warning"><i class="bi bi-cart3 me-2"></i>Shopping Cart</h2>

    <div class="row">
        <div class="col-lg-8">
            <div class="cart-card p-4">
                <%
                    if (products != null && !products.isEmpty()) {
                        double total = 0;
                        for (Product p : products) {
                            if (p != null) {
                                Integer qty = cartItems.get(p.getId());
                                double subtotal = p.getPrice().doubleValue() * qty;
                                total += subtotal;
                %>
                <div class="item-row d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div class="bg-dark p-2 rounded me-3">
                            <i class="bi bi-box text-warning fs-3"></i>
                        </div>
                        <div>
                            <h5 class="mb-0 text-warning"><%= p.getName() %></h5>
                            <small class="text-dim">Price: $<%= p.getPrice() %></small>
                        </div>
                    </div>
                    <div class="text-end">
                        <div class="mb-2">
                            <span class="badge bg-secondary">Qty: <%= qty %></span>
                        </div>
                        <h6 class="mb-0">$<%= String.format("%.2f", subtotal) %></h6>
                        <form action="cart" method="post" class="mt-2">
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
            <div class="cart-card p-4">
                <h4 class="text-warning mb-4">Summary</h4>
                <div class="d-flex justify-content-between mb-3">
                    <span class="text-dim">Subtotal</span>
                    <span>$<%= String.format("%.2f", total) %></span>
                </div>
                <div class="d-flex justify-content-between mb-4">
                    <span class="text-dim">Shipping</span>
                    <span class="text-success">FREE</span>
                </div>
                <hr class="border-secondary">
                <div class="d-flex justify-content-between mb-5">
                    <span class="fs-4">Total</span>
                    <span class="fs-4 text-warning fw-bold">$<%= String.format("%.2f", total) %></span>
                </div>
                <form action="checkout" method="post">
                    <button type="submit" class="btn btn-checkout w-100 py-3 rounded-pill">Proceed to Checkout</button>
                </form>
            </div>
        </div>
        <%
                    } else {
        %>
        <div class="col-12 text-center py-5">
            <div class="cart-card p-5">
                <i class="bi bi-cart-x text-dim display-1 mb-4"></i>
                <h3 class="text-dim">Your cart is empty</h3>
                <a href="shop" class="btn btn-warning mt-4 px-5 py-3 rounded-pill fw-bold">Start Shopping</a>
            </div>
        </div>
        <%
                    }
        %>
    </div>
</div>

</body>
</html>
