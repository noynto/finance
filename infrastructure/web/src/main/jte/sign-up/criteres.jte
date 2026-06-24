@param boolean length
@param boolean lower
@param boolean upper
@param boolean digit
@param boolean special
<div id="criteres" class="grid grid-cols-2 gap-x-3 gap-y-2 mt-3">
  <div class="flex items-center gap-1.5 text-[12px] transition-colors duration-200 ${length ? "text-ef-accent" : "text-ef-faint"}">
    <span class="w-4 h-4 rounded-full border border-current shrink-0 flex items-center justify-center">
      <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round" class="transition-opacity duration-150 ${length ? "opacity-100" : "opacity-0"}"><polyline points="20 6 9 17 4 12"/></svg>
    </span>
    20 à 60 caractères
  </div>
  <div class="flex items-center gap-1.5 text-[12px] transition-colors duration-200 ${lower ? "text-ef-accent" : "text-ef-faint"}">
    <span class="w-4 h-4 rounded-full border border-current shrink-0 flex items-center justify-center">
      <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round" class="transition-opacity duration-150 ${lower ? "opacity-100" : "opacity-0"}"><polyline points="20 6 9 17 4 12"/></svg>
    </span>
    Minuscule
  </div>
  <div class="flex items-center gap-1.5 text-[12px] transition-colors duration-200 ${upper ? "text-ef-accent" : "text-ef-faint"}">
    <span class="w-4 h-4 rounded-full border border-current shrink-0 flex items-center justify-center">
      <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round" class="transition-opacity duration-150 ${upper ? "opacity-100" : "opacity-0"}"><polyline points="20 6 9 17 4 12"/></svg>
    </span>
    Majuscule
  </div>
  <div class="flex items-center gap-1.5 text-[12px] transition-colors duration-200 ${digit ? "text-ef-accent" : "text-ef-faint"}">
    <span class="w-4 h-4 rounded-full border border-current shrink-0 flex items-center justify-center">
      <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round" class="transition-opacity duration-150 ${digit ? "opacity-100" : "opacity-0"}"><polyline points="20 6 9 17 4 12"/></svg>
    </span>
    Chiffre
  </div>
  <div class="flex items-center gap-1.5 text-[12px] transition-colors duration-200 ${special ? "text-ef-accent" : "text-ef-faint"}">
    <span class="w-4 h-4 rounded-full border border-current shrink-0 flex items-center justify-center">
      <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round" class="transition-opacity duration-150 ${special ? "opacity-100" : "opacity-0"}"><polyline points="20 6 9 17 4 12"/></svg>
    </span>
    Caractère spécial
  </div>
</div>