@import java.util.List
@import java.util.Map
@param boolean hasBankAccounts
@param String selectedBankAccountId
@param List<Map<String, Object>> bankGroups
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<title>Importer des opérations</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<script src="/tailwind.min.js"></script>
<script src="/tailwind.config.js"></script>
<script src="/htmx.min.js"></script>
</head>
<body class="bg-ef-bg text-ef-fg font-body min-h-screen flex items-center justify-center p-6">

<div class="w-full max-w-[560px]">

  <!-- En-tête -->
  <div class="mb-8">
    <div class="flex items-center gap-2 mb-2.5 font-mono text-[12px] text-ef-faint tracking-[0.08em] uppercase">
      <span class="w-1.5 h-1.5 rounded-full bg-ef-accent shrink-0"></span>
      Opérations · Import
    </div>
    <h1 class="font-display text-[28px] font-semibold tracking-tight mb-2">Importer un relevé</h1>
    <p class="text-[14.5px] text-ef-dim leading-relaxed">Sélectionnez le compte bancaire concerné puis les fichiers XLSX exportés. Les doublons sont automatiquement ignorés.</p>
  </div>

  <!-- Carte -->
  <div class="bg-ef-card border border-ef-border rounded-2xl p-7 shadow-[0_1px_2px_rgba(0,0,0,0.2),0_4px_16px_rgba(0,0,0,0.24)]">
    <form method="post" action="/operations/import" enctype="multipart/form-data"
          hx-post="/operations/import" hx-encoding="multipart/form-data"
          hx-indicator="#import-btn" hx-disabled-elt="#import-btn">

      <!-- Étape 1 -->
      <div class="flex items-center gap-2.5 mb-4">
        <span class="w-5 h-5 rounded-full bg-ef-accent font-mono text-[11px] font-semibold text-ef-bg flex items-center justify-center shrink-0">1</span>
        <span class="text-[13px] font-semibold uppercase tracking-[0.04em]">Compte bancaire</span>
        <a href="/bank-accounts/new" class="ml-auto font-mono text-[11.5px] font-medium text-[#7fbbb3] no-underline hover:underline">+ Ajouter</a>
      </div>

      @if(!hasBankAccounts)
      <div class="text-center py-9 px-5 bg-ef-input border-[1.5px] border-dashed border-ef-hover rounded-lg mb-7">
        <div class="w-11 h-11 mx-auto mb-3.5 rounded-lg bg-ef-hover flex items-center justify-center text-ef-faint">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="5" width="18" height="14" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/>
          </svg>
        </div>
        <p class="text-[14.5px] font-semibold mb-1">Aucun compte bancaire</p>
        <p class="text-[12.5px] text-ef-faint leading-relaxed mb-[18px]">Créez d'abord un compte bancaire pour pouvoir y importer vos opérations.</p>
        <a href="/bank-accounts/new"
           class="inline-flex items-center gap-[7px] text-[13.5px] font-semibold text-ef-bg bg-ef-accent no-underline px-[18px] py-[11px] rounded-lg transition-colors duration-150 hover:bg-ef-accent-str">
          Créer un compte bancaire
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
          </svg>
        </a>
      </div>
      @else

      <!-- Sélection du compte -->
      <div role="radiogroup" aria-label="Choisir un compte bancaire" class="mb-7">
        @for(var group : bankGroups)
        <div class="mb-4 last:mb-0">
          <div class="flex items-center gap-2 px-0.5 mb-2">
            <div class="w-5 h-5 rounded-[5px] font-display font-bold text-[9px] text-ef-bg flex items-center justify-center shrink-0"
                 style="background:${(String) group.get("logoColor")}">${(String) group.get("logoInitials")}</div>
            <span class="text-[12px] font-semibold text-ef-faint uppercase tracking-[0.04em]">${(String) group.get("bankName")}</span>
          </div>
          @for(var account : (List<Map<String, Object>>) group.get("accounts"))
          <label class="flex items-center gap-3 w-full bg-ef-input border-[1.5px] border-ef-border rounded-lg px-3.5 py-3 mb-2 last:mb-0 cursor-pointer transition-colors duration-150 hover:bg-ef-hover hover:border-ef-hover has-[:checked]:border-ef-accent has-[:checked]:bg-ef-accent-soft focus-within:outline focus-within:outline-2 focus-within:outline-ef-accent focus-within:outline-offset-2">
            <input type="radio" name="bankAccountId" value="${(String) account.get("id")}" class="peer sr-only"
                   checked="${selectedBankAccountId != null && selectedBankAccountId.equals((String) account.get("id"))}">
            <span class="relative w-[18px] h-[18px] rounded-full border-[1.5px] border-ef-hover shrink-0 transition-colors duration-150
                         after:content-[''] after:absolute after:inset-[3px] after:rounded-full after:bg-ef-accent after:scale-0 after:transition-transform after:duration-150
                         peer-checked:border-ef-accent peer-checked:after:scale-100"></span>
            <span class="flex-1 text-[14px] font-medium">${(String) account.get("name")}</span>
            <span class="w-2.5 h-2.5 rounded-full shrink-0" style="background:${(String) account.get("color")}"></span>
          </label>
          @endfor
        </div>
        @endfor
      </div>

      <!-- Étape 2 -->
      <div class="flex items-center gap-2.5 mb-4">
        <span class="w-5 h-5 rounded-full bg-ef-accent font-mono text-[11px] font-semibold text-ef-bg flex items-center justify-center shrink-0">2</span>
        <span class="text-[13px] font-semibold uppercase tracking-[0.04em]">Les fichiers</span>
      </div>

      <!-- Zone de fichier -->
      <label id="drop-zone" class="block border-[1.5px] border-dashed border-ef-hover rounded-lg px-5 py-8 text-center cursor-pointer transition-colors duration-150 hover:border-ef-accent hover:bg-ef-accent-soft">
        <input type="file" id="file-input" name="file" accept=".xlsx" multiple class="sr-only">

        <!-- État par défaut -->
        <div id="file-default">
          <div class="w-11 h-11 mx-auto mb-3.5 rounded-lg bg-ef-hover flex items-center justify-center">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#a7c080" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/>
              <line x1="12" y1="18" x2="12" y2="12"/><polyline points="9 15 12 12 15 15"/>
            </svg>
          </div>
          <p class="text-[14.5px] font-semibold mb-1">Sélectionner les relevés</p>
          <p class="text-[12.5px] text-ef-faint">Format <strong class="text-ef-dim">.xlsx</strong> · <span class="text-[#7fbbb3] font-medium">plusieurs fichiers acceptés</span></p>
        </div>

        <!-- État sélectionné -->
        <div id="file-selected" class="hidden">
          <div class="w-11 h-11 mx-auto mb-3.5 rounded-lg bg-ef-accent-soft flex items-center justify-center">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#a7c080" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="20 6 9 17 4 12"/>
            </svg>
          </div>
          <p id="file-count" class="text-[14.5px] font-semibold text-ef-accent mb-1"></p>
          <p class="text-[12.5px] text-ef-faint">Cliquer pour modifier la sélection</p>
        </div>
      </label>

      <!-- Liste des fichiers sélectionnés -->
      <div id="file-list" class="mt-2.5 space-y-1.5"></div>

      <!-- Soumission -->
      <div class="mt-7 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <p class="text-[12px] text-ef-faint leading-relaxed">Les opérations en double<br>seront automatiquement ignorées.</p>
        <button id="import-btn" type="submit"
                class="group inline-flex items-center justify-center gap-2 text-[14px] font-semibold text-ef-bg bg-ef-accent border-none px-[22px] py-3 rounded-lg cursor-pointer whitespace-nowrap transition-colors duration-150 hover:bg-ef-accent-str active:scale-[0.98] focus-visible:outline focus-visible:outline-2 focus-visible:outline-ef-accent focus-visible:outline-offset-2 disabled:opacity-60 disabled:cursor-not-allowed disabled:active:scale-100">
          <!-- Spinner (visible pendant la requête) -->
          <svg class="htmx-indicator animate-spin shrink-0" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round">
            <path d="M21 12a9 9 0 1 1-6.219-8.56"/>
          </svg>
          Importer
          <!-- Flèche (masquée pendant la requête) -->
          <svg class="group-[.htmx-request]:opacity-0 transition-opacity" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
          </svg>
        </button>
      </div>
      @endif

    </form>
  </div>

