#' Pop messages in VR scene
#'
#' @param show_messages list of a_update() objects
#' @param visible optional logical to unpop or repop
#'
#' @examples 
#' \donttest{
#' 
#' show_messages <- list(
#' a_update(id = "questionPlane",
#'          component = "visible",
#'          attributes = TRUE),
#' a_update(id = "yesPlane",
#'          component = "visible",
#'          attributes = TRUE),
#' a_update(id = "noPlane",
#'          component = "visible",
#'          attributes = TRUE),
#' a_update(id = "yesPlaneBoundary",
#'          component = "visible",
#'          attributes = TRUE),
#' a_update(id = "noPlaneBoundary",
#'          component = "visible",
#'          attributes = TRUE)
#' )
#' 
#' ## Display messages in VR scene
#' pop(show_messages)
#' 
#' ## Remove messages
#' pop(show_messages, visible = FALSE)
#' }
#' 
#' @export
pop <- function(visible = TRUE, question_type = "binary"){
  
  if(question_type == "binary"){
    show_messages <- list(
      a_update(id = "questionPlane",
               component = "visible",
               attributes = TRUE),
      a_update(id = "yesPlane",
               component = "visible",
               attributes = TRUE),
      a_update(id = "noPlane",
               component = "visible",
               attributes = TRUE),
      a_update(id = "yesPlaneBoundary",
               component = "visible",
               attributes = TRUE),
      a_update(id = "noPlaneBoundary",
               component = "visible",
               attributes = TRUE)
    )
  } 
  # if(question_type = "multi"){
  #   show_messages <- list(
  #     a_update(id = "questionPlane",
  #              component = "visible",
  #              attributes = TRUE),
  #     a_update(id = "yesPlane",
  #              component = "visible",
  #              attributes = TRUE),
  #     a_update(id = "noPlane",
  #              component = "visible",
  #              attributes = TRUE),
  #     a_update(id = "yesPlaneBoundary",
  #              component = "visible",
  #              attributes = TRUE),
  #     a_update(id = "noPlaneBoundary",
  #              component = "visible",
  #              attributes = TRUE)
  # }
  
  visible_message <- change_message(show_messages, visible)
  animals$send_messages(visible_message)
}
