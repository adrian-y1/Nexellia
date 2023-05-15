import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "dropdown" ]

  toggle() {
    this.dropdownTarget.classList.toggle("dropdown-display")
    
    if (this.dropdownTarget.classList.contains("dropdown-display")) {
      // Add event listener to hide dropdown when clicking outside
      window.addEventListener("click", this.handleOutsideClick.bind(this));
    } else {
      // Remove event listener when dropdown is hidden
      window.removeEventListener("click", this.handleOutsideClick.bind(this));
    }
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.dropdownTarget.classList.remove("dropdown-display");
      window.removeEventListener("click", this.handleOutsideClick.bind(this));
    }
  }

}