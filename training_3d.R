library(r2vr)

IPv4_ADDRESS <- find_IP() # Note: If not on Windows, enter IP directly

## TODO: SET full name here
# set_user("Firstname-Lastname") # default to be overridden
set_user("Jon-Peppinck")

## OPTIONAL: '?set_marker_and_props' shows configuration options
# i.e. Number of markers and size of markers, but keep "3d"
set_marker_and_props("3d")
# set_marker_and_props("3d", marker_size = "extra-large") 

## OPTIONAL: '?set_colors'
# e.g. set_colors(coral = "#FFFF00", not_coral = "#FF00FF", evaluation_selection = "#0000FF")
set_colors()


## TODO: SET the 'Gold Standard points' for the corresponding 'img_paths' (set below)
# '?random_fixed_3d_marker()'
# Note: change 'id' and 'isCoral' and remove ',' for last random fixed marker generated
img1Points = list(
  list(id = 1, x = -0.635719096717973, y = -0.559076868185302, z = 0.532253967132419, isCoral = 1), # coral?
  list(id = 2, x = 0.11002160221726, y = -0.919201260096651, z = -0.378106189426035, isCoral = 1) # coral?
)

img2Points = list(
  list(id = 1, x = -0.220426988945576 , y = -0.971593315593853 , z = -0.0861299694515765, isCoral = 0),
  list(id = 2, x = -0.719527832018227 , y = -0.430690836388991 , z = -0.5447798660025, isCoral = 0), 
  list(id = 3, x = 0.972865988610512 , y = -0.0633466723423909 , z = -0.22252857638523, isCoral = 0) 
)

img3Points = list(
  list(id = 1, x = -0.360107366234836 , y = -0.153838364908118 , z = 0.920139360241592, isCoral = 0),
  list(id = 2, x = 0.66401612970315 , y = -0.53627251455049 , z = -0.521051215939224, isCoral = 0), 
  list(id = 3, x = 0.594898269501156 , y = -0.487906233530624 , z = 0.638782870955765, isCoral = 0) 
)

img4Points = list(
  list(id = 1, x = 0.236554238200567 , y = -0.645350804079801 , z = -0.726336307823658, isCoral = 0),
  list(id = 2, x = 0.560689468806834 , y = -0.295637517136722 , z = -0.773450565990061, isCoral = 0), 
  list(id = 3, x = -0.741564092459525 , y = -0.0768210007796801 , z = -0.66646922705695, isCoral = 0) 
)

R2VR_CDN <- "https://cdn.jsdelivr.net/gh/ACEMS/r2vr@experiment" # NOTE: Subject to change

R2VR_3D_IMAGES <- paste0(R2VR_CDN, "/inst/ext/images/3d/")

# TODO: Select images
# NOTE: If have other local images on PC can change img_paths to be a vector of relative file location for the current working directory
img_paths <- paste0(
  R2VR_3D_IMAGES,
  c("100030039.jpg",
    "120261897.jpg",
    "130030287.jpg",
    "130050093.jpg")
)

img_paths_and_points <- list(
  # 3D image paths
  list(img = img_paths[1], img_points = img1Points),
  list(img = img_paths[2], img_points = img2Points),
  list(img = img_paths[3], img_points = img3Points),
  list(img = img_paths[4], img_points = img4Points)
)

set_random_images(img_paths_and_points)

animals <- shared_setup_scene("3d", "training") # DON'T CHANGE


## COMMANDS - 3D TRAINING ##

# start()
# fixed_markers()
# go_to()
# go_to()
# check(1)
# check(2)
# check(3)
# end()
# data.df <- read("https://r2vr.herokuapp.com/api/3d/training") # TODO: deploy
# rm(list=ls())