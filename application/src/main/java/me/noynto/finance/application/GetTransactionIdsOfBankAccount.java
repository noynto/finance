package me.noynto.finance.application;

import me.noynto.finance.domain.bankaccount.BankAccount;
import me.noynto.finance.domain.bankaccount.BankAccountProvider;
import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.Limit;
import me.noynto.finance.domain.shared.TransactionId;
import me.noynto.finance.domain.transaction.TransactionProvider;

import java.util.stream.Stream;

public record GetTransactionIdsOfBankAccount(
        IdentityProvider identityProvider,
        BankAccountProvider bankAccountProvider,
        TransactionProvider transactionProvider
) {

    public Stream<TransactionId> handle(Query query) {
        if (query.identityId == null) {
            throw new RuntimeException("L'identifiant de l'identité est requis pour obtenir l'identifiant des transactions du compte bancaire.");
        }
        if (query.bankAccountId == null) {
            throw new RuntimeException("L'identifiant du compte bancaire est requis pour l'import du relevé d'opérations du compte bancaire.");
        }
        Identity identity = this.identityProvider.read(query.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        BankAccount bankAccount = this.bankAccountProvider.read(query.bankAccountId)
                .orElseThrow(() -> new RuntimeException("L'identifiant du compte bancaire ne correspond à rien."));

        if (!bankAccount.belongsTo(identity.getId())) {
            throw new RuntimeException("Le compte bancaire " + bankAccount.getId().getValue() + " n'appartient pas à l'identité " + identity.getId().getValue() + ".");
        }

        if (query.limit() != null && query.limit.getValue() != null) {
            return this.transactionProvider.readIds(bankAccount.getId(), null, null, null).limit(query.limit.getValue());
        } else {
            return this.transactionProvider.readIds(bankAccount.getId(), null, null, null);
        }
    }


    public record Query(
            IdentityId identityId,
            BankAccountId bankAccountId,
            Limit limit
    ) {

    }
}
