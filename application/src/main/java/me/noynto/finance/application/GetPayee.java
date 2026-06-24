package me.noynto.finance.application;

import me.noynto.finance.domain.bankaccount.BankAccount;
import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.payee.Payee;
import me.noynto.finance.domain.payee.PayeeProvider;
import me.noynto.finance.domain.shared.BankAccountId;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.PayeeId;

public record GetPayee(
        IdentityProvider identityProvider,
        PayeeProvider payeeProvider
) {

    public Payee handle(Query query) {
        if (query.identityId == null) {
            throw new RuntimeException("L'identifiant de l'identité est requis.");
        }
        if (query.payeeId == null) {
            throw new RuntimeException("L'identifiant du bénéficiaire est requis.");
        }
        Identity identity = this.identityProvider.read(query.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        Payee payee = this.payeeProvider.read(query.payeeId)
                .orElseThrow(() -> new RuntimeException("Le bénéficiaire " + query.payeeId.getValue() + " n'existe pas."));

        if (!payee.belongsTo(identity.getId())) {
            throw new RuntimeException("Le bénéficiaire " + payee.getId().getValue() + " n'appartient pas à l'identité " + identity.getId().getValue() + ".");
        }

        return payee;
    }

    public record Query(
            IdentityId identityId,
            PayeeId payeeId
    ) {

    }
}
