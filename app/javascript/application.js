// Entry point for the build (esbuild/rollup/webpack via jsbundling-rails)

import "@hotwired/turbo-rails"
import "./controllers"

import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap

import "smoothscroll"
import "./theme_custom"