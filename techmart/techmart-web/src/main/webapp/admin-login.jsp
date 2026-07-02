<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - TechMart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gold: #D4AF37;
            --dark-bg: #121212;
            --card-bg: #1E1E1E;
        }
        body {
            background-color: var(--dark-bg);
            color: #ffffff;
            font-family: 'Poppins', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background-color: var(--card-bg);
            border: 1px solid var(--primary-gold);
            border-radius: 15px;
            padding: 2rem;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }
        .btn-gold {
            background-color: var(--primary-gold);
            color: var(--dark-bg);
            font-weight: 600;
        }
        .btn-gold:hover {
            background-color: #C5A028;
            color: var(--dark-bg);
        }
        .form-control {
            background-color: #2C2C2C;
            border: 1px solid #444;
            color: white;
        }
        .form-control:focus {
            background-color: #333;
            border-color: var(--primary-gold);
            color: white;
            box-shadow: none;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <h2 class="text-center mb-4" style="color: var(--primary-gold);">Admin Login</h2>
        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-danger py-2 text-center small"><%= request.getAttribute("error") %></div>
        <% } %>
        <form action="admin-login" method="post">
            <div class="mb-3">
                <label class="form-label small">Email Address</label>
                <input type="email" name="email" class="form-control" required>
            </div>
            <div class="mb-4">
                <label class="form-label small">Password</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-gold w-100 py-2">Sign In as Admin</button>
        </form>
        <div class="mt-3 text-center">
            <a href="index.jsp" class="text-muted small text-decoration-none">Back to Store</a>
        </div>
    </div>
</body>
</html>
