package me.noynto.finance.infrastructure.web;

import io.javalin.http.Context;
import io.javalin.http.Cookie;
import io.javalin.http.SameSite;
import io.javalin.router.JavalinDefaultRoutingApi;
import me.noynto.finance.application.SignUp;

import java.util.Map;

public class SignUpController {

    private final SignUp signUp;

    public SignUpController(SignUp signUp) {
        this.signUp = signUp;
    }

    private static final java.util.regex.Pattern EMAIL_PATTERN =
            java.util.regex.Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");

    public void register(JavalinDefaultRoutingApi router) {
        router.get("/sign-up", this::show);
        router.post("/sign-up", this::handle);
        router.post("/sign-up/check-secret", this::checkSecret);
        router.post("/sign-up/check-electronic-address", this::checkElectronicAddress);
    }

    private void show(Context ctx) {
        ctx.render("sign-up.jte", Map.of("error", ""));
    }

    private void handle(Context ctx) {
        var command = new SignUp.Command(
                ctx.formParam("electronic-address"),
                ctx.formParam("secret")
        );
        try {
            var session = signUp.handle(command);
            ctx.cookie(new Cookie("identity-session-id", session.getId().getValue(), "/", -1, false, true, "", SameSite.LAX));
            ctx.redirect("/");
        } catch (RuntimeException e) {
            ctx.render("sign-up.jte", Map.of("error", e.getMessage()));
        }
    }

    private void checkSecret(Context ctx) {
        var secret = ctx.formParamAsClass("secret", String.class).getOrDefault("");
        ctx.render("sign-up/criteres.jte", Map.of(
                "length",  secret.length() >= 20 && secret.length() <= 60,
                "lower",   secret.matches(".*[a-z].*"),
                "upper",   secret.matches(".*[A-Z].*"),
                "digit",   secret.matches(".*\\d.*"),
                "special", secret.matches(".*[^a-zA-Z0-9].*")
        ));
    }

    private void checkElectronicAddress(Context ctx) {
        var email = ctx.formParamAsClass("electronic-address", String.class).getOrDefault("").trim();
        ctx.render("sign-up/email-feedback.jte", Map.of(
                "invalid", !email.isEmpty() && !EMAIL_PATTERN.matcher(email).matches()
        ));
    }

}