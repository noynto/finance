package me.noynto.finance.application;

import me.noynto.finance.domain.bankaccount.BankAccount;
import me.noynto.finance.domain.bankaccount.BankAccountProvider;
import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.payee.Payee;
import me.noynto.finance.domain.payee.PayeeProvider;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.transaction.Transaction;
import me.noynto.finance.domain.transaction.TransactionProvider;
import me.noynto.finance.domain.transaction.TransactionResolver;

import java.io.InputStream;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public record ImportBankStatementOnBankAccount(
        IdentityProvider identityProvider,
        BankAccountProvider bankAccountProvider,
        TransactionProvider transactionProvider,
        TransactionResolver transactionResolver,
        PayeeProvider payeeProvider
) {

    public void handle(Command command) {
        if (command.identityId == null) {
            throw new RuntimeException("L'identifiant de l'identité est requis pour l'import du relevé d'opérations du compte bancaire.");
        }
        if (command.bankAccountId == null) {
            throw new RuntimeException("L'identifiant du compte bancaire est requis pour l'import du relevé d'opérations du compte bancaire.");
        }
        if (command.inputStream == null) {
            throw new RuntimeException("Le flux d'informations est requis pour l'import du relevé d'opérations du compte bancaire.");
        }

        Identity identity = this.identityProvider.read(command.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        BankAccount bankAccount = this.bankAccountProvider.read(command.bankAccountId)
                .orElseThrow(() -> new RuntimeException("L'identifiant du compte bancaire ne correspond à rien."));

        if (!bankAccount.belongsTo(identity.getId())) {
            throw new RuntimeException("Le compte bancaire " + bankAccount.getId().getValue() + " n'appartient pas à l'identité " + identity.getId().getValue() + ".");
        }

        var payeePatterns = loadPayeePatterns(identity.getId());

        try (Stream<Transaction> transactionStream = this.transactionResolver().resolve(command.inputStream)) {
            transactionStream
                    .peek(transaction -> transaction.setBankAccountId(bankAccount.getId()))
                    .filter(transaction -> this.transactionProvider.readIds(bankAccount.getId(), transaction.getDescription(), transaction.getIssuing(), transaction.getAmount()).findAny().isEmpty())
                    .map(this.transactionProvider::write)
                    .forEach(transaction -> matchToPayees(transaction, payeePatterns));
        }
    }

    private Map<Payee, Pattern> loadPayeePatterns(IdentityId identityId) {
        return this.payeeProvider.readIds(identityId)
                .map(this.payeeProvider::read)
                .filter(Optional::isPresent)
                .map(Optional::get)
                .filter(p -> p.getPattern() != null && !p.getPattern().isBlank())
                .collect(Collectors.toMap(
                        p -> p,
                        p -> Pattern.compile(p.getPattern(), Pattern.CASE_INSENSITIVE)
                ));
    }

    private void matchToPayees(Transaction transaction, Map<Payee, Pattern> payeePatterns) {
        if (transaction.getDescription() == null) return;
        payeePatterns.forEach((payee, pattern) -> {
            if (pattern.matcher(transaction.getDescription()).find()) {
                payee.getTransactionIds().add(transaction.getId());
                this.payeeProvider.write(payee);
            }
        });
    }

    public record Command(
            IdentityId identityId,
            BankAccountId bankAccountId,
            InputStream inputStream
    ) {
    }
}