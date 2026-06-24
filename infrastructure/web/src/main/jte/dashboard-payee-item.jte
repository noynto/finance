@import me.noynto.finance.domain.payee.Payee
@param Payee payee
<a href="/payees/${payee.getId().getValue()}" class="flex items-center gap-3 px-4 py-3.5 transition-colors duration-150 hover:bg-white/[0.03] group no-underline">
  <div class="w-8 h-8 rounded-lg bg-white/10 flex items-center justify-center font-mono text-[11px] font-semibold text-ef-fg shrink-0">
    ${payee.getName().substring(0, Math.min(2, payee.getName().length())).toUpperCase()}
  </div>
  <div class="flex-1 min-w-0">
    <div class="text-[13.5px] font-medium text-ef-fg truncate">${payee.getName()}</div>
    @if(payee.getPattern() != null && !payee.getPattern().isBlank())
    <div class="text-[11.5px] text-ef-faint font-mono truncate">${payee.getPattern()}</div>
    @else
    <div class="text-[11.5px] text-ef-faint">${payee.getTransactionIds().size()} transaction${payee.getTransactionIds().size() > 1 ? "s" : ""}</div>
    @endif
  </div>
  <span class="text-[12px] font-mono text-ef-faint shrink-0">${payee.getTransactionIds().size()}</span>
</a>