import axios from "axios";

function loadImage() {
    console.log(axios({
        method: 'GET',
        url: '/gallery/1/edit',
    }));
}

export { loadImage }