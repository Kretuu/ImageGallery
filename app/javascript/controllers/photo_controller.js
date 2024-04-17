import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    path: String
  }

  connect() {
    this.container = document.getElementById('cropping-container');
  }

  setPath() {
    this.container.setAttribute("data-cropping-photo-path-value", this.pathValue)
    this.dispatch("setPath")
  }

}
