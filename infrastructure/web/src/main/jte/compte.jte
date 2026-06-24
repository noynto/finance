@import java.util.List
@import java.util.Map
@param String accountName
@param String accountInitial
@param String accountGradient
@param String totalWhole
@param String totalDecimal
@param boolean totalPositive
@param boolean hasRecurrent
@param String compteId
@param long operationCount
@param List<Map<String, Object>> operations
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<title>Compte · ${accountName}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<script src="https://unpkg.com/htmx.org@2.0.4/dist/htmx.min.js"></script>
<style>
  :root {
    --bg: #2d353b; --bg-elevated: #343f44; --bg-elevated-2: #3d484d; --bg-hover: #475258; --border: #475258;
    --fg: #d3c6aa; --fg-dim: #9da9a0; --fg-faint: #7a8478;
    --accent: #a7c080; --accent-soft: rgba(167,192,128,0.12); --accent-glow: rgba(167,192,128,0.16);
    --info: #7fbbb3; --info-soft: rgba(127,187,179,0.12);
    --positive: #a7c080; --positive-soft: rgba(167,192,128,0.1);
    --negative: #e67e80; --negative-soft: rgba(230,126,128,0.1);
    --font-display: 'Space Grotesk', sans-serif; --font-body: 'Inter', sans-serif; --font-mono: 'JetBrains Mono', monospace;
  }
  * { box-sizing: border-box; margin: 0; padding: 0; -webkit-tap-highlight-color: transparent; }
  html { -webkit-text-size-adjust: 100%; }
  body { background: var(--bg); color: var(--fg); font-family: var(--font-body); min-height: 100vh; padding: 16px 12px 48px; }
  .page { max-width: 640px; margin: 0 auto; }
  .topbar { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; margin-left: -8px; }
  .back-link { display: inline-flex; align-items: center; gap: 7px; font-size: 14px; font-weight: 500; color: var(--fg-dim); text-decoration: none; padding: 10px 14px 10px 8px; border-radius: 8px; min-height: 40px; transition: background 0.15s ease, color 0.15s ease; }
  .back-link:hover, .back-link:active { background: var(--bg-elevated); color: var(--fg); }
  .back-link:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px; }
  .icon-btn { display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 8px; color: var(--fg-faint); background: none; border: none; cursor: pointer; transition: background 0.15s ease, color 0.15s ease; margin-right: -6px; }
  .icon-btn:hover { background: var(--bg-elevated); color: var(--fg); }
  .icon-btn:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px; }
  .account-header { padding: 4px 4px 24px; }
  .account-identity { display: flex; align-items: center; gap: 14px; margin-bottom: 24px; }
  .account-avatar { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-family: var(--font-display); font-weight: 700; font-size: 18px; color: #fff; flex-shrink: 0; }
  .account-name-block { min-width: 0; }
  .account-name { font-family: var(--font-display); font-size: 21px; font-weight: 600; letter-spacing: -0.01em; color: var(--fg); line-height: 1.2; }
  .account-tag { display: inline-flex; align-items: center; gap: 5px; margin-top: 5px; font-family: var(--font-mono); font-size: 11px; color: var(--fg-faint); text-transform: uppercase; letter-spacing: 0.04em; }
  .total-block { padding: 20px 0 0; border-top: 1px solid var(--border); }
  .total-label { font-size: 12px; color: var(--fg-faint); margin-bottom: 6px; }
  .total-amount { font-family: var(--font-mono); font-weight: 500; font-variant-numeric: tabular-nums; font-size: clamp(30px,8vw,38px); letter-spacing: -0.01em; }
  .total-amount.positive { color: var(--positive); }
  .total-amount.negative { color: var(--negative); }
  .total-amount .decimals { opacity: 0.65; }
  .recurrent-card { margin-top: 16px; display: flex; align-items: center; gap: 12px; padding: 13px 14px; background: var(--info-soft); border: 1px solid rgba(127,187,179,0.3); border-radius: 10px; }
  .recurrent-icon { width: 32px; height: 32px; border-radius: 8px; background: rgba(127,187,179,0.18); color: var(--info); display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
  .recurrent-text { flex: 1; min-width: 0; }
  .recurrent-title { font-size: 13px; font-weight: 600; color: var(--fg); }
  .recurrent-sub { font-size: 12px; color: var(--fg-faint); margin-top: 1px; }
  .recurrent-btn { flex-shrink: 0; font-family: var(--font-body); font-size: 12.5px; font-weight: 600; color: var(--info); background: var(--bg-elevated); border: 1px solid rgba(127,187,179,0.35); padding: 8px 12px; border-radius: 7px; cursor: pointer; white-space: nowrap; text-decoration: none; display: inline-flex; align-items: center; transition: background 0.15s ease; }
  .recurrent-btn:hover { background: var(--bg-hover); }
  .recurrent-btn:focus-visible { outline: 2px solid var(--info); outline-offset: 2px; }
  .section-header { display: flex; align-items: baseline; justify-content: space-between; padding: 0 4px; margin-bottom: 10px; }
  .section-title { font-family: var(--font-display); font-size: 13.5px; font-weight: 600; color: var(--fg); }
  .section-count { font-family: var(--font-mono); font-size: 12px; color: var(--fg-faint); }
  .op-list { background: var(--bg-elevated); border: 1px solid var(--border); border-radius: 12px; overflow: hidden; }
  .op-row { display: flex; align-items: center; gap: 12px; padding: 13px 14px; min-height: 44px; border-bottom: 1px solid rgba(71,82,88,0.5); transition: background 0.12s ease; }
  .op-row:last-child { border-bottom: none; }
  .op-row:active { background: var(--bg-elevated-2); }
  .op-date { font-family: var(--font-mono); font-size: 11.5px; color: var(--fg-faint); width: 56px; flex-shrink: 0; line-height: 1.3; }
  .op-date .month { display: block; text-transform: uppercase; letter-spacing: 0.03em; font-size: 10px; }
  .op-date .day { display: block; font-size: 14px; color: var(--fg-dim); font-weight: 500; }
  .op-label { flex: 1; min-width: 0; font-size: 14px; font-weight: 450; color: var(--fg); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .op-amount { font-family: var(--font-mono); font-size: 13.5px; font-weight: 500; font-variant-numeric: tabular-nums; flex-shrink: 0; }
  .op-amount.positive { color: var(--positive); }
  .op-amount.negative { color: var(--negative); }
  .empty-hint { padding: 28px 16px; text-align: center; color: var(--fg-faint); font-size: 13px; }
  @media (min-width: 480px) {
    body { padding: 24px 16px 60px; } .topbar { margin-bottom: 28px; }
    .account-avatar { width: 56px; height: 56px; font-size: 20px; border-radius: 14px; }
    .account-name { font-size: 24px; } .op-date { width: 64px; }
  }
</style>
</head>
<body>

<div class="page">
  <div class="topbar">
    <a href="/" class="back-link">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
      </svg>
      Tableau de bord
    </a>
    <button class="icon-btn" aria-label="Options du compte">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="12" r="1"/><circle cx="12" cy="5" r="1"/><circle cx="12" cy="19" r="1"/>
      </svg>
    </button>
  </div>

  <div class="account-header">
    <div class="account-identity">
      <div class="account-avatar" style="background:${accountGradient}">${accountInitial}</div>
      <div class="account-name-block">
        <div class="account-name">${accountName}</div>
        <div class="account-tag">
          <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="3" width="18" height="18" rx="3"/>
          </svg>
          Compte
        </div>
      </div>
    </div>

    <div class="total-block">
      <div class="total-label">Total des opérations rattachées</div>
      <div class="total-amount ${totalPositive ? "positive" : "negative"}">
        <span>${totalWhole}</span><span class="decimals">${totalDecimal}</span> €
      </div>
    </div>

    <div class="recurrent-card">
      <div class="recurrent-icon">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M21 2v6h-6"/><path d="M3 12a9 9 0 0 1 15-6.7L21 8"/><path d="M3 22v-6h6"/><path d="M21 12a9 9 0 0 1-15 6.7L3 16"/>
        </svg>
      </div>
      @if(hasRecurrent)
      <div class="recurrent-text">
        <div class="recurrent-title">Règle récurrente active</div>
        <div class="recurrent-sub">Voir les échéances et ajuster</div>
      </div>
      <a href="/comptes/${compteId}/calendaire" class="recurrent-btn">Voir</a>
      @else
      <div class="recurrent-text">
        <div class="recurrent-title">Aucune règle récurrente</div>
        <div class="recurrent-sub">Définissez un montant et une périodicité</div>
      </div>
      <a href="/comptes/${compteId}/recurrent/new" class="recurrent-btn">+ Ajouter</a>
      @endif
    </div>
  </div>

  <div class="section-header">
    <span class="section-title">Opérations rattachées</span>
    <span class="section-count">${operationCount}</span>
  </div>

  <div class="op-list">
    @if(operations.isEmpty())
    <div class="empty-hint">Aucune opération rattachée à ce compte.</div>
    @else
    @for(var op : operations)
    <div class="op-row">
      <div class="op-date">
        <span class="month">${(String) op.get("monthAbbr")}</span>
        <span class="day">${(String) op.get("day")}</span>
      </div>
      <div class="op-label">${(String) op.get("label")}</div>
      <div class="op-amount ${(Boolean) op.get("positive") ? "positive" : "negative"}">${(String) op.get("amount")}</div>
    </div>
    @endfor
    @endif
  </div>
</div>

</body>
</html>