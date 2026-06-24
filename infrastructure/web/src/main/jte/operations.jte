@import java.util.List
@param String bankAccountId
@param List<String> transactionIds
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<title>Opérations</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<script src="/tailwind.min.js"></script>
<script src="/tailwind.config.js"></script>
<script src="/htmx.min.js"></script>
</head>
<body class="bg-ef-bg text-ef-fg font-body min-h-screen px-3 py-4 pb-12 sm:px-4 sm:py-6 sm:pb-[60px]">

<div class="max-w-[640px] mx-auto">

  <!-- Topbar -->
  <div class="-ml-2 mb-5 sm:mb-7">
    <a href="/bank-accounts/${bankAccountId}"
       class="inline-flex items-center gap-[7px] text-[14px] font-medium text-ef-dim no-underline px-2 py-2.5 pr-3.5 rounded-lg min-h-[40px] transition-colors duration-150 hover:bg-ef-card hover:text-ef-fg focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
      </svg>
      Tableau de bord
    </a>
  </div>

  <!-- En-tête -->
  <div class="mb-5 px-1 sm:mb-7">
    <div class="flex items-center gap-2 mb-2 font-mono text-[11.5px] sm:text-[12px] text-ef-faint tracking-[0.08em] uppercase">
      <span class="w-1.5 h-1.5 rounded-full bg-ef-accent shrink-0"></span>
      <span hx-get="/bank-accounts/${bankAccountId}/transactions/count"
            hx-trigger="load"
            hx-swap="outerHTML">
        <span class="inline-block h-3 w-24 rounded bg-ef-border animate-pulse align-middle"></span>
      </span>
    </div>
    <h1 class="font-display text-[22px] sm:text-[26px] font-semibold tracking-tight">Transactions</h1>
  </div>

  @if(transactionIds.isEmpty())

  <div class="flex flex-col items-center text-center py-16 px-4 gap-5">
    <div class="w-12 h-12 rounded-xl bg-ef-card border border-ef-border flex items-center justify-center text-ef-faint">
      <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="11" x2="12" y2="17"/><line x1="9" y1="14" x2="15" y2="14"/>
      </svg>
    </div>
    <div>
      <p class="text-[15px] font-medium text-ef-fg mb-1">Aucune transaction</p>
      <p class="text-[13px] text-ef-faint">Importez un relevé bancaire pour commencer.</p>
    </div>
    <a href="/operations/import?bank-account-id=${bankAccountId}"
       class="inline-flex items-center gap-2 text-[13.5px] font-medium text-ef-accent border border-ef-border rounded-full px-4 py-2 transition-colors duration-150 hover:bg-ef-accent-soft hover:border-ef-accent focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/>
      </svg>
      Importer un relevé
    </a>
  </div>

  @else

  <div class="bg-ef-card border border-ef-border rounded-2xl overflow-hidden">
    @for(var txId : transactionIds)
    <div hx-get="/bank-accounts/${bankAccountId}/transactions/${txId}"
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

</body>
</html>