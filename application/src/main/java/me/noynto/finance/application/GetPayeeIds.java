package me.noynto.finance.application;

import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.payee.PayeeProvider;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.PayeeId;

import java.util.stream.Stream;

public record GetPayeeIds(
        IdentityProvider identityProvider,
        PayeeProvider payeeProvider
) {

    public Stream<PayeeId> handle(Query query) {
        if (query.identityId == null) {
            throw new RuntimeException("L'identifiant de l'identité est requis pour obtenir l'identifiant des transactions du compte bancaire.");
        }
        Identity identity = this.identityProvider.read(query.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        return this.payeeProvider.readIds(identity.getId());
    }


    public record Query(
            IdentityId identityId
    ) {

    }
}
