package me.noynto.finance.application;

import me.noynto.finance.domain.bankaccount.BankAccount;
import me.noynto.finance.domain.bankaccount.BankAccountProvider;
import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.TransactionId;
import me.noynto.finance.domain.transaction.Transaction;
import me.noynto.finance.domain.transaction.TransactionProvider;

public record GetTransaction(
        IdentityProvider identityProvider,
        BankAccountProvider bankAccountProvider,
        TransactionProvider transactionProvider
) {

    public Transaction handle(Query query) {
        if (query.identityId == null) {
            throw new RuntimeException("L'identifiant de l'identité est requis pour obtenir l'identifiant des transactions du compte bancaire.");
        }
        Identity identity = this.identityProvider.read(query.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        Transaction transaction = this.transactionProvider.read(query.transactionId)
                .orElseThrow(() -> new RuntimeException("L'opération " + query.identityId.getValue() + " ne semble pas exister."));

        if (transaction.getBankAccountId() == null || transaction.getBankAccountId().getValue() == null) {
            throw new RuntimeException("Une opération est forcément lié à un compte bancaire.");
        }

        BankAccountId bankAccountId = transaction.getBankAccountId();

        BankAccount bankAccount = this.bankAccountProvider.read(bankAccountId)
                .orElseThrow(() -> new RuntimeException("Le compte bancaire " + bankAccountId.getValue() + " lié à l'opération " + transaction.getId().getValue() + " ne semble pas exister."));

        if (!bankAccount.belongsTo(identity.getId())) {
            throw new RuntimeException("Le compte bancaire " + bankAccount.getId().getValue() + " n'appartient pas à l'identité " + identity.getId().getValue() + ".");
        }

        return transaction;
    }


    public record Query(
            IdentityId identityId,
            TransactionId transactionId
    ) {

    }
}
