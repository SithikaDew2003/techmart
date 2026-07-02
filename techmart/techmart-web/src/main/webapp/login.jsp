<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log In | Techmart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        :root {
            --primary: #00d2ff;
            --primary-dark: #00a1c2;
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
            display: flex;
            align-items: center;
        }

        .login-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 48px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        }

        .login-header h1 {
            color: var(--primary);
            font-weight: 800;
            letter-spacing: -1px;
            margin-bottom: 8px;
        }

        .form-label {
            color: var(--text-muted);
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .form-control {
            background-color: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-color);
            color: var(--text-main);
            padding: 12px 16px;
            border-radius: 12px;
            transition: all 0.2s;
        }

        .form-control:focus {
            background-color: rgba(255, 255, 255, 0.08);
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(0, 210, 255, 0.1);
            color: var(--text-main);
        }

        .btn-login {
            background-color: var(--primary);
            color: #000;
            padding: 14px;
            font-weight: 600;
            border-radius: 12px;
            width: 100%;
            margin-top: 24px;
            border: none;
            transition: all 0.2s;
        }

        .btn-login:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }

        .footer-text {
            text-align: center;
            margin-top: 32px;
            color: var(--text-muted);
            font-size: 0.875rem;
        }

        .footer-text a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8 col-lg-5 col-xl-4">
            <div class="login-card">
                <div class="login-header text-center mb-5">
                    <h1>TECHMART</h1>
                    <p class="text-muted">Welcome back</p>
                </div>

                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger small mb-4 py-3 px-4 rounded-3">
                        <i class="bi bi-exclamation-circle-fill me-2"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="login" method="post">
                    <div class="mb-4">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" class="form-control" id="email" name="email" required placeholder="name@example.com">
                    </div>
                    <div class="mb-2">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" name="password" required placeholder="••••••••">
                    </div>
                    <div class="text-end mb-4">
                        <a href="#" class="text-primary small text-decoration-none">Forgot password?</a>
                    </div>
                    <button type="submit" class="btn btn-login">Sign In</button>
                </form>

                <div class="footer-text">
                    New to Techmart? <a href="signup.jsp">Create an account</a>
                </div>
                
                <div class="mt-4 text-center">
                    <a href="home" class="text-muted small text-decoration-none"><i class="bi bi-arrow-left me-1"></i> Back to Store</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
