package me.noynto.finance.infrastructure.persistence;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;

public class MongoConfiguration {

    private final MongoClient client;
    private final MongoDatabase database;

    public MongoConfiguration(String uri) {
        this.client = MongoClients.create(uri);
        this.database = this.client.getDatabase("finance");
    }

    public MongoPersistedIdentities identities() {
        return new MongoPersistedIdentities(database.getCollection("identities"));
    }

    public MongoPersistedIdentitySessions identitySessions() {
        return new MongoPersistedIdentitySessions(database.getCollection("identity_sessions"));
    }

    public MongoPersistedBankAccounts bankAccounts() {
        return new MongoPersistedBankAccounts(database.getCollection("bank_accounts"));
    }

    public MongoPersistedTransactions transactions() {
        return new MongoPersistedTransactions(database.getCollection("transactions"));
    }

    public MongoPersistedPayees payees() {
        return new MongoPersistedPayees(database.getCollection("payees"));
    }
}