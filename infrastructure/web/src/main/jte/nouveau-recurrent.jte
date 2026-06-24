@param String accountName
@param String accountInitial
@param String accountGradient
@param String compteId
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<title>Récurrent · ${accountName}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<script src="https://unpkg.com/htmx.org@2.0.4/dist/htmx.min.js"></script>
<style>
  :root {
    --bg: #2d353b; --bg-elevated: #343f44; --bg-elevated-2: #3d484d; --bg-hover: #475258;
    --border: #475258; --border-strong: #56635f;
    --fg: #d3c6aa; --fg-dim: #9da9a0; --fg-faint: #7a8478;
    --accent: #a7c080; --accent-strong: #8fad6f; --accent-soft: rgba(167,192,128,0.12);
    --info: #7fbbb3; --info-soft: rgba(127,187,179,0.12);
    --font-display: 'Space Grotesk', sans-serif; --font-body: 'Inter', sans-serif; --font-mono: 'JetBrains Mono', monospace;
    --radius-sm: 6px; --radius: 10px; --radius-lg: 16px;
    --shadow: 0 1px 2px rgba(0,0,0,0.2), 0 4px 16px rgba(0,0,0,0.24);
  }
  * { box-sizing: border-box; margin: 0; padding: 0; -webkit-tap-highlight-color: transparent; }
  html { -webkit-text-size-adjust: 100%; }
  body { background: var(--bg); color: var(--fg); font-family: var(--font-body); min-height: 100vh; padding: 16px 12px 48px; }
  .page { max-width: 480px; margin: 0 auto; }
  .topbar { display: flex; align-items: center; margin-bottom: 20px; margin-left: -8px; }
  .back-link { display: inline-flex; align-items: center; gap: 7px; font-size: 14px; font-weight: 500; color: var(--fg-dim); text-decoration: none; padding: 10px 14px 10px 8px; border-radius: 8px; min-height: 40px; transition: background 0.15s ease, color 0.15s ease; }
  .back-link:hover, .back-link:active { background: var(--bg-elevated); color: var(--fg); }
  .back-link:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px; }
  .header { margin-bottom: 24px; padding: 0 4px; }
  .eyebrow { font-family: var(--font-mono); font-size: 11.5px; color: var(--fg-faint); letter-spacing: 0.08em; text-transform: uppercase; display: flex; align-items: center; gap: 8px; margin-bottom: 8px; }
  .eyebrow::before { content: ""; width: 6px; height: 6px; border-radius: 50%; background: var(--info); flex-shrink: 0; }
  .account-chip { display: flex; align-items: center; gap: 10px; margin-bottom: 14px; }
  .account-avatar { width: 30px; height: 30px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-family: var(--font-display); font-weight: 700; font-size: 12px; color: #fff; flex-shrink: 0; }
  .account-chip-name { font-size: 13.5px; font-weight: 600; color: var(--fg-dim); }
  h1 { font-family: var(--font-display); font-size: 22px; font-weight: 600; letter-spacing: -0.01em; margin-bottom: 6px; }
  .subtitle { font-size: 13.5px; color: var(--fg-dim); line-height: 1.5; }
  .card { background: var(--bg-elevated); border: 1px solid var(--border); border-radius: var(--radius-lg); padding: 24px 20px; box-shadow: var(--shadow); }
  .field { margin-bottom: 22px; }
  .field:last-of-type { margin-bottom: 0; }
  .field-label { display: block; font-size: 12.5px; font-weight: 600; color: var(--fg); margin-bottom: 9px; }
  .field-hint { font-size: 12px; color: var(--fg-faint); margin-top: 7px; line-height: 1.4; }
  .text-input, .select-input { width: 100%; background: var(--bg-elevated-2); border: 1.5px solid var(--border); border-radius: var(--radius); padding: 13px 14px; font-family: var(--font-body); font-size: 15px; color: var(--fg); outline: none; transition: border-color 0.15s ease, background 0.15s ease; }
  .text-input::placeholder { color: var(--fg-faint); }
  .text-input:focus, .select-input:focus { border-color: var(--accent); background: var(--bg-elevated); }
  .amount-wrap { position: relative; }
  .amount-wrap .text-input { font-family: var(--font-mono); font-variant-numeric: tabular-nums; padding-right: 38px; }
  .amount-suffix { position: absolute; right: 14px; top: 50%; transform: translateY(-50%); color: var(--fg-faint); font-size: 15px; pointer-events: none; }
  .freq-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
  .freq-option { background: var(--bg-elevated-2); border: 1.5px solid var(--border); border-radius: var(--radius); padding: 13px 14px; cursor: pointer; transition: border-color 0.15s ease, background 0.15s ease; text-align: left; }
  .freq-option:hover { border-color: var(--border-strong); background: var(--bg-hover); }
  .freq-option:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px; }
  .freq-option.selected { border-color: var(--accent); background: var(--accent-soft); }
  .freq-option-title { font-size: 13.5px; font-weight: 600; color: var(--fg); display: flex; align-items: center; gap: 8px; }
  .freq-option-title svg { color: var(--fg-faint); flex-shrink: 0; }
  .freq-option.selected .freq-option-title svg { color: var(--accent); }
  .freq-option-sub { font-size: 11.5px; color: var(--fg-faint); margin-top: 3px; }
  .day-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 6px; }
  .day-cell { aspect-ratio: 1; border-radius: 8px; border: 1.5px solid var(--border); background: var(--bg-elevated-2); color: var(--fg-dim); font-family: var(--font-mono); font-size: 12.5px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.12s ease; }
  .day-cell:hover { border-color: var(--border-strong); background: var(--bg-hover); }
  .day-cell.selected { background: var(--accent); border-color: var(--accent); color: var(--bg); font-weight: 600; }
  .day-cell:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px; }
  .toggle-row { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-bottom: 12px; }
  .toggle-label-group { flex: 1; }
  .toggle-title { font-size: 13px; font-weight: 500; color: var(--fg); }
  .toggle-sub { font-size: 11.5px; color: var(--fg-faint); margin-top: 1px; }
  .switch { position: relative; width: 42px; height: 25px; flex-shrink: 0; }
  .switch input { opacity: 0; width: 0; height: 0; }
  .switch-track { position: absolute; inset: 0; background: var(--bg-hover); border: 1.5px solid var(--border-strong); border-radius: 100px; cursor: pointer; transition: background 0.15s ease, border-color 0.15s ease; }
  .switch-track::before { content: ""; position: absolute; width: 17px; height: 17px; left: 2px; top: 2px; background: var(--fg-dim); border-radius: 50%; transition: transform 0.15s ease, background 0.15s ease; }
  .switch input:checked + .switch-track { background: var(--accent-soft); border-color: var(--accent); }
  .switch input:checked + .switch-track::before { transform: translateX(17px); background: var(--accent); }
  .switch input:focus-visible + .switch-track { outline: 2px solid var(--accent); outline-offset: 2px; }
  .end-date-field { overflow: hidden; transition: max-height 0.2s ease, opacity 0.2s ease, margin-top 0.2s ease; }
  .end-date-field.hidden { max-height: 0; opacity: 0; margin-top: -22px; pointer-events: none; }
  .submit-row { margin-top: 28px; }
  .btn-primary { width: 100%; font-family: var(--font-body); font-size: 14.5px; font-weight: 600; color: var(--bg); background: var(--accent); border: none; padding: 14px 22px; border-radius: var(--radius); cursor: pointer; transition: background 0.15s ease, transform 0.1s ease; display: flex; align-items: center; justify-content: center; gap: 8px; }
  .btn-primary:hover { background: var(--accent-strong); }
  .btn-primary:active { transform: scale(0.99); }
  .btn-primary:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px; }
  .preview { margin-top: 16px; padding: 13px 14px; background: var(--info-soft); border: 1px solid rgba(127,187,179,0.3); border-radius: 10px; font-size: 12.5px; color: var(--fg-dim); line-height: 1.5; }
  .preview strong { color: var(--info); font-weight: 600; }
  @media (min-width: 480px) { body { padding: 24px 16px 60px; } .topbar { margin-bottom: 28px; } h1 { font-size: 24px; } .card { padding: 28px; } }
