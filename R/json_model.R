##' A JSON model entity for A-Frame
##'
##' This function returns an entity that will render a 3D model expressed in
##' threejs JSON format. See the format specification here:
##' https://github.com/mrdoob/three.js/wiki/JSON-Model-format-3. The mandatory
##' `src` argument should be an object returned by `a_asset()`.
##'
##' The entity imports the an extenal js source for loading JSON models written by Don McCurdy. 
##' 
##' @title a_json_model
##' @param src an a_asset describing a JSON file. 
##' @param js_sources defaults to version 4.0.2 of the JSON model loader, supply
##'   another version using a list here. e.g. `js_sources` =
##'   list("https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.loaders.js")
##' @param ... other components to be added to the JSON model. Passed to a_entity. 
##' @return An entity object describing a JSON model.
##' @author Miles McBain
a_json_model <- function(src,
                         js_sources = list("https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.loaders.js"),
                         ...){
  a_entity(json_model = list(src = src), js_sources = js_sources, ...)
}
