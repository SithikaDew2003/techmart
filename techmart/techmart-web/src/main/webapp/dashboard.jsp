<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Techmart</title>
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
            min-height: 100vh;
        }
        .card {
            background-color: var(--dark-card);
            border: 1px solid rgba(255, 204, 0, 0.15);
            border-radius: 12px;
            color: var(--text-light);
        }
        .stat-value {
            font-size: 2.5rem;
            font-weight: 600;
            color: var(--golden-yellow);
        }
        .table {
            color: var(--text-light);
        }
        .btn-golden {
            background-color: var(--golden-yellow);
            color: #000;
            font-weight: 600;
        }
        .btn-golden:hover {
            background-color: #e6b800;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg border-bottom border-secondary mb-4">
    <div class="container">
        <a class="navbar-brand text-warning fw-bold" href="index.jsp">TECHMART ADMIN</a>
        <div class="ms-auto">
            <span class="text-dim me-3">Senior Architect Session</span>
            <a href="index.jsp" class="btn btn-outline-warning btn-sm">Exit</a>
        </div>
    </div>
</nav>

<div class="container">
    <h2 class="mb-4">Enterprise Performance Dashboard</h2>

    <% if (request.getAttribute("message") != null) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <%= request.getAttribute("message") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card p-4 text-center">
                <div class="text-dim mb-2 uppercase">Total Request Volume</div>
                <div class="stat-value"><%= request.getAttribute("totalRequests") %></div>
                <div class="small text-success mt-2"><i class="bi bi-graph-up"></i> Real-time tracking enabled</div>
            </div>
        </div>
        <div class="col-md-8">
            <div class="card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0">Endpoint Traffic Analysis (Singleton EJB)</h5>
                    <form action="dashboard" method="post">
                        <input type="hidden" name="action" value="resetStats">
                        <button type="submit" class="btn btn-outline-danger btn-sm">Reset Stats</button>
                    </form>
                </div>
                <table class="table table-dark table-hover">
                    <thead>
                        <tr>
                            <th>Path</th>
                            <th>Invocations</th>
                            <th>Load Factor</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        Map<String, Long> stats = (Map<String, Long>) request.getAttribute("stats");
                        long total = (Long) request.getAttribute("totalRequests");
                        if (stats != null && !stats.isEmpty()) {
                            for (Map.Entry<String, Long> entry : stats.entrySet()) {
                        %>
                        <tr>
                            <td><code><%= entry.getKey() %></code></td>
                            <td><%= entry.getValue() %></td>
                            <td>
                                <div class="progress" style="height: 10px;">
                                    <div class="progress-bar bg-warning" role="progressbar" 
                                         style="width: <%= total > 0 ? (entry.getValue() * 100 / total) : 0 %>%"></div>
                                </div>
                            </td>
                        </tr>
                        <% 
                            }
                        } else {
                        %>
                        <tr><td colspan="3" class="text-center text-dim">No data available yet</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6">
            <div class="card p-4">
                <h5>Asynchronous Operations Test</h5>
                <p class="text-dim small">Trigger @Asynchronous EJB methods to simulate long-running background tasks without blocking the UI thread.</p>
                <form action="dashboard" method="post" class="mt-3">
                    <input type="hidden" name="action" value="testAsync">
                    <div class="mb-3">
                        <label class="form-label">Target Email Address</label>
                        <input type="email" name="email" class="form-control bg-dark text-white border-secondary" required placeholder="customer@example.com">
                    </div>
                    <button type="submit" class="btn btn-golden w-100">Send Async Order Confirmation</button>
                </form>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card p-4">
                <h5>System Architecture Justification</h5>
                <ul class="text-dim small">
                    <li><strong>Singleton EJB:</strong> Used for global state (Performance Monitor) with <code>Lock(LockType.READ/WRITE)</code> for thread safety.</li>
                    <li><strong>Stateless EJB:</strong> Utilized for <code>NotificationService</code> to ensure high scalability and poolable components.</li>
                    <li><strong>Asynchronous:</strong> Critical for NFRs, preventing UI lag during intensive processing.</li>
                    <li><strong>MDB:</strong> Enables decoupled messaging via <code>OrderQueue</code> for peak load handling.</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
