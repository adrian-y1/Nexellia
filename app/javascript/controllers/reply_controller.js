import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "replyForm" ]
  
  // Toggles the reply form using bootstrap's d-none class
  toggle(e) {
    e.preventDefault();
    this.replyFormTarget.classList.toggle("reply-form-display")
  }
}