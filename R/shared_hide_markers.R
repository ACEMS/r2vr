#' Hide all markers
#'
#' @param number_of_markers Integer for the number of markers to hide
#'
#' @examples 
#' \donttest{
#' hide_markers()
#' hide_markers(15)
#' }
#'
#' @export
hide_markers <- function(number_of_markers = NUMBER_OF_MARKERS){
  for (point in 1:number_of_markers) {
    container_messages <- list(
      a_update(
        id = paste0("markerContainer", point),
        component = "visible",
        attributes = FALSE
      )
    )
    animals$send_messages(container_messages)
  }
}