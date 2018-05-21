##' Personal computer movement controls for an A-Frame scene camera
##'
##' This function returns an entity that will enable the scene camera perspective to be controlled using WASD keys and the mouse.
##'
##' The entity imports an external js source for controls written by Don McCurdy.
##'
##' @title a_pc_control_camera
##' @param js_sources Defaults to version 4.0.2 of the controls. 
##' @param easingY Easing rate of movement in the y direction (up).
##' @param acceleration Acceleration of movement in forward, backward, left, and right directions.
##' @return An entity object describing a camera controlled by keyboard and mouse. 
a_pc_control_camera <- function(js_sources = list("https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.controls.js"),
                          easingY = 15,
                          acceleration = 100,
                          ...){
  a_entity(tag = "camera",
           movement_controls = list(fly = TRUE, easingY = easingY, acceleration = acceleration),
           js_sources = js_sources, ...)

}
