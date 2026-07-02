<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Techmart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        :root {
            --dark-bg: #0f0f0f;
            --golden-yellow: #ffcc00;
            --golden-hover: #e6b800;
            --text-light: #f8f9fa;
            --text-dim: #adb5bd;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--dark-bg);
            color: var(--text-light);
            min-height: 100vh;
            background-image: radial-gradient(circle at 50% 50%, #1a1a1a 0%, #0f0f0f 100%);
        }

        .navbar {
            background-color: rgba(15, 15, 15, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 204, 0, 0.1);
        }

        .navbar-brand {
            color: var(--golden-yellow);
            font-weight: 600;
            letter-spacing: 2px;
            font-size: 1.5rem;
        }

        .hero-section {
            padding: 100px 0;
            text-align: center;
        }

        .hero-title {
            font-size: 4rem;
            font-weight: 600;
            color: var(--golden-yellow);
            margin-bottom: 20px;
        }

        .hero-subtitle {
            font-size: 1.25rem;
            color: var(--text-dim);
            max-width: 600px;
            margin: 0 auto 40px;
        }

        .btn-primary-custom {
            background-color: var(--golden-yellow);
            border: none;
            color: #000;
            padding: 12px 30px;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            background-color: var(--golden-hover);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 204, 0, 0.3);
            color: #000;
        }

        .btn-outline-custom {
            border: 2px solid var(--golden-yellow);
            color: var(--golden-yellow);
            padding: 10px 30px;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-outline-custom:hover {
            background-color: var(--golden-yellow);
            color: #000;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="#">TECHMART</a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav align-items-center">
                <li class="nav-item">
                    <a class="nav-link text-light me-3" href="login.jsp">Log In</a>
                </li>
                <li class="nav-item">
                    <a class="btn btn-primary-custom" href="signup.jsp">Sign Up</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<main class="container">
    <section class="hero-section">
        <h1 class="hero-title">Techmart</h1>
        <p class="hero-subtitle">Discover the latest in technology. Your one-stop shop for premium gadgets, components, and electronics.</p>
        <div class="d-flex justify-content-center gap-3">
            <a href="signup.jsp" class="btn btn-primary-custom btn-lg">Get Started</a>
            <a href="#" class="btn btn-outline-custom btn-lg">Explore Shop</a>
        </div>
    </section>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
