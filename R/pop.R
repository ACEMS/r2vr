#' Pop messages in VR scene
#'
#' @param visible Optional logical to unpop or repop. Defaults to \code{TRUE}.
#' @param question_type Optional question type from \code{"binary"} or \code{"multivariable"}. Defaults to \code{"binary"}.
#'
#' @examples 
#' \donttest{
#' ## Display messages in VR scene
#' pop()
#' 
#' ## Remove messages
#' pop(FALSE)
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
  if(question_type == "multivariable"){
    show_messages <- list(
      a_update(id = "questionPlane",
               component = "visible",
               attributes = TRUE),
      a_update(id = "option1Plane",
               component = "visible",
               attributes = TRUE),
      a_update(id = "option3Plane",
               component = "visible",
               attributes = TRUE),
      a_update(id = "option4Plane",
               component = "visible",
               attributes = TRUE),
      a_update(id = "option2Plane",
               component = "visible",
               attributes = TRUE),
      a_update(id = "postPlane",
               component = "visible",
               attributes = TRUE),
      a_update(id = "postPlaneBoundary",
               component = "visible",
               attributes = TRUE),
      a_update(id = "option1Boundary",
               component = "visible",
               attributes = TRUE),
      a_update(id = "option3Boundary",
               component = "visible",
               attributes = TRUE),
      a_update(id = "option4Boundary",
               component = "visible",
               attributes = TRUE),
      a_update(id = "option2Boundary",
               component = "visible",
               attributes = TRUE)
    )
    
  }
  
  visible_message <- change_message(show_messages, visible)
  animals$send_messages(visible_message)
}
