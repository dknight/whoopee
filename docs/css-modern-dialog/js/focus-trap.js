/**
 * This is very simple focus lock and does not handle
 * edge cases. Quickly create just for demo.
 */

const focusableElements = [
  'input:not(:disabled)',
  'select:not(:disabled)',
  'textarea:not(:disabled)',
  'button:not(:disabled)',
  'a[href]',
  '[contenteditable]',
].join(',');

/**
 * @param {KeyboardEvent} e
 */
const focusHandler = (e) => {
  const dialog = e.target.closest('dialog');
  if (!dialog) {
    console.error('parent is not dialog');
    return;
  }
  const elems = dialog.querySelectorAll(focusableElements);
  const first = elems[0];
  const last = elems[elems.length-1];
  if (e.key === 'Tab') {
    if (document.activeElement === first && e.shiftKey) {
      e.preventDefault();
      last.focus();
    }
    if (document.activeElement === last && !e.shiftKey) {
      e.preventDefault();
      first.focus();
    }
  }
};

/**
 * @param {HTMLDialogElement} dialog 
 */
const createFocusTrap = (dialog) => {
  dialog.addEventListener('keydown', focusHandler)
};

/**
 * @param {HTMLDialogElement} dialog 
 */
const destroyFocusTrap = (dialog) => {
  dialog.removeEventListener('keydown', focusHandler);
};

export {
  createFocusTrap,
  destroyFocusTrap,
};