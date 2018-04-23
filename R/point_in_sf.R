#' Determine if a list of X,Y points interest with an sf object.
#'
#' @param x X coordinates
#' @param y Y coordinates
#' @param sf_obj An sf object, could contian multiple polygons etc
#'
#' @return a logical vector of the same length as the number of points
#' @export
#'
point_in_sf <- function(x, y, sf_obj){
  if(length(x) != length(y)){
    stop("length of x and y is not identical")
  }
  points_vec <- sf::st_sfc(purrr::map2(.x = x, .y = y, ~sf::st_point(c(.x,.y))))
  sf::st_crs(points_vec) <- sf::st_crs(sf_obj)
  points_in_sf_obj_idx <- unlist(sf::st_intersects(sf_obj, points_vec))
  result <- rep(FALSE, length(x))
  result[points_in_sf_obj_idx] <- TRUE
  result
}
