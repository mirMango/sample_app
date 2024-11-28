import 'bootstrap';
import 'jquery';
import 'popper.js';
import { Application } from "@hotwired/stimulus";

const application = Application.start();

application.debug = false;
window.Stimulus = application;

export { application };

document.addEventListener('turbolinks:load', () => {
  $('[data-toggle="dropdown"]').dropdown();
});
