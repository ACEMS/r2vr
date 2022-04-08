#' Randomly select the specified number of images (3 by default, in any order) and the corresponding points from a larger pool of images. Randomization avoids order bias
#'
#' @param image_paths_and_points List of Lists containing the img and the points for the annotation markers
#' @param number_of_images Integer of the number of images to select from all of the images
#'
#' @examples 
#' \donttest{
#' r2vr_pkg <- "https://cdn.jsdelivr.net/gh/ACEMS/r2vr@experiment"
#'
#' r2vr_3d_images <- paste0(r2vr_pkg, "/inst/ext/images/3d/")   
#' 
#' img_paths <- paste(
#'                    r2vr_3d_images,
#'                    c(
#'                      "100030039.jpg",
#'                      "120261897.jpg",
#'                      "130030287.jpg",
#'                      "130050093.jpg"
#'                    ),
#'                    sep = ""
#'                    )
#'                   
#' img1Points = list(
#'   list(id = 1, x = 0.236554238200567 , y = -0.645350804079801 , z = -0.726336307823658, isCoral = 0),
#'   list(id = 2, x = 0.560689468806834 , y = -0.295637517136722 , z = -0.773450565990061, isCoral = 0),
#'   list(id = 3, x = -0.741564092459525 , y = -0.0768210007796801 , z = -0.66646922705695, isCoral = 0)
#' )

#' img_paths_and_points <- list(
#'   list(img = img_paths[1], img_points = img1Points),
#'   list(img = img_paths[2], img_points = img1Points),
#'   list(img = img_paths[3], img_points = img1Points),
#'   list(img = img_paths[4], img_points = img1Points)
#' ) 
#' 
#' set_random_images(img_paths_and_points)            
#'                                                    
#' }
#'
#' @export
set_random_images <- function(image_paths_and_points) {
  number_of_images <- length(image_paths_and_points)
  if (number_of_images != as.integer(number_of_images)) {
    stop("Please enter an integer for the number of images to set")
  } else if (number_of_images <= 0 || number_of_images > length(image_paths_and_points)) {
    stop(paste("Please select between 1 and", length(image_paths_and_points), "images to set. You entered", number_of_images, "but there are only", length(image_paths_and_points), "images to select from" ))
  }
  selected_image_paths_and_points <- sample(image_paths_and_points, number_of_images, replace=FALSE)
  assign("selected_image_paths_and_points", selected_image_paths_and_points, envir = .GlobalEnv)
  
  list_of_non_first_images <- list()
  
  # Create image assets for selected images
  for (i in 1:length(selected_image_paths_and_points)) {
    current_img_path <- selected_image_paths_and_points[[i]]$img
    image_number <- paste0("image", i) # image1, ... , image<n>
    image_path <- paste0("image", i, "Path") # image1Path, ... , image<n>Path
    image_number_points <- paste0("image", i, "Points") # image1Points, ... , image<n>Points
    current_img_points <- selected_image_paths_and_points[[i]]$img_points # list of lists
    
    current_image <- a_asset(
      .tag = "image",
      id = paste0("img", i), # id = "img<i>" used to select DOM element
      src = current_img_path
    )
    
    # Assign list of images
    if (i > 1) {
      list_of_non_first_images[[length(list_of_non_first_images) + 1]] <- current_image
      assign("list_of_non_first_images", list_of_non_first_images, envir = .GlobalEnv)
    }
    
    # Assign image<n> variable to its corresponding image asset
    assign(image_number, current_image, envir = .GlobalEnv)
    # Assign image<n>Path variable to its corresponding image path
    assign(image_path, current_img_path, envir = .GlobalEnv)
    # Assign image<n>Points variable to its corresponding image points
    assign(image_number_points, current_img_points, envir = .GlobalEnv)
  }
  
  set_go_to_context(image_paths_and_points)
}