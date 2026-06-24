@import me.noynto.finance.domain.bankaccount.BankAccount
@param BankAccount account
<a href="/bank-accounts/${account.getId().getValue()}" class="flex items-center gap-3 px-4 py-3.5 transition-colors duration-150 hover:bg-white/[0.03] group no-underline">
  <div class="w-8 h-8 rounded-lg bg-white/10 flex items-center justify-center font-mono text-[11px] font-semibold text-ef-fg shrink-0">
    ${account.getBank().getAbbreviate()}
  </div>
  <div class="flex-1 min-w-0">
    <div class="text-[13.5px] font-medium text-ef-fg truncate">${account.getName()}</div>
    <div class="text-[11.5px] text-ef-faint">${account.getBank().getName()}</div>
  </div>
  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-ef-faint transition-transform duration-150 group-hover:translate-x-0.5 shrink-0">
    <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
  </svg>
</a>