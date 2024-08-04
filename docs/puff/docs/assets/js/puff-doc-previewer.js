export class PuffDocPreviewer extends HTMLElement {
  constructor() {
    super();
  }

  /**
   * Very dirty formattter.
   * @param {HTMLElement} elem
   */
  formatHTML(elem) {
    elem.childNodes?.forEach((node) => {
      let lines = node.textContent.split(/\r?\n/);
      lines = lines.filter(
        (line, index) =>
          !((index === 0 || index === lines.length - 1) && line.trim() === '')
      );
      const minStartPosition =
        lines.length === 0
          ? 0
          : Math.min.apply(
              null,
              lines.map((line) => {
                let pos = line.search(/\S/);
                if (pos === -1) {
                  pos = 200;
                }
                return pos;
              })
            );
      const text = lines
        .map((line) => line.substring(minStartPosition))
        .join('\n');
      if (text === '') {
        pre.removeChild(node);
      } else {
        node.textContent = text;
      }
    });
  }

  connectedCallback() {
    const code = document.createElement('code');
    code.textContent = this.innerHTML;

    const pre = document.createElement('pre');
    pre.append(code);

    const details = document.createElement('details');
    details.classList.add('p2');
    const summary = document.createElement('summary');
    summary.textContent = 'Show code';
    details.append(summary, pre);

    this.formatHTML(code);
    this.append(details);
  }
}

customElements.define('puff-doc-previewer', PuffDocPreviewer);
