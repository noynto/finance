package me.noynto.finance.infrastructure.web;

import io.javalin.http.Context;
import io.javalin.router.JavalinDefaultRoutingApi;
import me.noynto.finance.application.CreatePayee;
import me.noynto.finance.application.DeletePayee;
import me.noynto.finance.application.GetBalanceOfPayee;
import me.noynto.finance.application.GetPayee;
import me.noynto.finance.application.GetTransaction;
import me.noynto.finance.application.MatchTransactionToPayee;
import me.noynto.finance.application.UpdatePayee;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.PayeeId;
import me.noynto.finance.domain.shared.TransactionId;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.Map;

public class PayeeController {

    private static final ZoneId ZONE = ZoneId.of("Europe/Paris");
    private static final DateTimeFormatter SHORT_MONTH = DateTimeFormatter.ofPattern("MMM", Locale.FRENCH);

    private final CreatePayee createPayee;
    private final GetPayee getPayee;
    private final UpdatePayee updatePayee;
    private final DeletePayee deletePayee;
    private final MatchTransactionToPayee matchTransactionToPayee;
    private final GetBalanceOfPayee getBalanceOfPayee;
    private final GetTransaction getTransaction;

    public PayeeController(
            CreatePayee createPayee,
            GetPayee getPayee,
            UpdatePayee updatePayee,
            DeletePayee deletePayee,
            MatchTransactionToPayee matchTransactionToPayee,
            GetBalanceOfPayee getBalanceOfPayee,
            GetTransaction getTransaction
    ) {
        this.createPayee = createPayee;
        this.getPayee = getPayee;
        this.updatePayee = updatePayee;
        this.deletePayee = deletePayee;
        this.matchTransactionToPayee = matchTransactionToPayee;
        this.getBalanceOfPayee = getBalanceOfPayee;
        this.getTransaction = getTransaction;
    }

    public void register(JavalinDefaultRoutingApi router) {
        router.get("/payees/new",                      this::showNew);
        router.post("/payees",                         this::create);
        router.get("/payees/{id}",                     this::show);
        router.get("/payees/{id}/balance",             this::balance);
        router.get("/payees/{id}/settings",            this::showSettings);
        router.post("/payees/{id}/settings",           this::update);
        router.post("/payees/{id}/delete",             this::delete);
        router.post("/payees/{id}/match",              this::match);
        router.get("/payees/{id}/transactions/{txId}", this::transaction);
    }

    private void showNew(Context ctx) {
        ctx.render("payee-new.jte", Map.of("error", ""));
    }

    private void create(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var name    = ctx.formParam("name");
        var pattern = ctx.formParam("pattern");
        try {
            createPayee.handle(new CreatePayee.Command(name, pattern, identityId));
            ctx.redirect("/");
        } catch (RuntimeException e) {
            ctx.render("payee-new.jte", Map.of("error", e.getMessage()));
        }
    }

    private void show(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var payee = getPayee.handle(new GetPayee.Query(identityId, payeeIdFrom(ctx)));
        var transactionIds = payee.getTransactionIds().stream()
                .map(TransactionId::getValue)
                .toList();
        ctx.render("payee.jte", Map.of(
                "payeeId",        payee.getId().getValue(),
                "payeeName",      payee.getName(),
                "payeePattern",   payee.getPattern() != null ? payee.getPattern() : "",
                "transactionIds", transactionIds
        ));
    }

    private void showSettings(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var payee = getPayee.handle(new GetPayee.Query(identityId, payeeIdFrom(ctx)));
        ctx.render("payee-settings.jte", Map.of(
                "payeeId",      payee.getId().getValue(),
                "payeeName",    payee.getName(),
                "payeePattern", payee.getPattern() != null ? payee.getPattern() : "",
                "error",        ""
        ));
    }

    private void update(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var payeeId    = payeeIdFrom(ctx);
        var name       = ctx.formParam("name");
        var pattern    = ctx.formParam("pattern");
        try {
            updatePayee.handle(new UpdatePayee.Command(identityId, payeeId, name, pattern));
            ctx.redirect("/payees/" + payeeId.getValue());
        } catch (RuntimeException e) {
            var payee = getPayee.handle(new GetPayee.Query(identityId, payeeId));
            ctx.render("payee-settings.jte", Map.of(
                    "payeeId",      payee.getId().getValue(),
                    "payeeName",    payee.getName(),
                    "payeePattern", payee.getPattern() != null ? payee.getPattern() : "",
                    "error",        e.getMessage()
            ));
        }
    }

    private void balance(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var payeeId = payeeIdFrom(ctx);
        var total = getBalanceOfPayee.handle(new GetBalanceOfPayee.Query(identityId, payeeId));

        var numFmt = NumberFormat.getNumberInstance(Locale.FRENCH);
        numFmt.setMinimumFractionDigits(2);
        numFmt.setMaximumFractionDigits(2);

        var formatted = numFmt.format(total.abs());
        var commaIdx  = formatted.indexOf(',');
        var positive  = total.compareTo(BigDecimal.ZERO) >= 0;
        var prefix    = positive ? "" : "−";
        var whole     = prefix + (commaIdx >= 0 ? formatted.substring(0, commaIdx) : formatted);
        var decimal   = commaIdx >= 0 ? formatted.substring(commaIdx) : ",00";

        ctx.render("payee-balance.jte", Map.of(
                "balanceWhole",    whole,
                "balanceDecimal",  decimal,
                "balancePositive", positive
        ));
    }

    private void match(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var payeeId    = payeeIdFrom(ctx);
        matchTransactionToPayee.handle(new MatchTransactionToPayee.Command(identityId, payeeId));
        ctx.redirect("/payees/" + payeeId.getValue());
    }

    private void delete(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        deletePayee.handle(new DeletePayee.Command(identityId, payeeIdFrom(ctx)));
        ctx.redirect("/");
    }

    private void transaction(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var txId = new TransactionId();
        txId.setValue(ctx.pathParam("txId"));
        var tx = getTransaction.handle(new GetTransaction.Query(identityId, txId));

        var numFmt = NumberFormat.getNumberInstance(Locale.FRENCH);
        numFmt.setMinimumFractionDigits(2);
        numFmt.setMaximumFractionDigits(2);

        var zdt      = tx.getIssuing().atZone(ZONE);
        var positive = tx.getAmount().compareTo(BigDecimal.ZERO) >= 0;
        ctx.render("bank-account-transaction.jte", Map.of(
                "label",    tx.getDescription(),
                "month",    SHORT_MONTH.format(zdt).replace(".", ""),
                "day",      String.valueOf(zdt.getDayOfMonth()),
                "positive", positive,
                "amount",   (positive ? "+" : "−") + numFmt.format(tx.getAmount().abs()) + " €"
        ));
    }

    private PayeeId payeeIdFrom(Context ctx) {
        var id = new PayeeId();
        id.setValue(ctx.pathParam("id"));
        return id;
    }
}