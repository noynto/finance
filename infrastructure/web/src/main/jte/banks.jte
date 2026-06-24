@import java.util.List
@import me.noynto.finance.domain.bankaccount.Bank
@param List<Bank> banks
<div class="grid grid-cols-3 gap-2.5">
  @for(int i = 0; i < banks.size(); i++)
  !{var bank = banks.get(i);}
  <label class="flex flex-col items-center gap-2 py-4 px-2 cursor-pointer bg-ef-input border-[1.5px] border-ef-border rounded-xl transition-colors hover:border-white/20 has-[:checked]:border-ef-accent has-[:checked]:bg-ef-accent-soft">
    @if(i == 0)
    <input type="radio" name="bank" value="${bank.name()}" class="sr-only" checked required>
    @else
    <input type="radio" name="bank" value="${bank.name()}" class="sr-only" required>
    @endif
    <div class="w-8 h-8 rounded-lg bg-white/10 flex items-center justify-center font-mono text-[11px] font-semibold text-ef-fg">${bank.getAbbreviate()}</div>
    <span class="text-[12.5px] font-medium text-ef-dim">${bank.getName()}</span>
  </label>
  @endfor
</div>