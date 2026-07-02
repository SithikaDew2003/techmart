package lk.sithikaDev.techmart.service;

import jakarta.ejb.Remote;
import java.util.Map;

@Remote
public interface PerformanceMonitor {
    void incrementRequestCount(String path);
    Map<String, Long> getRequestStatistics();
    long getTotalRequests();
    void resetStatistics();
}
