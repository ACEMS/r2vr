Point2d <- R6::R6Class("Point2d",
  public = list(
    n = NA,
    x = NA,
    y = NA,
    
    initialize = function(n, x, y) {
      stopifnot(is.numeric(n))
      stopifnot(is.numeric(x) || is.numeric(y))

      self$x <- x
      self$y <- y
      self$n <- n
    }
  )
)

#' Create new 2d Point instance
#'
#' @param n Integer (uniquely) defining the number of the point to be created
#' @param x x position of the point
#' @param y y position of the point
#'
#' @examples 
#' \donttest{
#' p1 <- point_2d(1, 0.5, 0.5)
#' }
#'
#' @export
point_2d <- function(n, x, y) { 
  Point2d$new(n = n, x = x, y = y)
}

##' Checks if is this object a 2d point
##'
##' @title is_2d_point
##' @param point an object
##' @return boolean
##' 
#' @examples 
#' \donttest{
#' p1 <- point_2d(1, 0.5, 0.5)
#' is_2d_point(p1) # TRUE
#' is_2d_point(5) # FALSE
#' }
##' 
##' @export
is_2d_point <- function(point) inherits(point, "Point2d")