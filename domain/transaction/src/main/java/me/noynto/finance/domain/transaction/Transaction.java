package me.noynto.finance.domain.transaction;

import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.TransactionId;

import java.math.BigDecimal;
import java.time.Instant;

public class Transaction {
    private TransactionId id;
    private String description;
    private BigDecimal amount;
    private Instant issuing;
    private BankAccountId bankAccountId;

    public Transaction() {
    }

    public TransactionId getId() {
        return id;
    }

    public void setId(TransactionId id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Instant getIssuing() {
        return issuing;
    }

    public void setIssuing(Instant issuing) {
        this.issuing = issuing;
    }

    public BankAccountId getBankAccountId() {
        return bankAccountId;
    }

    public void setBankAccountId(BankAccountId bankAccountId) {
        this.bankAccountId = bankAccountId;
    }
}
