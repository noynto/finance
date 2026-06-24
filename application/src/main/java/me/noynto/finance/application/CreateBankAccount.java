package me.noynto.finance.application;

import me.noynto.finance.domain.bankaccount.Bank;
import me.noynto.finance.domain.bankaccount.BankAccount;
import me.noynto.finance.domain.bankaccount.BankAccountProvider;
import me.noynto.finance.domain.shared.IdentityId;

import java.util.Arrays;

public record CreateBankAccount(
        BankAccountProvider bankAccountProvider
) {

    public BankAccount handle(Command command) {
        if (command.bankName == null || command.bankName.isBlank()) {
            throw new RuntimeException("Le nom de la banque est requis pour créer le compte.");
        }
        if (command.name == null || command.name.isBlank()) {
            throw new RuntimeException("Le nom est requis pour créer le compte.");
        }
        if (command.identityId == null || command.identityId.getValue() == null || command.identityId.getValue().isBlank()) {
            throw new RuntimeException("L'identifiant de l'identité propriétaire est requis pour créer le compte.");
        }

        Bank bank;
        try {
            bank = Bank.valueOf(command.bankName);
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Aucune banque ne semble correspondre au nom fourni.");
        }

        BankAccount bankAccount = new BankAccount();
        bankAccount.setBank(bank);
        bankAccount.setName(command.name);
        bankAccount.setOwnerIdentityId(command.identityId);

        return this.bankAccountProvider.write(bankAccount);
    }

    public record Command(
            String bankName,
            String name,
            IdentityId identityId
    ) {
    }

}
