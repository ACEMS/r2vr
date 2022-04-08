#' Set the number of markers and the size of them for the 2d or 3d module
#'
#' @param module String to indicate if "2d" or "3d"
#' @param number_of_markers Integer between 1 and 20 of the number of markers to generate
#' @param marker_size String to change the size of the marker, can be: "extra-small", "small", "base" (default), "large", "extra-large" 
#'
#' @examples 
#' \donttest{
#' set_marker_and_props("2d")
#' set_marker_and_props("3d", 10, "small")
#' set_marker_and_props("3d", 15, "large")
#' }
#'
#' @export
set_marker_and_props <- function(module, number_of_markers = 15, marker_size = "base") {
  is_module_ok <- module == "2d" || module == "3d"
  is_marker_size_ok <- marker_size == "extra-small" || marker_size == "small" || marker_size == "base" || marker_size == "large" || marker_size == "extra-large"
  if (!is_module_ok) {
    stop("Invalid module param - Please input the string '2d' or '3d'")
  } else if (number_of_markers != as.integer(number_of_markers) || number_of_markers <= 0) {
    stop("Please enter an integer between 1 and 20 for the number of markers")
  } else if (number_of_markers > 20) {
    stop("For performance reasons, please select 20 or less markers.")
  } else if (!is_marker_size_ok) {
    stop("Please select the marker_size to be either 'extra-small' 'small', 'medium', 'large', or 'extra-large'. If further customization is needed please add an issue to the repo.")
  }
  assign("NUMBER_OF_MARKERS", number_of_markers, envir = .GlobalEnv)
  if (module == "2d") {
    if (marker_size == "extra-small") {
      assign("MARKER_OUTER_RADIUS", 0.08, envir = .GlobalEnv)
    } else if (marker_size == "small") {
      assign("MARKER_OUTER_RADIUS", 0.10, envir = .GlobalEnv)
    } else if (marker_size == "base") {
      assign("MARKER_OUTER_RADIUS", 0.12, envir = .GlobalEnv)
    } else if (marker_size == "large") {
      assign("MARKER_OUTER_RADIUS", 0.14, envir = .GlobalEnv)
    } else if (marker_size == "extra-large") {
      assign("MARKER_OUTER_RADIUS", 0.16, envir = .GlobalEnv)
    }
    # If 2D, also assign the default z-index
    assign("canvas_z", -3, envir = .GlobalEnv)
    assign("marker_z", -1, envir = .GlobalEnv)
    assign("camera_z", 0, envir = .GlobalEnv)
  } else if (module == "3d") {
    if (marker_size == "extra-small") {
      assign("MARKER_OUTER_RADIUS", 3, envir = .GlobalEnv)
    } else if (marker_size == "small") {
      assign("MARKER_OUTER_RADIUS", 3.5, envir = .GlobalEnv)
    } else if (marker_size == "base") {
      assign("MARKER_OUTER_RADIUS", 4, envir = .GlobalEnv)
    } else if (marker_size == "large") {
      assign("MARKER_OUTER_RADIUS", 4.5, envir = .GlobalEnv)
    } else if (marker_size == "extra-large") {
      assign("MARKER_OUTER_RADIUS", 5, envir = .GlobalEnv)
    }
  }
  assign("MARKER_INNER_RADIUS", 0.75 * MARKER_OUTER_RADIUS, envir = .GlobalEnv)
  assign("MENU_OPTION_OUTER_RADIUS", 2.5 * MARKER_OUTER_RADIUS, envir = .GlobalEnv)
  assign("MENU_OPTION_INNER_RADIUS", MARKER_OUTER_RADIUS, envir = .GlobalEnv)
}