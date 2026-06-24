package me.noynto.finance.application;

import me.noynto.finance.domain.bankaccount.Bank;
import me.noynto.finance.domain.bankaccount.BankAccount;
import me.noynto.finance.domain.bankaccount.BankAccountProvider;
import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;

public record UpdateBankAccount(
        IdentityProvider identityProvider,
        BankAccountProvider bankAccountProvider
) {

    public BankAccount handle(Command command) {
        if (command.name == null || command.name.isBlank()) {
            throw new RuntimeException("Le nom est requis.");
        }

        Identity identity = this.identityProvider.read(command.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        BankAccount account = this.bankAccountProvider.read(command.bankAccountId)
                .orElseThrow(() -> new RuntimeException("Le compte bancaire n'existe pas."));

        if (!account.belongsTo(identity.getId())) {
            throw new RuntimeException("Le compte bancaire n'appartient pas à cette identité.");
        }

        account.setName(command.name.strip());
        try {
            account.setBank(Bank.valueOf(command.bank));
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Banque inconnue : " + command.bank);
        }

        return this.bankAccountProvider.write(account);
    }

    public record Command(
            IdentityId identityId,
            BankAccountId bankAccountId,
            String name,
            String bank
    ) {
    }
}