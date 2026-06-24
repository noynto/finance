package me.noynto.finance.application;

import me.noynto.finance.domain.identity.IdentitySession;
import me.noynto.finance.domain.identity.IdentitySessionProvider;
import me.noynto.finance.domain.shared.IdentitySessionId;

import java.time.Instant;
import java.time.temporal.ChronoUnit;

public record GetValidIdentitySession(
        IdentitySessionProvider identitySessionProvider
) {

    public IdentitySession handle(Command command) {
        if (command.identitySessionId == null || command.identitySessionId.getValue() == null || command.identitySessionId.getValue().isBlank()) {
            throw new RuntimeException("L'identifiant de la session de l'identité est requis.");
        }

        IdentitySession identitySession = this.identitySessionProvider.read(command.identitySessionId)
                .orElseThrow(() -> new RuntimeException("La session de l'identité n'existe pas."));

        if (identitySession.hasExpired(Instant.now())) {
            throw new RuntimeException("La session de l'identité a expiré.");
        }

        return identitySession;
    }

    public record Command(
            IdentitySessionId identitySessionId
    ) {
    }

}
