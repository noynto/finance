package me.noynto.finance.domain.bankaccount;

import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;

import java.util.Optional;
import java.util.stream.Stream;

public interface BankAccountProvider {

    Stream<BankAccountId> readIds(IdentityId identityId);

    Optional<BankAccount> read(BankAccountId id);

    BankAccount write(BankAccount bankAccount);

    void delete(BankAccountId id);

}
