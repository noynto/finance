package me.noynto.finance.domain.payee;

import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.PayeeId;
import me.noynto.finance.domain.shared.TransactionId;

import java.util.ArrayList;
import java.util.List;

public class Payee {
    private PayeeId id;
    private String name;
    private IdentityId ownerIdentityId;
    private List<TransactionId> transactionIds = new ArrayList<>();
    private String pattern;

    public Payee() {
    }

    public PayeeId getId() {
        return id;
    }

    public void setId(PayeeId id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public IdentityId getOwnerIdentityId() {
        return ownerIdentityId;
    }

    public void setOwnerIdentityId(IdentityId ownerIdentityId) {
        this.ownerIdentityId = ownerIdentityId;
    }

    public List<TransactionId> getTransactionIds() {
        if (transactionIds == null) transactionIds = new ArrayList<>();
        return transactionIds;
    }

    public void setTransactionIds(List<TransactionId> transactionIds) {
        this.transactionIds = transactionIds;
    }

    public String getPattern() {
        return pattern;
    }

    public void setPattern(String pattern) {
        this.pattern = pattern;
    }

    public boolean belongsTo(IdentityId id) {
        if (this.ownerIdentityId == null || this.ownerIdentityId.getValue() == null) return false;
        if (id == null || id.getValue() == null) return false;
        return this.ownerIdentityId.getValue().equalsIgnoreCase(id.getValue());
    }
}