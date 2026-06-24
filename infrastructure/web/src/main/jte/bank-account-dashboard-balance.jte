@param String balanceWhole
@param String balanceDecimal
@param boolean balancePositive
<div class="px-1 mb-4">
  <div class="text-[12px] text-ef-faint mb-1.5">Solde importé</div>
  <div class="flex items-baseline gap-1 font-mono font-medium tabular-nums leading-none tracking-[-0.02em]"
       aria-label="Solde : ${balanceWhole}${balanceDecimal} euros">
    <span class="text-[36px] sm:text-[44px] ${balancePositive ? "text-ef-fg" : "text-ef-error"}">${balanceWhole}</span>
    <span class="text-[24px] sm:text-[28px] ${balancePositive ? "text-ef-dim" : "text-ef-error"} opacity-70">${balanceDecimal}</span>
    <span class="text-[18px] text-ef-accent font-medium ml-0.5">€</span>
  </div>
</div>