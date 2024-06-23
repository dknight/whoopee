<!-- Description -->

tags: web

# HTML modern native dialog

Since the invention of the first browsers, there has been a requirement for
modal windows, dialogs and other floating elements. For about 30 years natively
worked only: `window.alert()`, `window.confirm()`, `window.prompt()`.
Everything looked like this:

![Old browser confirmation](/assets/img/web/firefox_confirm_dialog.png)
*Image from [https://developer.mozilla.org/en-US/docs/Web/API/Window/confirm](https://developer.mozilla.org/en-US/docs/Web/API/Window/confirm)*

Somewhere in the 2000th in the era of [PrototypeJS](http://prototypejs.org/)
and [jQuery](https://jquery.com/) there were LightBox, DarkBox, ModalBox plus
hundreds of bloated, low-performing, inaccessible implementations of dialogs.
The same trend of ugly modal windows continued in 2010--2020th in the era of
[React](https://react.dev/), [Angular](https://angular.dev/) and
[Vue](https://vuejs.org/).

![Lightbox Demo](/assets/img/web/lightbox.webp)
*Image from [https://learnersbucket.com/examples/interview/create-a-lightbox-modal-image-gallery-in-reactjs/](https://learnersbucket.com/examples/interview/create-a-lightbox-modal-image-gallery-in-reactjs)*

## Finally native solution

After 30 years browser implemented a new HTML element
[`<dialog>`](https://html.spec.whatwg.org/#the-dialog-element) which provides
out-of-box API for such cases as dialogs, modal windows, etc.

I created a [small demo](/css-modern-dialog/) with native dialog, which includes
the most usable pattern for the dialogs. Including backdrop effects, animations,
modality, styling, keyboard tricks and focus trap. Everything can be achieved
now with a few lines of HTML, CSS and JavaScript. No need for more bloated, ugly
3rd party plugins for this task.

![Native HTML dialog demo](/assets/img/web/dialog.png)

Also worth looking at [Popover API](https://developer.mozilla.org/en-US/docs/Web/API/Popover_API)
which works perfectly in tandem with `<dialog>`.

## References

- [Source code on Github](https://github.com/dknight/css-modern-dialog).
- [HTML5 Specification](https://html.spec.whatwg.org/#the-dialog-element)
- [MDN: Dialog Element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dialog)
- [MDN: Popover API](https://developer.mozilla.org/en-US/docs/Web/API/Popover_API)