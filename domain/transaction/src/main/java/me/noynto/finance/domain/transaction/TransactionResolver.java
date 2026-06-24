package me.noynto.finance.domain.transaction;

import java.io.InputStream;
import java.util.stream.Stream;

public interface TransactionResolver {

    Stream<Transaction> resolve(InputStream inputStream);

}
