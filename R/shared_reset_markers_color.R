#' Reset the color of all markers
#'
#' @param number_of_markers Integer to indicate the number of markers to reset the color of
#' @param default_marker_color Character string of the HEX color to reset the markers back to
#'
#' @examples 
#' \donttest{
#' NUMBER_OF_MARKERS <- 15
#' COLOR_MARKER <- "#FFFFFF"
#' reset_markers_color()
#' 
#' reset_markers_color(15, "#FFFFFF")
#' }
#'
#' @export
reset_markers_color <- function(number_of_markers = NUMBER_OF_MARKERS, default_marker_color = COLOR_MARKER){
  if (number_of_markers != as.integer(number_of_markers)) {
    stop("Please enter an integer for the number of markers to reset")
  } else if (number_of_markers <= 0) {
    stop("Please enter a positive integer for the number of markers to reset")
  } else if (!is.character(default_marker_color)) {
    stop("Please enter either the HEX code or A-Frame color as a Character string")
  }
  
  for (i in 1:number_of_markers) {
    reset_colors <- list(
      a_update(
        id = paste0("markerBoundary", i),
        component = "color",
        attributes = default_marker_color
      )
    )
    animals$send_messages(reset_colors)
  }
}