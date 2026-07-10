package lk.sithikaDev.techmart.impl;

import jakarta.ejb.Lock;
import jakarta.ejb.LockType;
import jakarta.ejb.Singleton;
import lk.sithikaDev.techmart.service.PerformanceMonitor;

import java.lang.management.ManagementFactory;
import java.util.HashMap;
import java.util.Map;

@Singleton
public class PerformanceMonitorImpl implements PerformanceMonitor {

    private final Map<String, Long> requestStatistics = new HashMap<>();
    private long totalRequests = 0;
    private long activeSessions = 0;

    @Override
    @Lock(LockType.WRITE)
    public void incrementRequestCount(String path) {
        totalRequests++;
        requestStatistics.put(path, requestStatistics.getOrDefault(path, 0L) + 1);
    }

    @Override
    @Lock(LockType.READ)
    public Map<String, Long> getRequestStatistics() {
        return new HashMap<>(requestStatistics);
    }

    @Override
    @Lock(LockType.READ)
    public long getTotalRequests() {
        return totalRequests;
    }

    @Override
    @Lock(LockType.READ)
    public long getActiveSessions() {
        return activeSessions;
    }

    @Override
    @Lock(LockType.WRITE)
    public void resetStatistics() {
        requestStatistics.clear();
        totalRequests = 0;
    }

    @Override
    public long getUsedMemory() {
        Runtime runtime = Runtime.getRuntime();
        return (runtime.totalMemory() - runtime.freeMemory()) / (1024 * 1024);
    }

    @Override
    public long getFreeMemory() {
        return Runtime.getRuntime().freeMemory() / (1024 * 1024);
    }

    @Override
    public long getMaxMemory() {
        return Runtime.getRuntime().maxMemory() / (1024 * 1024);
    }

    @Override
    public long getUptimeSeconds() {
        return ManagementFactory.getRuntimeMXBean().getUptime() / 1000;
    }

    @Override
    public int getAvailableProcessors() {
        return Runtime.getRuntime().availableProcessors();
    }

    @Override
    public int getActiveThreadCount() {
        return ManagementFactory.getThreadMXBean().getThreadCount();
    }

    @Override
    @Lock(LockType.READ)
    public String getMostVisitedEndpoint() {
        return requestStatistics.entrySet()
                .stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("No data");
    }

    @Override
    @Lock(LockType.READ)
    public double getAverageRequestsPerEndpoint() {
        if (requestStatistics.isEmpty()) {
            return 0;
        }
        return (double) totalRequests / requestStatistics.size();
    }
}