package me.noynto.finance.infrastructure.persistence;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.ReplaceOptions;
import me.noynto.finance.domain.payee.Payee;
import me.noynto.finance.domain.payee.PayeeProvider;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.PayeeId;
import me.noynto.finance.domain.shared.TransactionId;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

public record MongoPersistedPayees(
        MongoCollection<Document> collection
) implements PayeeProvider {

    @Override
    public Stream<PayeeId> readIds(IdentityId identityId) {
        return StreamSupport.stream(
                collection.find(Filters.eq("ownerIdentityId", identityId.getValue()))
                          .map(doc -> payeeIdFrom(doc.getString("_id")))
                          .spliterator(),
                false
        );
    }

    @Override
    public Optional<Payee> read(PayeeId id) {
        return Optional.ofNullable(
                collection.find(Filters.eq("_id", id.getValue())).first()
        ).map(this::toPayee);
    }

    @Override
    public void delete(PayeeId id) {
        collection.deleteOne(Filters.eq("_id", id.getValue()));
    }

    @Override
    public Payee write(Payee payee) {
        if (payee.getId() == null || payee.getId().getValue() == null) {
            var newId = new PayeeId();
            newId.setValue(UUID.randomUUID().toString());
            payee.setId(newId);
        }
        collection.replaceOne(
                Filters.eq("_id", payee.getId().getValue()),
                toDocument(payee),
                new ReplaceOptions().upsert(true)
        );
        return payee;
    }

    private Document toDocument(Payee payee) {
        var txIds = payee.getTransactionIds().stream()
                .map(tx -> tx.getValue())
                .toList();
        return new Document("_id", payee.getId().getValue())
                .append("name", payee.getName())
                .append("pattern", payee.getPattern())
                .append("ownerIdentityId", payee.getOwnerIdentityId().getValue())
                .append("transactionIds", txIds);
    }

    private Payee toPayee(Document doc) {
        var id = new PayeeId();
        id.setValue(doc.getString("_id"));
        var ownerIdentityId = new IdentityId();
        ownerIdentityId.setValue(doc.getString("ownerIdentityId"));

        var txIds = new ArrayList<>(doc.getList("transactionIds", String.class, List.of())
                .stream().map(v -> {
                    var txId = new TransactionId();
                    txId.setValue(v);
                    return txId;
                }).toList());

        var payee = new Payee();
        payee.setId(id);
        payee.setName(doc.getString("name"));
        payee.setPattern(doc.getString("pattern"));
        payee.setOwnerIdentityId(ownerIdentityId);
        payee.setTransactionIds(txIds);
        return payee;
    }

    private static PayeeId payeeIdFrom(String value) {
        var id = new PayeeId();
        id.setValue(value);
        return id;
    }
}