</div>

<script>
(function () {
  var input    = document.getElementById('file-input');
  var zone     = document.getElementById('drop-zone');
  var dflt     = document.getElementById('file-default');
  var sel      = document.getElementById('file-selected');
  var countEl  = document.getElementById('file-count');
  var list     = document.getElementById('file-list');

  function fmt(b) {
    if (b < 1024)        return b + ' o';
    if (b < 1048576)     return Math.round(b / 1024) + ' Ko';
    return (b / 1048576).toFixed(1) + ' Mo';
  }

  input.addEventListener('change', function () {
    var files = Array.from(this.files);

    if (!files.length) {
      zone.classList.remove('border-ef-accent', 'bg-ef-accent-soft');
      zone.classList.add('border-ef-hover');
      dflt.classList.remove('hidden');
      sel.classList.add('hidden');
      list.innerHTML = '';
      return;
    }

    zone.classList.remove('border-ef-hover');
    zone.classList.add('border-ef-accent', 'bg-ef-accent-soft');
    dflt.classList.add('hidden');
    sel.classList.remove('hidden');
    countEl.textContent = files.length === 1 ? '1 fichier prêt' : files.length + ' fichiers prêts';

    list.innerHTML = '';
    files.forEach(function (f) {
      var row = document.createElement('div');
      row.className = 'flex items-center gap-3 px-3.5 py-2.5 bg-ef-input border border-ef-border rounded-lg';
      row.insertAdjacentHTML('beforeend',
        '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#a7c080" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="shrink-0" aria-hidden="true">' +
        '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>'
      );
      var nameEl = document.createElement('span');
      nameEl.className = 'flex-1 text-[13.5px] font-medium truncate';
      nameEl.textContent = f.name;
      var sizeEl = document.createElement('span');
      sizeEl.className = 'text-[12px] text-ef-faint font-mono shrink-0';
      sizeEl.textContent = fmt(f.size);
      row.appendChild(nameEl);
      row.appendChild(sizeEl);
      list.appendChild(row);
    });
  });
}());
</script>
</body>
</html>
