@param String payeeId
@param String payeeName
@param String payeePattern
@param String error
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<title>${payeeName} · Paramètres</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<script src="/tailwind.min.js"></script>
<script src="/tailwind.config.js"></script>
</head>
<body class="bg-ef-bg text-ef-fg font-body min-h-screen px-4 py-6 sm:py-10">

<div class="max-w-lg mx-auto">

  <div class="-ml-2 mb-6">
    <a href="/payees/${payeeId}"
       class="inline-flex items-center gap-1.5 text-[14px] font-medium text-ef-dim no-underline px-2.5 py-2 rounded-lg transition-colors hover:bg-ef-card hover:text-ef-fg focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
      </svg>
      ${payeeName}
    </a>
  </div>

  <div class="mb-6 px-1">
    <div class="flex items-center gap-2 mb-2 font-mono text-[11.5px] uppercase tracking-[0.08em] text-ef-faint">
      <span class="w-1.5 h-1.5 rounded-full bg-ef-accent shrink-0"></span>
      Tiers · Paramètres
    </div>
    <h1 class="font-display text-[22px] sm:text-[24px] font-semibold tracking-tight">${payeeName}</h1>
  </div>

  <!-- Formulaire -->
  <div class="bg-ef-card border border-ef-border rounded-2xl p-6 sm:p-7 shadow-[0_1px_2px_rgba(0,0,0,0.2),0_4px_16px_rgba(0,0,0,0.24)] mb-4">
    <form method="post" action="/payees/${payeeId}/settings">

      @if(!error.isEmpty())
      <div class="flex items-center gap-2.5 px-4 py-3 mb-5 bg-ef-error-soft border border-ef-error rounded-xl text-ef-error text-[13px]">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="shrink-0">
          <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        ${error}
      </div>
      @endif

      <div class="mb-5">
        <label class="block text-[12.5px] font-semibold mb-2.5" for="name">Nom</label>
        <input
          type="text" id="name" name="name" required
          value="${payeeName}"
          class="w-full bg-ef-input border-[1.5px] border-ef-border rounded-xl px-4 py-3.5 font-body text-[15px] text-ef-fg placeholder:text-ef-faint outline-none transition-colors focus:border-ef-accent focus:bg-ef-card"
          autocomplete="off" maxlength="80"
        >
      </div>

      <div class="mb-0">
        <label class="block text-[12.5px] font-semibold mb-1" for="pattern">Regex de rapprochement <span class="font-normal text-ef-faint">(optionnel)</span></label>
        <p class="text-[12px] text-ef-faint mb-2.5 leading-relaxed">Motif appliqué sur le libellé des transactions pour les classer automatiquement dans cette catégorie.</p>
        <input
          type="text" id="pattern" name="pattern"
          value="${payeePattern}"
          class="w-full bg-ef-input border-[1.5px] border-ef-border rounded-xl px-4 py-3.5 font-mono text-[13.5px] text-ef-fg placeholder:text-ef-faint outline-none transition-colors focus:border-ef-accent focus:bg-ef-card"
          placeholder="Ex. (?i)netflix|NETFLIX.*"
          autocomplete="off" maxlength="200"
        >
      </div>

      <div class="mt-7">
        <button type="submit"
          class="w-full font-body text-[14.5px] font-semibold text-ef-bg bg-ef-accent px-6 py-3.5 rounded-xl transition-colors flex items-center justify-center gap-2 hover:bg-ef-accent-str active:scale-[0.99] focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2"
        >
          Enregistrer
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
          </svg>
        </button>
      </div>
    </form>
  </div>

  <!-- Zone de danger -->
  <div class="bg-ef-card border border-ef-error/30 rounded-2xl p-6 sm:p-7">
    <h2 class="text-[13px] font-semibold text-ef-error mb-1">Zone de danger</h2>
    <p class="text-[12.5px] text-ef-faint mb-4 leading-relaxed">La suppression est définitive. Les transactions classées dans cette catégorie ne seront pas supprimées.</p>
    <form method="post" action="/payees/${payeeId}/delete">
      <button type="submit"
        class="inline-flex items-center gap-2 text-[13.5px] font-medium text-ef-error border border-ef-error/40 rounded-xl px-4 py-2.5 transition-colors hover:bg-ef-error/10 focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-error focus-visible:outline-offset-2"
        onclick="return confirm('Supprimer ${payeeName} ?')"
      >
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/>
        </svg>
        Supprimer ce tiers
      </button>
    </form>
  </div>

</div>

</body>
</html>