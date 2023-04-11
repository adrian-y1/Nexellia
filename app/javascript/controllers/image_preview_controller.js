import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "newPicture", "newPictureContainer" ]

  connect() {
    this.newPictureContainerTarget.style.display = 'none'
  }

  preview() {
    const fileField = document.querySelector('input[data-action="change->image-preview#preview"]')
    const file = fileField.files[0]
    if (file) {
      this.newPictureTarget.src = URL.createObjectURL(file)
      this.newPictureContainerTarget.style.display = 'block'
    }
  }
}