import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    deletePath: String,
    name: String
  }

  connect() {
    this.deleteForm = document.getElementById('confirmDeleteButton');
    this.deleteGalleryName = document.getElementById('deleteGalleryName');
  }

  delete() {
    this.deleteForm.setAttribute("action", this.deletePathValue);
    this.deleteGalleryName.innerText = this.nameValue;
  }

}
