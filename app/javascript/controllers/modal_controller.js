import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Using Bootstrap's JavaScript library, this instantiates a new Modal object
    this.modal = new bootstrap.Modal(this.element)
  }

  open() {
    if (!this.modal.isOpened) {
      this.modal.show()
    }
  }

  // Closes the modal if the form was successfully submitted
  close(event) {
    if (event.detail.success) {
      this.modal.hide()
    }
  }
}