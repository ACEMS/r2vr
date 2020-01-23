#' Pop messages in VR scene
#'
#' @param animal_messages list of a_update() objects
#' @param visible optional logical to unpop or repop
#'
#' @export
pop <- function(animal_messages, visible = TRUE){
  animals$send_messages(animal_messages)
}
