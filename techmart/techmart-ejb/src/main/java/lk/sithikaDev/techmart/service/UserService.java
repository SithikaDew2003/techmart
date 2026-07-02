package lk.sithikaDev.techmart.service;

import jakarta.ejb.Remote;
import lk.sithikaDev.techmart.entity.Users;

@Remote
public interface UserService {
    void signUp(Users user);
    boolean isEmailExists(String email);
}
