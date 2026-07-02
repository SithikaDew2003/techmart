package lk.sithikaDev.techmart.service;

import jakarta.ejb.Local;
import java.util.Map;

@Local
public interface PerformanceMonitor {
    void incrementRequestCount(String path);
    Map<String, Long> getRequestStatistics();
    long getTotalRequests();
    long getActiveSessions();
    void resetStatistics();
}
