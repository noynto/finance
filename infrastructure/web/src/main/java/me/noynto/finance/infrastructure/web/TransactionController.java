package me.noynto.finance.infrastructure.web;

import io.javalin.http.Context;
import io.javalin.router.JavalinDefaultRoutingApi;
import me.noynto.finance.application.GetBankAccount;
import me.noynto.finance.application.GetBankAccountIds;
import me.noynto.finance.application.ImportBankStatementOnBankAccount;
import me.noynto.finance.domain.bankaccount.Bank;
import me.noynto.finance.domain.bankaccount.BankAccount;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class TransactionController {

    private static final Map<Bank, String> BANK_COLORS = Map.of(
            Bank.CA, "#a7c080"
    );

    private final GetBankAccountIds getBankAccountIds;
    private final GetBankAccount getBankAccount;
    private final ImportBankStatementOnBankAccount importBankStatement;

    public TransactionController(
            GetBankAccountIds getBankAccountIds,
            GetBankAccount getBankAccount,
            ImportBankStatementOnBankAccount importBankStatement
    ) {
        this.getBankAccountIds = getBankAccountIds;
        this.getBankAccount = getBankAccount;
        this.importBankStatement = importBankStatement;
    }

    public void register(JavalinDefaultRoutingApi router) {
        router.get("/operations/import",         this::importForm);
        router.post("/operations/import",        this::importSubmit);
        // Rétro-compat : les anciens liens /bank-accounts/{id}/import redirigent vers la nouvelle URL
        router.get("/bank-accounts/{id}/import", ctx ->
                ctx.redirect("/operations/import?bank-account-id=" + ctx.pathParam("id")));
        router.post("/bank-accounts/{id}/import", ctx ->
                ctx.redirect("/operations/import"));
    }

    private void importForm(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var selectedId = ctx.queryParam("bank-account-id");
        var bankGroups = buildBankGroups(identityId, selectedId);
        ctx.render("transactions-wizard.jte", Map.of(
                "hasBankAccounts",    !bankGroups.isEmpty(),
                "selectedBankAccountId", selectedId != null ? selectedId : "",
                "bankGroups",         bankGroups
        ));
    }

    private void importSubmit(Context ctx) {
        var identityId = ctx.<IdentityId>attribute("identityId");
        var rawId = ctx.formParam("bankAccountId");
        if (rawId == null || rawId.isBlank()) {
            ctx.redirect("/operations/import");
            return;
        }
        var bankAccountId = new BankAccountId();
        bankAccountId.setValue(rawId);
        var files = ctx.uploadedFiles("file");
        if (files.isEmpty()) {
            ctx.redirect("/operations/import?bank-account-id=" + rawId);
            return;
        }
        for (var file : files) {
            importBankStatement.handle(new ImportBankStatementOnBankAccount.Command(
                    identityId, bankAccountId, file.content()
            ));
        }
        if ("true".equals(ctx.header("HX-Request"))) {
            ctx.header("HX-Redirect", "/bank-accounts/" + rawId + "/transactions");
        } else {
            ctx.redirect("/bank-accounts/" + rawId + "/transactions");
        }
    }

    private List<Map<String, Object>> buildBankGroups(IdentityId identityId, String selectedId) {
        var accounts = getBankAccountIds.handle(new GetBankAccountIds.Query(identityId))
                .map(id -> getBankAccount.handle(new GetBankAccount.Query(identityId, id)))
                .toList();

        var byBank = new LinkedHashMap<Bank, List<BankAccount>>();
        for (var account : accounts) {
            byBank.computeIfAbsent(account.getBank(), k -> new ArrayList<>()).add(account);
        }

        return byBank.entrySet().stream().map(entry -> {
            var bank = entry.getKey();
            var color = BANK_COLORS.getOrDefault(bank, "#9da9a0");
            var accountMaps = entry.getValue().stream().map(account -> Map.<String, Object>of(
                    "id",    account.getId().getValue(),
                    "name",  account.getName(),
                    "color", color
            )).toList();
            return Map.<String, Object>of(
                    "bankName",     bank.getName(),
                    "logoInitials", bank.getAbbreviate(),
                    "logoColor",    color,
                    "accounts",     accountMaps
            );
        }).toList();
    }
}