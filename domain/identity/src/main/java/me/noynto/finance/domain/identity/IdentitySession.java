package me.noynto.finance.domain.identity;

import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.IdentitySessionId;

import java.time.Instant;
import java.time.temporal.ChronoUnit;

public class IdentitySession {
    private static final int HOURS_TO_LIVE = 3;
    private IdentitySessionId id;
    private IdentityId identityId;
    private Instant beginning;

    public IdentitySession() {
    }

    public IdentitySessionId getId() {
        return id;
    }

    public void setId(IdentitySessionId id) {
        this.id = id;
    }

    public IdentityId getIdentityId() {
        return identityId;
    }

    public void setIdentityId(IdentityId identityId) {
        this.identityId = identityId;
    }

    public Instant getBeginning() {
        return beginning;
    }

    public void setBeginning(Instant beginning) {
        this.beginning = beginning;
    }

    public boolean hasExpired(Instant now) {
        return this.getBeginning().plus(HOURS_TO_LIVE, ChronoUnit.HOURS).isBefore(now);
    }
}
