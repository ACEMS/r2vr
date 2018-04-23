#' Convert a shapefile with contours to a raster
#'
#' @param contour_sf an sf object read from a shapefile with contours, eg elevation.
#' @param raster_attribute The name of the attribute to be rastered
#' @param n_samples the number of contour points to be sampled for raster interpolation
#' @param nrow number of rows in the raster grid
#' @param ncol number of columns in the raster grid
#'
#' @return a raster
#' @export
#'
contour_2_raster <- function(contour_sf, raster_attribute, n_samples = 10000, nrow, ncol){

x <- contour_sf

## L1, L2 are the holes, and islands respectively
coords <-
  sf::st_coordinates(x) %>%
  tibble::as_tibble() %>%
  dplyr::sample_n(n_samples)

xy <-
  coords %>%
  dplyr::rename(x = X, y = Y) %>%
  select(x,y) %>%
  as.matrix()

value <- x[[raster_attribute]][dplyr::pull(coords, L2)]

## helper function to build a raster from the extent of a set of points
grid <- guerrilla::defaultgrid(xy, ncol = ncol, nrow = nrow)

## this function triangulates the points (no account is taken of the lines)
## and uses barycentric interpolation on triangles to interpolate value
## (this is what griddata in Matlab does, default method)
trigrid <- guerrilla::tri_fun(xy,
                   value,
                   grid)
trigrid
}
