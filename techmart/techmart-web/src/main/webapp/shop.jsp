<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.sithikaDev.techmart.entity.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop | Techmart</title>
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

        .product-card {
            background-color: var(--dark-card);
            border: 1px solid rgba(255, 204, 0, 0.1);
            border-radius: 12px;
            transition: all 0.3s ease;
            height: 100%;
        }

        .product-card:hover {
            transform: translateY(-5px);
            border-color: var(--golden-yellow);
        }

        .product-name {
            color: var(--golden-yellow);
            font-weight: 600;
        }

        .btn-add-cart {
            background-color: var(--golden-yellow);
            color: #000;
            border: none;
            font-weight: 600;
            width: 100%;
        }

        .btn-add-cart:hover {
            background-color: #e6b800;
            color: #000;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg sticky-top mb-5">
    <div class="container">
        <a class="navbar-brand text-warning fw-bold" href="index.jsp">TECHMART</a>
        <div class="ms-auto d-flex align-items-center">
            <a href="cart" class="text-light me-3 position-relative">
                <i class="bi bi-cart3 fs-4"></i>
            </a>
            <a href="index.jsp" class="btn btn-outline-warning btn-sm">Home</a>
        </div>
    </div>
</nav>

<div class="container">
    <h2 class="mb-4 text-warning">Latest Gadgets</h2>
    <div class="row g-4">
        <%
            List<Product> products = (List<Product>) request.getAttribute("products");
            if (products != null && !products.isEmpty()) {
                for (Product p : products) {
        %>
        <div class="col-12 col-md-6 col-lg-3">
            <div class="product-card p-3 d-flex flex-column">
                <div class="mb-3 bg-secondary bg-opacity-10 rounded d-flex align-items-center justify-content-center" style="height: 150px;">
                    <i class="bi bi-cpu text-warning fs-1"></i>
                </div>
                <h5 class="product-name"><%= p.getName() %></h5>
                <p class="text-dim small flex-grow-1"><%= p.getDescription() %></p>
                <div class="d-flex justify-content-between align-items-center mt-3">
                    <span class="fs-5 fw-bold">$<%= p.getPrice() %></span>
                    <span class="badge bg-dark text-warning border border-warning">Stock: <%= p.getStockQuantity() %></span>
                </div>
                <form action="cart" method="post" class="mt-3">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                    <button type="submit" class="btn btn-add-cart py-2">Add to Cart</button>
                </form>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div class="col-12 text-center py-5">
            <p class="text-dim">No products available at the moment.</p>
        </div>
        <%
            }
        %>
    </div>
</div>

</body>
</html>
