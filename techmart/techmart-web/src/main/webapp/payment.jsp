<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="lk.sithikaDev.techmart.entity.Users" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment | Techmart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        :root {
            --primary: #00d2ff;
            --primary-dark: #00a1c2;
            --accent: #ffcc00;
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
        }

        .navbar {
            background-color: rgba(10, 10, 11, 0.8);
            border-bottom: 1px solid var(--border-color);
            padding: 1rem 0;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: var(--primary) !important;
        }

        .payment-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 30px;
        }

        .StripeElement {
            background-color: #2a2a2a;
            border: 1px solid var(--border-color);
            padding: 12px;
            border-radius: 8px;
            color: var(--text-main);
        }

        .StripeElement--focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(0, 210, 255, 0.1);
        }

        .btn-pay {
            background-color: var(--primary);
            color: #000;
            font-weight: 600;
            padding: 14px;
            border: none;
            border-radius: 12px;
            width: 100%;
            transition: all 0.2s;
        }

        .btn-pay:hover {
            background-color: var(--primary-dark);
            color: #000;
        }

        .btn-pay:disabled {
            background-color: #666;
            cursor: not-allowed;
        }

        .order-summary {
            background-color: #1c1c1e;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 20px;
        }

        .security-badge {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 20px;
            padding: 15px;
            background-color: rgba(0, 210, 255, 0.1);
            border-radius: 12px;
            border: 1px solid var(--border-color);
        }

        .spinner-border-sm {
            width: 1rem;
            height: 1rem;
            border-width: 0.2em;
        }

        .error-message {
            color: #ff4d4d;
            margin-top: 10px;
            padding: 10px;
            border-radius: 8px;
            background-color: rgba(255, 77, 77, 0.1);
            border: 1px solid #ff4d4d;
            display: none;
        }

        .success-message {
            color: #4dff4d;
            margin-top: 10px;
            padding: 10px;
            border-radius: 8px;
            background-color: rgba(77, 255, 77, 0.1);
            border: 1px solid #4dff4d;
            display: none;
        }
    </style>
</head>
<body>

<%
    Users user = (Users) session.getAttribute("user");
    BigDecimal totalAmount = (BigDecimal) request.getAttribute("totalAmount");
    
    if (user == null || totalAmount == null) {
        response.sendRedirect("cart");
        return;
    }
%>

<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="home">TECHMART</a>
    </div>
</nav>

<div class="container mt-5 mb-5">
    <div class="row g-4 justify-content-center">
        <div class="col-lg-5">
            <h2 class="fw-bold mb-4">Payment Details</h2>

            <div class="payment-card mb-4">
                <h5 class="fw-bold mb-3">Cardholder Information</h5>
                
                <div class="mb-3">
                    <label class="form-label text-muted small">Full Name</label>
                    <input type="text" id="cardholderName" class="form-control" placeholder="<%= user.getFirstName() %> <%= user.getLastName() %>" readonly style="background-color: #2a2a2a; border: 1px solid var(--border-color); color: var(--text-muted);">
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted small">Email</label>
                    <input type="email" id="cardholderEmail" class="form-control" placeholder="<%= user.getEmail() %>" readonly style="background-color: #2a2a2a; border: 1px solid var(--border-color); color: var(--text-muted);">
                </div>

                <div class="mb-4">
                    <label class="form-label text-muted small">Card Information</label>
                    <div id="card-element" class="StripeElement"></div>
                </div>

                <div id="error-message" class="error-message"></div>
                <div id="success-message" class="success-message"></div>

                <button id="pay-button" class="btn btn-pay" type="button">
                    <span id="button-text">Pay $<%= String.format("%.2f", totalAmount) %></span>
                    <span id="spinner" class="spinner-border spinner-border-sm ms-2" role="status" aria-hidden="true" style="display: none;"></span>
                </button>
            </div>

            <div class="security-badge">
                <i class="bi bi-shield-lock me-2"></i>
                <span class="small">Secure Payment by Stripe</span>
            </div>
        </div>

        <div class="col-lg-3">
            <h5 class="fw-bold mb-4">Order Summary</h5>
            <div class="order-summary">
                <div class="d-flex justify-content-between mb-3">
                    <span class="text-muted">Subtotal</span>
                    <span>$<%= String.format("%.2f", totalAmount) %></span>
                </div>
                <div class="d-flex justify-content-between mb-3">
                    <span class="text-muted">Shipping</span>
                    <span class="text-primary fw-medium">FREE</span>
                </div>
                <hr class="border-secondary border-opacity-25 my-3">
                <div class="d-flex justify-content-between align-items-center">
                    <span class="fw-bold">Total</span>
                    <span class="fs-5 fw-bold text-primary">$<%= String.format("%.2f", totalAmount) %></span>
                </div>
            </div>

            <div class="mt-4">
                <a href="cart" class="btn btn-outline-secondary w-100">Back to Cart</a>
            </div>
        </div>
    </div>
