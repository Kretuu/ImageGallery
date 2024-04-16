//= require dropzone
import { Controller } from "@hotwired/stimulus";

Dropzone.autoDiscover = false;

export default class extends Controller {
    static values = {
        photoGalleryId: String
    }
    connect() {
        const dropzoneConfig = {
            url: this.url,
            method: "post",
            clickable: true,
            paramName: "original_photo",
            maxFilesize: 256,
            previewTemplate: document.querySelector('#dropzoneContainer').innerHTML,
            parallelUploads: "1",
            addRemoveLinks: true,
            autoProcessQueue: false,
            acceptedFiles: ".jpg, .jpeg, .png",
            thumbnailWidth: null,
            thumbnailHeight: null,
            maxFiles: 1,
            headers: {
                "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
            },
        };

        this.dropzone = new Dropzone(this.element, dropzoneConfig);
    }

    get url() {
        return `/posts/${this.photoGalleryIdValue}`;
    }
}