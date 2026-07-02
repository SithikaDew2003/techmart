package lk.sithikaDev.techmart.service;

import jakarta.ejb.Local;

@Local
public interface TestService {
    void test(String hello);
}
