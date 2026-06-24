@param String error
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<title>Nouveau compte bancaire</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<script src="/tailwind.min.js"></script>
<script src="/tailwind.config.js"></script>
<script src="/htmx.min.js"></script>
</head>
<body class="bg-ef-bg text-ef-fg font-body min-h-screen px-4 py-6 sm:py-10">

<div class="max-w-lg mx-auto">

  <div class="-ml-2 mb-6">
    <a href="/" class="inline-flex items-center gap-1.5 text-[14px] font-medium text-ef-dim no-underline px-2.5 py-2 rounded-lg transition-colors hover:bg-ef-card hover:text-ef-fg focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
      </svg>
      Tableau de bord
    </a>
  </div>

  <div class="mb-6 px-1">
    <div class="flex items-center gap-2 mb-2 font-mono text-[11.5px] uppercase tracking-[0.08em] text-ef-faint">
      <span class="w-1.5 h-1.5 rounded-full bg-ef-accent shrink-0"></span>
      Compte bancaire · Nouveau
    </div>
    <h1 class="font-display text-[22px] sm:text-[24px] font-semibold tracking-tight mb-1.5">Créer un compte bancaire</h1>
    <p class="text-[13.5px] text-ef-dim leading-relaxed">Un compte bancaire est la source de vos opérations importées — courant, livret, joint…</p>
  </div>

  <div class="bg-ef-card border border-ef-border rounded-2xl p-6 sm:p-7 shadow-[0_1px_2px_rgba(0,0,0,0.2),0_4px_16px_rgba(0,0,0,0.24)]">
    <form method="post" action="/bank-accounts">

      @if(!error.isEmpty())
      <div class="flex items-center gap-2.5 px-4 py-3 mb-5 bg-ef-error-soft border border-ef-error rounded-xl text-ef-error text-[13px]">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="shrink-0">
          <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        ${error}
      </div>
      @endif

      <div class="mb-6">
        <label class="block text-[12.5px] font-semibold mb-2.5" for="name">Nom du compte</label>
        <input
          type="text" id="name" name="name" required
          class="w-full bg-ef-input border-[1.5px] border-ef-border rounded-xl px-4 py-3.5 font-body text-[15px] text-ef-fg placeholder:text-ef-faint outline-none transition-colors focus:border-ef-accent focus:bg-ef-card"
          placeholder="Ex. Courant, Livret A, Compte joint…"
          autocomplete="off" maxlength="40"
        >
      </div>

      <div class="mb-0">
        <span class="block text-[12.5px] font-semibold mb-2.5">Banque</span>
        <div
          id="bank-grid"
          hx-get="/banks"
          hx-trigger="load"
          hx-swap="innerHTML"
        >
          <div class="grid grid-cols-3 gap-2.5">
            <div class="h-20 bg-ef-input border-[1.5px] border-ef-border rounded-xl animate-pulse"></div>
            <div class="h-20 bg-ef-input border-[1.5px] border-ef-border rounded-xl animate-pulse opacity-75"></div>
            <div class="h-20 bg-ef-input border-[1.5px] border-ef-border rounded-xl animate-pulse opacity-50"></div>
          </div>
        </div>
      </div>

      <div class="mt-7">
        <button type="submit"
          class="w-full font-body text-[14.5px] font-semibold text-ef-bg bg-ef-accent px-6 py-3.5 rounded-xl transition-colors flex items-center justify-center gap-2 hover:bg-ef-accent-str active:scale-[0.99] focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2"
        >
          Créer le compte bancaire
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
          </svg>
        </button>
      </div>
    </form>
  </div>
</div>

</body>
</html>