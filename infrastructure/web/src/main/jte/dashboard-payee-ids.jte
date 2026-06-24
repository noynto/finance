@import java.util.List
@param List<String> ids
@if(ids.isEmpty())
<div class="bg-ef-card border border-dashed border-ef-border rounded-2xl px-5 py-6 flex flex-col items-center gap-3">
  <p class="text-[13px] text-ef-faint text-center">Aucun tiers enregistré.</p>
  <a href="/payees/new" class="inline-flex items-center gap-1.5 text-[13px] font-medium text-ef-accent border border-ef-border rounded-full px-4 py-2 transition-colors duration-150 hover:bg-ef-accent-soft hover:border-ef-accent focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2">
    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
      <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
    </svg>
    Ajouter un tiers
  </a>
</div>
@else
<div class="bg-ef-card border border-ef-border rounded-2xl overflow-hidden divide-y divide-ef-border/50">
  @for(var id : ids)
  <div hx-get="/dashboard/payees/${id}"
       hx-trigger="load"
       hx-swap="outerHTML"
       class="h-[57px] animate-pulse bg-white/[0.02]"></div>
  @endfor
  <a href="/payees/new" class="flex items-center gap-3 px-4 py-3.5 transition-colors duration-150 hover:bg-white/[0.03] group no-underline">
    <div class="w-8 h-8 rounded-lg border border-dashed border-ef-border flex items-center justify-center shrink-0">
      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-ef-faint">
        <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
      </svg>
    </div>
    <span class="text-[13px] text-ef-faint group-hover:text-ef-dim transition-colors duration-150">Ajouter un tiers</span>
  </a>
</div>
@endif