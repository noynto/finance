package me.noynto.finance.infrastructure.persistence;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.ReplaceOptions;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.TransactionId;
import me.noynto.finance.domain.transaction.Transaction;
import me.noynto.finance.domain.transaction.TransactionProvider;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.Decimal128;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.Optional;
import java.util.UUID;
import java.util.regex.Pattern;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

public record MongoPersistedTransactions(
        MongoCollection<Document> collection
) implements TransactionProvider {

    @Override
    public Stream<TransactionId> readIds(BankAccountId bankAccountId, String description, Instant issuing, BigDecimal amount) {
        var filters = new ArrayList<Bson>();

        if (bankAccountId != null && bankAccountId.getValue() != null && !bankAccountId.getValue().isBlank()) {
            filters.add(Filters.eq("bankAccountId", bankAccountId.getValue()));
        }
        if (description != null && !description.isBlank()) {
            filters.add(Filters.regex("description", Pattern.compile(Pattern.quote(description), Pattern.CASE_INSENSITIVE)));
        }
        if (issuing != null) {
            filters.add(Filters.eq("issuing", Date.from(issuing)));
        }
        if (amount != null) {
            filters.add(Filters.eq("amount", new Decimal128(amount)));
        }

        var query = filters.isEmpty() ? new Document() : Filters.and(filters);
        return StreamSupport.stream(
                collection.find(query)
                          .sort(new Document("issuing", -1))
                          .map(doc -> transactionIdFrom(doc.getString("_id")))
                          .spliterator(),
                false
        );
    }

    @Override
    public Optional<Transaction> read(TransactionId id) {
        return Optional.ofNullable(
                collection.find(Filters.eq("_id", id.getValue())).first()
        ).map(this::toTransaction);
    }

    @Override
    public void delete(TransactionId id) {
        collection.deleteOne(Filters.eq("_id", id.getValue()));
    }

    public Transaction write(Transaction transaction) {
        if (transaction.getId() == null || transaction.getId().getValue() == null) {
            var newId = new TransactionId();
            newId.setValue(UUID.randomUUID().toString());
            transaction.setId(newId);
        }
        collection.replaceOne(
                Filters.eq("_id", transaction.getId().getValue()),
                toDocument(transaction),
                new ReplaceOptions().upsert(true)
        );
        return transaction;
    }

    private Document toDocument(Transaction tx) {
        return new Document("_id", tx.getId().getValue())
                .append("description", tx.getDescription())
                .append("amount", new Decimal128(tx.getAmount()))
                .append("issuing", Date.from(tx.getIssuing()))
                .append("bankAccountId", tx.getBankAccountId().getValue());
    }

    private Transaction toTransaction(Document doc) {
        var id = new TransactionId();
        id.setValue(doc.getString("_id"));
        var bankAccountId = new BankAccountId();
        bankAccountId.setValue(doc.getString("bankAccountId"));
        var tx = new Transaction();
        tx.setId(id);
        tx.setDescription(doc.getString("description"));
        tx.setAmount(doc.get("amount", Decimal128.class).bigDecimalValue());
        tx.setIssuing(doc.getDate("issuing").toInstant());
        tx.setBankAccountId(bankAccountId);
        return tx;
    }

    private static TransactionId transactionIdFrom(String value) {
        var id = new TransactionId();
        id.setValue(value);
        return id;
    }
}