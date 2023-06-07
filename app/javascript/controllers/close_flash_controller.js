import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('animationend', this.handleAnimationEnd.bind(this));
  }

  close() {
    this.element.remove()
  }

  handleAnimationEnd() {
    this.element.remove();
  }
}