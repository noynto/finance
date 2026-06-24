package me.noynto.finance.infrastructure.web;

import io.javalin.http.Context;
import io.javalin.http.Cookie;
import io.javalin.http.SameSite;
import io.javalin.router.JavalinDefaultRoutingApi;
import me.noynto.finance.application.SignIn;

import java.util.Map;
import java.util.regex.Pattern;

public class SignInController {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");

    private final SignIn signIn;

    public SignInController(SignIn signIn) {
        this.signIn = signIn;
    }

    public void register(JavalinDefaultRoutingApi router) {
        router.get("/sign-in", this::show);
        router.post("/sign-in", this::handle);
        router.post("/sign-in/check-electronic-address", this::checkElectronicAddress);
    }

    private void show(Context ctx) {
        ctx.render("sign-in.jte", Map.of("error", ""));
    }

    private void handle(Context ctx) {
        var command = new SignIn.Command(
                ctx.formParam("electronic-address"),
                ctx.formParam("secret")
        );
        try {
            var session = signIn.handle(command);
            ctx.cookie(new Cookie("identity-session-id", session.getId().getValue(), "/", -1, false, true, "", SameSite.LAX));
            ctx.redirect("/");
        } catch (RuntimeException e) {
            ctx.render("sign-in.jte", Map.of("error", e.getMessage()));
        }
    }

    private void checkElectronicAddress(Context ctx) {
        var email = ctx.formParamAsClass("electronic-address", String.class).getOrDefault("").trim();
        ctx.render("sign-up/email-feedback.jte", Map.of(
                "invalid", !email.isEmpty() && !EMAIL_PATTERN.matcher(email).matches()
        ));
    }

}