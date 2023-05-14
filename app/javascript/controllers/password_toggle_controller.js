import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "togglePassword", "passwordField" ]

  toggle() {
    if (this.togglePasswordTarget.classList.contains("bi-eye-fill")) {
      this.togglePasswordTarget.classList.replace("bi-eye-fill", "bi-eye-slash-fill")
    } else {
      this.togglePasswordTarget.classList.replace("bi-eye-slash-fill", "bi-eye-fill")
    }

    this.changeType()
  }

  changeType() {
    const type = this.passwordFieldTarget.getAttribute("type") === "password" ? "text" : "password"
    this.passwordFieldTarget.setAttribute("type", type)
  }
}