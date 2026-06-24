tailwind.config = {
  safelist: ['hidden', 'text-ef-accent', 'opacity-100'],
  theme: {
    extend: {
      colors: {
        ef: {
          bg:           '#2d353b',
          card:         '#343f44',
          input:        '#3d484d',
          hover:        '#475258',
          border:       '#475258',
          fg:           '#d3c6aa',
          dim:          '#9da9a0',
          faint:        '#7a8478',
          accent:       '#a7c080',
          'accent-soft':'rgba(167,192,128,0.18)',
          'accent-str': '#8fad6f',
          'accent-hover':'#8fad6f',
          error:        '#e67e80',
          'error-soft': 'rgba(230,126,128,0.10)',
        }
      },
      fontFamily: {
        display: ['"Space Grotesk"', 'sans-serif'],
        body:    ['"Inter"', 'sans-serif'],
        mono:    ['"JetBrains Mono"', 'monospace'],
      },
      keyframes: {
        breathe: {
          '0%, 100%': { opacity: '0.6', transform: 'translate(-50%, -50%) scale(1)' },
          '50%':      { opacity: '1',   transform: 'translate(-50%, -50%) scale(1.06)' },
        },
        fadeUp: {
          'from': { opacity: '0', transform: 'translateY(8px)' },
          'to':   { opacity: '1', transform: 'translateY(0)' },
        },
      },
      animation: {
        breathe: 'breathe 6s ease-in-out infinite',
      },
    }
  }
}