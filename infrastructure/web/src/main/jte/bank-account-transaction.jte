@param String label
@param String month
@param String day
@param boolean positive
@param String amount

<div class="flex items-center gap-3 px-4 py-3.5 border-b border-ef-border/50 last:border-b-0 transition-colors duration-[120ms] active:bg-ef-border/20">

  <div class="flex flex-col items-center w-[38px] shrink-0 text-center font-mono text-ef-faint leading-[1.3]">
    <span class="text-[10px] uppercase tracking-[0.03em] capitalize">${month}</span>
    <span class="text-[15px] text-ef-dim font-medium">${day}</span>
  </div>

  <div class="flex-1 min-w-0 text-[14px] font-medium text-ef-fg truncate">${label}</div>

  <span class="font-mono text-[13.5px] font-medium tabular-nums rounded-md px-2 py-[3px] shrink-0 ${positive ? "text-ef-accent bg-ef-accent-soft" : "text-ef-error bg-ef-error-soft"}">${amount}</span>

</div>