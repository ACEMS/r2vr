#' Check if user annotations are correct or not
#'
#' @param img_number Integer to indicate which image to check as per the order the user annotated the images in
#'
#' @examples 
#' \donttest{
#' check(1)
#' check(2)
#' check(3)
#' }
#'
#' @export
check <- function(img_number) {
  # Only check if all images are annotated
  if (!has_last_image_displayed) {
    stop('Please annotate all images before calling check!')
  }
  if (!is.na(img_number) && img_number > length(img_paths)) {
    stop("Please ensure the index does not exceed the total number of images.")
  }
  if (!exists("img_number") ) {
    stop("Please pass the image number of the image you would like to check. E.g. 'img_number = 1' denotes the first randomly generated image number.")
  } else if (img_number != as.integer(img_number) || img_number <= 0) {
    stop("Please enter a positive integer corresponding to the image number of the randomly generated images.")
  }
  # Determine image path of the image to be checked
  image_path <- selected_image_paths_and_points[[img_number]]$img
  # Determine the gold standard of the image to be checked
  image_gold_standard <- selected_image_paths_and_points[[img_number]]$img_points #
  # Display the image to be checked
  go_to(img_number)
  # Display fixed points in the location previously annotated
  fixed_markers()
  # Pick out id and isCoral from correctly annotated markers
  mutated_image_gold_standard <- list()
  # Select id and isCoral from mutated_image_gold_standard
  for (annotation in image_gold_standard) {
    current_annotation <- list(id = annotation$id, isCoral = annotation$isCoral)
    mutated_image_gold_standard[[length(mutated_image_gold_standard) + 1]] <- current_annotation
  }
  # Check if markers are correct or incorrect
  check_entities <- list(
    a_check(
      imageId = image_path,
      goldStandard = mutated_image_gold_standard
    )
  )
  animals$send_messages(check_entities)
  
  checked_messages <- list(
    a_update(id = "metaData",
             component = "checked",
             attributes = TRUE)
  )
  animals$send_messages(checked_messages)
}