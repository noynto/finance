package me.noynto.finance.application;

import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.payee.Payee;
import me.noynto.finance.domain.payee.PayeeProvider;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.PayeeId;
import me.noynto.finance.domain.transaction.TransactionProvider;

import java.math.BigDecimal;
import java.util.Objects;
import java.util.Optional;

public record GetBalanceOfPayee(
        IdentityProvider identityProvider,
        PayeeProvider payeeProvider,
        TransactionProvider transactionProvider
) {

    public BigDecimal handle(Query query) {
        Objects.requireNonNull(query);
        if (query.identityId == null) {
            throw new RuntimeException("L'identifiant de l'identité est requis pour calculer le solde du compte bancaire.");
        }
        if (query.payeeId == null) {
            throw new RuntimeException("L'identifiant du compte bancaire est requis pour calculer le solde.");
        }

        Identity identity = this.identityProvider.read(query.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        Payee payee = this.payeeProvider.read(query.payeeId)
                .orElseThrow(() -> new RuntimeException("L'identifiant du bénéficiaire ne correspond à rien."));

        if (!payee.belongsTo(identity.getId())) {
            throw new RuntimeException("Le bénéficiaire " + payee.getId().getValue() + " n'appartient pas à l'identité " + identity.getId().getValue() + ".");
        }

        return payee.getTransactionIds()
                .stream()
                .map(this.transactionProvider::read)
                .filter(Optional::isPresent)
                .map(Optional::get)
                .map(tx -> tx.getAmount() != null ? tx.getAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public record Query(
            IdentityId identityId,
            PayeeId payeeId
    ) {
    }
}