import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ['window'];
  static classes = ['hidden'];

  connect() {
    console.log('connected!');
  }

  open() {
    this.windowTarget.classList.toggle(this.hiddenClass);
  }

  close() {
    this.windowTarget.classList.toggle(this.hiddenClass);
  }
}
