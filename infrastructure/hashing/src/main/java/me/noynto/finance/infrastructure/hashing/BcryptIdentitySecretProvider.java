package me.noynto.finance.infrastructure.hashing;

import me.noynto.finance.domain.identity.IdentitySecretProvider;
import org.mindrot.jbcrypt.BCrypt;

public class BcryptIdentitySecretProvider implements IdentitySecretProvider {

    @Override
    public String hash(String raw) {
        return BCrypt.hashpw(raw, BCrypt.gensalt());
    }

    @Override
    public boolean verify(String raw, String hash) {
        return BCrypt.checkpw(raw, hash);
    }

}