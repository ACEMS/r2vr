#' Set the colors of the user interface entities
#'
#' @param marker Character string of the HEX color
#' @param coral Character string of the HEX color 
#' @param not_coral Character string of the HEX color 
#' @param text Character string of the HEX color 
#' @param plane Character string of the HEX color
#' @param check_correct Character string of the HEX color 
#' @param check_incorrect Character string of the HEX color
#' @param evaluation_selection Character string of the HEX color  
#' @param cursor Character string of the HEX color 
#'
#' @examples 
#' \donttest{
#' set_colors()
#' 
#' set_colors("#FFFFFF")
#' 
#' set_colors("#FFFFFF", "#FF95BC", "#B8B27B", "#000000", "#FFFFFF", "#00FF00", "#FF0000", "#00FF00", "#FF0000")
#' }
#'
#' @export
set_colors <- function(marker = "#FFFFFF", coral = "#FF95BC", not_coral = "#B8B27B", text = "#000000", plane = "#FFFFFF", check_correct = "#00FF00", check_incorrect = "#FF0000", evaluation_selection = "#00FF00", cursor = "#FF0000") {
  if (!is.character(marker) || !is.character(coral) || !is.character(not_coral) || !is.character(text) || !is.character(plane) || !is.character(check_correct) || !is.character(check_incorrect) || !is.character(evaluation_selection) || !is.character(cursor)) {
    stop("Please enter either the HEX code or A-Frame color as a Character string")
  }
  assign("COLOR_MARKER", marker, envir = .GlobalEnv)
  assign("COLOR_CORAL", coral, envir = .GlobalEnv)
  assign("COLOR_NOT_CORAL", not_coral, envir = .GlobalEnv)
  assign("COLOR_TEXT", text, envir = .GlobalEnv)
  assign("COLOR_PLANE", plane, envir = .GlobalEnv)
  assign("COLOR_CORRECT", check_correct, envir = .GlobalEnv)
  assign("COLOR_INCORRECT", check_incorrect, envir = .GlobalEnv)
  assign("COLOR_EVALUATION_SELECTION", evaluation_selection, envir = .GlobalEnv)
  assign("COLOR_CAMERA_CURSOR", cursor, envir = .GlobalEnv)
  
  # coral/not_coral/plane/check_correct/check_incorrect/evaluation_selection
  responsive_colors <- paste(coral, not_coral, plane, check_correct, check_incorrect, evaluation_selection, sep="/")
  
  assign("COLORS_RESPONSIVE", responsive_colors, envir = .GlobalEnv)
}
