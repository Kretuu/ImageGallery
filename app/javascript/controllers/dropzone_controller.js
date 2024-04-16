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
            paramName: "original_image",
            maxFilesize: 256,
            previewTemplate: document.querySelector('#dropzoneContainer').innerHTML,
            parallelUploads: "1",
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
        this.uploadButton = document.getElementById("upload-button");
        this.alert = document.getElementById("upload-alert");
        this.uploadButtonListener = () => {
            if(this.uploadButton.innerText === "Upload") {
                this.dropzone.processQueue();
                this.uploadButton.disabled = true;
            } else {
                const imagePreview = this.imagePreviewElement;
                if(imagePreview) {
                    document.getElementById("editedImage").setAttribute("src", imagePreview.src);
                }
            }
        }

        this.registerDOMListeners();
        this.registerDropzoneListeners();
    }

    registerDOMListeners() {
        window.visualViewport.addEventListener("resize", (event) => {
            const element = this.imagePreviewElement;

            if(element) {
                document.querySelectorAll("#imageOverlay").forEach((el) => {
                    el.style.width = element.offsetWidth + "px";
                    el.style.left = (el.parentElement.offsetWidth - element.offsetWidth) / 2 + "px";
                });
            }
        });

        document.querySelectorAll(".close-upload").forEach((el) => {
            el.addEventListener("click", () => {
                this.dropzone.removeAllFiles();
                this.resetComponents();
            });
        });

        this.uploadButton.addEventListener("click", this.uploadButtonListener)
    }

    registerDropzoneListeners() {
        this.dropzone.on("addedfile", file => {
            var reader = new FileReader();
            reader.onload = function (e) {
                var img = new Image;
                img.onload = function() {
                    var aspectRatio = img.width / img.height;
                    document.querySelectorAll("#imageOverlay").forEach((el) => {
                        const width = aspectRatio * el.offsetHeight
                        el.style.width = width + "px";
                        el.style.left = (el.parentElement.offsetWidth - width) / 2 + "px";
                    });
                };
                img.src = reader.result;
            };
            reader.readAsDataURL(file);
        });

        this.dropzone.on("complete", file => {
            this.uploadButton.innerText = "Crop";
            this.uploadButton.setAttribute("data-bs-target","#cropImageModal");
            this.uploadButton.setAttribute("data-bs-toggle", "modal");
            this.uploadButton.disabled = false;
        });

        this.dropzone.on("processing", () => {
            document.querySelectorAll("#upload-progress").forEach((el) => {
                el.classList.remove("invisible");
            });
            document.querySelectorAll("#imageOverlay").forEach((el) => {
                el.classList.add("invisible");
            });
        });

        this.dropzone.on("error", (file, message) => {
            document.querySelectorAll("#upload-progress").forEach((el) => {
                el.classList.add("invisible");
            });
            this.alert.classList.remove("invisible");
            this.alert.classList.add("alert-danger");
            this.alert.innerText = "Something went wrong. Cannot upload the image.";
        });

        this.dropzone.on("success", () => {
            document.querySelectorAll("#upload-progress").forEach((el) => {
                el.classList.add("invisible");
            });
            this.alert.classList.remove("invisible");
            this.alert.classList.add("alert-success");
            this.alert.innerText = "Image was uploaded successfully.";
        });
    }

    resetComponents() {
        this.uploadButton.removeEventListener("click", this.uploadButtonListener);
        this.uploadButton.addEventListener("click", this.uploadButtonListener);
        this.uploadButton.removeAttribute("data-bs-target");
        this.uploadButton.removeAttribute("data-bs-toggle");
        this.uploadButton.disabled = false;
        this.uploadButton.innerText = "Upload";

        document.querySelectorAll("#upload-progress").forEach((el) => {
            el.classList.add("invisible");
        })

        document.querySelectorAll("#imageOverlay").forEach((el) => {
            el.classList.remove("invisible");
        });

        this.alert.classList.remove("alert-success");
        this.alert.classList.remove("alert-danger");
        this.alert.classList.add("invisible");
        this.alert.innerText = "";
    }

    get imagePreviewElement() {
        const elements = Array.from(document.querySelectorAll("#previewImage"))
            .filter((ell) => ell.width > 0);

        if (elements.length) {
            return elements.at(0);
        }
        return null;
    }


    get url() {
        return `/gallery/${this.photoGalleryIdValue}/photo`;
    }
}