package me.noynto.finance.domain.shared;

import java.time.Instant;

public class Period {
    private Instant begin;
    private Instant end;

    public Period() {
    }

    public Instant getBegin() {
        return begin;
    }

    public void setBegin(Instant begin) {
        this.begin = begin;
    }

    public Instant getEnd() {
        return end;
    }

    public void setEnd(Instant end) {
        this.end = end;
    }
}
