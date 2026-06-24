package me.noynto.finance.domain.identity;

import me.noynto.finance.domain.shared.IdentityId;

import java.util.Optional;
import java.util.stream.Stream;

public interface IdentityProvider {

    Stream<IdentityId> readIds(String electronicAddress);

    Optional<Identity> read(IdentityId id);

    Identity write(Identity identity);

}
