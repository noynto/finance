@import java.util.List
@param String payeeId
@param String payeeName
@param String payeePattern
@param List<String> transactionIds
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<title>${payeeName}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<script src="/tailwind.min.js"></script>
<script src="/tailwind.config.js"></script>
<script src="/htmx.min.js"></script>
<style>
  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(8px); }
    to   { opacity: 1; transform: translateY(0); }
  }
</style>
</head>
<body class="bg-ef-bg text-ef-fg font-body min-h-screen px-3 py-4 pb-12 sm:px-4 sm:py-6 sm:pb-[60px]">

<div class="max-w-[640px] mx-auto">

  <!-- Topbar -->
  <div class="-ml-2 mb-5 sm:mb-7">
    <a href="/"
       class="inline-flex items-center gap-[7px] text-[14px] font-medium text-ef-dim no-underline px-2 py-2.5 pr-3.5 rounded-lg min-h-[40px] transition-colors duration-150 hover:bg-ef-card hover:text-ef-fg focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
      </svg>
      Tableau de bord
    </a>
  </div>

  <!-- En-tête -->
  <div class="opacity-0 [animation:fadeUp_0.5s_ease_0.05s_forwards] motion-reduce:opacity-100 motion-reduce:[animation:none] mb-6 px-1 sm:mb-8">
    <div class="flex items-center gap-2 mb-2 font-mono text-[11.5px] sm:text-[12px] text-ef-faint tracking-[0.08em] uppercase">
      <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" class="opacity-70 shrink-0">
        <circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
      </svg>
      Tiers · ${transactionIds.size()} transaction${transactionIds.size() > 1 ? "s" : ""}
    </div>
    <div class="flex items-start justify-between gap-4">
      <div class="min-w-0">
        <h1 class="font-display text-[22px] sm:text-[26px] font-semibold tracking-tight">${payeeName}</h1>
        @if(!payeePattern.isEmpty())
        <div class="mt-1.5 inline-flex items-center gap-1.5 font-mono text-[11.5px] text-ef-faint bg-ef-card border border-ef-border rounded-md px-2.5 py-1">
          <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="shrink-0 opacity-60">
            <polyline points="4 17 10 11 4 5"/><line x1="12" y1="19" x2="20" y2="19"/>
          </svg>
          ${payeePattern}
        </div>
        @endif
      </div>
      <div class="flex items-center gap-2 shrink-0">
        @if(!payeePattern.isEmpty())
        <form method="post" action="/payees/${payeeId}/match">
          <button type="submit"
                  class="inline-flex items-center gap-1.5 text-[13px] font-medium text-ef-accent border border-ef-border rounded-full px-3.5 py-2 transition-colors duration-150 hover:bg-ef-accent-soft hover:border-ef-accent focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2 bg-transparent cursor-pointer">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M21 2v6h-6"/><path d="M3 12a9 9 0 0 1 15-6.7L21 8"/><path d="M3 22v-6h6"/><path d="M21 12a9 9 0 0 1-15 6.7L3 16"/>
            </svg>
            Rapprocher
          </button>
        </form>
        @endif
        <a href="/payees/${payeeId}/settings"
           class="inline-flex items-center gap-1.5 text-[13px] font-medium text-ef-dim border border-ef-border rounded-full px-3.5 py-2 transition-colors duration-150 hover:bg-ef-card hover:text-ef-fg focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2">
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
          </svg>
          Modifier
        </a>
      </div>
    </div>
  </div>

  <!-- Balance -->
  <div hx-get="/payees/${payeeId}/balance"
       hx-trigger="load"
       hx-swap="outerHTML">
    <div class="px-1 mb-6 animate-pulse">
      <div class="h-2.5 w-20 rounded bg-ef-border mb-2"></div>
      <div class="h-10 w-44 rounded-lg bg-ef-border"></div>
    </div>
  </div>

  <!-- Transactions -->
  <div class="opacity-0 [animation:fadeUp_0.5s_ease_0.1s_forwards] motion-reduce:opacity-100 motion-reduce:[animation:none]">

    @if(transactionIds.isEmpty())

    <div class="flex flex-col items-center text-center py-16 px-4 gap-5">
      <div class="w-12 h-12 rounded-xl bg-ef-card border border-ef-border flex items-center justify-center text-ef-faint">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
        </svg>
      </div>
      <div>
        <p class="text-[15px] font-medium text-ef-fg mb-1">Aucune transaction dans cette catégorie</p>
        <p class="text-[13px] text-ef-faint">Les transactions dont le libellé correspond à la regex seront classées ici automatiquement.</p>
      </div>
    </div>

    @else

    <div class="bg-ef-card border border-ef-border rounded-2xl overflow-hidden">
      @for(var txId : transactionIds)
      <div hx-get="/payees/${payeeId}/transactions/${txId}"
           hx-trigger="load"
           hx-swap="outerHTML"
           class="flex items-center gap-3 px-4 py-3.5 border-b border-ef-border/50 last:border-b-0 animate-pulse">
        <div class="flex flex-col items-center w-[38px] shrink-0 gap-1">
          <div class="h-2 w-6 rounded bg-ef-border/60"></div>
          <div class="h-4 w-5 rounded bg-ef-border/80"></div>
        </div>
        <div class="flex-1 h-3.5 rounded bg-ef-border/80"></div>
        <div class="h-6 w-20 rounded-md bg-ef-border/60 shrink-0"></div>
      </div>
      @endfor
    </div>

    @endif

  </div>

</div>

</body>
</html>