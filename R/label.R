##' Create a text label, visible in VR.
##'
##' This function returns an entity that will render a 2D text label in VR. It
##' is wrapper for an A-Frame entity with the text component attached, see:
##' https://aframe.io/docs/0.8.0/components/text.html. Additional component
##' configuration arguments listed in the A-Frame documentation can be supplied
##' in the `...` arguments.
##'
##' Use standard entity components such as `position`, `rotation`, and `scale`
##' in `...` to place the label.
##'
##' @title a_label
##' @param text the label text.
##' @param color the label text colour.
##' @param font the font to be used for the label text. Either the name of a
##'   built-in font, listed here:
##'   https://aframe.io/docs/0.8.0/components/text.html#stock-fonts, or a URL
##'   for an sdf .fnt file.
##' @param ... additional arguments to be passed to the A-Frame text entity,
##'   see: https://aframe.io/docs/0.8.0/primitives/a-text.html.
##' @return an A-Frame entity object.
##' @export
a_label <- function(text, color = "#000000", font = "roboto", ...){

  a_entity(.tag = "text", value = text,
           color = color,
           font = font,
           align = "center",
           geometry = list(primitive = "box",
                           width = 0.2,
                           height = 0.2,
                           depth = 0.2),
           material = list(transparent = TRUE,
                           opacity = 0), ...)
}
