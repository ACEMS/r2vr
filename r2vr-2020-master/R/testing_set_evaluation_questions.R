#' Set the evaluation questions and responses and associated question context (i.e. current question number from evaluation questions)
#'
#' @param evaluation_questions list of evaluation question lists composed of a 'question', 'answerOne', 'answerTwo', 'answerThree', and an 'answerFour'
#'
#' @examples 
#' \donttest{
#' evaluation_questions <- list(
#' list(question = "Did you enjoy this experiment?", answerOne = "Very much", answerTwo = "Yes", #' answerThree = "A little", answerFour = "No"),
#' list(question = "On a scale of 1-4, how would you rate your experience?", answerOne = "1",  
#' answerTwo = "2", answerThree = "3", answerFour = "4")
#' )
#' 
#' set_questions_and_responses(evaluationQuestions)
#' }                 
#'
#' @export
set_questions_and_responses <- function(evaluation_questions) {
  if (!hasArg(evaluation_questions)) {
    stop("Please pass the evaluation questions as an argument")
  }
  for (question in evaluation_questions) { 
    if (!is.list(question)) {
      stop("Please ensure the data structure of the evaluation_questions is a list of lists, in which each nested list has a 'question', 'answerOne', 'answerTwo', 'answerThree', and an 'answerFour' property associated with it")
    }
  }
  
  assign("QUESTIONS_AND_RESPONSES", evaluation_questions, envir = .GlobalEnv)
  assign("QUESTION_CONTEXT", 1, envir = .GlobalEnv)
}