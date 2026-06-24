package me.noynto.finance.infrastructure.persistence;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.ReplaceOptions;
import me.noynto.finance.domain.identity.IdentitySession;
import me.noynto.finance.domain.identity.IdentitySessionProvider;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.IdentitySessionId;
import org.bson.Document;

import java.util.Date;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

public record MongoPersistedIdentitySessions(
        MongoCollection<Document> collection
) implements IdentitySessionProvider {

    @Override
    public Stream<IdentitySessionId> readIds(IdentityId identityId) {
        return StreamSupport.stream(
                collection.find(Filters.eq("identityId", identityId.getValue()))
                          .map(doc -> sessionIdFrom(doc.getString("_id")))
                          .spliterator(),
                false
        );
    }

    @Override
    public Optional<IdentitySession> read(IdentitySessionId id) {
        return Optional.ofNullable(
                collection.find(Filters.eq("_id", id.getValue())).first()
        ).map(this::toSession);
    }

    @Override
    public IdentitySession write(IdentitySession session) {
        if (session.getId() == null || session.getId().getValue() == null) {
            var newId = new IdentitySessionId();
            newId.setValue(UUID.randomUUID().toString());
            session.setId(newId);
        }
        collection.replaceOne(
                Filters.eq("_id", session.getId().getValue()),
                toDocument(session),
                new ReplaceOptions().upsert(true)
        );
        return session;
    }

    private Document toDocument(IdentitySession session) {
        return new Document("_id", session.getId().getValue())
                .append("identityId", session.getIdentityId().getValue())
                .append("beginning", Date.from(session.getBeginning()));
    }

    private IdentitySession toSession(Document doc) {
        var id = new IdentitySessionId();
        id.setValue(doc.getString("_id"));
        var identityId = new IdentityId();
        identityId.setValue(doc.getString("identityId"));
        var session = new IdentitySession();
        session.setId(id);
        session.setIdentityId(identityId);
        session.setBeginning(doc.getDate("beginning").toInstant());
        return session;
    }

    private static IdentitySessionId sessionIdFrom(String value) {
        var sessionId = new IdentitySessionId();
        sessionId.setValue(value);
        return sessionId;
    }
}