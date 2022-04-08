library(r2vr)

IPv4_ADDRESS <- find_IP() # Note: If not on Windows, enter IP directly

# set_user("Firstname-Lastname") # default to be overridden
set_user("EXP-H")

## OPTIONAL: '?set_marker_and_props' shows configuration options
# i.e. Number of markers and size of markers, but keep "2d"
# set_marker_and_props("2d") 
set_marker_and_props("2d", 10, "small")

## OPTIONAL: '?set_colors'
set_colors()

R2VR_CDN <- "https://cdn.jsdelivr.net/gh/ACEMS/r2vr@master"

R2VR_2D_IMAGES <- paste0(R2VR_CDN, "/inst/ext/images/2d_testing/")

# 56017030401.jpeg
img1Points = list(
  list(id = 1, x = 3194, y = 1284, isCoral = 1), # Coral - Hard Coral 
  list(id = 2, x = 3625, y = 1525, isCoral = 1), # Coral - Hard Coral
  list(id = 3, x = 2191, y = 794, isCoral = 0), # Not Coral - Algae
  list(id = 4, x = 2397, y = 981, isCoral = 0), # Not Coral - Algae
  list(id = 5, x = 1672, y = 1606, isCoral = 0), # Not Coral - Algae
  list(id = 6, x = 2194, y = 2581, isCoral = 0), # Not Coral - Algae
  list(id = 7, x = 2956, y = 2828, isCoral = 0), # Not Coral - Algae
  list(id = 8, x = 631, y = 175, isCoral = 0), # Not Coral - sand
  list(id = 9, x = 2472, y = 313, isCoral = 0), # Not Coral - sand
  list(id = 10, x = 1591, y = 906, isCoral = 0), # Not Coral - sand
  list(id = 11, x = 447, y = 1372, isCoral = 0), # Not Coral - sand
  list(id = 12, x = 447, y = 1784, isCoral = 0), # Not Coral - sand
  list(id = 13, x = 1213, y = 2053, isCoral = 0), # Not Coral - sand
  list(id = 14, x = 1938, y = 2069, isCoral = 0), # Not Coral - sand
  list(id = 15, x = 913, y = 2250, isCoral = 0), # Not Coral - sand
  list(id = 16, x = 3034, y = 2334, isCoral = 0), # Not Coral - sand
  list(id = 17, x = 1034, y = 2400, isCoral = 0), # Not Coral - sand
  list(id = 18, x = 3138, y = 2478, isCoral = 0), # Not Coral - sand
  list(id = 19, x = 788, y = 2531, isCoral = 0), # Not Coral - sand
  list(id = 20, x = 931, y = 2822, isCoral = 0) # Not Coral - sand
)

# 51017045001.jpeg
img2Points = list(
  list(id = 1, x = 2153, y = 1726, isCoral = 0), # Not Coral - Algae
  list(id = 2, x = 448, y = 2799, isCoral = 0), # Not Coral - Algae
  list(id = 3, x = 1543, y = 194, isCoral = 1), # Coral - Hard Coral
  list(id = 4, x = 3415, y = 408, isCoral = 1), # Coral - Hard Coral
  list(id = 5, x = 1458, y = 470, isCoral = 1), # Coral - Hard Coral
  list(id = 6, x = 1902, y = 504, isCoral = 1), # Coral - Hard Coral
  list(id = 7, x = 661, y = 716, isCoral = 1), # Coral - Hard Coral
  list(id = 8, x = 2020, y = 781, isCoral = 1), # Coral - Hard Coral
  list(id = 9, x = 2442, y = 840, isCoral = 1), # Coral - Hard Coral
  list(id = 10, x = 1965, y = 1195, isCoral = 1), # Coral - Hard Coral
  list(id = 11, x = 3665, y = 1208, isCoral = 1), # Coral - Hard Coral
  list(id = 12, x = 1279, y = 1405, isCoral = 1), # Coral - Hard Coral
  list(id = 13, x = 434, y = 1492, isCoral = 1), # Coral - Hard Coral
  list(id = 14, x = 2332, y = 1563, isCoral = 1), # Coral - Hard Coral
  list(id = 15, x = 3413, y = 1576, isCoral = 1), # Coral - Hard Coral
  list(id = 16, x = 1895, y = 1924, isCoral = 1), # Coral - Hard Coral
  list(id = 17, x = 1268, y = 1949, isCoral = 1), # Coral - Hard Coral
  list(id = 18, x = 1471, y = 2145, isCoral = 1), # Coral - Hard Coral
  list(id = 19, x = 3734, y = 2216, isCoral = 1), # Coral - Hard Coral
  list(id = 20, x = 3088, y = 2334, isCoral = 1) # Coral - Hard Coral
)

