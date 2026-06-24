package me.noynto.finance.domain.transaction;

import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.TransactionId;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Optional;
import java.util.stream.Stream;

public interface TransactionProvider {
    Stream<TransactionId> readIds(BankAccountId bankAccountId, String description, Instant issuing, BigDecimal amount);

    Optional<Transaction> read(TransactionId id);

    Transaction write(Transaction transaction);

    void delete(TransactionId id);
}
