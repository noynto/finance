package me.noynto.finance.application;

import me.noynto.finance.domain.identity.Identity;
import me.noynto.finance.domain.identity.IdentityProvider;
import me.noynto.finance.domain.payee.Payee;
import me.noynto.finance.domain.payee.PayeeProvider;
import me.noynto.finance.domain.shared.IdentityId;
import me.noynto.finance.domain.shared.PayeeId;

public record UpdatePayee(
        IdentityProvider identityProvider,
        PayeeProvider payeeProvider
) {

    public Payee handle(Command command) {
        if (command.name == null || command.name.isBlank()) {
            throw new RuntimeException("Le nom est requis.");
        }

        Identity identity = this.identityProvider.read(command.identityId)
                .orElseThrow(() -> new RuntimeException("L'identifiant de l'identité n'existe pas."));

        Payee payee = this.payeeProvider.read(command.payeeId)
                .orElseThrow(() -> new RuntimeException("Le bénéficiaire n'existe pas."));

        if (!payee.belongsTo(identity.getId())) {
            throw new RuntimeException("Le bénéficiaire n'appartient pas à cette identité.");
        }

        payee.setName(command.name.strip());
        payee.setPattern(command.pattern != null && !command.pattern.isBlank() ? command.pattern.strip() : null);

        return this.payeeProvider.write(payee);
    }

    public record Command(
            IdentityId identityId,
            PayeeId payeeId,
            String name,
            String pattern
    ) {
    }
}