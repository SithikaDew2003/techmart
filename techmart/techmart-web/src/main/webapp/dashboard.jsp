<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Techmart</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

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
            font-size: 2rem;
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

        .text-dim {
            color: var(--text-dim);
        }

        code {
            color: var(--golden-yellow);
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
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card p-4 text-center mb-3">
                <div class="text-dim mb-2">Total Requests</div>
                <div class="stat-value"><%= request.getAttribute("totalRequests") %></div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card p-4 text-center mb-3">
                <div class="text-dim mb-2">Active Sessions</div>
                <div class="stat-value"><%= request.getAttribute("activeSessions") %></div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card p-4 text-center mb-3">
                <div class="text-dim mb-2">CPU Cores</div>
                <div class="stat-value"><%= request.getAttribute("availableProcessors") %></div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card p-4 text-center mb-3">
                <div class="text-dim mb-2">Active Threads</div>
                <div class="stat-value"><%= request.getAttribute("activeThreadCount") %></div>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card p-4 text-center mb-3">
                <div class="text-dim mb-2">Used Memory</div>
                <div class="stat-value"><%= request.getAttribute("usedMemory") %> MB</div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card p-4 text-center mb-3">
                <div class="text-dim mb-2">Free Memory</div>
                <div class="stat-value"><%= request.getAttribute("freeMemory") %> MB</div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card p-4 text-center mb-3">
                <div class="text-dim mb-2">Max Memory</div>
                <div class="stat-value"><%= request.getAttribute("maxMemory") %> MB</div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card p-4 text-center mb-3">
                <div class="text-dim mb-2">JVM Uptime</div>
                <div class="stat-value"><%= request.getAttribute("uptimeSeconds") %>s</div>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card p-4 text-center">
                <div class="text-dim mb-2">Average Requests / Endpoint</div>
                <div class="stat-value">
                    <%= String.format("%.2f", request.getAttribute("averageRequestsPerEndpoint")) %>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 text-center">
                <div class="text-dim mb-2">Most Visited Endpoint</div>
                <code class="fs-5"><%= request.getAttribute("mostVisitedEndpoint") %></code>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 text-center">
                <div class="text-dim mb-2">Server Time</div>
                <div class="small text-warning"><%= request.getAttribute("serverTime") %></div>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-md-8">
            <div class="card p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0">Endpoint Traffic Analysis</h5>

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
                                <div class="progress-bar bg-warning"
                                     style="width: <%= total > 0 ? (entry.getValue() * 100 / total) : 0 %>%">
                                </div>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="3" class="text-center text-dim">No data available yet</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 h-100">
                <h5>System Health Summary</h5>

                <ul class="text-dim small mt-3">
                    <li>JVM memory usage is monitored in real time.</li>
                    <li>Thread count shows current server execution activity.</li>
                    <li>Endpoint statistics are collected using Singleton EJB.</li>
                    <li>Request tracking helps identify high-traffic URLs.</li>
                    <li>Uptime shows how long the Payara server JVM has been running.</li>
                </ul>

                <hr class="border-secondary">

                <p class="small text-warning mb-0">
                    <i class="bi bi-activity"></i>
                    Monitoring powered by Jakarta EE Singleton EJB.
                </p>
            </div>
        </div>
    </div>

    <div class="row mb-5">
        <div class="col-md-6">
            <div class="card p-4">
                <h5>Asynchronous Operations Test</h5>
                <p class="text-dim small">
                    Trigger @Asynchronous EJB methods to simulate long-running background tasks
                    without blocking the UI thread.
                </p>

                <form action="dashboard" method="post" class="mt-3">
                    <input type="hidden" name="action" value="testAsync">

                    <div class="mb-3">
                        <label class="form-label">Target Email Address</label>
                        <input type="email"
                               name="email"
                               class="form-control bg-dark text-white border-secondary"
                               required
                               placeholder="customer@example.com">
                    </div>

                    <button type="submit" class="btn btn-golden w-100">
                        Send Async Order Confirmation
                    </button>
                </form>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card p-4">
                <h5>System Architecture Justification</h5>

                <ul class="text-dim small">
                    <li><strong>Singleton EJB:</strong> Global performance monitor with shared request state.</li>
                    <li><strong>Stateless EJB:</strong> Notification service for scalable business operations.</li>
                    <li><strong>Asynchronous EJB:</strong> Prevents UI blocking during long-running operations.</li>
                    <li><strong>MDB:</strong> Handles queued background messages using Jakarta Messaging.</li>
                    <li><strong>JPA:</strong> Persists application data through the configured persistence unit.</li>
                </ul>

                <div class="mt-3">
                    <a href="init-data" target="_blank" class="btn btn-outline-warning btn-sm w-100">
                        <i class="bi bi-database-fill-add"></i>
                        Initialize System Sample Data
                    </a>
                </div>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>