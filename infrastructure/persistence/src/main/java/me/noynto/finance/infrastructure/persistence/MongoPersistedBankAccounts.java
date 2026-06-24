package me.noynto.finance.infrastructure.persistence;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.ReplaceOptions;
import me.noynto.finance.domain.bankaccount.Bank;
import me.noynto.finance.domain.bankaccount.BankAccount;
import me.noynto.finance.domain.bankaccount.BankAccountProvider;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;
import org.bson.Document;

import java.util.Optional;
import java.util.UUID;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

public record MongoPersistedBankAccounts(
        MongoCollection<Document> collection
) implements BankAccountProvider {

    @Override
    public Stream<BankAccountId> readIds(IdentityId identityId) {
        return StreamSupport.stream(
                collection.find(Filters.eq("ownerIdentityId", identityId.getValue()))
                          .map(doc -> bankAccountIdFrom(doc.getString("_id")))
                          .spliterator(),
                false
        );
    }

    @Override
    public Optional<BankAccount> read(BankAccountId id) {
        return Optional.ofNullable(
                collection.find(Filters.eq("_id", id.getValue())).first()
        ).map(this::toBankAccount);
    }

    @Override
    public void delete(BankAccountId id) {
        collection.deleteOne(Filters.eq("_id", id.getValue()));
    }

    @Override
    public BankAccount write(BankAccount account) {
        if (account.getId() == null || account.getId().getValue() == null) {
            var newId = new BankAccountId();
            newId.setValue(UUID.randomUUID().toString());
            account.setId(newId);
        }
        collection.replaceOne(
                Filters.eq("_id", account.getId().getValue()),
                toDocument(account),
                new ReplaceOptions().upsert(true)
        );
        return account;
    }

    private Document toDocument(BankAccount account) {
        return new Document("_id", account.getId().getValue())
                .append("name", account.getName())
                .append("bank", account.getBank().name())
                .append("ownerIdentityId", account.getOwnerIdentityId().getValue());
    }

    private BankAccount toBankAccount(Document doc) {
        var id = new BankAccountId();
        id.setValue(doc.getString("_id"));
        var ownerIdentityId = new IdentityId();
        ownerIdentityId.setValue(doc.getString("ownerIdentityId"));
        var account = new BankAccount();
        account.setId(id);
        account.setName(doc.getString("name"));
        account.setBank(Bank.valueOf(doc.getString("bank")));
        account.setOwnerIdentityId(ownerIdentityId);
        return account;
    }

    private static BankAccountId bankAccountIdFrom(String value) {
        var id = new BankAccountId();
        id.setValue(value);
        return id;
    }
}