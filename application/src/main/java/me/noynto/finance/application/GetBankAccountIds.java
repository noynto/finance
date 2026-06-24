package me.noynto.finance.application;

import me.noynto.finance.domain.bankaccount.BankAccountProvider;
import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;

import java.util.stream.Stream;

public record GetBankAccountIds(
        IdentityProvider identityProvider,
        BankAccountProvider bankAccountProvider
) {

    public Stream<BankAccountId> handle(Query query) {
        if (query.identityId == null) {
            throw new RuntimeException("L'identifiant de l'identité est requis pour obtenir l'identifiant des transactions du compte bancaire.");
        }
        Identity identity = this.identityProvider.read(query.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        return this.bankAccountProvider.readIds(identity.getId());
    }


    public record Query(
            IdentityId identityId
    ) {

    }
}
