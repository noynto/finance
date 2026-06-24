package me.noynto.finance.domain.identity;

public interface IdentitySecretProvider {

    String hash(String raw);

    boolean verify(String raw, String hash);

}