</div>

<!-- Stripe Script -->
<script src="https://js.stripe.com/v3/"></script>
<script>
    const stripe = Stripe('pk_test_51TF7U82LY9N7Z9csoGf7DOv6al9zjGNJk6Lsn3ywfuoqOtUXZmeBPxMi7kt2m3El6ijbJ8Zw5NtvWic1Nw1TPCjz00SLPJOdrl');
    const elements = stripe.elements();
    const cardElement = elements.create('card');
    cardElement.mount('#card-element');

    // Handle card element changes
    cardElement.on('change', function(event) {
        const displayError = document.getElementById('error-message');
        if (event.error) {
            displayError.textContent = event.error.message;
            displayError.style.display = 'block';
        } else {
            displayError.style.display = 'none';
        }
    });

    // Handle payment
    document.getElementById('pay-button').addEventListener('click', async function() {
        const payButton = document.getElementById('pay-button');
        const buttonText = document.getElementById('button-text');
        const spinner = document.getElementById('spinner');

        payButton.disabled = true;
        spinner.style.display = 'inline-block';
        buttonText.textContent = 'Processing...';

        try {
            // Step 1: Create PaymentIntent on the server
            const createResponse = await fetch('/techmart/payment', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'action=create_payment_intent'
            });

            const createData = await createResponse.json();
            if (createData.error) {
                throw new Error(createData.error);
            }

            const clientSecret = createData.clientSecret;
            const orderId = createData.orderId;

            // Step 2: Confirm payment with Stripe
            const confirmResult = await stripe.confirmCardPayment(clientSecret, {
                payment_method: {
                    card: cardElement,
                    billing_details: {
                        name: '<%= user.getFirstName() %> <%= user.getLastName() %>',
                        email: '<%= user.getEmail() %>'
                    }
                }
            });

            if (confirmResult.error) {
                throw new Error(confirmResult.error.message);
            }

            // Step 3: Confirm payment on server
            const paymentIntentId = confirmResult.paymentIntent.id;
            const confirmResponse = await fetch('/techmart/payment', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'action=confirm_payment&paymentIntentId=' + paymentIntentId + '&orderId=' + orderId
            });

            const confirmData = await confirmResponse.json();
            if (confirmData.success) {
                document.getElementById('success-message').textContent = 'Payment successful! Redirecting...';
                document.getElementById('success-message').style.display = 'block';
                setTimeout(() => {
                    window.location.href = '/techmart/home?success=Order placed successfully!';
                }, 2000);
            } else {
                throw new Error(confirmData.message || 'Payment confirmation failed');
            }
        } catch (error) {
            document.getElementById('error-message').textContent = error.message;
            document.getElementById('error-message').style.display = 'block';
            payButton.disabled = false;
            spinner.style.display = 'none';
            buttonText.textContent = 'Pay $<%= String.format("%.2f", totalAmount) %>';
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
