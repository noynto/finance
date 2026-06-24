package me.noynto.finance.application;

import me.noynto.finance.domain.bankaccount.BankAccountProvider;
import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.transaction.TransactionProvider;

import java.math.BigDecimal;
import java.util.Objects;
import java.util.Optional;

public record GetBalance(
        IdentityProvider identityProvider,
        BankAccountProvider bankAccountProvider,
        TransactionProvider transactionProvider
) {

    public BigDecimal handle(Query query) {
        Objects.requireNonNull(query);
        if (query.identityId == null) {
            throw new RuntimeException("L'identifiant de l'identité est requis pour calculer le solde du compte bancaire.");
        }

        Identity identity = this.identityProvider.read(query.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        return this.bankAccountProvider.readIds(identity.getId())
                .map(this.bankAccountProvider::read)
                .filter(Optional::isPresent)
                .map(Optional::get)
                .filter(bankAccount -> bankAccount.belongsTo(identity.getId()))
                .flatMap(bankAccount -> this.transactionProvider.readIds(bankAccount.getId(), null, null, null))
                .parallel()
                .map(this.transactionProvider::read)
                .filter(Optional::isPresent)
                .map(Optional::get)
                .map(tx -> tx.getAmount() != null ? tx.getAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public record Query(
            IdentityId identityId
    ) {
    }
}