import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "likersDropup" ]

  displayDropup() {
    if (this.hasLikersDropupTarget) {
      this.likersDropupTarget.style.display = "flex";
    }
  }

  hideDropup() {
    if (this.hasLikersDropupTarget) {
      this.likersDropupTarget.style.display = "none";
    }
  }
}
