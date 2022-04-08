library(r2vr)

IPv4_ADDRESS <- find_IP() # Note: If not on Windows, enter IP directly

# set_user("Firstname-Lastname") # default to be overridden
set_user("Gold-Standard")

## OPTIONAL: '?set_marker_and_props' shows configuration options
# i.e. Number of markers and size of markers, but keep "3d"
set_marker_and_props("3d", 20) 

## OPTIONAL: '?set_colors'
set_colors()

# 130010712.jpg
### TODO: All image points have isCoral set to 0 and need to be annotated
img1Points = list(
  list(id = 1, x = -0.635719096717973, y = -0.559076868185302, z = 0.532253967132419, isCoral = 0), # e.g. Coral/Not Coral - Hard Coral / Sand
  list(id = 2, x = 0.11002160221726, y = -0.919201260096651, z = -0.378106189426035, isCoral = 0), # TODO: change: e.g. Coral - Hard Coral
  list(id = 3, x = 0.4020168212195, y = -0.778777269414547, z = 0.481547962408513, isCoral = 0),
  list(id = 4, x = 0.18522025240936, y = -0.424382221323645, z = 0.886336949653924, isCoral = 0),
  list(id = 5, x = 0.228054080660746, y = -0.598287532680161, z = -0.768142802175134, isCoral = 0),
  list(id = 6, x = -0.394036058938119, y = -0.667785409230024, z = -0.631504735909402, isCoral = 0),
  list(id = 7, x = -0.448505398127273, y = -0.378852623036549, z = 0.80951442103833, isCoral = 0),
  list(id = 8, x = 0.581226293763736, y = -0.5250325611766, z = -0.621704757213593, isCoral = 0),
  list(id = 9, x = 0.247756016791279, y = -0.949406993403767, z = 0.192985276691616, isCoral = 0), 
  list(id = 10, x = -0.322785078280407, y = -0.753127110206935, z = 0.573244580533355, isCoral = 0),
  list(id = 11, x = -0.220426988945576 , y = -0.971593315593853 , z = -0.0861299694515765, isCoral = 0),
  list(id = 12, x = -0.719527832018227 , y = -0.430690836388991 , z = -0.5447798660025, isCoral = 0),
  list(id = 13, x = -0.302886903416526, y = -0.817147550607321, z = -0.490437971893698, isCoral = 0),
  list(id = 14, x = -0.341145161234973, y = -0.893839732014959, z = -0.290981979575008, isCoral = 0),
  list(id = 15, x = 0.156354196929794, y = -0.98670341567822, z = -0.0443816920742393, isCoral = 0),
  list(id = 16, x = -0.722671792859104, y = -0.312586267133621, z = 0.616470036096871, isCoral = 0),
  list(id = 17, x = 0.12293720953025, y = -0.756244863113315, z = -0.642635316122323, isCoral = 0),
  list(id = 18, x = -0.899777135547457, y = -0.42741028322943, z = -0.0878723855130374, isCoral = 0),
  list(id = 19, x = 0.50020528808911, y = -0.808931975507928, z = 0.30890731420368, isCoral = 0),
  list(id = 20, x = -0.097499420289735, y = -0.792844249201617, z = -0.601574483793229, isCoral = 0)
)

# 140040045.jpg
img2Points = list(
  list(id = 1, x = 0.594898269501156 , y = -0.487906233530624 , z = 0.638782870955765, isCoral = 0),
  list(id = 2, x = 0.236554238200567 , y = -0.645350804079801 , z = -0.726336307823658, isCoral = 0),
  list(id = 3, x = 0.547976073105187, y = -0.114579432574326, z = 0.828609544318169, isCoral = 0),
  list(id = 4, x = 0.797015956343955, y = -0.360389948631791, z = 0.484648996964097, isCoral = 0),
  list(id = 5, x = -0.14770616703761, y = -0.906159160810476, z = 0.39630602253601, isCoral = 0),
  list(id = 6, x = -0.313234020581858, y = -0.836287192918066, z = -0.450009088031948, isCoral = 0),
  list(id = 7, x = 0.168683003136405, y = -0.759263419505305, z = 0.62854204652831, isCoral = 0),
  list(id = 8, x = 0.0406852632158069, y = -0.972173054101855, z = -0.230703840963542, isCoral = 0),
  list(id = 9, x = -0.374856833619196, y = -0.89516984015876, z = 0.241149977315217, isCoral = 0),
  list(id = 10, x = 0.777658751954558, y = -0.231839698914556, z = 0.584377634339035, isCoral = 0),
  list(id = 11, x = 0.314134593326275, y = -0.918706281225413, z = 0.239370478782803, isCoral = 0),
  list(id = 12, x = -0.715726526132113, y = -0.686356787667586, z = 0.129034490790218, isCoral = 0),
  list(id = 13, x = 0.59461309347335, y = -0.659562186395174, z = 0.459796684794128, isCoral = 0),
  list(id = 14, x = -0.341145161234973, y = -0.893839732014959, z = -0.290981979575008, isCoral = 0),
  list(id = 15, x = 0.156354196929794, y = -0.98670341567822, z = -0.0443816920742393, isCoral = 0),
  list(id = 16, x = -0.281212242109177, y = -0.957670955209865, z = -0.0615306138060987, isCoral = 0),
  list(id = 17, x = 0.12293720953025, y = -0.756244863113315, z = -0.642635316122323, isCoral = 0),
  list(id = 18, x = -0.404247990134697, y = -0.509116358390693, z = 0.759857944678515, isCoral = 0),
  list(id = 19, x = 0.50020528808911, y = -0.808931975507928, z = 0.30890731420368, isCoral = 0),
  list(id = 20, x = -0.097499420289735, y = -0.792844249201617, z = -0.601574483793229, isCoral = 0)
)

