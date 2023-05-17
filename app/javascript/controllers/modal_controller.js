import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ['window']
  static classes = ['hidden']

  open() {
    this.windowTarget.classList.remove(this.hiddenClass)
  }

  close() {
    this.windowTarget.classList.add(this.hiddenClass)
  }
}
