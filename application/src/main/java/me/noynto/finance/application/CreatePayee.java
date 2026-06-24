package me.noynto.finance.application;

import me.noynto.finance.domain.payee.Payee;
import me.noynto.finance.domain.payee.PayeeProvider;
import me.noynto.finance.domain.shared.IdentityId;

public record CreatePayee(
        PayeeProvider payeeProvider
) {

    public Payee handle(Command command) {
        if (command.name == null || command.name.isBlank()) {
            throw new RuntimeException("Le nom est requis pour créer le bénéficiaire.");
        }
        if (command.identityId == null || command.identityId.getValue() == null || command.identityId.getValue().isBlank()) {
            throw new RuntimeException("L'identifiant de l'identité propriétaire est requis pour créer le bénéficiaire.");
        }

        Payee payee = new Payee();
        payee.setName(command.name);
        payee.setOwnerIdentityId(command.identityId);
        if (command.pattern != null && !command.pattern.isBlank()) {
            payee.setPattern(command.pattern.strip());
        }

        return this.payeeProvider.write(payee);
    }

    public record Command(
            String name,
            String pattern,
            IdentityId identityId
    ) {
    }

}
