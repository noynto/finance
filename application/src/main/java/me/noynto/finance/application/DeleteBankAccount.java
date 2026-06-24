package me.noynto.finance.application;

import me.noynto.finance.domain.bankaccount.BankAccount;
import me.noynto.finance.domain.bankaccount.BankAccountProvider;
import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.transaction.TransactionProvider;

import java.util.Optional;

public record DeleteBankAccount(
        IdentityProvider identityProvider,
        BankAccountProvider bankAccountProvider,
        TransactionProvider transactionProvider
) {

    public void handle(Command command) {
        Identity identity = this.identityProvider.read(command.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        BankAccount account = this.bankAccountProvider.read(command.bankAccountId)
                .orElseThrow(() -> new RuntimeException("Le compte bancaire n'existe pas."));

        if (!account.belongsTo(identity.getId())) {
            throw new RuntimeException("Le compte bancaire n'appartient pas à cette identité.");
        }

        this.transactionProvider.readIds(account.getId(),null,null,null)
                .forEach(transactionProvider::delete);

        this.bankAccountProvider.delete(command.bankAccountId);
    }

    public record Command(
            IdentityId identityId,
            BankAccountId bankAccountId
    ) {
    }
}