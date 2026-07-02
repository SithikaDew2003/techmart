package lk.sithikaDev.techmart.impl;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lk.sithikaDev.techmart.entity.Users;
import lk.sithikaDev.techmart.service.UserService;

@Stateless
public class UserServiceImpl implements UserService {

    @PersistenceContext(unitName = "TechmartPU")
    private EntityManager entityManager;

    @Override
    public void signUp(Users user) {
        entityManager.persist(user);
    }

    @Override
    public boolean isEmailExists(String email) {
        Long count = entityManager.createQuery("SELECT COUNT(u) FROM Users u WHERE LOWER(u.email) = LOWER(:email)", Long.class)
                .setParameter("email", email.toLowerCase())
                .getSingleResult();
        return count > 0;
    }

    @Override
    public Users login(String email, String password) {
        try {
            return entityManager.createQuery("SELECT u FROM Users u WHERE LOWER(u.email) = LOWER(:email) AND u.password = :password", Users.class)
                    .setParameter("email", email.toLowerCase())
                    .setParameter("password", password)
                    .getSingleResult();
        } catch (jakarta.persistence.NoResultException e) {
            return null;
        }
    }
}
