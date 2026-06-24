@import java.util.List
@param String bankAccountId
@param List<String> transactionIds

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

<div>

  <div class="flex items-baseline justify-between px-1 mb-2">
    <span class="font-display text-[13.5px] font-semibold">Dernières transactions</span>
    <a href="/bank-accounts/${bankAccountId}/transactions"
       class="inline-flex items-center gap-1 text-[12.5px] font-medium text-ef-accent no-underline transition-colors duration-150 hover:text-ef-fg group">
      Tout voir
      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="transition-transform duration-150 group-hover:translate-x-0.5">
        <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
      </svg>
    </a>
  </div>

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

  <div class="mt-3 flex justify-center">
    <a href="/bank-accounts/${bankAccountId}/transactions"
       class="inline-flex items-center gap-1.5 text-[13.5px] font-medium text-ef-accent border border-ef-border rounded-full px-4 py-2 transition-colors duration-150 hover:bg-ef-accent-soft hover:border-ef-accent focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2 group">
      Voir les transactions
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="transition-transform duration-150 group-hover:translate-x-0.5">
        <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
      </svg>
    </a>
  </div>

</div>

@endif