<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<title>Tableau de bord</title>
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

  <!-- En-tête -->
  <div class="opacity-0 [animation:fadeUp_0.5s_ease_0.05s_forwards] motion-reduce:opacity-100 motion-reduce:[animation:none] mb-7 px-1 sm:mb-9">
    <div class="flex items-center gap-2 mb-2 font-mono text-[11.5px] sm:text-[12px] text-ef-faint tracking-[0.08em] uppercase">
      <span class="w-1.5 h-1.5 rounded-full bg-ef-accent shrink-0"></span>
      Finance
    </div>
    <div class="flex items-center justify-between gap-4">
      <h1 class="font-display text-[22px] sm:text-[26px] font-semibold tracking-tight">Tableau de bord</h1>
      <a href="/operations/import"
         class="inline-flex items-center gap-1.5 text-[13px] font-medium text-ef-dim border border-ef-border rounded-full px-3.5 py-2 transition-colors duration-150 hover:bg-ef-card hover:text-ef-fg focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2">
        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/>
        </svg>
        Importer
      </a>
    </div>
  </div>

  <!-- Balance -->
  <div hx-get="/dashboard/balance"
       hx-trigger="load"
       hx-swap="outerHTML">
    <div class="px-1 mb-7 animate-pulse">
      <div class="h-2.5 w-16 rounded bg-ef-border mb-2"></div>
      <div class="h-10 w-44 rounded-lg bg-ef-border"></div>
    </div>
  </div>

  <!-- Comptes bancaires -->
  <div class="opacity-0 [animation:fadeUp_0.5s_ease_0.15s_forwards] motion-reduce:opacity-100 motion-reduce:[animation:none] mb-7">

    <div class="flex items-center gap-2 px-1 mb-3 font-mono text-[11px] uppercase tracking-[0.08em] text-ef-faint">
      <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" class="opacity-70 shrink-0">
        <rect x="3" y="5" width="18" height="14" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/>
      </svg>
      Comptes bancaires
    </div>

    <div hx-get="/dashboard/bank-accounts/ids"
         hx-trigger="load"
         hx-swap="outerHTML">
      <div class="bg-ef-card border border-ef-border rounded-2xl overflow-hidden divide-y divide-ef-border/50">
        <div class="h-[57px] animate-pulse bg-white/[0.02]"></div>
        <div class="h-[57px] animate-pulse bg-white/[0.015]"></div>
        <div class="h-[57px] animate-pulse bg-white/[0.01]"></div>
      </div>
    </div>

  </div>

  <!-- Tiers -->
  <div class="opacity-0 [animation:fadeUp_0.5s_ease_0.2s_forwards] motion-reduce:opacity-100 motion-reduce:[animation:none]">

    <div class="flex items-center gap-2 px-1 mb-3 font-mono text-[11px] uppercase tracking-[0.08em] text-ef-faint">
      <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" class="opacity-70 shrink-0">
        <circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
      </svg>
      Tiers
    </div>

    <div hx-get="/dashboard/payees/ids"
         hx-trigger="load"
         hx-swap="outerHTML">
      <div class="bg-ef-card border border-ef-border rounded-2xl overflow-hidden divide-y divide-ef-border/50">
        <div class="h-[57px] animate-pulse bg-white/[0.02]"></div>
        <div class="h-[57px] animate-pulse bg-white/[0.015]"></div>
      </div>
    </div>

  </div>

</div>

</body>
</html>