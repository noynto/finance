package me.noynto.finance.domain.identity;

import me.noynto.finance.domain.shared.IdentityId;

public class Identity {
    private IdentityId id;
    private String electronicAddress;
    private String secret;

    public Identity() {
    }

    public String getElectronicAddress() {
        return electronicAddress;
    }

    public void setElectronicAddress(String electronicAddress) {
        this.electronicAddress = electronicAddress;
    }

    public String getSecret() {
        return secret;
    }

    public void setSecret(String secret) {
        this.secret = secret;
    }

    public IdentityId getId() {
        return id;
    }

    public void setId(IdentityId id) {
        this.id = id;
    }
}
