@param boolean invalid
<p id="email-feedback" class="${invalid ? "mt-2 text-[12px] text-ef-error flex items-center gap-1.5" : "hidden"}">
  @if(invalid)
  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="shrink-0">
    <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
  </svg>
  Format d'adresse électronique invalide.
  @endif
</p>