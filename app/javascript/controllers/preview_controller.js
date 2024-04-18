import { Controller } from "@hotwired/stimulus"
import axios from "axios";

export default class extends Controller {
    static values = {
        path: String
    }

    static targets = [ "image" ]

    connect() {
        this.images = new Map();
        this.container = document.getElementById('preview-images-container');
        this.nextImageButton = document.getElementById('preview-next');
        this.prevImageButton = document.getElementById('preview-back');
        this.modalButton = document.getElementById('modal-launch');

        this.pauseButton = document.getElementById('preview-pause');
        this.resumeButton = document.getElementById('preview-resume');
        this.backControlComponent = document.querySelector(".carousel-control-prev");
        this.nextControlComponent = document.querySelector(".carousel-control-next");

        this.slideshowId = null;

        this.updateImageElements();

        this.index = 0;
    }

    updateImageElements() {
        this.prevImageElement = document.getElementById('preview-item-prev')
        this.currentImageElement = document.getElementById('preview-item-current')
        this.nextImageElement = document.getElementById('preview-item-next')
    }

    openPreview(event) {
        this.index = this.getTargetIndexForId(event.params.id);
        this.setCurrentPreviewedImage(() => { this.loadPreview() });
    }



    loadPreview() {
        this.prevImageElement.querySelector("img").src = this.images.get(this.prevIndexValue);
        this.currentImageElement.querySelector("img").src = this.images.get(this.index);
        this.nextImageElement.querySelector("img").src = this.images.get(this.nextIndexValue);

        this.modalButton.click();
    }

    next() {
        this.index = this.nextIndexValue;
        this.nextImageButton.click();

        const onComplete = () => {
            this.prevImageElement.remove();
            this.currentImageElement.id = 'preview-item-prev';
            this.nextImageElement.id = 'preview-item-current';

            const nextIndex = this.nextIndexValue;
            this.createNewImageElement(false, this.images.get(nextIndex), nextIndex);

            this.updateImageElements();
        }

        this.setCurrentPreviewedImage(onComplete);
    }

    prev() {
        this.index = this.prevIndexValue;
        this.prevImageButton.click();

        const onComplete = () => {
            this.nextImageElement.remove();
            this.currentImageElement.id = 'preview-item-next';
            this.prevImageElement.id = 'preview-item-current';

            const nextIndex = this.prevIndexValue;
            this.createNewImageElement(true, this.images.get(nextIndex), nextIndex);

            this.updateImageElements();
        }

        this.setCurrentPreviewedImage(onComplete);
    }

    close() {
        this.pauseSlideshow();
    }

    pauseSlideshow() {
        this.backControlComponent.classList.remove('visually-hidden');
        this.nextControlComponent.classList.remove('visually-hidden');
        this.pauseButton.classList.add('visually-hidden');
        this.resumeButton.classList.remove('visually-hidden');

        if(this.slideshowId) {
            clearInterval(this.slideshowId);
            this.slideshowId = null;
        }
    }

    resumeSlideshow() {
        this.backControlComponent.classList.add('visually-hidden');
        this.nextControlComponent.classList.add('visually-hidden');
        this.pauseButton.classList.remove('visually-hidden');
        this.resumeButton.classList.add('visually-hidden');

        if(!this.slideshowId) this.slideshowId = setInterval(() => { this.next() }, 3000);
    }

    createNewImageElement(prepend, src, index) {
        const newInstance = document.createElement('div');
        newInstance.classList.add('carousel-item', 'h-100', 'w-100');

        const imageInstance = document.createElement('img');
        imageInstance.src = src;
        imageInstance.alt = 'image index ' + index;
        imageInstance.classList.add('d-block', 'mh-100', 'mw-100', 'm-auto');
        newInstance.appendChild(imageInstance);

        if(prepend) {
            newInstance.id = 'preview-item-prev';
            this.container.insertBefore(newInstance, this.container.firstChild);
        } else {
            newInstance.id = 'preview-item-next';
            this.container.appendChild(newInstance);
        }
    }

    setCurrentPreviewedImage(onComplete) {
        //Load previous image if not loaded earlier
        const prevIndex = this.prevIndexValue;
        const prevImagePromise = !this.images.has(prevIndex) ? this.loadImageByIndex(prevIndex) : Promise.resolve();

        const currentImagePromise = !this.images.has(this.index) ? this.loadImageByIndex(this.index) : Promise.resolve();

        //Load next image if not loaded earlier
        const nextIndex = this.nextIndexValue;
        const nextImagePromise = !this.images.has(nextIndex) ? this.loadImageByIndex(nextIndex) : Promise.resolve();

        Promise.all([prevImagePromise, currentImagePromise, nextImagePromise]).then(() => {
            onComplete();
        })
    }

    getTargetIndexForId(id) {
        if(id === null) return 0;

        let elIndex = 0;
        this.imageTargets.forEach((element, index) => {
            const idString = element.getAttribute("data-preview-id-param");
            if(idString && parseInt(idString) === id) {
                elIndex = index;
            }
        });

        return elIndex;
    }

    getPhotoIdFromTargetIndex(index) {
        const idString = this.imageTargets.at(index).getAttribute("data-preview-id-param");
        if(idString) {
            return parseInt(idString);
        }
        return 0;
    }

    loadImageByIndex(index) {
        const photoId = this.getPhotoIdFromTargetIndex(index);
        if(!photoId) return;

        return axios({
            method: 'GET',
            url: this.pathValue + "/" + photoId,
        }).then((response) => {
            if(response.data.image) this.images.set(index, response.data.image);
        });
    }

    startSlideshow() {
        this.index = 0;
        this.setCurrentPreviewedImage(() => {
            this.loadPreview();
            this.resumeSlideshow();
        });
    }

    get nextIndexValue() {
        return this.index + 1 < this.imageTargets.length ? this.index + 1 : 0;
    }

    get prevIndexValue() {
        return this.index - 1 > 0 ? this.index - 1 : this.imageTargets.length - 1;
    }

}
