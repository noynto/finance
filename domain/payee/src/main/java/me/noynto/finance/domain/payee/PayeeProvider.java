package me.noynto.finance.domain.payee;

import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.PayeeId;

import java.util.Optional;
import java.util.stream.Stream;

public interface PayeeProvider {

    Stream<PayeeId> readIds(IdentityId identityId);

    Optional<Payee> read(PayeeId id);

    Payee write(Payee payee);

    void delete(PayeeId id);

}