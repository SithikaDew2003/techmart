package lk.sithikaDev.techmart.dto;

import java.io.Serializable;

public class PaymentIntentInfo implements Serializable {
    private String id;
    private String clientSecret;

    public PaymentIntentInfo() {}

    public PaymentIntentInfo(String id, String clientSecret) {
        this.id = id;
        this.clientSecret = clientSecret;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getClientSecret() {
        return clientSecret;
    }

    public void setClientSecret(String clientSecret) {
        this.clientSecret = clientSecret;
    }
}
