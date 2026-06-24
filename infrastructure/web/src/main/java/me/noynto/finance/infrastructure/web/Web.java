package me.noynto.finance.infrastructure.web;

import gg.jte.ContentType;
import gg.jte.TemplateEngine;
import gg.jte.resolve.DirectoryCodeResolver;
import io.javalin.Javalin;
import io.javalin.compression.CompressionStrategy;
import io.javalin.config.JavalinConfig;
import io.javalin.http.staticfiles.Location;
import io.javalin.rendering.template.JavalinJte;
import me.noynto.finance.application.CountTransactionsOfBankAccount;
import me.noynto.finance.application.CreateBankAccount;
import me.noynto.finance.application.DeleteBankAccount;
import me.noynto.finance.application.CreatePayee;
import me.noynto.finance.application.DeletePayee;
import me.noynto.finance.application.GetBalance;
import me.noynto.finance.application.GetBalanceOfBankAccount;
import me.noynto.finance.application.GetBalanceOfPayee;
import me.noynto.finance.application.GetPayee;
import me.noynto.finance.application.GetPayeeIds;
import me.noynto.finance.application.UpdateBankAccount;
import me.noynto.finance.application.UpdatePayee;
import me.noynto.finance.application.GetBankAccount;
import me.noynto.finance.application.GetBankAccountIds;
import me.noynto.finance.application.GetTransaction;
import me.noynto.finance.application.GetTransactionIdsOfBankAccount;
import me.noynto.finance.application.GetValidIdentitySession;
import me.noynto.finance.application.ImportBankStatementOnBankAccount;
import me.noynto.finance.application.MatchTransactionToPayee;
import me.noynto.finance.application.SignIn;
import me.noynto.finance.application.SignUp;
import me.noynto.finance.domain.shared.IdentitySessionId;
import me.noynto.finance.infrastructure.hashing.BcryptIdentitySecretProvider;
import me.noynto.finance.infrastructure.persistence.MongoConfiguration;
import me.noynto.finance.infrastructure.xlsx.XlsxTransactionResolver;

import java.io.IOException;
import java.nio.file.Path;
import java.time.Clock;
import java.util.Arrays;
import java.util.List;
import java.util.logging.LogManager;
import java.util.logging.Logger;

public class Web {

    private static final Logger LOG = Logger.getLogger(Web.class.getName());

    static void main(String[] args) throws IOException {

        LogManager.getLogManager().readConfiguration(
                Web.class.getResourceAsStream("/logging.properties")
        );

        var properties = WebConfiguration.properties();

        var clock            = Clock.systemUTC();
        var mongo            = new MongoConfiguration(properties.mongoUri());
        var identities       = mongo.identities();
        var identitySessions = mongo.identitySessions();
        var bankAccounts     = mongo.bankAccounts();
        var transactions     = mongo.transactions();
        var secretProvider   = new BcryptIdentitySecretProvider();

        var getValidIdentitySession = new GetValidIdentitySession(identitySessions);
        var signUpController        = new SignUpController(new SignUp(clock, identities, secretProvider, identitySessions));
        var signInController        = new SignInController(new SignIn(clock, identities, secretProvider, identitySessions));
        var payees            = mongo.payees();
        var getBankAccountIds = new GetBankAccountIds(identities, bankAccounts);
        var getBankAccount    = new GetBankAccount(identities, bankAccounts);
        var getPayeeIds = new GetPayeeIds(identities, payees);
        var getPayee    = new GetPayee(identities, payees);
        var dashboardController = new DashboardController(
                getBankAccountIds,
                getBankAccount,
                new GetBalance(identities, bankAccounts, transactions),
                getPayeeIds,
                getPayee
        );

        var bankAccountController = new BankAccountController(
                getBankAccountIds,
                getBankAccount,
                new CreateBankAccount(bankAccounts),
                new GetTransactionIdsOfBankAccount(identities, bankAccounts, transactions),
                new GetTransaction(identities, bankAccounts, transactions),
                new CountTransactionsOfBankAccount(identities, bankAccounts, transactions),
                new GetBalanceOfBankAccount(identities, bankAccounts, transactions),
                new UpdateBankAccount(identities, bankAccounts),
                new DeleteBankAccount(identities, bankAccounts, transactions)
        );
        var transactionController = new TransactionController(
                getBankAccountIds,
                getBankAccount,
                new ImportBankStatementOnBankAccount(identities, bankAccounts, transactions, new XlsxTransactionResolver(), payees)
        );
        var payeeController = new PayeeController(
                new CreatePayee(payees),
                getPayee,
                new UpdatePayee(identities, payees),
                new DeletePayee(identities, payees),
                new MatchTransactionToPayee(identities, payees, bankAccounts, transactions),
                new GetBalanceOfPayee(identities, payees, transactions),
                new GetTransaction(identities, bankAccounts, transactions)
        );

        Javalin.create(config -> {
                    config.startup.showJavalinBanner = false;
                    config.staticFiles.add("/public", Location.CLASSPATH);
                    config.fileRenderer(new JavalinJte(templateEngine(properties.devMode())));
                    config.http.compressionStrategy = CompressionStrategy.GZIP;
                    configureCors(config, properties.corsOrigins());
                    config.requestLogger.http((ctx, ms) ->
                            LOG.info("%s %s → %d (%.0fms)".formatted(ctx.method(), ctx.path(), ctx.statusCode(), ms))
                    );
                    config.routes.before(ctx -> {
                        var path = ctx.path();
                        if (path.startsWith("/sign-in") || path.startsWith("/sign-up") || path.endsWith(".js") || path.endsWith(".css") || path.endsWith(".ico")) return;
                        var cookieValue = ctx.cookie("identity-session-id");
                        if (cookieValue == null || cookieValue.isBlank()) {
                            ctx.redirect("/sign-in");
                            return;
                        }
                        var sessionId = new IdentitySessionId();
                        sessionId.setValue(cookieValue);
                        try {
                            var session = getValidIdentitySession.handle(new GetValidIdentitySession.Command(sessionId));
                            ctx.attribute("identityId", session.getIdentityId());
                        } catch (RuntimeException e) {
                            ctx.redirect("/sign-in");
                        }
                    });
                    signUpController.register(config.routes);
                    signInController.register(config.routes);
                    dashboardController.register(config.routes);
                    bankAccountController.register(config.routes);
                    transactionController.register(config.routes);
                    payeeController.register(config.routes);
                })
                .start(properties.port());
    }

    private static void configureCors(JavalinConfig config, List<String> origins) {
        if (origins.isEmpty()) return;
        config.bundledPlugins.enableCors(cors -> cors.addRule(rule -> {
            var arr = origins.toArray(String[]::new);
            rule.allowHost(arr[0], Arrays.copyOfRange(arr, 1, arr.length));
        }));
    }

    private static TemplateEngine templateEngine(boolean dev) {
        if (dev) {
            var resolver = new DirectoryCodeResolver(Path.of("infrastructure/web/src/main/jte"));
            return TemplateEngine.create(resolver, ContentType.Html);
        }
        return TemplateEngine.createPrecompiled(ContentType.Html);
    }

}