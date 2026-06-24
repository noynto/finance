package me.noynto.finance.application;

import me.noynto.finance.domain.identity.*;

import java.time.Clock;
import java.time.Instant;
import java.util.logging.Logger;
import java.util.regex.Pattern;

public record SignUp(
        Clock clock,
        IdentityProvider identityProvider,
        IdentitySecretProvider identitySecretProvider,
        IdentitySessionProvider identitySessionProvider
) {

    private static final Logger LOG = Logger.getLogger(SignUp.class.getName());
    private static final Pattern SECRET_PATTERN = Pattern.compile(
            "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^a-zA-Z0-9]).{20,60}$"
    );

    public IdentitySession handle(Command command) {
        if (command.electronicAddress == null || command.electronicAddress.isBlank()) {
            throw new RuntimeException("L'adresse électronique est requise pour procéder à l'inscription.");
        }
        if (command.secret == null || command.secret.isBlank()) {
            throw new RuntimeException("Le secret est requis pour procéder à l'inscription.");
        }
        if (!SECRET_PATTERN.matcher(command.secret).matches()) {
            throw new RuntimeException("Le secret doit contenir entre 20 et 60 caractères, avec au moins une minuscule, une majuscule, un chiffre et un caractère spécial.");
        }
        if (this.identityProvider.readIds(command.electronicAddress).findAny().isPresent()) {
            throw new RuntimeException("Cette adresse électronique est déjà utilisée.");
        }
        String hash = this.identitySecretProvider.hash(command.secret);

        Identity identity = new Identity();
        identity.setElectronicAddress(command.electronicAddress);
        identity.setSecret(hash);

        identity = this.identityProvider.write(identity);

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
