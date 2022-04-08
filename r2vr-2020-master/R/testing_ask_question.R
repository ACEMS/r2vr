#' Ask the user a question or multiple questions
#'
#' @param index Integer representing the question number as defined by the user in 'question_and_reponses'
#' @param visible Boolean to toggle visibility of the question and response entities
#' @param question_and_responses list of evaluation question lists composed of a 'question', 'answerOne', 'answerTwo', 'answerThree', and an 'answerFour'
#'
#' @examples 
#' \donttest{
#' evaluation_questions <- list(
#' list(question = "Did you enjoy this experiment?", answerOne = "Very much", answerTwo = "Yes", #' answerThree = "A little", answerFour = "No"),
#' list(question = "On a scale of 1-4, how would you rate your experience?", answerOne = "1",  
#' answerTwo = "2", answerThree = "3", answerFour = "4")
#' )
#' 
#' ask_question(1)
#' ask_question(2)
#' ask_question(1, FALSE) # hide question/responses
#' ask_question(1, TRUE, evaluation_questions)
#' }                 
#'
#' @export
ask_question <- function(index = NA, visible = TRUE, question_and_responses = QUESTIONS_AND_RESPONSES){
  if (!is.na(index) && index > length(question_and_responses)) {
    stop("The index of the question exceeds the total number of questions.")
  }
  if (!is.na(index)) {
    assign("QUESTION_CONTEXT", index, envir = .GlobalEnv)
    
    if (QUESTION_CONTEXT == 1) {
      hide_markers()
    }
    
    text_messages <- list(
      a_update(id = "questionPlaneText",
               component = "value",
               attributes = question_and_responses[[index]]$question),
      a_update(id = "optionOneText",
               component = "value",
               attributes = question_and_responses[[index]]$answerOne),
      a_update(id = "optionTwoText",
               component = "value",
               attributes = question_and_responses[[index]]$answerTwo),
      a_update(id = "optionThreeText",
               component = "value",
               attributes = question_and_responses[[index]]$answerThree),
      a_update(id = "optionFourText",
               component = "value",
               attributes = question_and_responses[[index]]$answerFour)
    )
    animals$send_messages(text_messages)
  }
  show_messages <- list(
    a_update(id = "questionPlane",
             component = "visible",
             attributes = TRUE),
    a_update(id = "optionOnePlane",
             component = "visible",
             attributes = TRUE),
    a_update(id = "optionTwoPlane",
             component = "visible",
             attributes = TRUE),
    a_update(id = "optionThreePlane",
             component = "visible",
             attributes = TRUE),
    a_update(id = "optionFourPlane",
             component = "visible",
             attributes = TRUE),
    a_update(id = "postPlane",
             component = "visible",
             attributes = TRUE)
  )
  animals$send_messages(show_messages)
  
  question_messages <- list(
    a_update(id = "questionPlane",
             component = "questioned",
             attributes = TRUE)
  )
  animals$send_messages(question_messages)
}