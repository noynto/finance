# ── Stage 1 : Build ───────────────────────────────────────────────────────────
# Build context : racine du projet
# docker build -f web.Dockerfile .
FROM --platform=$BUILDPLATFORM maven:3.9-eclipse-temurin-25 AS builder

WORKDIR /app

# Les pom.xml sont copiés avant les sources pour que Docker cache la couche
# de résolution des dépendances — elle ne se recharge que si un pom.xml change
COPY pom.xml                                    .
COPY domain/pom.xml                             domain/
COPY domain/shared/pom.xml                      domain/shared/
COPY domain/bank-account/pom.xml                domain/bank-account/
COPY domain/identity/pom.xml                    domain/identity/
COPY domain/payee/pom.xml                       domain/payee/
COPY domain/transaction/pom.xml                 domain/transaction/
COPY application/pom.xml                        application/
COPY infrastructure/pom.xml                     infrastructure/
COPY infrastructure/web/pom.xml                 infrastructure/web/
COPY infrastructure/hashing/pom.xml             infrastructure/hashing/
COPY infrastructure/persistence/pom.xml         infrastructure/persistence/
COPY infrastructure/tasks/pom.xml               infrastructure/tasks/
COPY infrastructure/xlsx/pom.xml                infrastructure/xlsx/

RUN --mount=type=cache,target=/root/.m2 \
    mvn dependency:go-offline -q

# Seules les sources dont le module web dépend sont copiées (--also-make)
# tasks est exclu : non dépendance de web, un changement là ne rebuild pas l'image
COPY domain/shared/src                          domain/shared/src
COPY domain/bank-account/src                    domain/bank-account/src
COPY domain/identity/src                        domain/identity/src
COPY domain/payee/src                           domain/payee/src
COPY domain/transaction/src                     domain/transaction/src
COPY application/src                            application/src
COPY infrastructure/hashing/src                 infrastructure/hashing/src
COPY infrastructure/persistence/src             infrastructure/persistence/src
COPY infrastructure/xlsx/src                    infrastructure/xlsx/src
COPY infrastructure/web/src                     infrastructure/web/src

# install (et non package) pour que les modules internes soient disponibles
# dans le repo local lors du dependency:copy-dependencies
RUN --mount=type=cache,target=/root/.m2 \
    mvn install -DskipTests -q -pl infrastructure/web --also-make && \
    mvn dependency:copy-dependencies \
      -DoutputDirectory=infrastructure/web/target/deps \
      -pl infrastructure/web -q

# ── Stage 2 : OTel Java agent ─────────────────────────────────────────────────
# Stage isolé pour que le téléchargement de l'agent soit mis en cache
# indépendamment du build Maven — ne se re-télécharge que si OTEL_VERSION change
FROM eclipse-temurin:25-jdk-noble AS otel-agent
ARG OTEL_VERSION=2.10.0
RUN apt-get update -qq && apt-get install -y -qq curl && \
    curl -fsSL -o /otel-javaagent.jar \
    "https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_VERSION}/opentelemetry-javaagent.jar"

# ── Stage 3 : Runtime ─────────────────────────────────────────────────────────
FROM eclipse-temurin:25-jre-noble AS runtime

WORKDIR /app

COPY --from=builder    /app/infrastructure/web/target/deps                           ./deps
COPY --from=builder    /app/infrastructure/web/target/web-*.jar                      ./app.jar
COPY --from=otel-agent /otel-javaagent.jar                                           ./otel-javaagent.jar

# ── Variables d'environnement ─────────────────────────────────────────────────

# [OBLIGATOIRE] URI de connexion MongoDB
# Exemple : mongodb://user:password@host:27017/finance
ENV MONGO_URI=""

# Port d'écoute du serveur HTTP (défaut : 8080)
ENV FINANCE_SERVER_PORT="8080"

# [OTel] Nom du service affiché dans les outils d'observabilité (Grafana, Jaeger...)
ENV OTEL_SERVICE_NAME="finance"

# [OTel] Endpoint du collecteur OTLP (ex: http://otel-collector:4317)
ENV OTEL_EXPORTER_OTLP_ENDPOINT=""

# [OTel] Exporteurs désactivés par défaut — activer au runtime selon l'environnement
# Valeurs possibles : otlp | none
ENV OTEL_TRACES_EXPORTER="none"
ENV OTEL_METRICS_EXPORTER="none"
ENV OTEL_LOGS_EXPORTER="none"

EXPOSE 8080

# -javaagent     : agent OTel injecté au démarrage, instrumente Jetty et MongoDB automatiquement
# UseContainerSupport + MaxRAMPercentage : adapte la mémoire aux limites du conteneur
# ZGC Generational : GC à faible latence, adapté aux applis à SLA strict
ENTRYPOINT ["java", \
  "-javaagent:otel-javaagent.jar", \
  "-XX:+UseContainerSupport", \
  "-XX:MaxRAMPercentage=75.0", \
  "-XX:+UseZGC", \
  "-XX:+ZGenerational", \
  "-cp", "app.jar:deps/*", \
  "me.noynto.finance.infrastructure.web.Web"]