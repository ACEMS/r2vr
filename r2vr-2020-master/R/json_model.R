.extras_model_loader <- "https://cdn.rawgit.com/donmccurdy/aframe-extras/v${.version_num}/dist/aframe-extras.loaders.min.js"
.extras_misc_smoother <- "https://cdn.rawgit.com/donmccurdy/aframe-extras/v${.version_num}/dist/aframe-extras.misc.min.js"

##  A JSON model entity for A-Frame
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
##' @param .version_num A-Frame extras version number.
##' @param .js_sources defaults to version 4.1.2 of the JSON model loader, supply
##'   another version using a list here. e.g. `js_sources` =
##'   list("https://cdn.rawgit.com/donmccurdy/aframe-extras/<path_to_js_file>")
##' @param ... other components to be added to the JSON model. Passed to a_entity. 
##' @param mesh_smooth if true, compute normals in browser to give the model a
##'   smoothed appearance.
##' @return An entity object describing a JSON model.
##' @export
a_json_model <- function(src,
                         .version_num = "4.1.2",
                         mesh_smooth = FALSE,
                         .js_sources = list(),
                         ...){
  ## Add the model loader to any additional JS sources
  model_loader <- stringr::str_interp(.extras_model_loader)
  .js_sources <- c(model_loader, .js_sources)

  if (mesh_smooth) {
    smoother <- stringr::str_interp(.extras_misc_smoother)
    .js_sources <- c(smoother, .js_sources)
    a_entity(json_model = list(src = src), .js_sources = .js_sources,
             mesh_smooth = "", ...)
  } else {
    a_entity(json_model = list(src = src), .js_sources = .js_sources, ...)
  }
}
