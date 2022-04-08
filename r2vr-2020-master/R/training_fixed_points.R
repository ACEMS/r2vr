#' Generate markers in fixed locations
#'
#' @param module String to indicate if "2d" or "3d"
#' @param image_paths_and_points List of Lists containing the 'img' and the 'img_points' for the annotation markers
#' @param marker_depth Optional integer for the '3d' module to alter the depth of the marker where the default is 100 e.g. A value of 80 is shallower/closer to the camera than 100
#'
#' @examples 
#' \donttest{
#' selected_img_paths_and_points <- list(
#'   list(img = img_paths[1], img_points = img1Points),
#'   list(img = img_paths[2], img_points = img1Points),
#'   list(img = img_paths[3], img_points = img1Points)
#' ) 
#' 
#' fixed_markers()
#' fixed_markers("2d")
#' fixed_markers("3d")
#' fixed_markers("3d", selected_img_paths_and_points, 90)              
#'                                                    
#' }
#'
#' @export
fixed_markers <- function(module = MODULE, image_paths_and_points = selected_image_paths_and_points, marker_depth = NA){
  is_module_ok <- module == "2d" || module == "3d"
  if (!is_module_ok) {
    stop("Invalid module param - Please input the string '2d' or '3d'")
  }
  if (module != "3d" && !is.na(marker_depth)) {
    stop("The marker depth property can only be changed for the markers from the 3d module")
  }
  
  # Find which image to generate the points for
  if (!exists("CONTEXT_INDEX")) {
    # NOTE: Consider removing check when set_go_to_context called before scene created
    selected_image_points <- image_paths_and_points[[1]]$img_points
  } else {
    selected_image_points <- image_paths_and_points[[CONTEXT_INDEX]]$img_points
  }
  
  if (module == "2d") {
    # 2D Images are 4000x3000px
    x_translation <- range_translation(4000, 0, 2, -2)
    y_translation <- range_translation(3000, 0, 3/2, -3/2)
    
    for(point in 1:length(selected_image_points)) {
      ## Find the transformed x and y values
      x <- x_translation(selected_image_points[[point]]$x)
      y <- -y_translation(selected_image_points[[point]]$y)
      
      # Update the position for the number of points specified
      update_entities <- list(
        a_update(
          id = paste0("markerContainer", point),
          component = "position",
          attributes = list(x = x, y = y, z = canvas_z + 0.02)
        ),
        # Update the specified number of points to be visible
        a_update(
          id = paste0("markerContainer", point),
          component = "visible",
          attributes = TRUE
        )
      )
      animals$send_messages(update_entities)
    }
  } else if (module == "3d") {
      if (is.na(marker_depth)) {
        depth <- 100
      } else {
        depth <- marker_depth
      }
    
      for(point in 1:length(selected_image_points)) {
        x <- depth * selected_image_points[[point]]$x
        y <- depth * selected_image_points[[point]]$y
        z <- depth * selected_image_points[[point]]$z
        
        # Update the position for the number of points specified
        update_entities <- list(
          a_update(
            id = paste0("markerContainer", point),
            component = "position",
            attributes = list(x = x, y = y, z = z)
          ),
          # Update the specified number of points to be visible
          a_update(
            id = paste0("markerContainer", point),
            component = "visible",
            attributes = TRUE
          )
        )
        animals$send_messages(update_entities)
      }
  }
  
  start_number_of_remaining_points <- length(selected_image_points) + 1
  
  if (start_number_of_remaining_points > NUMBER_OF_MARKERS) return()
  
  # Update the remaining points to not be visible
  for (point in start_number_of_remaining_points:NUMBER_OF_MARKERS) {
    # Update the position
    update_entities <- list(
      a_update(
        id = paste0("markerContainer", point),
        component = "visible",
        attributes = FALSE
      )
    )
    animals$send_messages(update_entities)
  }

}