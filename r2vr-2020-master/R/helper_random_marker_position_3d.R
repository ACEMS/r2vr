#' Helper function that prints a random marker to be included within a list of fixed images at a default depth (away from the camera). NOTE: change `id` and `isCoral`
#'
#' @examples 
#' \donttest{
#' random_fixed_3d_marker()
#' [1] "list(id = 1, x = 0.876366487435723, y = -0.00865718001555315, z = -0.481567059643567, isCoral = 0),"
#' random_fixed_3d_marker()
#' [1] "list(id = 1, x = 0.729674742517203, y = -0.312136177299759, z = 0.608396069146693, isCoral = 0),"
#' 
#' # training_3d.R
#' img1Points = list(list(id = 1, x = 0.876366487435723, y = -0.00865718001555315, z = -0.481567059643567, isCoral = 0), list(id = 1, x = 0.729674742517203, y = -0.312136177299759, z = 0.608396069146693, isCoral = 0))
#' }
#'
#' @export
random_fixed_3d_marker <- function() {
  u <- runif(1, -1, 1)
  theta <- runif(1, -pi, 0)
  random_coordinate_x <- sqrt(1 - u^2) * cos(theta)
  random_coordinate_y <- sqrt(1 - u^2) * sin(theta)
  random_coordinate_z <- u
  
  print(paste0("list(id = 1, x = ", random_coordinate_x, ", y = ", random_coordinate_y, ", z = ", random_coordinate_z, ", isCoral = 0),"))
}