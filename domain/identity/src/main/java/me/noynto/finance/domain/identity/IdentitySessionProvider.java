package me.noynto.finance.domain.identity;

import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.IdentitySessionId;

import java.util.Optional;
import java.util.stream.Stream;

public interface IdentitySessionProvider {

    Stream<IdentitySessionId> readIds(IdentityId identityId);

    Optional<IdentitySession> read(IdentitySessionId id);

    IdentitySession write(IdentitySession identitySession);

}