# 110060902.jpg
img3Points = list(
  list(id = 1, x = -0.779392538236776, y = -0.114969218422822, z = -0.615897191222757, isCoral = 0),
  list(id = 2, x = 0.11002160221726, y = -0.919201260096651, z = -0.378106189426035, isCoral = 0),
  list(id = 3, x = 0.4020168212195, y = -0.778777269414547, z = 0.481547962408513, isCoral = 0), #
  list(id = 4, x = 0.158881065756252, y = -0.760924101999447, z = 0.629087687004358, isCoral = 0),
  list(id = 5, x = 0.228054080660746, y = -0.598287532680161, z = -0.768142802175134, isCoral = 0),
  list(id = 6, x = -0.394036058938119, y = -0.667785409230024, z = -0.631504735909402, isCoral = 0),
  list(id = 7, x = -0.0500841809063547, y = -0.590089813396383, z = -0.805782592855394, isCoral = 0),
  list(id = 8, x = 0.581226293763736, y = -0.5250325611766, z = -0.621704757213593, isCoral = 0),
  list(id = 9, x = 0.247756016791279, y = -0.949406993403767, z = 0.192985276691616, isCoral = 0),
  list(id = 10, x = -0.080186616766328, y = -0.805003239524905, z = -0.587826412171125, isCoral = 0),
  list(id = 11, x = 0.314134593326275, y = -0.918706281225413, z = 0.239370478782803, isCoral = 0),
  list(id = 12, x = 0.148836482248288, y = -0.892347843946891, z = 0.42610213207081, isCoral = 0),
  list(id = 13, x = -0.390945752748735, y = -0.774195452732033, z = -0.497777881566435, isCoral = 0),
  list(id = 14, x = -0.341145161234973, y = -0.893839732014959, z = -0.290981979575008, isCoral = 0),
  list(id = 15, x = 0.156354196929794, y = -0.98670341567822, z = -0.0443816920742393, isCoral = 0),
  list(id = 16, x = -0.281212242109177, y = -0.957670955209865, z = -0.0615306138060987, isCoral = 0),
  list(id = 17, x = -0.598870724286725, y = -0.751802632184096, z = 0.275946838781238, isCoral = 0),
  list(id = 18, x = 0.515218282463182, y = -0.15422199182064, z = -0.843069213442504, isCoral = 0),
  list(id = 19, x = 0.50020528808911, y = -0.808931975507928, z = 0.30890731420368, isCoral = 0),
  list(id = 20, x = -0.64089968822928, y = -0.757375666561513, z = -0.12501875590533, isCoral = 0)
)

R2VR_CDN <- "https://cdn.jsdelivr.net/gh/ACEMS/r2vr@master"

R2VR_3D_IMAGES <- paste0(R2VR_CDN, "/inst/ext/images/3d_testing/")

# NOTE: If have other local images on PC can change img_paths to be a vector of relative file location for the current working directory
img_paths <- paste0(
  R2VR_3D_IMAGES,
  c("130010712.jpg",
    "140040045.jpg",
    "110060902.jpg")
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
  list(img = img_paths[1], img_points = select_random_fixed_points(img1Points, 20)),
  list(img = img_paths[2], img_points = select_random_fixed_points(img2Points, 20)),
  list(img = img_paths[3], img_points = select_random_fixed_points(img3Points, 20))
)

set_random_images(img_paths_and_points)

evaluation_questions <- list(
  list(question = "How much did the visual display quality interfere or distract you from performing assigned tasks or required activities?", answerOne = "Not at all", answerTwo = "A bit", answerThree = "A lot", answerFour = "Completely"),
  list(question = "How involved were you in the virtual environment experience?", answerOne = "Not at all", answerTwo = "A bit", answerThree = "A lot", answerFour = "Completely"),
  list(question = "Did you find completing the training helpful to annotate the testing images more accurately?", answerOne = "Not at all", answerTwo = "A bit", answerThree = "A lot", answerFour = "Completely")
)

## OPTIONAL: '?set_questions_and_responses'
set_questions_and_responses(evaluation_questions)

animals <- shared_setup_scene("3d", "testing") # DON'T CHANGE

# vignette("testing_3d", package = "r2vr")

## COMMANDS - 3D Testing ##

# rm(list=ls())
# start()
# fixed_markers()
# go_to()
# go_to()
# ask_question(1)
# ask_question(2)
# ask_question(3)
# end()
# testing_3d.df <- read("https://r2vr.herokuapp.com/api/3d/testing")
# evaluation_3d.df <- read("https://r2vr.herokuapp.com/api/3d/evaluation")
# rm(list=ls())