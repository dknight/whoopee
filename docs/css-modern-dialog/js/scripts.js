import {createFocusTrap, destroyFocusTrap} from './focus-trap.js';

const closeButton = document.getElementById('close-dialog-btn');
const dialog = document.getElementById('my-dialog');
const trapSwitch = document.getElementById('focus-trap-switch');
const escapeSwitch = document.getElementById('disable-escape-switch');
const closeSwitch = document.getElementById('disable-close-switch');
trapSwitch.addEventListener('change', (e) => {
  if (e.target.checked) {
    createFocusTrap(dialog);
  } else {
    destroyFocusTrap(dialog);
  }
});
closeSwitch.addEventListener('change', (e) => {
  closeButton.disabled = e.target.checked;
});

const closeHandler = (event) => {
  dialog.classList.add('-closing');
  const closeClosure = () => {
    dialog.classList.remove('-closing');
    dialog.close();
  };
  const anims = dialog.getAnimations();
  // if (anims.length === 0) {
  // closeClosure();
  // }
  Promise.all(anims.map((a) => a.finished))
    .then(closeClosure)
    .catch(closeClosure);
};

dialog.addEventListener('cancel', (e) => {
  if (escapeSwitch.checked) {
    return;
  }
  e.preventDefault();
  closeHandler(e.target);
});
closeButton.addEventListener('click', (e) => {
  closeHandler(dialog);
});
// dialog.addEventListener('close', (e) => {
// e.preventDefault();
// closeHandler(e.target);
// });
