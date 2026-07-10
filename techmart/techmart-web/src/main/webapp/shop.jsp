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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        :root {
            --bg: #0a0d12;
            --bg-soft: #10151d;
            --panel: rgba(16, 21, 29, 0.88);
            --panel-strong: #151b24;
            --line: rgba(255, 255, 255, 0.09);
            --text: #f8fafc;
            --muted: #cbd5e1;
            --accent: #5eead4;
            --accent-2: #60a5fa;
            --warning: #fbbf24;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            color: var(--text);
            background:
                radial-gradient(circle at top left, rgba(94, 234, 212, 0.18), transparent 26%),
                radial-gradient(circle at 85% 15%, rgba(96, 165, 250, 0.16), transparent 22%),
                linear-gradient(180deg, #0a0d12 0%, #0b1017 100%);
        }

        .text-muted {
            color: var(--muted) !important;
        }

        .navbar {
            background: rgba(10, 13, 18, 0.7);
            backdrop-filter: blur(18px);
            border-bottom: 1px solid var(--line);
        }

        .navbar-brand {
            font-weight: 800;
            letter-spacing: 0.08em;
            color: var(--text) !important;
        }

        .navbar-brand span {
            color: var(--accent);
        }

        .hero {
            padding: 42px 0 22px;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            border-radius: 999px;
            border: 1px solid rgba(94, 234, 212, 0.22);
            background: rgba(94, 234, 212, 0.08);
            color: #b8fff1;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .hero h1 {
            font-size: clamp(2.2rem, 5vw, 4.4rem);
            line-height: 0.95;
            letter-spacing: -0.05em;
            margin: 18px 0 14px;
            font-weight: 800;
        }

        .hero p {
            max-width: 660px;
            color: var(--muted);
            font-size: 1.02rem;
        }

        .filter-panel,
        .product-card,
        .info-card {
            background: linear-gradient(180deg, rgba(21, 27, 36, 0.96), rgba(16, 21, 29, 0.96));
            border: 1px solid var(--line);
            border-radius: 24px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.24);
        }

        .filter-panel {
            padding: 22px;
            position: sticky;
            top: 92px;
        }

        .filter-title {
            font-size: 0.78rem;
            letter-spacing: 0.16em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 14px;
        }

        .field-label {
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 8px;
            color: #d6dbe4;
        }

        .form-control-custom,
        .form-select-custom {
            background: rgba(255, 255, 255, 0.04) !important;
            border: 1px solid var(--line) !important;
            color: var(--text) !important;
            border-radius: 14px !important;
            padding: 12px 14px;
        }

        .form-control-custom:focus,
        .form-select-custom:focus {
            border-color: rgba(94, 234, 212, 0.5) !important;
            box-shadow: 0 0 0 4px rgba(94, 234, 212, 0.1) !important;
        }

        .form-control-custom::placeholder {
            color: #768294;
        }

        .input-group .form-control-custom {
            border-right: none !important;
        }

        .input-group-text-custom {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--line);
            border-right: none;
            color: var(--muted);
            border-radius: 14px 0 0 14px !important;
        }

        .btn-accent {
            background: linear-gradient(135deg, var(--accent), #93c5fd);
            border: none;
            color: #04111a;
            font-weight: 800;
            border-radius: 14px;
        }

        .btn-accent:hover {
            filter: brightness(1.02);
            color: #04111a;
        }

        .btn-dark-outline {
            background: transparent;
            border: 1px solid var(--line);
            color: var(--text);
            border-radius: 14px;
        }

        .btn-dark-outline:hover {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text);
        }

        .product-card {
            height: 100%;
            overflow: hidden;
            transition: transform .24s ease, border-color .24s ease, box-shadow .24s ease;
            display: flex;
            flex-direction: column;
        }

        .product-card:hover {
            transform: translateY(-6px);
            border-color: rgba(94, 234, 212, 0.26);
            box-shadow: 0 24px 60px rgba(0, 0, 0, 0.32);
        }

        .product-media {
            aspect-ratio: 1 / 1;
            background: radial-gradient(circle at top, rgba(96, 165, 250, 0.12), rgba(255, 255, 255, 0.02));
            border-bottom: 1px solid var(--line);
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .product-media img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .product-body {
            padding: 18px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .product-name {
            font-size: 1.05rem;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .product-description {
            color: var(--muted);
            font-size: 0.92rem;
            min-height: 44px;
            margin-bottom: 14px;
        }

        .price {
            font-size: 1.18rem;
            font-weight: 800;
            color: #ffffff !important;
            text-shadow: 0 1px 0 rgba(0, 0, 0, 0.35);
        }

        .stock-chip {
            border: 1px solid var(--line);
            color: #c9d2dd;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 999px;
            font-size: 0.8rem;
            padding: 6px 10px;
        }

        .range-wrap {
            padding: 14px 0 4px;
        }

        .range-value {
            color: #dbe5ef;
            font-size: 0.9rem;
        }

        .quick-filter {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .quick-filter a {
            text-decoration: none;
            color: #dbe5ef;
            border: 1px solid var(--line);
            background: rgba(255, 255, 255, 0.03);
            padding: 8px 12px;
            border-radius: 999px;
            font-size: 0.85rem;
        }

        .quick-filter a:hover {
            border-color: rgba(94, 234, 212, 0.28);
            background: rgba(94, 234, 212, 0.08);
        }

        .section-head {
            display: flex;
            align-items: end;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 18px;
        }

        .section-head h2 {
            font-weight: 800;
            letter-spacing: -0.03em;
            margin: 0;
        }

        .section-head p {
            color: var(--muted);
            margin: 6px 0 0;
        }

        .empty-state {
            padding: 64px 20px;
            text-align: center;
        }

        .empty-state i {
            font-size: 3rem;
            color: rgba(94, 234, 212, 0.75);
        }

        .footer {
            margin-top: 64px;
            padding: 28px 0 40px;
            color: var(--muted);
            border-top: 1px solid var(--line);
        }

        .dropdown-menu-dark {
            background: #121823;
            border: 1px solid var(--line);
        }

        .dropdown-item {
            color: var(--text);
        }

        .dropdown-item:hover,
        .dropdown-item:focus {
            background: rgba(94, 234, 212, 0.12);
            color: var(--text);
        }

        .price-bar {
            height: 4px;
            border-radius: 999px;
            background: linear-gradient(90deg, rgba(94, 234, 212, 0.2), rgba(96, 165, 250, 0.45));
        }

        .btn-accent.w-100 {
            box-shadow: 0 12px 24px rgba(94, 234, 212, 0.18);
        }

        .btn-accent.w-100:hover {
            box-shadow: 0 16px 32px rgba(94, 234, 212, 0.24);
        }

        .product-body .mt-auto {
            padding-top: 12px;
        }

        .product-body form {
            margin-top: 10px;
        }
    </style>
</head>
<body>
<%
    Users user = (Users) session.getAttribute("user");
    String searchValue = request.getParameter("search") != null ? request.getParameter("search") : "";
    String minPriceValue = request.getParameter("minPrice") != null ? request.getParameter("minPrice") : "";
    String maxPriceValue = request.getParameter("maxPrice") != null ? request.getParameter("maxPrice") : "";
    String sortValue = request.getParameter("sortBy") != null ? request.getParameter("sortBy") : "featured";
    String filterError = (String) request.getAttribute("filterError");
%>

<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container py-2">
        <a class="navbar-brand" href="home">TECH<span>MART</span></a>
        <div class="ms-auto d-flex align-items-center gap-2">
            <a href="cart" class="btn btn-dark-outline btn-sm px-3">
                <i class="bi bi-cart3 me-1"></i>Cart
            </a>
            <a href="home" class="btn btn-dark-outline btn-sm px-3">Home</a>
            <% if (user == null) { %>
                <a href="login" class="btn btn-accent btn-sm px-3">Sign in</a>
            <% } else { %>
                <span class="text-muted small d-none d-md-inline">Welcome, <%= user.getFirstName() %></span>
            <% } %>
        </div>
    </div>
</nav>

<div class="container hero">
    <div class="hero-badge"><i class="bi bi-phone"></i> Phones only, filtered by your budget</div>
    <h1>Find the right phone without category noise.</h1>
    <p>Search by model, set a budget range, and sort like a real storefront. The page focuses on what matters for phones: price, stock, and fast decisions.</p>
</div>

<div class="container pb-4">
    <div class="row g-4">
        <div class="col-lg-3">
            <div class="filter-panel">
                <div class="filter-title">Refine results</div>

                <form action="shop" method="get" id="filterForm">
                    <div class="mb-3">
                        <label class="field-label">Search phones</label>
                        <div class="input-group">
                            <span class="input-group-text input-group-text-custom"><i class="bi bi-search"></i></span>
                            <input type="text" name="search" class="form-control form-control-custom" placeholder="iPhone, Galaxy, Pixel" value="<%= searchValue %>">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="field-label">Sort by</label>
                        <select name="sortBy" class="form-select form-select-custom">
                            <option value="featured" <%= "featured".equals(sortValue) ? "selected" : "" %>>Featured</option>
                            <option value="price_asc" <%= "price_asc".equals(sortValue) ? "selected" : "" %>>Price: Low to High</option>
                            <option value="price_desc" <%= "price_desc".equals(sortValue) ? "selected" : "" %>>Price: High to Low</option>
                            <option value="name_asc" <%= "name_asc".equals(sortValue) ? "selected" : "" %>>Name: A to Z</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="field-label">Budget range</label>
                        <div class="row g-2">
                            <div class="col-6">
                                <input type="number" name="minPrice" id="minPriceInput" class="form-control form-control-custom" placeholder="Min" min="0" step="0.01" value="<%= minPriceValue %>">
                            </div>
                            <div class="col-6">
                                <input type="number" name="maxPrice" id="maxPriceInput" class="form-control form-control-custom" placeholder="Max" min="0" step="0.01" value="<%= maxPriceValue %>">
                            </div>
                        </div>
                        <div class="range-wrap">
                            <input type="range" class="form-range" id="priceRange" min="0" max="5000" value="<%= maxPriceValue != null && !maxPriceValue.isEmpty() ? maxPriceValue : "2500" %>">
                            <div class="d-flex justify-content-between range-value">
                                <span>$0</span>
                                <span id="rangeValue">$<%= maxPriceValue != null && !maxPriceValue.isEmpty() ? maxPriceValue : "2500" %></span>
                            </div>
                            <div class="price-bar mt-2"></div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="field-label">Quick budgets</div>
                        <div class="quick-filter">
                            <a href="#" data-min="0" data-max="300">Budget</a>
                            <a href="#" data-min="300" data-max="700">Mid-range</a>
                            <a href="#" data-min="700" data-max="1500">Premium</a>
                            <a href="#" data-min="1500" data-max="5000">Flagship</a>
                        </div>
                    </div>

                    <% if (filterError != null) { %>
                        <div class="alert alert-danger py-2 small"><%= filterError %></div>
                    <% } %>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-accent py-2">Apply Filters</button>
                        <a href="shop" class="btn btn-dark-outline py-2">Reset</a>
                    </div>
                </form>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="section-head">
                <div>
                    <h2>Available phones</h2>
                    <p>Showing products matched to your search and price range.</p>
                </div>
                <div class="d-none d-md-flex gap-2">
                    <span class="stock-chip"><i class="bi bi-lightning-charge me-1"></i>Fast checkout</span>
                    <span class="stock-chip"><i class="bi bi-shield-check me-1"></i>Trusted orders</span>
                </div>
            </div>

            <%
                List<Product> products = (List<Product>) request.getAttribute("products");
                boolean hasSearch = searchValue != null && !searchValue.trim().isEmpty();
                boolean hasPriceFilter = (minPriceValue != null && !minPriceValue.isEmpty()) || (maxPriceValue != null && !maxPriceValue.isEmpty());
                boolean hasFilters = hasSearch || hasPriceFilter || (sortValue != null && !"featured".equals(sortValue));
            %>

            <div class="row g-4">
                <%
                    if (products != null && !products.isEmpty()) {
                        for (Product p : products) {
                %>
                <div class="col-md-6 col-xl-4">
                    <div class="product-card">
                        <div class="product-media">
                            <% if (p.getImagePath() != null && !p.getImagePath().isEmpty()) { %>
                                <%
                                    String imageSrc = p.getImagePath().startsWith("http") ? p.getImagePath() : request.getContextPath() + "/" + p.getImagePath();
                                %>
                                <img src="<%= imageSrc %>" alt="<%= p.getName() %>">
                            <% } else { %>
                                <i class="bi bi-phone text-muted" style="font-size: 3rem;"></i>
                            <% } %>
                        </div>
                        <div class="product-body d-flex flex-column h-100">
                            <h5 class="product-name"><%= p.getName() %></h5>
                            <p class="product-description"><%= p.getDescription() %></p>
                            <div class="mt-auto">
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <div class="price">$<%= p.getPrice() %></div>
                                    <div class="stock-chip">Stock <%= p.getStockQuantity() %></div>
                                </div>
                                <form action="cart" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                                    <button type="submit" class="btn btn-accent w-100 py-2">Add to Cart</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="col-12">
                    <div class="info-card empty-state">
                        <i class="bi bi-search"></i>
                        <h4 class="mt-3 fw-bold">No phones found</h4>
                        <p class="text-muted mb-4">
                            <% if (hasFilters) { %>
                                Try widening the price range or clearing the filters.
                            <% } else { %>
                                No products are available yet.
                            <% } %>
                        </p>
                        <a href="shop" class="btn btn-accent px-4 py-2">Reset filters</a>
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
    <div class="container d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
        <div>&copy; 2026 Techmart</div>
        <div>Phones only. Curated pricing. Fast checkout.</div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        const range = document.getElementById('priceRange');
        const rangeValue = document.getElementById('rangeValue');
        const minPriceInput = document.getElementById('minPriceInput');
        const maxPriceInput = document.getElementById('maxPriceInput');
        const quickLinks = document.querySelectorAll('.quick-filter a');

        function syncRange() {
            if (!range || !rangeValue || !maxPriceInput) return;
            rangeValue.textContent = '$' + range.value;
            maxPriceInput.value = range.value;
        }

        if (range) {
            range.addEventListener('input', syncRange);
        }

        quickLinks.forEach(function (link) {
            link.addEventListener('click', function (event) {
                event.preventDefault();
                if (minPriceInput) minPriceInput.value = link.dataset.min;
                if (maxPriceInput) maxPriceInput.value = link.dataset.max;
                if (range) {
                    range.value = link.dataset.max;
                    syncRange();
                }
                document.getElementById('filterForm').submit();
            });
        });

        syncRange();
    })();
</script>
</body>
</html>
