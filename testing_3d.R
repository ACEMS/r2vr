library(r2vr)

IPv4_ADDRESS <- find_IP() # Note: If not on Windows, enter IP directly

## TODO: SET full name here
# set_user("Firstname-Lastname") # default to be overridden
set_user("Jon-Peppinck")

## OPTIONAL: '?set_marker_and_props' shows configuration options
# i.e. Number of markers and size of markers, but keep "3d"
set_marker_and_props("3d") 

## OPTIONAL: '?set_colors'
# set_colors()
# set_colors(
#   marker = "#0000FF",
#   coral = "#FF00FF",
#   not_coral = "#FFFF00",
#   text = "#FFFFFF",
#   plane = "#000000",
#   check_correct = "#00FFFF",
#   check_incorrect = "#FFDDAA",
#   evaluation_selection = "#FF0000",
#   cursor = "#00FF00"
# )
set_colors()

R2VR_CDN <- "https://cdn.jsdelivr.net/gh/ACEMS/r2vr@master"

R2VR_3D_IMAGES <- paste0(R2VR_CDN, "/inst/ext/images/3d_testing/")

# TODO: Select images
# NOTE: If have other local images on PC can change img_paths to be a vector of relative file location for the current working directory
img_paths <- paste0(
  R2VR_3D_IMAGES,
  c("130010712.jpg",
    "140040045.jpg",
    "110060902.jpg")
)


img_paths_and_points <- list(
  # 3D image paths
  list(img = img_paths[1]),
  list(img = img_paths[2]),
  list(img = img_paths[3])
)

set_random_images(img_paths_and_points)

## TODO: SET evaluation question and responses here
evaluation_questions <- list(
  list(question = "Did you enjoy this experiment?", answerOne = "Very much", answerTwo = "Yes", answerThree = "A little", answerFour = "No"),
  list(question = "On a scale of 1-4, how would you rate your experience?", answerOne = "1", answerTwo = "2", answerThree = "3", answerFour = "4")
)

## OPTIONAL: '?set_questions_and_responses'
set_questions_and_responses(evaluation_questions)

animals <- shared_setup_scene("3d", "testing") # DON'T CHANGE

# vignette("testing_3d", package = "r2vr")

## COMMANDS - 3D Testing ##

# rm(list=ls())
# start()
# randomize_markers()
# go_to()
# go_to()
# ask_question(1)
# ask_question(2)
# end()
# testing_3d.df <- read("https://r2vr.herokuapp.com/api/3d/testing")
# evaluation_3d.df <- read("https://r2vr.herokuapp.com/api/3d/evaluation")
# rm(list=ls())