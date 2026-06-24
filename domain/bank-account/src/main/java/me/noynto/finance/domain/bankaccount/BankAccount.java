package me.noynto.finance.domain.bankaccount;

import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;

public class BankAccount {
    private BankAccountId id;
    private String name;
    private Bank bank;
    private IdentityId ownerIdentityId;

    public BankAccount() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Bank getBank() {
        return bank;
    }

    public void setBank(Bank bank) {
        this.bank = bank;
    }

    public IdentityId getOwnerIdentityId() {
        return ownerIdentityId;
    }

    public void setOwnerIdentityId(IdentityId ownerIdentityId) {
        this.ownerIdentityId = ownerIdentityId;
    }

    public BankAccountId getId() {
        return id;
    }

    public void setId(BankAccountId id) {
        this.id = id;
    }

    public boolean belongsTo(IdentityId id) {
        if (this.ownerIdentityId == null || this.ownerIdentityId.getValue() == null) {
            return false;
        }
        if (id.getValue() == null) {
            return false;
        }
        return this.ownerIdentityId.getValue().equalsIgnoreCase(id.getValue());
    }
}
