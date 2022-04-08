#' Set global variables needed for go_to() and check() to assess which image is being displayed
#'
#' @param image_paths_and_points List of Lists containing the img and the points for the annotation markers
#'
#' @examples 
#' \donttest{
#' img_paths_and_points <- list(
#'   list(img = img_paths[1], img_points = img1Points[1]),
#'   list(img = img_paths[2], img_points = img1Points[2]),
#'   list(img = img_paths[3], img_points = img1Points[3]),
#'   list(img = img_paths[4], img_points = img1Points[1])
#' ) 
#'  
#' set_go_to_context(img_paths_and_points)                                  
#' }
#'
#' @export
set_go_to_context <- function(image_paths_and_points) {
  assign("CONTEXT_INDEX", 1, envir = .GlobalEnv)
  assign("current_image", image_paths_and_points[[1]], envir = .GlobalEnv)
  assign("has_last_image_displayed", FALSE, envir = .GlobalEnv)
}
