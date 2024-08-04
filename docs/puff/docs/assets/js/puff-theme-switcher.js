class PuffThemeSwitcher extends HTMLElement {
  constructor() {
    super();
    this.documentRoot = document.documentElement;
    this.attachShadow({mode: 'open'});
  }

  /**
   * @returns {HTMLStyleElement}
   */
  renderStyles() {
    const css = `
    :host {
      display: inline-block;
    }
    button {
      align-items: center;
      border-radius: 99px;
      border: 0;
      color: var(--c-txt);
      cursor: pointer;
      display: flex;
      padding: 11px;
      background: transparent !important;
    }
    .label {
      display: none;
    }
    @media (prefers-color-scheme: dark) {
      button {
        background: #111;
      }
    }
    button[value=dark] .icon {
      -webkit-mask: url(assets/img/moon.svg) no-repeat left;
      mask: url(assets/img/moon.svg) no-repeat left;
    }
    button[value=light] .icon {
      -webkit-mask: url(assets/img/sun.svg) no-repeat left;
      mask: url(assets/img/sun.svg) no-repeat left;
    }
    .icon {
      display: inline-block;
      background-color: var(--c-txt);
      width: 1.5rem;
      aspect-ratio: 1 / 1;
    }
    @media screen and (max-width: 60rem) {
      button {
        padding: .5rem;
      }
      .icon {
        margin-right: 0;
      }
    }`;
    const styles = document.createElement('style');
    styles.textContent = css;
    return styles;
  }

  /**
   * @type {Record<string, string>}
   */
  static get Themes() {
    return {
      DARK: 'dark',
      LIGHT: 'light',
    };
  }

  /**
   * @type {string}
   */
  static get StorageKey() {
    return 'puff-theme';
  }

  /**
   * @param {string} theme
   */
  saveTheme(theme) {
    if (!window.localStorage) {
      return;
    }
    window.localStorage.setItem(this.constructor.StorageKey, theme);
  }

  /**
   * @returns {boolean}
   */
  isDark() {
    const isForced = !!this.documentRoot.dataset.theme;
    if (!isForced) {
      return window.matchMedia('((prefers-color-scheme: dark)').matches;
    }
    return this.documentRoot.dataset.theme === this.constructor.Themes.DARK;
  }

  /**
   * @returns {string}
   */
  getThemePreference() {
    const theme = this.loadTheme();
    if (theme) {
      return theme;
    } else {
      return window.matchMedia('(prefers-color-scheme: dark)').matches
        ? this.constructor.Themes.DARK
        : this.constructor.Themes.LIGHT;
    }
  }

  /**
   * @returns {string | null}
   */
  loadTheme() {
    if (!window.localStorage) {
      return;
    }
    return window.localStorage.getItem(this.constructor.StorageKey);
  }

  /**
   * @param {string} theme
   */
  setTheme(theme) {
    this.documentRoot.dataset.theme = theme;
    this.saveTheme(theme);
  }

  /**
   * @returns {HTMLButtonElement}}
   */
  renderButton(theme) {
    const text = theme === this.constructor.Themes.DARK ? 'Dark' : 'Light';
    const tpl = `<button type="button" value="${theme}" aria-label="${text}">
      <span class="icon"></span>
    </button>`;

    this.shadowRoot.innerHTML = tpl;
    const button = this.shadowRoot.querySelector('button');
    return button;
  }

  connectedCallback() {
    this.innerHTML = '';
    const theme = this.getThemePreference();
    this.setTheme(theme);
    const styles = this.renderStyles();

    const button = this.renderButton(theme);
    button.addEventListener('click', (e) => {
      const dark = this.constructor.Themes.DARK;
      const light = this.constructor.Themes.LIGHT;
      const value = button.value;
      button.value = value === dark ? light : dark;
      button.ariaLabel = value === dark ? 'Light' : 'Dark';
      this.setTheme(button.value);
    });
    this.shadowRoot.prepend(styles, button);
  }
}

customElements.define('puff-theme-switcher', PuffThemeSwitcher);
