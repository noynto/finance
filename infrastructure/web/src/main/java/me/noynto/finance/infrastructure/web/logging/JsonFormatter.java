package me.noynto.finance.infrastructure.web.logging;

import java.time.Instant;
import java.util.logging.Formatter;
import java.util.logging.LogRecord;

public class JsonFormatter extends Formatter {

    @Override
    public String format(LogRecord record) {
        var sb = new StringBuilder();
        sb.append("{");
        sb.append("\"timestamp\":\"").append(Instant.ofEpochMilli(record.getMillis())).append("\",");
        sb.append("\"level\":\"").append(record.getLevel().getName()).append("\",");
        sb.append("\"logger\":\"").append(record.getLoggerName()).append("\",");
        sb.append("\"thread\":\"").append(Thread.currentThread().getName()).append("\",");
        sb.append("\"message\":\"").append(escape(formatMessage(record))).append("\"");
        if (record.getThrown() != null) {
            sb.append(",\"exception\":\"").append(escape(record.getThrown().toString())).append("\"");
        }
        sb.append("}\n");
        return sb.toString();
    }

    private String escape(String value) {
        if (value == null) return "";
        return value
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r");
    }

}