import axios from "axios";

var currentLoadedImage = null;

function loadImage(path) {
    console.log(axios({
        method: 'GET',
        url: path,
    }));
}

export { loadImage }