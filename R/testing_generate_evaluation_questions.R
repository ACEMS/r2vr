#' Generate the entities needed for the evaluation question, responses, and post button
#'
#' @param evaluation_questions list of evaluation question lists composed of a 'question', 'answerOne', 'answerTwo', 'answerThree', and a 'answerFour',
#'
#' @examples 
#' \donttest{
#' evaluation_questions <- list(
#' list(question = "Did you enjoy this experiment?", answerOne = "Very much", answerTwo = "Yes", #' answerThree = "A little", answerFour = "No"),
#' list(question = "On a scale of 1-4, how would you rate your experience?", answerOne = "1",  
#' answerTwo = "2", answerThree = "3", answerFour = "4")
#' 
#' generate_evaluation_questions(evaluation_questions)
#' }
#'
#' @export
generate_evaluation_questions <- function(evaluation_questions = QUESTIONS_AND_RESPONSES) {
  message_height <- 1
  
  list_length <- length(list_of_children_entities)
  
  question_label <- a_label(
    text = evaluation_questions[[1]]$question,
    id = "questionPlaneText",
    color = COLOR_TEXT,
    font = "mozillavr",
    height = 3,
    width = 2,
    position = c(0, 0.05, 0)
  )
  
  question_plane <- a_entity(
    .tag = "plane",
    .children = list(question_label),
    questioned = FALSE,
    id = "questionPlane",
    visible = FALSE,
    position = c(0, message_height, -2),
    color = COLOR_PLANE,
    height = 0.5,
    width = 2,
  )
  
  post_label <- a_label(
    text = "Submit",
    id = "postText",
    color = COLOR_TEXT,
    font = "mozillavr",
    height = 3,
    width = 2, # Note: width exceeds plane for long text, consistent size & static text though
    position = c(0, 0.05, 0)
  )
  
  post_plane <- a_entity(
    .tag = "plane",
    .children = list(post_label),
    raycaster_listen = "",
    id = "postPlane",
    visible = FALSE,
    position = c(1.35, message_height, -2),
    color = COLOR_PLANE,
    height = 0.5,
    width = 0.5,
  )
  
  option_one_label <- a_label(
    text = evaluation_questions[[1]]$answerOne,
    id = "optionOneText",
    color = COLOR_TEXT,
    font = "mozillavr",
    height = 3,
    width = 2,
    position = c(0, 0.05, 0)
  )
  
  option_one_plane <- a_entity(
    .tag = "plane",
    .children = list(option_one_label),
    raycaster_listen = "",
    id = "optionOnePlane",
    class="option1",
    visible = FALSE,
    position = c(-0.3, message_height-0.6, -2),
    color = COLOR_PLANE,
    height = 0.5,
    width = 0.5
  )
  
  option_two_label <- a_label(
    text = evaluation_questions[[1]]$answerTwo,
    id = "optionTwoText",
    color = COLOR_TEXT,
    font = "mozillavr",
    height = 3,
    width = 2,
    position = c(0, 0.05, 0)
  )
  
  option_two_plane <- a_entity(
    .tag = "plane",
    .children = list(option_two_label),
    raycaster_listen = "",
    id = "optionTwoPlane",
    class="option2",
    visible = FALSE,
    position = c(-0.3, message_height-1.2, -2),
    color = COLOR_PLANE,
    height = 0.5,
    width = 0.5
  )
  
  option_three_label <- a_label(
    text = evaluation_questions[[1]]$answerThree,
    id = "optionThreeText",
    color = COLOR_TEXT,
    font = "mozillavr",
    height = 3,
    width = 2,
    position = c(0, 0.05, 0)
  )
  
  option_three_plane <- a_entity(
    .tag = "plane",
    .children = list(option_three_label),
    raycaster_listen = "",
    id = "optionThreePlane",
    class="option3",
    visible = FALSE,
    position = c(0.3, message_height-0.6, -2),
    color = COLOR_PLANE,
    height = 0.5,
    width = 0.5
  )
  
  option_four_label <- a_label(
    text = evaluation_questions[[1]]$answerFour,
    id = "optionFourText",
    color = COLOR_TEXT,
    font = "mozillavr",
    height = 3,
    width = 2,
    position = c(0, 0.05, 0)
  )
  
  option_four_plane <- a_entity(
    .tag = "plane",
    .children = list(option_four_label),
    raycaster_listen = "",
    id = "optionFourPlane",
    class="option4",
    visible = FALSE,
    position = c(0.3, message_height-1.2, -2),
    color = COLOR_PLANE,
    height = 0.5,
    width = 0.5
  )
  
  list_of_children_entities[[list_length + 1]] <<- question_plane # assign(q_number, question_plane)
  list_of_children_entities[[list_length + 2]] <<- post_plane
  list_of_children_entities[[list_length + 3]] <<- option_one_plane
  list_of_children_entities[[list_length + 4]] <<- option_two_plane
  list_of_children_entities[[list_length + 5]] <<- option_three_plane
  list_of_children_entities[[list_length + 6]] <<- option_four_plane
}