package me.noynto.finance.application;

import me.noynto.finance.domain.bankaccount.Bank;

import java.util.Arrays;
import java.util.stream.Stream;

public record GetBanks() {

    public Stream<Bank> handle() {
        return Arrays.stream(Bank.values());
    }
}
