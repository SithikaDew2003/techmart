<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up | Techmart</title>
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
            --error-red: #ff4d4d;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--dark-bg);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }

        .signup-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 48px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        }

        .signup-header h1 {
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

        .form-control.is-invalid {
            border-color: var(--error-red);
        }

        .btn-signup {
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

        .btn-signup:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }

        .error-message {
            color: var(--error-red);
            font-size: 0.75rem;
            margin-top: 4px;
            min-height: 1rem;
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

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-12 col-md-10 col-lg-7 col-xl-6">
            <div class="signup-card">
                <div class="signup-header text-center mb-5">
                    <h1>TECHMART</h1>
                    <p class="text-muted">Create your professional tech account</p>
                </div>

                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger small mb-4 py-3 px-4 rounded-3">
                        <i class="bi bi-exclamation-circle-fill me-2"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="signup" method="post" novalidate>
                    <div class="row g-4 mb-3">
                        <div class="col-md-6">
                            <label for="firstName" class="form-label">First Name</label>
                            <input type="text" class="form-control <%= request.getAttribute("firstNameError") != null ? "is-invalid" : "" %>" id="firstName" name="firstName" placeholder="John" value="<%= request.getParameter("firstName") != null ? request.getParameter("firstName") : "" %>">
                            <div class="error-message">
                                <%= request.getAttribute("firstNameError") != null ? request.getAttribute("firstNameError") : "" %>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="lastName" class="form-label">Last Name</label>
                            <input type="text" class="form-control <%= request.getAttribute("lastNameError") != null ? "is-invalid" : "" %>" id="lastName" name="lastName" placeholder="Doe" value="<%= request.getParameter("lastName") != null ? request.getParameter("lastName") : "" %>">
                            <div class="error-message">
                                <%= request.getAttribute("lastNameError") != null ? request.getAttribute("lastNameError") : "" %>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" class="form-control <%= request.getAttribute("emailError") != null ? "is-invalid" : "" %>" id="email" name="email" placeholder="name@example.com" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                        <div class="error-message">
                            <%= request.getAttribute("emailError") != null ? request.getAttribute("emailError") : "" %>
                        </div>
                    </div>

                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control <%= request.getAttribute("passwordError") != null ? "is-invalid" : "" %>" id="password" name="password" placeholder="••••••••">
                            <div class="error-message">
                                <%= request.getAttribute("passwordError") != null ? request.getAttribute("passwordError") : "" %>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="confirmPassword" class="form-label">Confirm Password</label>
                            <input type="password" class="form-control <%= request.getAttribute("confirmPasswordError") != null ? "is-invalid" : "" %>" id="confirmPassword" name="confirmPassword" placeholder="••••••••">
                            <div class="error-message">
                                <%= request.getAttribute("confirmPasswordError") != null ? request.getAttribute("confirmPasswordError") : "" %>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-signup">Create Account</button>
                </form>

                <div class="footer-text">
                    Already part of Techmart? <a href="login.jsp">Sign in</a>
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
