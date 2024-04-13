import axios from "axios";

function loadImage() {
    console.log(axios({
        method: 'GET',
        url: '/posts/1/edit',
    }));
}

export default loadImage;