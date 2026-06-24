@import java.util.List
@import java.util.Map
@param String accountName
@param String accountInitial
@param String accountGradient
@param String compteId
@param String ruleSummary
@param List<Map<String, Object>> yearGroups
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<title>Calendaire · ${accountName}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<script src="https://unpkg.com/htmx.org@2.0.4/dist/htmx.min.js"></script>
<style>
  :root {
    --bg: #2d353b; --bg-elevated: #343f44; --bg-elevated-2: #3d484d; --bg-hover: #475258;
    --border: #475258; --border-strong: #56635f;
    --fg: #d3c6aa; --fg-dim: #9da9a0; --fg-faint: #7a8478;
    --accent: #a7c080; --accent-soft: rgba(167,192,128,0.12);
    --info: #7fbbb3; --info-soft: rgba(127,187,179,0.12);
    --warn: #dbbc7f; --warn-soft: rgba(219,188,127,0.12);
    --positive: #a7c080; --negative: #e67e80;
    --font-display: 'Space Grotesk', sans-serif; --font-body: 'Inter', sans-serif; --font-mono: 'JetBrains Mono', monospace;
    --radius-sm: 6px; --radius: 10px; --radius-lg: 16px;
  }
  * { box-sizing: border-box; margin: 0; padding: 0; -webkit-tap-highlight-color: transparent; }
  html { -webkit-text-size-adjust: 100%; }
  body { background: var(--bg); color: var(--fg); font-family: var(--font-body); min-height: 100vh; padding: 16px 12px 48px; }
  .page { max-width: 600px; margin: 0 auto; }
  .topbar { display: flex; align-items: center; margin-bottom: 20px; margin-left: -8px; }
  .back-link { display: inline-flex; align-items: center; gap: 7px; font-size: 14px; font-weight: 500; color: var(--fg-dim); text-decoration: none; padding: 10px 14px 10px 8px; border-radius: 8px; min-height: 40px; transition: background 0.15s ease, color 0.15s ease; }
  .back-link:hover, .back-link:active { background: var(--bg-elevated); color: var(--fg); }
  .back-link:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px; }
  .header { margin-bottom: 20px; padding: 0 4px; }
  .eyebrow { font-family: var(--font-mono); font-size: 11.5px; color: var(--fg-faint); letter-spacing: 0.08em; text-transform: uppercase; display: flex; align-items: center; gap: 8px; margin-bottom: 8px; }
  .eyebrow::before { content: ""; width: 6px; height: 6px; border-radius: 50%; background: var(--info); flex-shrink: 0; }
  .account-chip { display: flex; align-items: center; gap: 10px; margin-bottom: 14px; }
  .account-avatar { width: 30px; height: 30px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-family: var(--font-display); font-weight: 700; font-size: 12px; color: #fff; flex-shrink: 0; }
  .account-chip-name { font-size: 13.5px; font-weight: 600; color: var(--fg-dim); }
  h1 { font-family: var(--font-display); font-size: 22px; font-weight: 600; letter-spacing: -0.01em; margin-bottom: 6px; }
  .subtitle { font-size: 13.5px; color: var(--fg-dim); line-height: 1.5; }
  .rule-summary { margin-top: 14px; padding: 11px 14px; background: var(--info-soft); border: 1px solid rgba(127,187,179,0.3); border-radius: 10px; font-size: 12.5px; color: var(--fg-dim); display: flex; align-items: center; gap: 9px; }
  .rule-summary svg { color: var(--info); flex-shrink: 0; }
  .rule-summary strong { color: var(--info); font-weight: 600; }
  .year-group { margin-top: 24px; }
  .year-header { display: flex; align-items: center; gap: 10px; padding: 0 4px; margin-bottom: 10px; }
  .year-label { font-family: var(--font-display); font-size: 13px; font-weight: 600; color: var(--fg-faint); }
  .year-line { flex: 1; height: 1px; background: var(--border); }
  .occ-list { background: var(--bg-elevated); border: 1px solid var(--border); border-radius: 12px; overflow: hidden; }
  .occ-row { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-bottom: 1px solid rgba(71,82,88,0.5); }
  .occ-row:last-child { border-bottom: none; }
  .occ-status { width: 7px; height: 7px; border-radius: 50%; flex-shrink: 0; }
  .occ-status.matched { background: var(--positive); }
  .occ-status.pending { background: var(--warn); }
  .occ-status.future { background: var(--border-strong); }
  .occ-date-input { font-family: var(--font-mono); font-size: 13px; color: var(--fg-dim); background: var(--bg-elevated-2); border: 1.5px solid var(--border); border-radius: 7px; padding: 8px 9px; width: 134px; flex-shrink: 0; outline: none; transition: border-color 0.15s ease; color-scheme: dark; }
  .occ-date-input:focus { border-color: var(--accent); }
  .occ-label { flex: 1; min-width: 0; font-size: 12.5px; color: var(--fg-faint); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .occ-amount-wrap { position: relative; flex-shrink: 0; }
  .occ-amount-input { font-family: var(--font-mono); font-variant-numeric: tabular-nums; font-size: 13.5px; font-weight: 500; color: var(--fg); background: var(--bg-elevated-2); border: 1.5px solid var(--border); border-radius: 7px; padding: 8px 24px 8px 10px; width: 92px; text-align: right; outline: none; transition: border-color 0.15s ease, background 0.15s ease; }
  .occ-amount-input:focus { border-color: var(--accent); background: var(--bg-elevated); }
  .occ-amount-input.edited { border-color: var(--warn); }
  .occ-amount-suffix { position: absolute; right: 9px; top: 50%; transform: translateY(-50%); font-size: 12px; color: var(--fg-faint); pointer-events: none; }
  .occ-row.future .occ-date-input, .occ-row.future .occ-amount-input { opacity: 0.55; }
  .legend { display: flex; gap: 16px; flex-wrap: wrap; margin-top: 16px; padding: 0 4px; }
  .legend-item { display: flex; align-items: center; gap: 6px; font-size: 11.5px; color: var(--fg-faint); }
  .legend-dot { width: 7px; height: 7px; border-radius: 50%; }
  @media (min-width: 480px) { body { padding: 24px 16px 60px; } .topbar { margin-bottom: 28px; } h1 { font-size: 24px; } .occ-row { padding: 11px 14px; gap: 14px; } .occ-date-input { width: 150px; } }
  @media (max-width: 400px) { .occ-label { display: none; } }
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
    <div class="eyebrow">Calendaire</div>
    <div class="account-chip">
      <div class="account-avatar" style="background:${accountGradient}">${accountInitial}</div>
      <span class="account-chip-name">${accountName}</span>
    </div>
    <h1>Échéances</h1>
    <p class="subtitle">Ajustez la date ou le montant d'une échéance précise si elle diffère de la règle.</p>

    <div class="rule-summary">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 2v6h-6"/><path d="M3 12a9 9 0 0 1 15-6.7L21 8"/><path d="M3 22v-6h6"/><path d="M21 12a9 9 0 0 1-15 6.7L3 16"/>
      </svg>
      Règle : <strong>${ruleSummary}</strong>
    </div>
  </div>

  @for(var yearGroup : yearGroups)
  <div class="year-group">
    <div class="year-header">
      <span class="year-label">${(String) yearGroup.get("year")}</span>
      <div class="year-line"></div>
    </div>
    <div class="occ-list">
      @for(var occ : (List<Map<String, Object>>) yearGroup.get("occurrences"))
      <form method="post" action="/comptes/${compteId}/calendaire/${(String) occ.get("id")}" class="occ-row ${(String) occ.get("status")}">
        <span class="occ-status ${(String) occ.get("status")}"></span>
        <input type="date" class="occ-date-input" name="date" value="${(String) occ.get("dateValue")}">
        <span class="occ-label">${(String) occ.get("label")}</span>
        <div class="occ-amount-wrap">
          <input type="text" class="occ-amount-input ${(Boolean) occ.get("edited") ? "edited" : ""}" name="amount" value="${(String) occ.get("amount")}" data-rule-amount="${(String) occ.get("ruleAmount")}">
          <span class="occ-amount-suffix">€</span>
        </div>
      </form>
      @endfor
    </div>
  </div>
  @endfor

  <div class="legend">
    <div class="legend-item"><span class="legend-dot" style="background:var(--positive);"></span> Rapprochée</div>
    <div class="legend-item"><span class="legend-dot" style="background:var(--warn);"></span> En attente</div>
    <div class="legend-item"><span class="legend-dot" style="background:var(--border-strong);"></span> À venir</div>
  </div>
</div>

<script>
  document.querySelectorAll('.occ-amount-input').forEach(input => {
    const ruleAmount = input.dataset.ruleAmount;
    input.addEventListener('input', () => {
      input.classList.toggle('edited', input.value.trim() !== ruleAmount);
    });
  });
</script>

</body>
</html>