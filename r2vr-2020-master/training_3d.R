library(r2vr)

IPv4_ADDRESS <- find_IP() # Note: If not on Windows, enter IP directly

# set_user("Firstname-Lastname") # default to be overridden
set_user("EXP-H")

## OPTIONAL: '?set_marker_and_props' shows configuration options
# i.e. Number of markers and size of markers, but keep "3d"
set_marker_and_props("3d")
# set_marker_and_props("3d", marker_size = "extra-large") 

## OPTIONAL: '?set_colors'
# e.g. set_colors(coral = "#FFFF00", not_coral = "#FF00FF", evaluation_selection = "#0000FF")
set_colors()

# '?random_fixed_3d_marker()'
# Note: change 'id' and 'isCoral' and remove ',' for last random fixed marker generated
# 100030039.jpg
img1Points = list(
  list(id = 1, x = -0.635719096717973, y = -0.559076868185302, z = 0.532253967132419, isCoral = 1), # Coral - Hard corals?
  list(id = 2, x = 0.11002160221726, y = -0.919201260096651, z = -0.378106189426035, isCoral = 1), # Coral - Hard corals?
  list(id = 3, x = 0.4020168212195, y = -0.778777269414547, z = 0.481547962408513, isCoral = 1), # Coral - Hard corals?
  list(id = 4, x = 0.18522025240936, y = -0.424382221323645, z = 0.886336949653924, isCoral = 1), # Coral - Hard corals?
  list(id = 5, x = 0.337620467181165, y = -0.022623316592305, z = 0.941010417416692, isCoral = 1), # Coral - Hard corals?
  list(id = 6, x = -0.0346468959746449, y = -0.981810188606288, z = -0.186677117366344, isCoral = 1), # Coral - Hard corals?
  list(id = 7, x = -0.375322088954052, y = -0.913977365707525, z = 0.154203451704234, isCoral = 1), # Coral - Hard corals?
  list(id = 8, x = -0.105114700742732, y = -0.0908423346825567, z = 0.990302261896431, isCoral = 1), # Coral - Hard corals?
  list(id = 9, x = 0.247756016791279, y = -0.949406993403767, z = 0.192985276691616, isCoral = 1), # Coral - Hard corals?
  list(id = 10, x = -0.48934273520074, y = -0.117741205216415, z = 0.864106877706945, isCoral = 1) # Coral - Hard corals?
)

#  "120050111.jpg
img2Points = list(
  list(id = 1, x = -0.220426988945576 , y = -0.971593315593853 , z = -0.0861299694515765, isCoral = 0), # Not Coral - sand
  list(id = 2, x = -0.719527832018227 , y = -0.430690836388991 , z = -0.5447798660025, isCoral = 0), # Not Coral - sand
  list(id = 3, x = -0.302886903416526, y = -0.817147550607321, z = -0.490437971893698, isCoral = 0),# Not Coral - sand
  list(id = 4, x = -0.58263228871045, y = -0.793120574518062, z = -0.177480619866401, isCoral = 0), # Not Coral - sand
  list(id = 5, x = 0.156354196929794, y = -0.98670341567822, z = -0.0443816920742393, isCoral = 0), # Not Coral - sand
  list(id = 6, x = -0.722671792859104, y = -0.312586267133621, z = 0.616470036096871, isCoral = 0), # Not Coral - sand
  list(id = 7, x = 0.19802350334778, y = -0.772452220134257, z = 0.603410523384809, isCoral = 0), # Not Coral - sand
  list(id = 8, x = -0.899777135547457, y = -0.42741028322943, z = -0.0878723855130374, isCoral = 0), # Not Coral - sand
  list(id = 9, x = 0.50020528808911, y = -0.808931975507928, z = 0.30890731420368, isCoral = 0), # Not Coral - sand
  list(id = 10, x = 0.419052650614953, y = -0.758202959137444, z = 0.499522921163589, isCoral = 0) # Not Coral - sand
)

# 150280102.jpg
img3Points = list(
  list(id = 1, x = 0.594898269501156 , y = -0.487906233530624 , z = 0.638782870955765, isCoral = 0), # Not Coral - sand
  list(id = 2, x = 0.236554238200567 , y = -0.645350804079801 , z = -0.726336307823658, isCoral = 0), # Not Coral - sand
  list(id = 3, x = 0.547976073105187, y = -0.114579432574326, z = 0.828609544318169, isCoral = 0), # Not Coral - sand
  list(id = 4, x = -0.908835087374138, y = -0.178000075035359, z = -0.377272788900882, isCoral = 0), # Not Coral - water
  list(id = 5, x = -0.14770616703761, y = -0.906159160810476, z = 0.39630602253601, isCoral = 0), # Not Coral - sand
  list(id = 6, x = -0.313234020581858, y = -0.836287192918066, z = -0.450009088031948, isCoral = 0), # Not Coral - sand
  list(id = 7, x = 0.270182517549586, y = -0.761299242508919, z = 0.589427578728646, isCoral = 0), # Not Coral - sand
  list(id = 8, x = -0.858672619307233, y = -0.312995516268783, z = 0.405851129908115, isCoral = 0), # Not Coral - sand
  list(id = 9, x = 0.0313647288065982, y = -0.955378198219304, z = -0.293715427163988, isCoral = 0), # Not Coral - sand
  list(id = 10, x = 0.777658751954558, y = -0.231839698914556, z = 0.584377634339035, isCoral = 0) # Not Coral - sand
)


R2VR_CDN <- "https://cdn.jsdelivr.net/gh/ACEMS/r2vr@master"

R2VR_3D_IMAGES <- paste0(R2VR_CDN, "/inst/ext/images/3d_training/")

# NOTE: If have other local images on PC can change img_paths to be a vector of relative file location for the current working directory
img_paths <- paste0(
  R2VR_3D_IMAGES,
  c("100030039.jpg",
    "120050111.jpg",
    "150280102.jpg")
)

img_paths_and_points <- list(
  # 3D image paths
  list(img = img_paths[1], img_points = img1Points),
  list(img = img_paths[2], img_points = img2Points),
  list(img = img_paths[3], img_points = img3Points)
)

set_random_images(img_paths_and_points)

animals <- shared_setup_scene("3d", "training") # DON'T CHANGE


# vignette("training_3d", package = "r2vr")

## COMMANDS - 3D TRAINING ##

# start()
# fixed_markers()
# go_to()
# go_to()
# check(1)
# check(2)
# check(3)
# end()
# training_3d.df <- read("https://r2vr.herokuapp.com/api/3d/training")
# rm(list=ls())