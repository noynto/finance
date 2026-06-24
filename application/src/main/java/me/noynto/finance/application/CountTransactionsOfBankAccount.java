package me.noynto.finance.application;

import me.noynto.finance.domain.bankaccount.BankAccount;
import me.noynto.finance.domain.bankaccount.BankAccountProvider;
import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.transaction.TransactionProvider;

import java.math.BigDecimal;
import java.util.Objects;
import java.util.Optional;

public record CountTransactionsOfBankAccount(
        IdentityProvider identityProvider,
        BankAccountProvider bankAccountProvider,
        TransactionProvider transactionProvider
) {

    public long handle(Query query) {
        Objects.requireNonNull(query);
        if (query.identityId == null) {
            throw new RuntimeException("L'identifiant de l'identité est requis pour calculer le solde du compte bancaire.");
        }
        if (query.bankAccountId == null) {
            throw new RuntimeException("L'identifiant du compte bancaire est requis pour calculer le solde.");
        }

        Identity identity = this.identityProvider.read(query.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        BankAccount bankAccount = this.bankAccountProvider.read(query.bankAccountId)
                .orElseThrow(() -> new RuntimeException("L'identifiant du compte bancaire ne correspond à rien."));

        if (!bankAccount.belongsTo(identity.getId())) {
            throw new RuntimeException("Le compte bancaire " + bankAccount.getId().getValue() + " n'appartient pas à l'identité " + identity.getId().getValue() + ".");
        }

        return this.transactionProvider.readIds(bankAccount.getId(), null, null, null)
                .count();
    }

    public record Query(
            IdentityId identityId,
            BankAccountId bankAccountId
    ) {
    }
}