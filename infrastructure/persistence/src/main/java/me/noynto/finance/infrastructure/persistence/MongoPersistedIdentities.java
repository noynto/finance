package me.noynto.finance.infrastructure.persistence;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.ReplaceOptions;
import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.shared.IdentityId;
import org.bson.Document;

import java.util.Optional;
import java.util.UUID;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

public record MongoPersistedIdentities(
        MongoCollection<Document> collection
) implements IdentityProvider {

    @Override
    public Stream<IdentityId> readIds(String electronicAddress) {
        return StreamSupport.stream(
                collection.find(Filters.eq("electronicAddress", electronicAddress))
                          .map(doc -> idFrom(doc.getString("_id")))
                          .spliterator(),
                false
        );
    }

    @Override
    public Optional<Identity> read(IdentityId id) {
        return Optional.ofNullable(
                collection.find(Filters.eq("_id", id.getValue())).first()
        ).map(this::toIdentity);
    }

    @Override
    public Identity write(Identity identity) {
        if (identity.getId() == null || identity.getId().getValue() == null) {
            var newId = new IdentityId();
            newId.setValue(UUID.randomUUID().toString());
            identity.setId(newId);
        }
        collection.replaceOne(
                Filters.eq("_id", identity.getId().getValue()),
                toDocument(identity),
                new ReplaceOptions().upsert(true)
        );
        return identity;
    }

    private Document toDocument(Identity identity) {
        return new Document("_id", identity.getId().getValue())
                .append("electronicAddress", identity.getElectronicAddress())
                .append("secret", identity.getSecret());
    }

    private Identity toIdentity(Document doc) {
        var id = new IdentityId();
        id.setValue(doc.getString("_id"));
        var identity = new Identity();
        identity.setId(id);
        identity.setElectronicAddress(doc.getString("electronicAddress"));
        identity.setSecret(doc.getString("secret"));
        return identity;
    }

    private static IdentityId idFrom(String value) {
        var id = new IdentityId();
        id.setValue(value);
        return id;
    }
}