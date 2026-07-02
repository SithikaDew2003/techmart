<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.sithikaDev.techmart.entity.Product" %>
<%@ page import="lk.sithikaDev.techmart.entity.Users" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel - TechMart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-gold: #D4AF37;
            --dark-bg: #121212;
            --card-bg: #1E1E1E;
        }
        body { background-color: var(--dark-bg); color: #ffffff; }
        .navbar { background-color: var(--card-bg); border-bottom: 1px solid var(--primary-gold); }
        .card { background-color: var(--card-bg); border: 1px solid #333; }
        .nav-tabs .nav-link { color: #aaa; border: none; }
        .nav-tabs .nav-link.active { background: transparent; color: var(--primary-gold); border-bottom: 2px solid var(--primary-gold); }
        .btn-gold { background-color: var(--primary-gold); color: var(--dark-bg); font-weight: 600; }
        .table { color: #eee; }
        .table thead { color: var(--primary-gold); }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#" style="color: var(--primary-gold);">TechMart ADMIN</a>
            <div class="d-flex">
                <span class="text-white-50 me-3">Welcome, <%= ((Users)session.getAttribute("admin")).getFirstName() %></span>
                <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <ul class="nav nav-tabs mb-4" id="adminTabs" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" id="products-tab" data-bs-toggle="tab" data-bs-target="#products" type="button">Manage Products</button>
            </li>
            <li class="nav-item">
                <button class="nav-link" id="users-tab" data-bs-toggle="tab" data-bs-target="#users" type="button">Manage Users</button>
            </li>
        </ul>

        <div class="tab-content" id="adminTabsContent">
            <!-- Products Tab -->
            <div class="tab-pane fade show active" id="products" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3>Product Inventory</h3>
                    <button class="btn btn-gold btn-sm" data-bs-toggle="modal" data-bs-target="#addProductModal">
                        <i class="bi bi-plus-lg me-1"></i> Add New Product
                    </button>
                </div>
                <div class="card p-3">
                    <div class="table-responsive">
                        <table class="table table-dark table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Image</th>
                                    <th>Name</th>
                                    <th>Price</th>
                                    <th>Stock</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Product> products = (List<Product>) request.getAttribute("products");
                                    if (products != null) {
                                        for (Product product : products) {
                                %>
                                    <tr>
                                        <td><%= product.getId() %></td>
                                        <td>
                                            <img src="<%= product.getImagePath() %>" alt="<%= product.getName() %>" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px;">
                                        </td>
                                        <td><%= product.getName() %></td>
                                        <td>$<%= product.getPrice() %></td>
                                        <td><%= product.getStockQuantity() %></td>
                                        <td>
                                            <a href="admin-panel?action=deleteProduct&id=<%= product.getId() %>" class="btn btn-danger btn-sm" onclick="return confirm('Delete this product?')">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Users Tab -->
            <div class="tab-pane fade" id="users" role="tabpanel">
                <h3>User Management</h3>
                <div class="card p-3">
                    <div class="table-responsive">
                        <table class="table table-dark table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Type</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Users> users = (List<Users>) request.getAttribute("users");
                                    if (users != null) {
                                        for (Users u : users) {
                                %>
                                    <tr>
                                        <td><%= u.getId() %></td>
                                        <td><%= u.getFirstName() %> <%= u.getLastName() %></td>
                                        <td><%= u.getEmail() %></td>
                                        <td><span class="badge <%= "ADMIN".equals(u.getUserType().toString()) ? "bg-warning" : "bg-info" %>"><%= u.getUserType() %></span></td>
                                        <td>
                                            <a href="admin-panel?action=deleteUser&id=<%= u.getId() %>" class="btn btn-danger btn-sm" onclick="return confirm('Delete this user?')">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Product Modal -->
    <div class="modal fade" id="addProductModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content bg-dark border-gold">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-gold">Add New Product</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="admin-panel" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="addProduct">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Product Name</label>
                            <input type="text" name="name" class="form-control bg-secondary text-white border-0" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-control bg-secondary text-white border-0" rows="3"></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Price ($)</label>
                                <input type="number" step="0.01" name="price" class="form-control bg-secondary text-white border-0" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Stock Quantity</label>
                                <input type="number" name="stock" class="form-control bg-secondary text-white border-0" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Product Image</label>
                            <input type="file" name="image" class="form-control bg-secondary text-white border-0" accept="image/*">
                        </div>
                    </div>
                    <div class="modal-footer border-secondary">
                        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-gold">Save Product</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <style>
        .border-gold { border: 1px solid var(--primary-gold); }
        .text-gold { color: var(--primary-gold); }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
