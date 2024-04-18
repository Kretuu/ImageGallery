import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    path: String
  }

  connect() {
    this.container = document.getElementById('cropping-container');
    this.confirmDelete = document.getElementById('confirmDeleteButton');
  }

  setPath() {
    this.container.setAttribute('data-cropping-photo-path-value', this.pathValue)
    this.dispatch('setPath')
  }

  delete() {
    this.confirmDelete.setAttribute('action', this.pathValue)
  }

}
