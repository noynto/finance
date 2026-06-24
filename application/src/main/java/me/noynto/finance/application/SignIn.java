package me.noynto.finance.application;

import me.noynto.finance.domain.identity.*;

import java.time.Clock;
import java.time.Instant;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

public record SignIn(
        Clock clock,
        IdentityProvider identityProvider,
        IdentitySecretProvider identitySecretProvider,
        IdentitySessionProvider identitySessionProvider

) {

    private static final Logger LOG = Logger.getLogger(SignIn.class.getName());

    public IdentitySession handle(Command command) {
        if (command.electronicAddress == null || command.electronicAddress.isBlank()) {
            throw new RuntimeException("L'adresse électronique est requise pour procéder à l'inscription.");
        }
        if (command.secret == null || command.secret.isBlank()) {
            throw new RuntimeException("Le secret est requis pour procéder à l'inscription.");
        }
        Identity identity = this.identityProvider.readIds(command.electronicAddress)
                .findFirst()
                .flatMap(this.identityProvider::read)
                .orElseThrow(() -> new RuntimeException("Cette adresse électronique n'est pas utilisée."));

        if (!this.identitySecretProvider.verify(command.secret, identity.getSecret())) {
            throw new RuntimeException("Le secret est erroné.");
        }

        IdentitySession identitySession = new IdentitySession();
        identitySession.setIdentityId(identity.getId());
        identitySession.setBeginning(Instant.now(clock));

        identitySession = this.identitySessionProvider.write(identitySession);

        return identitySession;
    }

    public record Command(
            String electronicAddress,
            String secret
    ) {

    }

}
