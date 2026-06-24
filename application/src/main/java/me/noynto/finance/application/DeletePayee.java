package me.noynto.finance.application;

import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.payee.Payee;
import me.noynto.finance.domain.payee.PayeeProvider;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.PayeeId;

public record DeletePayee(
        IdentityProvider identityProvider,
        PayeeProvider payeeProvider
) {

    public void handle(Command command) {
        Identity identity = this.identityProvider.read(command.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        Payee payee = this.payeeProvider.read(command.payeeId)
                .orElseThrow(() -> new RuntimeException("Le bénéficiaire n'existe pas."));

        if (!payee.belongsTo(identity.getId())) {
            throw new RuntimeException("Le bénéficiaire n'appartient pas à cette identité.");
        }

        this.payeeProvider.delete(command.payeeId);
    }

    public record Command(
            IdentityId identityId,
            PayeeId payeeId
    ) {
    }
}