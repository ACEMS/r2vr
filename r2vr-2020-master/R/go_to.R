#' Go to either the next image or navigate to a selected image by index
#'
#' @param index Optional Integer to indicate which image to navigate to
#' @param image_paths List of Lists containing the img and the points for the annotation markers
#'
#' @examples 
#' \donttest{
#' go_to()
#' go_to(1)
#' go_to(2)
#' go_to(3)
#' }
#'
#' @export
go_to <- function(index = NA, image_paths = selected_image_paths_and_points) {
  if (!is.na(index) && index > length(image_paths)) {
    stop("Please ensure the index does not exceed the total number of images.")
  }
  # Prevent image change if last image has showed and no args for index have been passed
  if (has_last_image_displayed && is.na(index)) {
    stop("Please ensure the index is passed when it is the last image.")
  }
  # Prevent image change if an index has been passed but the last image has not displayed
  if (!has_last_image_displayed && !is.na(index)) {
    stop("Please ensure the index is not passed unless it is the last image and annotation has finished.")
  }
  # Reset marker colour to default color (initially white)
  reset_markers_color()
  
  # Relative path of current image
  current_image <<- image_paths[[CONTEXT_INDEX]]$img
  
  # Set the index of the next image to be displayed
  CONTEXT_INDEX <<- ifelse(!is.na(index),
                           yes = index,
                           no = CONTEXT_INDEX + 1
  )
  # Indicate if the last image has displayed (Allows to go back to an image to check it)
  if (CONTEXT_INDEX == length(image_paths)) {
    assign("has_last_image_displayed", TRUE, envir = .GlobalEnv)
  } else if (exists("has_last_image_displayed")) {
    if (!exists("go_to_called_after_last_image_displayed_count")) {
      assign("go_to_called_after_last_image_displayed_count", 1, envir = .GlobalEnv)
    } else {
      go_to_called_after_last_image_displayed_count = go_to_called_after_last_image_displayed_count + 1
    }
  }
  # Set the next image path and ID
  next_image <- image_paths[[CONTEXT_INDEX]]$img
  next_image_el_id <- paste0("#img", CONTEXT_INDEX)
  print(paste("Image", CONTEXT_INDEX, "is displayed from", next_image))
  
  setup_scene <- list(
    a_update(id = "canvas",
             component = "material",
             attributes = list(src = next_image_el_id)),
    a_update(id = "canvas",
             component = "src",
             attributes = next_image_el_id),
    a_update(id = "canvas",
             component = "class",
             attributes = next_image
    )
  )
  
  for(aUpdate in 1:length(setup_scene)){
    if(setup_scene[[aUpdate]]$id == "canvas"){
      if(setup_scene[[aUpdate]]$component == "material"){
        setup_scene[[aUpdate]]$attributes <- list(src = next_image_el_id)
      }
      if(setup_scene[[aUpdate]]$component == "src"){
        setup_scene[[aUpdate]]$attributes <- next_image_el_id
      }
      if(setup_scene[[aUpdate]]$component == "class"){
        setup_scene[[aUpdate]]$attributes <- next_image
      }
    }
  }
  animals$send_messages(setup_scene)
  
  # NOTE: Experiment requires random fixed points
  if (!has_last_image_displayed || go_to_called_after_last_image_displayed_count == 1) {
    fixed_markers()
  }
  
  # if (MODULE_TYPE == "training") {
  #   # Display fixed markers when go_to() next image is called, unless it is the last image, in which case check will handle displaying the markers
  #   if (!has_last_image_displayed || go_to_called_after_last_image_displayed_count == 1) {
  #     fixed_markers()
  #   }
  # } else if (MODULE_TYPE == "testing") {
  #   # randomize the position of the markers
  #   randomize_markers()
  # }
  
}