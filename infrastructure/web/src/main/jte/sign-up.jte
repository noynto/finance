@param String error
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<title>Inscription</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<script src="/tailwind.min.js"></script>
<script src="/tailwind.config.js"></script>
<script src="/htmx.min.js"></script>
</head>
<body class="bg-ef-bg text-ef-fg font-body min-h-screen flex flex-col items-center justify-start px-3 pt-6 pb-14 sm:justify-center sm:px-4 sm:pt-10 lg:pt-16">

  <div class="w-full max-w-sm sm:max-w-md">

    <!-- En-tête -->
    <div class="mb-5 px-1 sm:mb-6">
      <div class="flex items-center gap-2 mb-2 font-mono text-[11.5px] uppercase tracking-[0.08em] text-ef-faint">
        <span class="w-1.5 h-1.5 rounded-full bg-ef-accent shrink-0"></span>
        Accès · Inscription
      </div>
      <h1 class="font-display text-[22px] sm:text-2xl font-semibold tracking-tight text-ef-fg mb-1.5">
        Créer un accès
      </h1>
      <p class="text-[13.5px] text-ef-dim leading-relaxed">
        Votre adresse électronique restera confidentielle et ne sera jamais partagée.
      </p>
    </div>

    <!-- Carte -->
    <div class="bg-ef-card border border-ef-border rounded-2xl p-5 sm:p-7 shadow-[0_1px_2px_rgba(0,0,0,0.2),0_4px_16px_rgba(0,0,0,0.24)]">
      <form method="post" action="/sign-up" novalidate>

        @if(!error.isEmpty())
        <div class="flex items-center gap-2.5 mb-5 px-3.5 py-3 rounded-lg bg-ef-error-soft border border-ef-error text-ef-error text-[13px]">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="shrink-0">
            <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
          </svg>
          ${error}
        </div>
        @endif

        <!-- Adresse électronique -->
        <div class="mb-5">
          <label for="electronic-address" class="block text-[12.5px] font-semibold text-ef-fg mb-2">
            Adresse électronique
          </label>
          <input
            type="email"
            id="electronic-address"
            name="electronic-address"
            class="w-full bg-ef-input border-[1.5px] border-ef-border rounded-lg px-3.5 py-3 text-ef-fg text-[15px] placeholder-ef-faint outline-none transition-colors duration-150 focus:border-ef-accent focus:bg-ef-card"
            placeholder="vous@example.com"
            autocomplete="email"
            inputmode="email"
            hx-post="/sign-up/check-electronic-address"
            hx-trigger="blur"
            hx-target="#email-feedback"
            hx-swap="outerHTML"
          >
          <p id="email-feedback" class="hidden"></p>
        </div>

        <!-- Secret -->
        <div>
          <label for="secret" class="block text-[12.5px] font-semibold text-ef-fg mb-2">
            Secret
          </label>
          <input
            type="password"
            id="secret"
            name="secret"
            class="w-full bg-ef-input border-[1.5px] border-ef-border rounded-lg px-3.5 py-3 text-ef-fg text-[15px] placeholder-ef-faint outline-none transition-colors duration-150 focus:border-ef-accent focus:bg-ef-card"
            placeholder="Votre secret…"
            autocomplete="new-password"
            hx-post="/sign-up/check-secret"
            hx-trigger="input changed delay:300ms"
            hx-target="#criteres"
            hx-swap="outerHTML"
          >

          <!-- Critères — état initial : tous non validés -->
          <div id="criteres" class="grid grid-cols-2 gap-x-3 gap-y-2 mt-3">
            <div class="flex items-center gap-1.5 text-[12px] text-ef-faint">
              <span class="w-4 h-4 rounded-full border border-current shrink-0 flex items-center justify-center">
                <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round" class="opacity-0"><polyline points="20 6 9 17 4 12"/></svg>
              </span>
              20 à 60 caractères
            </div>
            <div class="flex items-center gap-1.5 text-[12px] text-ef-faint">
              <span class="w-4 h-4 rounded-full border border-current shrink-0 flex items-center justify-center">
                <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round" class="opacity-0"><polyline points="20 6 9 17 4 12"/></svg>
              </span>
              Minuscule
            </div>
            <div class="flex items-center gap-1.5 text-[12px] text-ef-faint">
              <span class="w-4 h-4 rounded-full border border-current shrink-0 flex items-center justify-center">
                <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round" class="opacity-0"><polyline points="20 6 9 17 4 12"/></svg>
              </span>
              Majuscule
            </div>
            <div class="flex items-center gap-1.5 text-[12px] text-ef-faint">
              <span class="w-4 h-4 rounded-full border border-current shrink-0 flex items-center justify-center">
                <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round" class="opacity-0"><polyline points="20 6 9 17 4 12"/></svg>
              </span>
              Chiffre
            </div>
            <div class="flex items-center gap-1.5 text-[12px] text-ef-faint">
              <span class="w-4 h-4 rounded-full border border-current shrink-0 flex items-center justify-center">
                <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round" class="opacity-0"><polyline points="20 6 9 17 4 12"/></svg>
              </span>
              Caractère spécial
            </div>
          </div>
        </div>

        <hr class="border-ef-border my-6">

        <button
          type="submit"
          class="w-full bg-ef-accent text-ef-bg font-semibold text-[14.5px] rounded-lg py-3.5 flex items-center justify-center gap-2 transition-all duration-150 hover:bg-ef-accent-hover active:scale-[0.99]"
        >
          Créer l'accès
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
          </svg>
        </button>

      </form>
    </div>

    <p class="mt-5 text-center text-[13px] text-ef-faint">
      Déjà un accès ? <a href="/sign-in" class="text-ef-accent font-medium hover:underline">Se connecter</a>
    </p>

  </div>

</body>
</html>