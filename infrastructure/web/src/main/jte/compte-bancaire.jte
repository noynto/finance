@param String bankAccountId
@param String bankAccountName
@param String balanceWhole
@param String balanceDecimal
@param long operationCount
@param String asOf
@param String endOfMonthWhole
@param String endOfMonthDecimal
@param String endOfMonthDelta
@param boolean endOfMonthPositive
@param String endOfYearWhole
@param String endOfYearDecimal
@param String endOfYearDelta
@param boolean endOfYearPositive
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<title>${bankAccountName}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<script src="/tailwind.min.js"></script>
<script src="/tailwind.config.js"></script>
<script src="/htmx.min.js"></script>
<style>
  @keyframes breathe {
    0%, 100% { opacity: 0.6; transform: translate(-50%, -50%) scale(1); }
    50%       { opacity: 1;   transform: translate(-50%, -50%) scale(1.06); }
  }
  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(8px); }
    to   { opacity: 1; transform: translateY(0); }
  }
</style>
</head>
<body class="bg-ef-bg text-ef-fg font-body min-h-screen flex flex-col px-6 py-8 relative overflow-x-hidden">

  <!-- Glow ambiant -->
  <div class="pointer-events-none fixed top-1/2 left-1/2 w-[900px] h-[900px] -translate-x-1/2 -translate-y-1/2 rounded-full bg-[radial-gradient(circle,rgba(167,192,128,0.18)_0%,transparent_60%)] animate-breathe motion-reduce:animate-none"></div>

  <!-- Barre de navigation -->
  <div class="relative z-10 -ml-2 mb-auto">
    <a href="/" class="inline-flex items-center gap-1.5 text-[14px] font-medium text-ef-dim no-underline px-2.5 py-2 rounded-lg transition-colors duration-150 hover:bg-ef-card hover:text-ef-fg focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
      </svg>
      Tableau de bord
    </a>
  </div>

  <!-- Contenu centré -->
  <div class="relative z-10 flex-1 flex items-center justify-center">
    <div class="text-center">

      <!-- Eyebrow compte -->
      <div class="opacity-0 [animation:fadeUp_0.6s_ease_0.05s_forwards] motion-reduce:opacity-100 motion-reduce:[animation:none] flex items-center justify-center gap-2 mb-2 font-mono text-[12px] uppercase tracking-[0.1em] text-ef-faint">
        <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" class="opacity-70">
          <rect x="3" y="5" width="18" height="14" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/>
        </svg>
        Compte bancaire
      </div>

      <!-- Nom du compte -->
      <div class="opacity-0 [animation:fadeUp_0.6s_ease_0.1s_forwards] motion-reduce:opacity-100 motion-reduce:[animation:none] mb-5 font-display text-[22px] sm:text-[26px] font-semibold tracking-tight text-ef-fg">
        ${bankAccountName}
      </div>

      <!-- Solde -->
      <div class="opacity-0 [animation:fadeUp_0.6s_ease_0.15s_forwards] motion-reduce:opacity-100 motion-reduce:[animation:none] flex items-baseline justify-center gap-1 font-mono font-medium tabular-nums text-[clamp(48px,11vw,96px)] leading-none tracking-[-0.02em] text-ef-fg"
           aria-label="Solde : ${balanceWhole}${balanceDecimal} euros">
        <span>${balanceWhole}</span><span class="text-ef-dim">${balanceDecimal}</span><span class="text-[0.45em] text-ef-accent font-medium ml-0.5">€</span>
      </div>

      <!-- Sous-titre -->
      <p class="opacity-0 [animation:fadeUp_0.6s_ease_0.3s_forwards] motion-reduce:opacity-100 motion-reduce:[animation:none] mt-[22px] text-[13.5px] text-ef-faint">
        Calculé à partir de <strong class="text-ef-dim font-medium">${operationCount} opération${operationCount > 1 ? "s" : ""}</strong> · au ${asOf}
      </p>

      <!-- Cartes de prévision -->
      <div class="opacity-0 [animation:fadeUp_0.6s_ease_0.36s_forwards] motion-reduce:opacity-100 motion-reduce:[animation:none] flex flex-col sm:flex-row gap-3 mt-8 justify-center">

        <div class="bg-ef-card border border-ef-border rounded-2xl px-5 py-4 min-w-[152px] text-left">
          <div class="flex items-center gap-1.5 mb-2 text-[11.5px] text-ef-faint uppercase tracking-[0.05em]">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="opacity-70 shrink-0">
              <rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
            </svg>
            Fin de mois
          </div>
          <div class="font-mono font-medium tabular-nums text-[19px] tracking-[-0.01em] text-ef-fg">
            ${endOfMonthWhole}<span class="text-ef-faint text-[0.8em]">${endOfMonthDecimal}</span> €
          </div>
          <div class="mt-1 font-mono text-[11.5px] font-medium ${endOfMonthPositive ? "text-ef-accent" : "text-ef-error"}">
            ${endOfMonthDelta}
          </div>
        </div>

        <div class="bg-ef-card border border-ef-border rounded-2xl px-5 py-4 min-w-[152px] text-left">
          <div class="flex items-center gap-1.5 mb-2 text-[11.5px] text-ef-faint uppercase tracking-[0.05em]">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="opacity-70 shrink-0">
              <polyline points="22 7 13.5 15.5 8.5 10.5 2 17"/><polyline points="16 7 22 7 22 13"/>
            </svg>
            Fin d'année
          </div>
          <div class="font-mono font-medium tabular-nums text-[19px] tracking-[-0.01em] text-ef-fg">
            ${endOfYearWhole}<span class="text-ef-faint text-[0.8em]">${endOfYearDecimal}</span> €
          </div>
          <div class="mt-1 font-mono text-[11.5px] font-medium ${endOfYearPositive ? "text-ef-accent" : "text-ef-error"}">
            ${endOfYearDelta}
          </div>
        </div>

      </div>

      <!-- Lien opérations -->
      <a
        href="/bank-accounts/${bankAccountId}/transactions"
        class="opacity-0 [animation:fadeUp_0.6s_ease_0.5s_forwards] motion-reduce:opacity-100 motion-reduce:[animation:none] inline-flex items-center gap-1.5 mt-7 text-[13.5px] font-medium text-ef-accent border border-ef-border rounded-full px-4 py-2 transition-colors duration-150 hover:bg-ef-accent-soft hover:border-ef-accent focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2 group"
      >
        Voir les opérations
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="transition-transform duration-150 group-hover:translate-x-0.5">
          <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
        </svg>
      </a>

    </div>
  </div>

</body>
</html>