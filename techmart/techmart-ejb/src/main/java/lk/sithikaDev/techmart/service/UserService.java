package lk.sithikaDev.techmart.service;

import jakarta.ejb.Local;
import lk.sithikaDev.techmart.entity.Users;

@Local
public interface UserService {
    void signUp(Users user);
    boolean isEmailExists(String email);
    Users login(String email, String password);
    java.util.List<Users> getAllUsers();
    void updateUser(Users user);
    void deleteUser(Integer userId);
}
