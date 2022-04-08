#' Calculates and returns the Euclidean Distance between two Points
#'
#' @param p1 First Point of type Point2d || Point3d
#' @param p2 First Point of type Point2d || Point3d
#'
#' @return The distance between p1 and p2
#' 
#' @examples 
#' \donttest{
#' euclidean_distance(p1, p2)
#' }
#' 
#' @export
euclidean_distance <- function(p1, p2) {
  if (!exists("MODULE")) {
    stop("Please set the 'MOUDLE' as '2d' or '3d' prior to calculating the Euclidean distance between two points.")
  } else if (!hasArg(p1) || !hasArg(p2)) {
    stop("Please ensure two points are passed to calculate the distance between p1 and p2.")
  }
  
  if (MODULE == "2d") {
    if (!is_2d_point(p1) || !is_2d_point(p2)) {
      stop("Please ensure both points are created using 'point_2d'")
    }
    return(sqrt((p2$x - p1$x)^2 + (p2$y - p1$y)^2))
  } else if (MODULE == "3d") {
    if (!is_3d_point(p1) || !is_3d_point(p2)) {
      stop("Please ensure both points are created using 'point_3d'")
    }
    return(sqrt((p2$x - p1$x)^2 + (p2$y - p1$y)^2 + (p2$z - p1$z)^2))
  }
}