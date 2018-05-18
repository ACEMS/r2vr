##' A JSON model entity for A-Frame
##'
##' This function returns an entity that will render a 3D model expressed in threejs JSON format. See the format specification here: https://github.com/mrdoob/three.js/wiki/JSON-Model-format-3. The mandatory `src` argument is an should be an object returned by `a_asset()`.
##' 
##' @title 
##' @param src 
##' @param js_sources 
##' @param ... 
##' @return 
##' @author Miles McBain
a_json_model <- function(src,
                         js_sources = list("https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.loaders.js"),
                         ...){
  a_entity(json_model = list(src = src), js_sources = js_sources, ...)
}
