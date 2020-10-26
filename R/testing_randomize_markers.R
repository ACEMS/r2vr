#' Randomize the position of the markers
#'
#' @param module "2d" || "3d"
#'
#' @examples 
#' \donttest{
#' randomize_markers()
#' randomize_markers("2d")
#' randomize_markers("3d")
#' }
#'
#' @export
randomize_markers <- function(module = MODULE) {
  # reset list of points back to initial value
  points.list <<- list()
  # Set a guard to prevent a possible infinite loop if n is too large
  guard <- 0
  
  if (MODULE == "2d") {
    # Create annotation markers
    while (length(points.list) < NUMBER_OF_MARKERS) {
      # Note: Canvas: -2/3 < x < 2/3, -1/2 < y < 1/2
      random_coordinate_x <- runif(1, -2 + MARKER_OUTER_RADIUS, 2 - MARKER_OUTER_RADIUS)
      random_coordinate_y <- runif(1, -1.5 + MARKER_OUTER_RADIUS, 1.5 - MARKER_OUTER_RADIUS)
      n <- length(points.list) + 1
      overlapping = FALSE
      
      # Create a new point object
      p <- point_2d(n, random_coordinate_x, random_coordinate_y)
      
      if (length(points.list) > 0) {
        # Determine if the new point intersects with any of the other points in list
        for (marker in 1:length(points.list)) {
          marker_in_list = points.list[[marker]]
          # Find the distance between the new point and the point in the list
          distance = euclidean_distance(p, marker_in_list)
          # If the new point overlaps with any current point set overlapping to true
          if (distance < 2 * MARKER_OUTER_RADIUS) {
            overlapping = TRUE
            break
          }
        }
      }
      
      # If there is no overlap then new point can be added to the list
      if (!overlapping) {
        points.list[[n]] <<- p
        update_entities <- list(
          a_update(
            id = paste0("markerContainer", n),
            component = "position",
            attributes = list(
              x = random_coordinate_x, y = random_coordinate_y, z = canvas_z + 0.02
            )
          ),
          # Update the specified number of points to be visible
          a_update(
            id = paste0("markerContainer", n),
            component = "visible",
            attributes = TRUE
          )
        )
        animals$send_messages(update_entities)
      }
      # Increment the guard for each while loop iteration
      guard = guard + 1
      if (guard > 1000) { break }
    }
  } else if (MODULE == "3d") {
    # Create annotation markers
    while (length(points.list) < NUMBER_OF_MARKERS) {
      u <- runif(1, -1, 1) # runif(1, -1, 1)
      theta <- runif(1, -pi, 0) # Full sphere: runif(1, 0, pi)
      random_coordinate_x <- 100 * sqrt(1 - u^2) * cos(theta)
      random_coordinate_y <- 100 * sqrt(1 - u^2) * sin(theta)
      random_coordinate_z <- 100 * u
      
      n <- length(points.list) + 1
      overlapping = FALSE
      
      # Create a new point object
      p <- point_3d(n, random_coordinate_x, random_coordinate_y, random_coordinate_z)
      
      if (length(points.list) > 0) {
        # Determine if the new point intersects with any of the other points in list
        for (marker in 1:length(points.list)) {
          marker_in_list = points.list[[marker]]
          # Find the distance between the new point and the point in the list
          distance = euclidean_distance(p, marker_in_list)
          # If the new point overlaps with any current point set overlapping to true
          if (distance < 2 * MENU_OPTION_OUTER_RADIUS) {
            overlapping = TRUE
            break
          }
        }
      }
      
      # If there is no overlap then new point can be added to the list
      if (!overlapping) {
        points.list[[n]] <<- p
        update_entities <- list(
          a_update(
            id = paste0("markerContainer", n),
            component = "position",
            attributes = list(
              x = random_coordinate_x, y = random_coordinate_y, z = random_coordinate_z
            )
          ),
          a_update(
            id = paste0("markerContainer", n),
            component = "visible",
            attributes = TRUE
          )
        )
        animals$send_messages(update_entities)
      }
      # Increment the guard for each while loop iteration
      guard = guard + 1
      if (guard > 1000) { break }
    }
  }
}