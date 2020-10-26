Point3d <- R6::R6Class("Point3d",
  inherit = Point2d,
  public = list(
    z = NA,
    
    initialize = function(n, x, y, z) {
      super$initialize(n, x, y)
      
      stopifnot(is.numeric(z))
      
      self$z <- z
    }
  )
)

#' Create new 3d Point instance
#'
#' @param n Integer (uniquely) defining the number of the point to be created
#' @param x x position of the point
#' @param y y position of the point
#' @param z z position of the point
#'
#' @examples 
#' \donttest{
#' p1 <- point_3d(1, 0.5, 0.5, 0.5)
#' }
#'
#' @export
point_3d <- function(n, x, y, z) { 
  Point3d$new(n = n, x = x, y = y, z = z)
}

##' Checks if is this object a 3d point
##'
##' @title is_3d_point
##' @param point an object
##' @return boolean
##' 
#' @examples 
#' \donttest{
#' p1 <- point_3d(1, 0.5, 0.5, 0.5)
#' is_3d_point(p1) # TRUE
#' is_3d_point(5) # FALSE
#' }
##' 
##' @export
is_3d_point <- function(point) inherits(point, "Point3d")