package lk.sithikaDev.techmart.impl;

import jakarta.annotation.PostConstruct;
import jakarta.ejb.ConcurrencyManagement;
import jakarta.ejb.ConcurrencyManagementType;
import jakarta.ejb.Lock;
import jakarta.ejb.LockType;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import lk.sithikaDev.techmart.service.PerformanceMonitor;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

@Singleton
@Startup
@ConcurrencyManagement(ConcurrencyManagementType.CONTAINER)
public class PerformanceMonitorImpl implements PerformanceMonitor {

    private Map<String, AtomicLong> requestCounts;
    private AtomicLong totalRequests;

    @PostConstruct
    public void init() {
        requestCounts = new ConcurrentHashMap<>();
        totalRequests = new AtomicLong(0);
        System.out.println("[PERFORMANCE MONITOR] Initialized at startup.");
    }

    @Override
    @Lock(LockType.WRITE)
    public void incrementRequestCount(String path) {
        requestCounts.computeIfAbsent(path, k -> new AtomicLong(0)).incrementAndGet();
        totalRequests.incrementAndGet();
    }

    @Override
    @Lock(LockType.READ)
    public Map<String, Long> getRequestStatistics() {
        Map<String, Long> stats = new HashMap<>();
        requestCounts.forEach((k, v) -> stats.put(k, v.get()));
        return stats;
    }

    @Override
    @Lock(LockType.READ)
    public long getTotalRequests() {
        return totalRequests.get();
    }

    @Override
    @Lock(LockType.WRITE)
    public void resetStatistics() {
        requestCounts.clear();
        totalRequests.set(0);
    }

    @Override
    @Lock(LockType.READ)
    public long getActiveSessions() {
        // Mock session count for demonstration
        return totalRequests.get() / 5 + 1; 
    }
}
