package me.noynto.finance.infrastructure.xlsx;

import me.noynto.finance.domain.transaction.Transaction;
import me.noynto.finance.domain.transaction.TransactionResolver;
import org.dhatim.fastexcel.reader.ReadableWorkbook;
import org.dhatim.fastexcel.reader.Row;

import java.io.IOException;
import java.io.InputStream;
import java.io.UncheckedIOException;
import java.math.BigDecimal;
import java.time.ZoneOffset;
import java.util.Optional;
import java.util.stream.Stream;

public class XlsxTransactionResolver implements TransactionResolver {

    @Override
    public Stream<Transaction> resolve(InputStream inputStream) {
        try {
            ReadableWorkbook workbook = new ReadableWorkbook(inputStream);
            Stream<Row> rows = workbook.getFirstSheet().openStream();

            return rows.skip(9)
                    .map(this::toTransaction)
                    .onClose(() -> {
                        try { rows.close(); } catch (Exception ignored) {}
                        try { workbook.close(); } catch (Exception ignored) {}
                    });
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    private Transaction toTransaction(Row row) {
        var transaction = new Transaction();

        row.getCellAsDate(0).ifPresent(date ->
            transaction.setIssuing(date.toInstant(ZoneOffset.UTC))
        );

        transaction.setDescription(row.getCellText(1));

        BigDecimal debit = parseMoney(row, 2);
        BigDecimal credit = parseMoney(row, 3);
        transaction.setAmount(credit.subtract(debit));

        return transaction;
    }

    private BigDecimal parseMoney(Row row, int index) {
        Optional<BigDecimal> number = row.getCellAsNumber(index);
        if (number.isPresent()) return number.get();
        String text = row.getCellText(index).trim().replace(",", ".");
        return text.isEmpty() ? BigDecimal.ZERO : new BigDecimal(text);
    }

}