library(r2vr)

IPv4_ADDRESS <- find_IP() # Note: If not on Windows, enter IP directly

## TODO: SET full name here
# set_user("Firstname-Lastname") # default to be overridden
set_user("Jon-Peppinck")

## OPTIONAL: '?set_marker_and_props' shows configuration options
# i.e. Number of markers and size of markers, but keep "2d"
# e.g. set_marker_and_props("2d", 15, "small") 
set_marker_and_props("2d")


## OPTIONAL: '?set_colors'
# e.g. set_colors(coral = "#FFFF00", not_coral = "#FF00FF", evaluation_selection = "#0000FF")
set_colors()
# set_colors(coral = "#FFFF00", not_coral = "#FF00FF", evaluation_selection = "#0000FF")

## TODO: SET the 'Gold Standard points' for the corresponding 'img_paths' (set below)
# Note: images are 4000x3000 (px) i.e. 0 <= x <= 4000, 0 <= y <= 3000
img1Points = list(
  list(id = 1, x = 3203, y = 173, isCoral = 0), ## sand (TODO)
  list(id = 2, x = 1726, y = 356, isCoral = 0),
  list(id = 3, x = 2291, y = 1086, isCoral = 0)
)

img2Points = list(
  list(id = 1, x = 1000, y = 1000, isCoral = 0),
  list(id = 2, x = 2000, y = 2000, isCoral = 0)
)

img3Points = list(
  list(id = 1, x = 300, y = 300, isCoral = 0),
  list(id = 2, x = 800, y = 800, isCoral = 0)
)

img4Points = list(
  list(id = 1, x = 800, y = 800, isCoral = 0),
  list(id = 2, x = 1500, y = 1500, isCoral = 0)
)

# NOTE: The center point of the marker will be at both corners => enough space needs to be allowed for the marker and potentially the menu options as well
img5Points = list(
  list(id = 1, x = 0, y = 0, isCoral = 0),
  list(id = 2, x = 4000, y = 3000, isCoral = 0)
)

R2VR_CDN <- "https://cdn.jsdelivr.net/gh/ACEMS/r2vr@experiment" # NOTE: Subject to change

R2VR_2D_IMAGES <- paste0(R2VR_CDN, "/inst/ext/images/2d/")

# TODO: Select images (4000x3000px)
# NOTE: If have other local images on PC can change img_paths to be a vector of relative file location for the current working directory
img_paths <- paste0(
  R2VR_2D_IMAGES,
  c("49001074001.jpeg",
    "49002256001.jpeg",
    "51010026001.jpeg",
    "49004035001.jpeg",
    "50003181001.jpeg")
)

img_paths_and_points <- list(
  # 2D image paths  4000x3000
  list(img = img_paths[1], img_points = img1Points),
  list(img = img_paths[2], img_points = img2Points),
  list(img = img_paths[3], img_points = img3Points),
  list(img = img_paths[4], img_points = img4Points),
  list(img = img_paths[5], img_points = img5Points)
)

set_random_images(img_paths_and_points)

animals <- shared_setup_scene("2d", "training") # DON'T CHANGE


## COMMANDS - 2D TRAINING ##

# start()
# fixed_markers()
# go_to()
# go_to()
# check(1)
# check(2)
# check(3)
# end()
# data.df <- read("https://r2vr.herokuapp.com/api/2d/training") # TODO: deploy
# rm(list=ls())