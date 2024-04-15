// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

//= require activestorage

import "@hotwired/turbo-rails"
import "controllers"

import "popper"
import "bootstrap"

import * as FullscreenMode from 'src/fullscreen_image'
window.FullscreenMode = FullscreenMode
import * as Cropper from 'src/crop_image'