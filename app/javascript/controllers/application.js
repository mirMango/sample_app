import { Application } from "@hotwired/stimulus";
import 'bootstrap';
import "jquery";
import "popper.js";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };

document.addEventListener('turbolinks:load', () => {
  $('[data-toggle="dropdown"]').dropdown();
});