</style>
</head>
<body>

<div class="page">
  <div class="topbar">
    <a href="/comptes/${compteId}" class="back-link">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
      </svg>
      ${accountName}
    </a>
  </div>

  <div class="header">
    <div class="eyebrow">Récurrent · Nouveau</div>
    <div class="account-chip">
      <div class="account-avatar" style="background:${accountGradient}">${accountInitial}</div>
      <span class="account-chip-name">${accountName}</span>
    </div>
    <h1>Définir la règle récurrente</h1>
    <p class="subtitle">Le montant attendu et le jour du mois où l'opération doit normalement apparaître.</p>
  </div>

  <div class="card">
    <form method="post" action="/comptes/${compteId}/recurrent">

      <div class="field">
        <label class="field-label" for="amount">Montant attendu</label>
        <div class="amount-wrap">
          <input type="text" inputmode="decimal" id="amount" name="amount" class="text-input" placeholder="0,00">
          <span class="amount-suffix">€</span>
        </div>
      </div>

      <div class="field">
        <span class="field-label">Fréquence</span>
        <div class="freq-grid" role="radiogroup" aria-label="Choisir la fréquence">
          <button type="button" class="freq-option selected" id="freqMonthly" role="radio" aria-checked="true">
            <div class="freq-option-title">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
              </svg>
              Mensuel
            </div>
            <div class="freq-option-sub">Tous les mois</div>
          </button>
          <button type="button" class="freq-option" id="freqQuarterly" role="radio" aria-checked="false">
            <div class="freq-option-title">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
              </svg>
              Trimestriel
            </div>
            <div class="freq-option-sub">Tous les 3 mois</div>
          </button>
        </div>
        <input type="hidden" name="frequency" id="frequencyInput" value="MONTHLY">
      </div>

      <div class="field">
        <span class="field-label" id="dayFieldLabel">Jour du mois</span>
        <div class="day-grid" role="radiogroup" aria-label="Choisir le jour du mois">
          @for(int d = 1; d <= 31; d++)
          <button type="button" class="day-cell" data-day="${d}">${d}</button>
          @endfor
        </div>
        <input type="hidden" name="dayOfMonth" id="dayInput" value="">
        <p class="field-hint" id="dayFieldHint">Pour les mois plus courts, l'opération sera attendue au dernier jour du mois.</p>
      </div>

      <div class="field">
        <label class="field-label" for="startDate">Date de début</label>
        <input type="date" id="startDate" name="startDate" class="text-input">
      </div>

      <div class="field">
        <div class="toggle-row">
          <div class="toggle-label-group">
            <div class="toggle-title">Durée indéfinie</div>
            <div class="toggle-sub">Pas de date de fin prévue</div>
          </div>
          <label class="switch">
            <input type="checkbox" id="indefiniteToggle" checked>
            <span class="switch-track"></span>
          </label>
        </div>
        <div class="end-date-field hidden" id="endDateField">
          <label class="field-label" for="endDate">Date de fin</label>
          <input type="date" id="endDate" name="endDate" class="text-input">
        </div>
      </div>

      <div class="preview" id="previewBox">
        Renseignez le montant, le jour et la date de début pour voir un résumé.
      </div>

      <div class="submit-row">
        <button type="submit" class="btn-primary">
          Enregistrer la règle
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="20 6 9 17 4 12"/>
          </svg>
        </button>
      </div>
    </form>
  </div>
