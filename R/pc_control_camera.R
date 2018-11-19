.extras_controls <- "https://cdn.rawgit.com/donmccurdy/aframe-extras/v{.version_num}/dist/aframe-extras.controls.js"

##' Personal computer movement controls for an A-Frame scene camera
##'
##' This function returns an entity that will enable the scene camera perspective to be controlled using WASD keys and the mouse.
##'
##' The entity imports an external js source for controls written by Don McCurdy.
##'
##' @title a_pc_control_camera
##' @param .js_sources Defaults to version 4.1.2 of the controls. 
##' @param .version_num A-Frame extras version number.
##' @param easingY Easing rate of movement in the y direction (up).
##' @param acceleration Acceleration of movement in forward, backward, left, and
##'   right directions.
##' @param ... additional components to be added to this entity.
##' @return An entity object describing a camera controlled by keyboard and mouse.
##' @export
a_pc_control_camera <- function(.js_sources = list(),
                                easingY = 15,
                                acceleration = 100,
                                .version_num = "4.1.2",
                                ...){

  controls <- stringr::str_interp(.extras_controls)
  .js_sources <- c(controls, .js_sources)

  a_entity(id = "rig",
           movement_controls = list(fly = TRUE, easingY = easingY,
                                    acceleration = acceleration),
           .js_sources = .js_sources,
           ...,
           .children =
             list(
               a_entity(camera = "", position = c(0, 1.6, 0),
                        look_controls = list(pointerLockEnabled = TRUE))))
}
