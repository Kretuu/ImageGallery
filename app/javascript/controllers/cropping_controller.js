//= require cropper
import { Controller } from "@hotwired/stimulus"
import axios from "axios";

export default class extends Controller {
    static values = {
        photoGalleryId: Number,
        photoPath: String,
    }

    croppingConfiguration = {

    }

    connect() {
        this.image = document.getElementById('editedImage');
        this.alert = document.getElementById('cropping-alert');
        this.alertContainer = document.getElementById('cropping-alert-container');
        this.initialiseObservers();
    }

    initialiseObservers() {
        const croppingModal = document.getElementById('cropImageModal');
        var prevClasses = croppingModal.getAttribute('class');
        const modalObserver = new MutationObserver((changes) => {
            changes.forEach(change => {
                const classes = change.target.getAttribute('class');
                if(classes.indexOf('show') !== -1 && prevClasses.indexOf('show') === -1) {
                    this.createCropper();
                    prevClasses = classes;
                } else if(classes.indexOf('show') === -1 && prevClasses.indexOf('show') !== -1) {
                    if(this.cropper) {
                        this.cropper.destroy()
                    }
                    prevClasses = classes;
                }
            });
        });
        modalObserver.observe(croppingModal, { attributes: true });

        document.getElementById("save-cropping").addEventListener('click', (event) => {
            console.log(this.photoPathValue)
            axios({
                method: 'PUT',
                url: this.photoPathValue,
                data: {
                    photo: {
                        x: this.croppingConfiguration.left,
                        y: this.croppingConfiguration.top,
                        w: this.croppingConfiguration.width,
                        h: this.croppingConfiguration.height
                    }
                },
                headers: {
                    "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
                }
            }).then((response) => {
                console.log(response.status)
                if(response.status === 200) {
                    let url = window.location.href;
                    if (url.indexOf('?') > -1){
                        url += '&notice=Image was cropped successfully'
                    } else {
                        url += '?notice=Image was cropped successfully'
                    }
                    window.location.href = url;
                } else {
                    this.alertContainer.classList.remove("d-none");
                    this.alert.classList.add("alert-danger");
                    this.alert.innerText = "Something went wrong. Could not crop the image.";
                }
            })
        })
    }

    setImagePath() {
        console.log("test")
        axios({
            method: 'GET',
            url: this.photoPathValue + "/edit",
        }).then((response) => {
            if(response.data.original_image) this.image.src = response.data.original_image;
            this.setCroppingConfiguration(response.data)
            console.log(response.data)
            console.log(this.croppingConfiguration)
            console.log(this.image.src)
            document.getElementById('open-cropping-modal').click()
        });
    }

    createCropper() {
        const cropData = this.croppingConfiguration;
        const setInputs = (values) => this.setCroppingConfiguration(values);

        this.cropper = new Cropper(this.image, {
            viewMode: 2,
            background: false,
            autoCrop: true,
            zoomable: false,
            autoCropArea: 1,
            movable: false,
            rotatable: false,
            scalable: false,
            crop(event) {
                // console.log("x: " + event.detail.x)
                // console.log("y: " + event.detail.y)
                // console.log("w: " + event.detail.width)
                // console.log("h: " + event.detail.height)
                setInputs({
                    x: event.detail.x < 0 ? 0 : event.detail.x,
                    y: event.detail.y < 0 ? 0 : event.detail.y,
                    w: event.detail.width < 0 ? 0 : event.detail.width,
                    h: event.detail.height < 0 ? 0 : event.detail.height
                });
            },
            ready() {
                if(cropData.left !== null) {
                    // const container = document.querySelector(".cropper-container")
                    // const cropBox = document.querySelector(".cropper-crop-box")
                    // cropData.x = cropData.x + ((container.offsetWidth - cropBox.offsetWidth) / 2)
                    // cropData.y = cropData.y + ((container.offsetHeight - cropBox.offsetHeight) / 2)
                    this.cropper.setCropBoxData(cropData);
                }
            }
        });
    }

    setCroppingConfiguration(inputData) {
        if(inputData.x || inputData.y || inputData.w || inputData.h) {
            this.croppingConfiguration = {
                left: inputData.x,
                top: inputData.y,
                width: inputData.w,
                height: inputData.h
            }
        }
    }
}
