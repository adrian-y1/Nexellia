import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open() {
    this.modalTarget.style.display = "flex"
    document.body.classList.add('modal-open');
  }

  // Closes the modal if the form was successfully submitted
  close() {
    this.modalTarget.style.display = "none"
    document.body.classList.remove('modal-open');
  }
}