package me.noynto.finance.infrastructure.web;

import io.javalin.http.Context;
import io.javalin.router.JavalinDefaultRoutingApi;
import me.noynto.finance.application.CountTransactionsOfBankAccount;
import me.noynto.finance.application.CreateBankAccount;
import me.noynto.finance.application.DeleteBankAccount;
import me.noynto.finance.application.GetBalanceOfBankAccount;
import me.noynto.finance.application.GetBankAccount;
import me.noynto.finance.application.GetBankAccountIds;
import me.noynto.finance.application.GetBanks;
import me.noynto.finance.application.UpdateBankAccount;
import me.noynto.finance.application.GetTransaction;
import me.noynto.finance.application.GetTransactionIdsOfBankAccount;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.Limit;
import me.noynto.finance.domain.shared.TransactionId;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class BankAccountController {

    private static final ZoneId ZONE = ZoneId.of("Europe/Paris");
    private static final DateTimeFormatter SHORT_MONTH = DateTimeFormatter.ofPattern("MMM", Locale.FRENCH);

    private final GetBankAccountIds getBankAccountIds;
    private final GetBankAccount getBankAccount;
    private final CreateBankAccount createBankAccount;
    private final GetBanks getBanks;
    private final GetTransactionIdsOfBankAccount getTransactionIdsOfBankAccount;
    private final GetTransaction getTransaction;
    private final CountTransactionsOfBankAccount countTransactions;
    private final GetBalanceOfBankAccount getBalance;
    private final UpdateBankAccount updateBankAccount;
    private final DeleteBankAccount deleteBankAccount;

    public BankAccountController(
            GetBankAccountIds getBankAccountIds,
            GetBankAccount getBankAccount,
            CreateBankAccount createBankAccount,
            GetTransactionIdsOfBankAccount getTransactionIdsOfBankAccount,
            GetTransaction getTransaction,
            CountTransactionsOfBankAccount countTransactions,
            GetBalanceOfBankAccount getBalance,
            UpdateBankAccount updateBankAccount,
            DeleteBankAccount deleteBankAccount
    ) {
        this.getBankAccountIds = getBankAccountIds;
        this.getBankAccount = getBankAccount;
        this.createBankAccount = createBankAccount;
        this.getBanks = new GetBanks();
        this.getTransactionIdsOfBankAccount = getTransactionIdsOfBankAccount;
        this.getTransaction = getTransaction;
        this.countTransactions = countTransactions;
        this.getBalance = getBalance;
        this.updateBankAccount = updateBankAccount;
        this.deleteBankAccount = deleteBankAccount;
    }

    public void register(JavalinDefaultRoutingApi router) {
        router.get("/bank-accounts/new", this::newForm);
        router.post("/bank-accounts", this::create);
        router.get("/banks", this::banks);
        router.get("/bank-accounts/{id}", this::dashboard);
        router.get("/bank-accounts/{id}/count",   this::dashboardCount);
        router.get("/bank-accounts/{id}/balance", this::dashboardBalance);
        router.get("/bank-accounts/{id}/last-transactions", this::dashboardLastTransactions);
        router.get("/bank-accounts/{id}/settings",       this::showSettings);
        router.get("/bank-accounts/{id}/settings/banks", this::settingsBanks);
        router.post("/bank-accounts/{id}/settings",      this::update);
        router.post("/bank-accounts/{id}/delete",        this::delete);
        router.get("/bank-accounts/{id}/transactions",       this::transactions);
        router.get("/bank-accounts/{id}/transactions/count", this::transactionCount);
        router.get("/bank-accounts/{id}/transactions/{txId}", this::transaction);
    }

    private void newForm(Context ctx) {
        ctx.render("nouveau-compte-bancaire.jte", Map.of("error", ""));
    }

    private void banks(Context ctx) {
        var banks = getBanks.handle().toList();
        ctx.render("banks.jte", Map.of("banks", banks));
    }

    private void create(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var bankName = ctx.formParam("bank");
        var name = ctx.formParam("name");
        try {
            createBankAccount.handle(new CreateBankAccount.Command(bankName, name, identityId));
            ctx.redirect("/");
        } catch (RuntimeException e) {
            ctx.render("nouveau-compte-bancaire.jte", Map.of("error", e.getMessage()));
        }
    }

    private void dashboard(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var bankAccountId = bankAccountIdFrom(ctx);
        var account = getBankAccount.handle(new GetBankAccount.Query(identityId, bankAccountId));
        ctx.render("bank-account-dashboard.jte", Map.of(
                "bankAccountId",   bankAccountId.getValue(),
                "bankAccountName", account.getName()
        ));
    }

    private void dashboardCount(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var bankAccountId = bankAccountIdFrom(ctx);
        var count = countTransactions.handle(new CountTransactionsOfBankAccount.Query(identityId, bankAccountId));
        ctx.render("bank-account-dashboard-count.jte", Map.of("count", count));
    }

    private void dashboardBalance(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var bankAccountId = bankAccountIdFrom(ctx);
        var balance = getBalance.handle(new GetBalanceOfBankAccount.Query(identityId, bankAccountId));
        var numFmt = NumberFormat.getNumberInstance(Locale.FRENCH);
        numFmt.setMinimumFractionDigits(2);
        numFmt.setMaximumFractionDigits(2);
        ctx.render("bank-account-dashboard-balance.jte", Map.of(
                "balanceWhole",    formatWhole(balance, numFmt),
                "balanceDecimal",  formatDecimal(balance, numFmt),
                "balancePositive", balance.compareTo(BigDecimal.ZERO) >= 0
        ));
    }

    private void dashboardLastTransactions(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var bankAccountId = bankAccountIdFrom(ctx);

        var ids = getTransactionIdsOfBankAccount
                .handle(new GetTransactionIdsOfBankAccount.Query(identityId, bankAccountId, new Limit(5)))
                .map(TransactionId::getValue)
                .toList();

        ctx.render("bank-account-last-transactions.jte", Map.of(
                "bankAccountId",  bankAccountId.getValue(),
                "transactionIds", ids
        ));
    }

    private void transaction(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var txId = new TransactionId();
        txId.setValue(ctx.pathParam("txId"));
        var tx = getTransaction.handle(new GetTransaction.Query(identityId, txId));

        var zdt = tx.getIssuing().atZone(ZONE);
        var numFmt = NumberFormat.getNumberInstance(Locale.FRENCH);
        numFmt.setMinimumFractionDigits(2);
        numFmt.setMaximumFractionDigits(2);
        var positive = tx.getAmount().compareTo(BigDecimal.ZERO) >= 0;

        ctx.render("bank-account-transaction.jte", Map.of(
                "label",    tx.getDescription(),
                "month",    SHORT_MONTH.format(zdt).replace(".", ""),
                "day",      String.valueOf(zdt.getDayOfMonth()),
                "positive", positive,
                "amount",   (positive ? "+" : "−") + numFmt.format(tx.getAmount().abs()) + " €"
        ));
    }

    private static String formatWhole(BigDecimal amount, NumberFormat fmt) {
        var formatted = fmt.format(amount.abs());
        var commaIdx = formatted.indexOf(',');
        var prefix = amount.compareTo(BigDecimal.ZERO) < 0 ? "−" : "";
        return prefix + (commaIdx >= 0 ? formatted.substring(0, commaIdx) : formatted);
    }

    private BankAccountId bankAccountIdFrom(Context ctx) {
        var id = new BankAccountId();
        id.setValue(ctx.pathParam("id"));
        return id;
    }

    private static String formatDecimal(BigDecimal amount, NumberFormat fmt) {
        var formatted = fmt.format(amount.abs());
        var commaIdx = formatted.indexOf(',');
        return commaIdx >= 0 ? formatted.substring(commaIdx) : ",00";
    }

    private void transactions(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var bankAccountId = bankAccountIdFrom(ctx);

        var ids = getTransactionIdsOfBankAccount
                .handle(new GetTransactionIdsOfBankAccount.Query(identityId, bankAccountId, null))
                .map(TransactionId::getValue)
                .toList();

        ctx.render("operations.jte", Map.of(
                "bankAccountId",   bankAccountId.getValue(),
                "transactionIds",  ids
        ));
    }

    private void showSettings(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var bankAccountId = bankAccountIdFrom(ctx);
        var account = getBankAccount.handle(new GetBankAccount.Query(identityId, bankAccountId));
        ctx.render("bank-account-settings.jte", Map.of(
                "bankAccountId",   account.getId().getValue(),
                "bankAccountName", account.getName(),
                "error",           ""
        ));
    }

    private void settingsBanks(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var bankAccountId = bankAccountIdFrom(ctx);
        var account = getBankAccount.handle(new GetBankAccount.Query(identityId, bankAccountId));
        var banks = getBanks.handle().toList();
        ctx.render("bank-account-settings-banks.jte", Map.of(
                "banks",        banks,
                "selectedBank", account.getBank().name()
        ));
    }

    private void update(Context ctx) {
        var identityId    = ctx.<IdentityId>attribute("identityId");
        var bankAccountId = bankAccountIdFrom(ctx);
        var name = ctx.formParam("name");
        var bank = ctx.formParam("bank");
        try {
            updateBankAccount.handle(new UpdateBankAccount.Command(identityId, bankAccountId, name, bank));
            ctx.redirect("/bank-accounts/" + bankAccountId.getValue());
        } catch (RuntimeException e) {
            ctx.render("bank-account-settings.jte", Map.of(
                    "bankAccountId",   bankAccountId.getValue(),
                    "bankAccountName", name != null ? name : "",
                    "error",           e.getMessage()
            ));
        }
    }

    private void delete(Context ctx) {
        var identityId    = ctx.<IdentityId>attribute("identityId");
        var bankAccountId = bankAccountIdFrom(ctx);
        deleteBankAccount.handle(new DeleteBankAccount.Command(identityId, bankAccountId));
        ctx.redirect("/");
    }

    private void transactionCount(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var bankAccountId = bankAccountIdFrom(ctx);
        var count = countTransactions.handle(new CountTransactionsOfBankAccount.Query(identityId, bankAccountId));
        ctx.render("bank-account-transactions-count.jte", Map.of("count", count));
    }

}