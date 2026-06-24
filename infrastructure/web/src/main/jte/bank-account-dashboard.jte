@param String bankAccountId
@param String bankAccountName
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

  <!-- En-tête compte -->
  <div class="opacity-0 [animation:fadeUp_0.5s_ease_0.05s_forwards] motion-reduce:opacity-100 motion-reduce:[animation:none] mb-6 px-1 sm:mb-8">
    <div class="flex items-center gap-2 mb-2 font-mono text-[11.5px] sm:text-[12px] text-ef-faint tracking-[0.08em] uppercase">
      <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" class="opacity-70 shrink-0">
        <rect x="3" y="5" width="18" height="14" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/>
      </svg>
      Compte bancaire ·
      <span hx-get="/bank-accounts/${bankAccountId}/count"
            hx-trigger="load"
            hx-swap="outerHTML">
        <span class="inline-block h-3 w-20 rounded bg-ef-border animate-pulse align-middle"></span>
      </span>
    </div>
    <div class="flex items-center justify-between gap-4">
      <h1 class="font-display text-[22px] sm:text-[26px] font-semibold tracking-tight">${bankAccountName}</h1>
      <div class="flex items-center gap-2 shrink-0">
        <a href="/operations/import?bank-account-id=${bankAccountId}"
           class="inline-flex items-center gap-1.5 text-[13px] font-medium text-ef-dim border border-ef-border rounded-full px-3.5 py-2 transition-colors duration-150 hover:bg-ef-card hover:text-ef-fg focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2">
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/>
          </svg>
          Importer
        </a>
        <a href="/bank-accounts/${bankAccountId}/settings"
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
  <div hx-get="/bank-accounts/${bankAccountId}/balance"
       hx-trigger="load"
       hx-swap="outerHTML">
    <div class="px-1 mb-4 animate-pulse">
      <div class="h-3 w-20 rounded bg-ef-border mb-2.5"></div>
      <div class="h-10 w-44 rounded-lg bg-ef-border"></div>
    </div>
  </div>

  <!-- Dernières opérations -->
  <div hx-get="/bank-accounts/${bankAccountId}/last-transactions"
       hx-trigger="load"
       hx-swap="outerHTML">
    <div class="animate-pulse">

      <!-- Skeleton section titre -->
      <div class="flex items-baseline justify-between px-1 mb-2">
        <div class="h-3.5 w-36 rounded bg-ef-border"></div>
        <div class="h-3 w-14 rounded bg-ef-border/60"></div>
      </div>

      <!-- Skeleton 5 lignes -->
      <div class="bg-ef-card border border-ef-border rounded-2xl overflow-hidden">
        @for(int i = 0; i < 5; i++)
        <div class="flex items-center gap-3 px-4 py-3.5 border-b border-ef-border/50 last:border-b-0">
          <div class="flex flex-col items-center w-[38px] shrink-0 gap-1">
            <div class="h-2 w-6 rounded bg-ef-border/60"></div>
            <div class="h-4 w-5 rounded bg-ef-border/80"></div>
          </div>
          <div class="flex-1 h-3.5 rounded bg-ef-border/80"></div>
          <div class="h-6 w-20 rounded-md bg-ef-border/60 shrink-0"></div>
        </div>
        @endfor
      </div>

    </div>
  </div>

</div>

</body>
</html>