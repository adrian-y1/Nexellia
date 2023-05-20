import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open() {
    this.modalTarget.style.display = "flex"
  }

  // Closes the modal if the form was successfully submitted
  close() {
    this.modalTarget.style.display = "none"
  }
}