</div>

<script>
  const accountName = '${accountName}';
  const freqMonthly = document.getElementById('freqMonthly');
  const freqQuarterly = document.getElementById('freqQuarterly');
  const frequencyInput = document.getElementById('frequencyInput');
  const dayFieldLabel = document.getElementById('dayFieldLabel');
  const dayFieldHint = document.getElementById('dayFieldHint');
  const dayInput = document.getElementById('dayInput');
  const previewBox = document.getElementById('previewBox');
  const startDateInput = document.getElementById('startDate');
  const endDateInput = document.getElementById('endDate');
  const indefiniteToggle = document.getElementById('indefiniteToggle');
  const endDateField = document.getElementById('endDateField');

  let selectedFreq = 'MONTHLY';
  let selectedDay = null;

  const monthsFr = ['janvier','février','mars','avril','mai','juin','juillet','août','septembre','octobre','novembre','décembre'];
  function formatDateFr(s) {
    if (!s) return '';
    const [y, m, d] = s.split('-').map(Number);
    return d + ' ' + monthsFr[m - 1] + ' ' + y;
  }

  function updatePreview() {
    const amount = document.getElementById('amount').value.trim();
    const start = formatDateFr(startDateInput.value);
    if (!amount || !selectedDay || !start) { previewBox.innerHTML = 'Renseignez le montant, le jour et la date de début pour voir un résumé.'; return; }
    const freqText = selectedFreq === 'QUARTERLY' ? 'tous les 3 mois, le' : 'tous les mois, le';
    let text = '<strong>' + accountName + '</strong> — ' + freqText + ' <strong>' + selectedDay + '</strong>, <strong>' + amount + ' €</strong>, à partir du <strong>' + start + '</strong>';
    if (indefiniteToggle.checked) { text += ', sans date de fin.'; }
    else if (endDateInput.value) { text += " jusqu'au <strong>" + formatDateFr(endDateInput.value) + '</strong>.'; }
    else { text += '.'; }
    previewBox.innerHTML = text;
  }

  function selectFreq(freq) {
    selectedFreq = freq;
    frequencyInput.value = freq;
    freqMonthly.classList.toggle('selected', freq === 'MONTHLY');
    freqMonthly.setAttribute('aria-checked', String(freq === 'MONTHLY'));
    freqQuarterly.classList.toggle('selected', freq === 'QUARTERLY');
    freqQuarterly.setAttribute('aria-checked', String(freq === 'QUARTERLY'));
    if (freq === 'QUARTERLY') {
      dayFieldLabel.textContent = 'Jour du mois (tous les 3 mois)';
      dayFieldHint.textContent = 'Le cycle se répète tous les 3 mois à partir de la date de début.';
    } else {
      dayFieldLabel.textContent = 'Jour du mois';
      dayFieldHint.textContent = "Pour les mois plus courts, l'opération sera attendue au dernier jour du mois.";
    }
    updatePreview();
  }

  freqMonthly.addEventListener('click', () => selectFreq('MONTHLY'));
  freqQuarterly.addEventListener('click', () => selectFreq('QUARTERLY'));

  document.querySelectorAll('.day-cell').forEach(cell => {
    cell.addEventListener('click', () => {
      document.querySelectorAll('.day-cell').forEach(c => c.classList.remove('selected'));
      cell.classList.add('selected');
      selectedDay = cell.dataset.day;
      dayInput.value = selectedDay;
      updatePreview();
    });
  });

  indefiniteToggle.addEventListener('change', () => {
    endDateField.classList.toggle('hidden', indefiniteToggle.checked);
    updatePreview();
  });

  document.getElementById('amount').addEventListener('input', updatePreview);
  startDateInput.addEventListener('change', updatePreview);
  endDateInput.addEventListener('change', updatePreview);
</script>

</body>
</html>