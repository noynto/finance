package me.noynto.finance.application;

import me.noynto.finance.domain.bankaccount.BankAccountProvider;
import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.payee.Payee;
import me.noynto.finance.domain.payee.PayeeProvider;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.PayeeId;
import me.noynto.finance.domain.shared.TransactionId;
import me.noynto.finance.domain.transaction.Transaction;
import me.noynto.finance.domain.transaction.TransactionProvider;

import java.util.List;
import java.util.Optional;
import java.util.regex.Pattern;

public record MatchTransactionToPayee(
        IdentityProvider identityProvider,
        PayeeProvider payeeProvider,
        BankAccountProvider bankAccountProvider,
        TransactionProvider transactionProvider
) {

    public void handle(Command command) {
        if (command.identityId == null) {
            throw new RuntimeException("L'identifiant de l'identité est requis.");
        }
        if (command.payeeId == null) {
            throw new RuntimeException("L'identifiant du bénéficiaire est requis.");
        }
        Identity identity = this.identityProvider.read(command.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        Payee payee = this.payeeProvider.read(command.payeeId)
                .orElseThrow(() -> new RuntimeException("Le bénéficiaire " + command.payeeId.getValue() + " n'existe pas."));

        Pattern pattern = Pattern.compile(payee.getPattern(), Pattern.CASE_INSENSITIVE);

        List<TransactionId> matchedIds = this.bankAccountProvider.readIds(identity.getId())
                .map(bankAccountProvider::read)
                .filter(Optional::isPresent)
                .map(Optional::get)
                .filter(bankAccount -> bankAccount.belongsTo(identity.getId()))
                .flatMap(bankAccount -> transactionProvider.readIds(bankAccount.getId(), null, null, null))
                .map(transactionProvider::read)
                .filter(Optional::isPresent)
                .map(Optional::get)
                .filter(transaction -> transaction.getDescription() != null
                        && pattern.matcher(transaction.getDescription()).find())
                .map(Transaction::getId)
                .toList();

        payee.setTransactionIds(matchedIds);
        this.payeeProvider.write(payee);
    }

    public record Command(
            IdentityId identityId,
            PayeeId payeeId
    ) {
    }
}
