import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "newPicture", "newPictureContainer" ]

  connect() {
    this.pictureContainerDisplay('none')
  }

  preview() {
    const fileField = this.element.querySelector('input[data-action="change->image-preview#preview"]')
    const file = fileField.files[0]
    if (file) {
      this.newPictureTarget.src = URL.createObjectURL(file)
      this.pictureContainerDisplay('flex')
    }
  }

  pictureContainerDisplay(display) {
    if (this.hasNewPictureContainerTarget) {
      this.newPictureContainerTarget.style.display = display
    }
  }
}