# 58036392301.jpeg
img3Points = list(
  list(id = 1, x = 1543, y = 1258, isCoral = 1), # Coral - Hard Coral
  list(id = 2, x = 345, y = 358, isCoral = 0), # Other - Mobile Invertebrate
  list(id = 3, x = 1140, y = 1970, isCoral = 0), # Other - Mobile Invertebrate
  list(id = 4, x = 3025, y = 405, isCoral = 0), # Not Coral - Algae
  list(id = 5, x = 1388, y = 970, isCoral = 0), # Not Coral - Algae
  list(id = 6, x = 3628, y = 1080, isCoral = 0), # Not Coral - Algae
  list(id = 7, x = 935, y = 1585, isCoral = 0), # Not Coral - Algae
  list(id = 8, x = 2980, y = 2400, isCoral = 0), # Not Coral - Algae
  list(id = 9, x = 2123, y = 268, isCoral = 0), # Not Coral - sand
  list(id = 10, x = 1055, y = 468, isCoral = 0), # Not Coral - sand
  list(id = 11, x = 2590, y = 493, isCoral = 0), # Not Coral - sand
  list(id = 12, x = 1705, y = 528, isCoral = 0), # Not Coral - sand
  list(id = 13, x = 278, y = 673, isCoral = 0), # Not Coral - sand
  list(id = 14, x = 2290, y = 1223, isCoral = 0), # Not Coral - sand
  list(id = 15, x = 2808, y = 1395, isCoral = 0), # Not Coral - sand
  list(id = 16, x = 3398, y = 1598, isCoral = 0), # Not Coral - sand
  list(id = 17, x = 3475, y = 2290, isCoral = 0), # Not Coral - sand
  list(id = 18, x = 1613, y = 2505, isCoral = 0), # Not Coral - sand
  list(id = 19, x = 2720, y = 2760, isCoral = 0), # Not Coral - sand
  list(id = 20, x = 2520, y = 1953, isCoral = 0) # Not Coral - sand
)

img_paths <- paste0(
  R2VR_2D_IMAGES,
  c("56017030401.jpeg",
    "51017045001.jpeg",
    "58036392301.jpeg")
)

select_random_fixed_points <- function(img_points, number_to_select) {
  selected_points <-  sample(img_points, number_to_select, replace = FALSE)
  for (i in 1:length(selected_points)) {
    selected_points[[i]]$id <- i
  } 
  return(selected_points)
}

img_paths_and_points <- list(
  # 2D image paths  4000x3000
  list(img = img_paths[1], img_points = select_random_fixed_points(img1Points, 10)),
  list(img = img_paths[2], img_points = select_random_fixed_points(img2Points, 10)),
  list(img = img_paths[3], img_points = select_random_fixed_points(img3Points, 10))
)

set_random_images(img_paths_and_points) # TODO: allow for img_paths w/o points (training)

evaluation_questions <- list(
  list(question = "How much did the visual display quality interfere or distract you from performing assigned tasks or required activities?", answerOne = "Not at all", answerTwo = "A bit", answerThree = "A lot", answerFour = "Completely"),
  list(question = "How involved were you in the virtual environment experience?", answerOne = "Not at all", answerTwo = "A bit", answerThree = "A lot", answerFour = "Completely"),
  list(question = "Did you find completing the training helpful to annotate the testing images more accurately?", answerOne = "Not at all", answerTwo = "A bit", answerThree = "A lot", answerFour = "Completely")
)

## OPTIONAL: '?set_questions_and_responses'
set_questions_and_responses(evaluation_questions)

animals <- shared_setup_scene("2d", "testing") # DON'T CHANGE

# vignette("testing_2d", package = "r2vr")

## COMMANDS - 2D Testing ##

# rm(list=ls())
# start()
# randomize_markers() ## Testing
# fixed_markers() ## Experiment Testing - random 10 from 20 fixed
# go_to()
# go_to()
# ask_question(1)
# ask_question(2)
# ask_question(3)
# end()
# testing_2d.df <- read("https://r2vr.herokuapp.com/api/2d/testing")
# evaluation_2d.df <- read("https://r2vr.herokuapp.com/api/2d/evaluation")
# rm(list=ls())