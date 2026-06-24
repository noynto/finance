package me.noynto.finance.infrastructure.web;

import java.util.Arrays;
import java.util.List;
import java.util.Objects;

public class WebConfiguration {

    private static final String URL = "FINANCE_URL";
    private static final String SERVER_PORT = "FINANCE_SERVER_PORT";
    private static final String DEV_MODE = "FINANCE_DEV_MODE";
    private static final String CORS_ORIGINS = "FINANCE_CORS_ORIGINS";
    private static final String MONGODB_URI = "FINANCE_MONGODB_URI";

    public static Properties properties() {
        return new Properties(
                Integer.valueOf(Objects.requireNonNullElse(System.getenv(SERVER_PORT), "8080")),
                Objects.requireNonNullElse(System.getenv(URL), "http://localhost:8080"),
                Boolean.parseBoolean(System.getenv(DEV_MODE)),
                Arrays.stream(Objects.requireNonNullElse(System.getenv(CORS_ORIGINS), "").split(","))
                        .map(String::strip)
                        .filter(s -> !s.isBlank())
                        .toList(),
                Objects.requireNonNull(System.getenv(MONGODB_URI), "FINANCE_MONGODB_URI is required")
        );
    }

    public record Properties(
            Integer port,
            String url,
            boolean devMode,
            List<String> corsOrigins,
            String mongoUri
    ) {

    }

}
