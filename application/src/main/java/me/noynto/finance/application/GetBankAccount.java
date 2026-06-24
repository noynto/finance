package me.noynto.finance.application;

import me.noynto.finance.domain.bankaccount.BankAccount;
import me.noynto.finance.domain.bankaccount.BankAccountProvider;
import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;

public record GetBankAccount(
        IdentityProvider identityProvider,
        BankAccountProvider bankAccountProvider
) {

    public BankAccount handle(Query query) {
        if (query.identityId == null) {
            throw new RuntimeException("L'identifiant de l'identité est requis.");
        }
        if (query.bankAccountId == null) {
            throw new RuntimeException("L'identifiant du compte bancaire est requis.");
        }
        Identity identity = this.identityProvider.read(query.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        BankAccount bankAccount = this.bankAccountProvider.read(query.bankAccountId)
                .orElseThrow(() -> new RuntimeException("Le compte bancaire " + query.bankAccountId.getValue() + " n'existe pas."));

        if (!bankAccount.belongsTo(identity.getId())) {
            throw new RuntimeException("Le compte bancaire " + bankAccount.getId().getValue() + " n'appartient pas à l'identité " + identity.getId().getValue() + ".");
        }

        return bankAccount;
    }

    public record Query(
            IdentityId identityId,
            BankAccountId bankAccountId
    ) {

    }
}
