<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up | Techmart</title>
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

        .signup-card {
            background-color: var(--dark-card);
            border: 1px solid rgba(255, 204, 0, 0.15);
            border-radius: 16px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.6);
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .signup-header {
            padding: 40px 40px 20px;
            text-align: center;
        }

        .signup-header h1 {
            color: var(--golden-yellow);
            font-weight: 600;
            letter-spacing: 3px;
            margin-bottom: 10px;
        }

        .signup-header p {
            color: var(--text-dim);
            font-size: 0.95rem;
        }

        .form-container {
            padding: 0 40px 40px;
        }

        .form-label {
            color: var(--text-dim);
            font-weight: 400;
            font-size: 0.85rem;
            margin-bottom: 6px;
        }

        .form-control {
            background-color: #252525;
            border: 1px solid #333;
            color: var(--text-light);
            padding: 12px 15px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background-color: #2a2a2a;
            border-color: var(--golden-yellow);
            color: var(--text-light);
            box-shadow: 0 0 0 0.25rem rgba(255, 204, 0, 0.15);
        }

        .form-control::placeholder {
            color: #555;
        }

        .btn-signup {
            background-color: var(--golden-yellow);
            border: none;
            color: #000;
            padding: 14px;
            font-weight: 600;
            border-radius: 8px;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 15px;
        }

        .btn-signup:hover {
            background-color: var(--golden-hover);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 204, 0, 0.3);
        }

        .btn-signup:active {
            transform: translateY(0);
        }

        .error-message {
            color: var(--error-red);
            font-size: 0.75rem;
            margin-top: 4px;
            height: 1rem;
        }

        .footer-text {
            text-align: center;
            color: var(--text-dim);
            font-size: 0.9rem;
        }

        .footer-text a {
            color: var(--golden-yellow);
            text-decoration: none;
            font-weight: 500;
        }

        .footer-text a:hover {
            text-decoration: underline;
        }

        #serverErrorAlert {
            <% if(request.getAttribute("error") == null) { %> display: none; <% } %>
        }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8 col-lg-5">
            <div class="signup-card">
                <div class="signup-header">
                    <h1>TECHMART</h1>
                    <p>Experience the future of tech shopping</p>
                </div>

                <div class="form-container">
                    <div id="serverErrorAlert" class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger small mb-4">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        <span id="serverErrorMessage">
                            <% if(request.getAttribute("error") != null) { %>
                                <%= request.getAttribute("error") %>
                            <% } %>
                        </span>
                    </div>

                    <form id="signupForm" action="signup" method="post" novalidate>
                        <div class="row g-3 mb-3">
                            <div class="col-sm-6">
                                <label for="firstName" class="form-label">First Name</label>
                                <input type="text" class="form-control <%= request.getAttribute("firstNameError") != null ? "is-invalid" : "" %>" id="firstName" name="firstName" placeholder="John" value="<%= request.getParameter("firstName") != null ? request.getParameter("firstName") : "" %>">
                                <div id="firstNameError" class="error-message">
                                    <%= request.getAttribute("firstNameError") != null ? request.getAttribute("firstNameError") : "" %>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <label for="lastName" class="form-label">Last Name</label>
                                <input type="text" class="form-control <%= request.getAttribute("lastNameError") != null ? "is-invalid" : "" %>" id="lastName" name="lastName" placeholder="Doe" value="<%= request.getParameter("lastName") != null ? request.getParameter("lastName") : "" %>">
                                <div id="lastNameError" class="error-message">
                                    <%= request.getAttribute("lastNameError") != null ? request.getAttribute("lastNameError") : "" %>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email Address</label>
                            <input type="email" class="form-control <%= request.getAttribute("emailError") != null ? "is-invalid" : "" %>" id="email" name="email" placeholder="john.doe@example.com" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                            <div id="emailError" class="error-message">
                                <%= request.getAttribute("emailError") != null ? request.getAttribute("emailError") : "" %>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control <%= request.getAttribute("passwordError") != null ? "is-invalid" : "" %>" id="password" name="password" placeholder="••••••••">
                            <div id="passwordError" class="error-message">
                                <%= request.getAttribute("passwordError") != null ? request.getAttribute("passwordError") : "" %>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="confirmPassword" class="form-label">Confirm Password</label>
                            <input type="password" class="form-control <%= request.getAttribute("confirmPasswordError") != null ? "is-invalid" : "" %>" id="confirmPassword" name="confirmPassword" placeholder="••••••••">
                            <div id="confirmPasswordError" class="error-message">
                                <%= request.getAttribute("confirmPasswordError") != null ? request.getAttribute("confirmPasswordError") : "" %>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-signup">
                            Create Account
                        </button>
                    </form>

                    <div class="footer-text mt-4">
                        Already part of Techmart? <a href="login.jsp">Log in</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
