import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "timer" ]

  connect() {
    this.countdown = 5
    this.timer = setInterval(() => this.updateTimer(), 1000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  updateTimer() {
    this.countdown -= 1
    this.timerTarget.innerText = this.countdown
    if (this.countdown == 0) {
      window.location.href = "/posts"
    }
  }
}
