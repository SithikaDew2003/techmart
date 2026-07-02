package lk.sithikaDev.techmart.service;

import jakarta.ejb.Remote;

@Remote
public interface TestService {
    void test(String hello);
}
