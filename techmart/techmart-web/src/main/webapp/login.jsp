<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log In | Techmart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        :root {
            --dark-bg: #0f0f0f;
            --dark-card: #1a1a1a;
            --golden-yellow: #ffcc00;
            --golden-hover: #e6b800;
            --text-light: #f8f9fa;
            --text-dim: #adb5bd;
            --error-red: #ff4d4d;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--dark-bg);
            color: var(--text-light);
            min-height: 100vh;
            display: flex;
            align-items: center;
            background-image: radial-gradient(circle at 50% 50%, #1a1a1a 0%, #0f0f0f 100%);
        }

        .login-card {
            background-color: var(--dark-card);
            border: 1px solid rgba(255, 204, 0, 0.15);
            border-radius: 16px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.6);
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .login-header {
            padding: 40px 40px 20px;
            text-align: center;
        }

        .login-header h1 {
            color: var(--golden-yellow);
            font-weight: 600;
            letter-spacing: 3px;
            margin-bottom: 10px;
        }

        .form-container {
            padding: 0 40px 40px;
        }

        .form-label {
            color: var(--text-dim);
            font-size: 0.85rem;
            margin-bottom: 6px;
        }

        .form-control {
            background-color: #252525;
            border: 1px solid #333;
            color: var(--text-light);
            padding: 12px 15px;
            border-radius: 8px;
        }

        .form-control:focus {
            background-color: #2a2a2a;
            border-color: var(--golden-yellow);
            color: var(--text-light);
            box-shadow: 0 0 0 0.25rem rgba(255, 204, 0, 0.15);
        }

        .btn-login {
            background-color: var(--golden-yellow);
            border: none;
            color: #000;
            padding: 14px;
            font-weight: 600;
            border-radius: 8px;
            text-transform: uppercase;
            width: 100%;
            margin-top: 15px;
            transition: all 0.3s ease;
        }

        .btn-login:hover {
            background-color: var(--golden-hover);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 204, 0, 0.3);
        }

        .footer-text {
            text-align: center;
            color: var(--text-dim);
            font-size: 0.9rem;
            margin-top: 20px;
        }

        .footer-text a {
            color: var(--golden-yellow);
            text-decoration: none;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8 col-lg-4">
            <div class="login-card">
                <div class="login-header">
                    <h1>TECHMART</h1>
                    <p class="text-dim">Login to your account</p>
                </div>

                <div class="form-container">
                    <% if(request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger small mb-4">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>

                    <form action="login" method="post">
                        <div class="mb-3">
                            <label for="email" class="form-label">Email Address</label>
                            <input type="email" class="form-control" id="email" name="email" required placeholder="name@example.com">
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required placeholder="••••••••">
                        </div>
                        <button type="submit" class="btn btn-login">Log In</button>
                    </form>

                    <div class="footer-text">
                        Don't have an account? <a href="signup.jsp">Sign up</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
