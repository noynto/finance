package me.noynto.finance.infrastructure.web;

import io.javalin.http.Context;
import io.javalin.router.JavalinDefaultRoutingApi;
import me.noynto.finance.application.GetBalance;
import me.noynto.finance.application.GetBankAccount;
import me.noynto.finance.application.GetBankAccountIds;
import me.noynto.finance.application.GetPayee;
import me.noynto.finance.application.GetPayeeIds;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.PayeeId;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;
import java.util.Map;

public class DashboardController {
    private final GetBankAccountIds getBankAccountIds;
    private final GetBankAccount getBankAccount;
    private final GetBalance getBalance;
    private final GetPayeeIds getPayeeIds;
    private final GetPayee getPayee;

    public DashboardController(
            GetBankAccountIds getBankAccountIds,
            GetBankAccount getBankAccount,
            GetBalance getBalance,
            GetPayeeIds getPayeeIds,
            GetPayee getPayee
    ) {
        this.getBankAccountIds = getBankAccountIds;
        this.getBankAccount = getBankAccount;
        this.getBalance = getBalance;
        this.getPayeeIds = getPayeeIds;
        this.getPayee = getPayee;
    }

    public void register(JavalinDefaultRoutingApi router) {
        router.get("/", this::show);
        router.get("/dashboard", this::show);
        router.get("/dashboard/balance",             this::balance);
        router.get("/dashboard/bank-accounts/ids",  this::bankAccountIds);
        router.get("/dashboard/bank-accounts/{id}", this::bankAccountItem);
        router.get("/dashboard/payees/ids",         this::payeeIds);
        router.get("/dashboard/payees/{id}",        this::payeeItem);
    }

    private void show(Context ctx) {
        ctx.render("dashboard.jte", Map.of());
    }

    private void balance(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var total = getBalance.handle(new GetBalance.Query(identityId));

        var numFmt = NumberFormat.getNumberInstance(Locale.FRENCH);
        numFmt.setMinimumFractionDigits(2);
        numFmt.setMaximumFractionDigits(2);

        var formatted = numFmt.format(total.abs());
        var commaIdx  = formatted.indexOf(',');
        var positive  = total.compareTo(BigDecimal.ZERO) >= 0;
        var prefix    = positive ? "" : "−";
        var whole     = prefix + (commaIdx >= 0 ? formatted.substring(0, commaIdx) : formatted);
        var decimal   = commaIdx >= 0 ? formatted.substring(commaIdx) : ",00";

        ctx.render("dashboard-balance.jte", Map.of(
                "balanceWhole",    whole,
                "balanceDecimal",  decimal,
                "balancePositive", positive
        ));
    }

    private void bankAccountIds(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var ids = getBankAccountIds.handle(new GetBankAccountIds.Query(identityId))
                .map(BankAccountId::getValue)
                .toList();
        ctx.render("dashboard-bank-account-ids.jte", Map.of("ids", ids));
    }

    private void bankAccountItem(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var bankAccountId = new BankAccountId();
        bankAccountId.setValue(ctx.pathParam("id"));
        var account = getBankAccount.handle(new GetBankAccount.Query(identityId, bankAccountId));
        ctx.render("dashboard-bank-account-item.jte", Map.of("account", account));
    }

    private void payeeIds(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var ids = getPayeeIds.handle(new GetPayeeIds.Query(identityId))
                .map(PayeeId::getValue)
                .toList();
        ctx.render("dashboard-payee-ids.jte", Map.of("ids", ids));
    }

    private void payeeItem(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var payeeId = new PayeeId();
        payeeId.setValue(ctx.pathParam("id"));
        var payee = getPayee.handle(new GetPayee.Query(identityId, payeeId));
        ctx.render("dashboard-payee-item.jte", Map.of("payee", payee));
    }

}