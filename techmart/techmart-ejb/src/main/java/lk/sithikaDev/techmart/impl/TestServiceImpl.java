package lk.sithikaDev.techmart.impl;

import jakarta.ejb.Stateless;
import lk.sithikaDev.techmart.service.TestService;

@Stateless
public class TestServiceImpl implements TestService {

    @Override
    public void test(String hello) {
        System.out.println(hello);
    }
}
