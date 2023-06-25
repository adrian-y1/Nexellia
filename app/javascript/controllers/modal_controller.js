import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    // Bind the handleOutsideClick function to the controller instance
    this.handleOutsideClick = this.handleOutsideClick.bind(this); 
  }

  open() {
    this.modalTarget.style.display = "flex"
    document.body.classList.add('modal-open');
    this.modalTarget.addEventListener("click", this.handleOutsideClick)
  }

  close() {
    this.modalTarget.style.display = "none"
    document.body.classList.remove('modal-open');
    this.modalTarget.removeEventListener("click", this.handleOutsideClick)
  }

  handleOutsideClick(event) {
    // Check if the clicked element has the "modal" class
    if (event.target.classList.contains("modal")) {
      this.close(); 
    }
  }
}
