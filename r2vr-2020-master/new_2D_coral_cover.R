library(r2vr)

# library(RMySQL)
# library(dbConnect)
library(httr)
library(jsonlite)

## Connect IP
IPv4_ADDRESS <- find_IP() 

## Set observer here
user <- "Jon"

# Set initial number of points to 0
# TODO: is needed?
numberOfPoints <- 0

## Set total number of points here
## NOTE: Do not exceed 20
MAX_NUMBER_OF_POINTS <- 20

# ## Change Number of points here
# number_of_points <- 5
# 
# ## Set marker radius
inner_radius = 0.05 # 0.08
outer_radius = inner_radius + 0.01

## TODO: Refactor when images on master 

# r2vr_pkg <- "https://cdn.jsdelivr.net/gh/milesmcbain/r2vr@master/inst"
# img_paths <- paste0(r2vr_pkg,
#                    c("/ext/images/reef/100030039.jpg", 
#                      "/ext/images/reef/120261897.jpg", 
#                      "/ext/images/reef/130030287.jpg",
#                      "/ext/images/reef/130050093.jpg"))

img1PointsIsCoral = list(
  list(id = 1, isCoral = 0), # sand
  list(id = 2, isCoral = 0), # sand
  list(id = 3, isCoral = 0), # sand
  list(id = 4, isCoral = 0), # sand
  list(id = 5, isCoral = 0), # sand
  list(id = 6, isCoral = 0) # sand
)

img1Points = list(
  list(x = 3203, y = 173), # sand
  list(x = 1726, y = 356), # sand
  list(x = 2291, y = 1086), # sand
  list(x = 2141, y = 2163), # sand
  list(x = 2824, y = 2643), # sand
  list(x = 2335, y = 2755) # sand
)

img2Points = list(
  list(x = 1000, y = 1000),
  list(x = 2000, y = 2000)
)

img2PointsIsCoral = list(
  list(id = 1, isCoral = 0),
  list(id = 2, isCoral = 0)
)

## Relative image path

# C:\r2vr2020\r2vr\inst\ext\images\reef
img_paths <- list(
  list(img = "./2dimages/latest/49001074001.jpeg", imgPoints = img1Points, imgPointIsCoral =          img1PointsIsCoral),
  list(img = "./2dimages/latest/49002256001.jpeg", imgPoints = img2Points, imgPointIsCoral =          img2PointsIsCoral),
  list(img = "./2dimages/latest/14017099802.jpeg", imgPoints = img2Points, imgPointIsCoral =          img2PointsIsCoral),
  list(img = "./2dimages/latest/51010026001.jpeg", imgPoints = img2Points, imgPointIsCoral =          img2PointsIsCoral),
  list(img = "./2dimages/latest/49004035001.jpeg", imgPoints = img2Points, imgPointIsCoral =          img2PointsIsCoral),
  list(img = "./2dimages/latest/50003181001.jpeg", imgPoints = img2Points, imgPointIsCoral =          img2PointsIsCoral)
)
# img_paths <- c(
#   "./2dimages/latest/49001074001.jpeg", # img1
#   "./2dimages/latest/49002256001.jpeg", # img2
#   "./2dimages/latest/14017099802.jpeg",
#   "./2dimages/latest/51010026001.jpeg",
#   "./2dimages/latest/49004035001.jpeg",
#   "./2dimages/latest/50003181001.jpeg"
# )

# Randomly select 3 out of the 6 images (any order)
img_paths <- sample(img_paths, 3, replace=FALSE)

for (i in 1:length(img_paths)) {
  currentImgPath <- img_paths[[i]]$img # string
  currentImgPoints <- img_paths[[i]]$imgPoints # list of lists
  currentImgGoldStandard <- img_paths[[i]]$imgPointIsCoral # list of lists
  
  # image1, ... , image<n>, s.t. n = index of last image path
  image_number <- paste0("image", i)
  image_number_points <- paste0("image", i, "Points")
  image_number_gold_standard <- paste0("image", i, "GoldStandard")
  image_path <- paste0("image", i, "Path")
  # Create image asset with id="img<i>" (to select DOM element)
  current_image <- a_asset(
    .tag = "image",
    id = paste0("img", i),
    src = currentImgPath
  )
  # Assign image<n> variable to its corresponding image asset
  assign(image_number, current_image)
  assign(image_number_points, currentImgPoints)
  assign(image_number_gold_standard, currentImgGoldStandard)
  assign(image_path, currentImgPath)
}

## Create variables for image assets
# for (i in 1:length(img_paths)) {
#   # image1, ... , image<n>, s.t. n = index of last image path
#   image_number <- paste0("image", i)
#   # Create image asset with id="img<i>" (to select DOM element)
#   current_image <- a_asset(.tag = "image",
#                            id = paste0("img", i),
#                            src = img_paths[i])
#   # Assign image<n> variable to its corresponding image asset
#   assign(image_number, current_image)
# }

## Z-index positions
# Note: z-index of camera > z-index of entities
canvas_z = -3
marker_z = -1
camera_z = 0

## Create a canvas for the image to be attached to
canvas_2d <- a_entity(
  .tag = "plane",
  # TODO: change to CDN
  .js_sources = list(
    "https://cdn.jsdelivr.net/gh/ACEMS/r2vr@master/inst/js/button_controls.js",
    # "./inst/js/new_2D_coral_cover.js",
    "./inst/js/bundle2d.js"
    ),
  .assets = list(image2, image3),
  id = "canvas2d",
  src = image1,
  class = img_paths[[1]]$img,
  height = 3,
  width = 4, # 3
  position = c(0, 0, canvas_z)
)

## Create a cursor
cursor <- a_entity(
  .tag = "cursor",
  color = "#ff0000"
)

## Position cursor in center of camera
camera <- a_entity(
  .tag = "camera",
  .children = list(cursor),
  position = c(0, 0, camera_z)
)

## Invisble entity to store user/observer in ID for client side JS
# Note: Mimics log-in functionality => Perhaps implemented in future
user <- a_entity(
  .tag = "circle",
  id = "user",
  class = user,
  opacity = 0,
  radius = 0
)

# Evauluation Question Variables
message_height <- 1.5

# the_question <- "Indicate your difficulty using the system to annotate 2D images?"
# 
# answer_1 <- "Unable to use"
# answer_2 <- "Major difficulty"
# answer_3 <- "Minor difficulty"
# answer_4 <- "No difficulty"


questions <- list(
  list(question = "Did you enjoy this experiment?", answer1 = "Very much", answer2 = "Yes", answer3 = "A little", answer4 = "No"),
  list(question = "On a scale of 1-4, how would you rate your experience?", answer1 = "4", answer2 = "3", answer3 = "2", answer4 = "1")
)

# Colours
dark_red <- "#8c0000"
bright_red <- "#ff0000"
white <- "#ffffff"
black <- "#000000"

question_label <- a_label(
  text = questions[[1]]$question,
  id = "questionPlaneText",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0.02, 0)
)

question_plane <- a_entity(
  .tag = "plane",
  .children = list(question_label),
  id = "questionPlane",
  visible = FALSE,
  position = c(0, message_height, -2),
  color = white,
  height = 0.3,
  width = 1.1,
)

post_label <- a_label(
  text = "Submit Answer",
  id = "postText",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

post_plane <- a_entity(
  .tag = "plane",
  .children = list(post_label),
  id = "postPlane",
  visible = FALSE,
  position = c(0.8, message_height, -2),
  color = white,
  height = 0.3,
  width = 0.3,
  annotated = FALSE, # TODO: check if allowed
  option_selected = FALSE # TODO: check if needed
)

# Outer boundary for intersection detection
post_plane_boundary <- a_entity(
  .tag = "ring",
  id = "postPlaneBoundary",
  visible = FALSE,
  position = c(0.8, message_height, -2),
  color = dark_red,
  radius_inner = 0.24,
  radius_outer = 0.25,
  segments_theta = 4,
  theta_start = 45
)

option_1_label <- a_label(
  text = questions[[1]]$answer1,
  id = "option1Text",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

option_1_plane <- a_entity(
  .tag = "plane",
  .children = list(option_1_label),
  id = "option1Plane",
  visible = FALSE,
  position = c(-0.35, message_height-0.45, -2),
  color = white,
  height = 0.4,
  width = 0.4
)

# Outer boundary for intersection detection
option_1_plane_boundary <- a_entity(
  .tag = "ring",
  id = "option1Boundary",
  position = c(-0.35, message_height-0.45, -2),
  visible = FALSE,
  color = dark_red,
  radius_inner = 0.34,
  radius_outer = 0.35,
  segments_theta = 4,
  theta_start = 45
)

option_2_label <- a_label(
  text = questions[[1]]$answer2,
  id = "option2Text",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

option_2_plane <- a_entity(
  .tag = "plane",
  .children = list(option_2_label),
  id = "option2Plane",
  visible = FALSE,
  position = c(-0.35, message_height-1, -2),
  color = white,
  height = 0.4,
  width = 0.4
)

# Outer boundary for intersection detection
option_2_plane_boundary <- a_entity(
  .tag = "ring",
  id = "option2Boundary",
  position = c(-0.35, message_height-1, -2),
  visible = FALSE,
  color = dark_red,
  radius_inner = 0.34,
  radius_outer = 0.35,
  segments_theta = 4,
  theta_start = 45
)

option_3_label <- a_label(
  text = questions[[1]]$answer3,
  id = "option3Text",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

option_3_plane <- a_entity(
  .tag = "plane",
  .children = list(option_3_label),
  id = "option3Plane",
  visible = FALSE,
  position = c(0.35, message_height-0.45, -2),
  color = white,
  height = 0.4,
  width = 0.4,
)

# Outer boundary for intersection detection
option_3_plane_boundary <- a_entity(
  .tag = "ring",
  id = "option3Boundary",
  visible = FALSE,
  position = c(0.35, message_height-0.45, -2),
  color = dark_red,
  radius_inner = 0.34,
  radius_outer = 0.35,
  segments_theta = 4,
  theta_start = 45
)

option_4_label <- a_label(
  text = questions[[1]]$answer4,
  id = "option4Text",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

option_4_plane <- a_entity(
  .tag = "plane",
  .children = list(option_4_label),
  id = "option4Plane",
  visible = FALSE,
  position = c(0.35, message_height-1, -2),
  color = white,
  height = 0.4,
  width = 0.4,
)

# Outer boundary for intersection detection
option_4_plane_boundary <- a_entity(
  .tag = "ring",
  id = "option4Boundary",
  visible = FALSE,
  position = c(0.35, message_height-1, -2),
  color = dark_red,
  radius_inner = 0.34,
  radius_outer = 0.35,
  segments_theta = 4,
  theta_start = 45
)

## Initial entities
list_of_children_entities <- list(canvas_2d, camera, user, option_1_plane_boundary, option_2_plane_boundary, option_3_plane_boundary, option_4_plane_boundary, question_plane, option_1_plane, option_2_plane, option_3_plane, option_4_plane, post_plane, post_plane_boundary)
# Initital list length needed to append annotation entities via for loop
initial_list_length <- length(list_of_children_entities)

# Arbitrarily small value
epsilon = 0.00001
delta = 100*epsilon

##### START GENERATE POINTS #####

## NOTE: More efficient to generate a fixed number of points in the DOM and toggle visibility and position compared to using websockets to remove and added each time calling points()

# Capped at 20 as it is unreasonable for annotating multiple images anything more
for (i in 1:MAX_NUMBER_OF_POINTS) {
  # Invisible inner circle for cursor detection based on ID
  marker_inside <- a_entity(
    .tag = "circle",
    id= paste("marker", i, sep = ""),
    class = "marker",
    position = c(0, 0, -1),
    radius = outer_radius,
    color = "#ffffff", # TODO: Remove 
    opacity = 0
  )
  # Label for coral (C)
  coral_label <- a_label(
    id = paste0("coralText", i),
    position = c(-0.15, 0.2, 0),
    text = "C",
    color = "#000000",
    font = "mozillavr",
    height = 0.5,
    width = 2
  )
  # Coral menu option
  menu_coral <- a_entity(
    .tag = "ring",
    .children = list(coral_label),
    id= paste0("menuCoral", i),
    class = "menu-item",
    position = c(0, 0, marker_z + delta), # Note: menu is slightly closer than its container
    radius_outer = outer_radius + 0.2,
    radius_inner = outer_radius,
    theta_length = 90,
    theta_start = 90,
    color = "#FF95BC",
    visible = FALSE
  )
  # Label for not coral
  not_coral_label <- a_label(
    id = paste0("notCoralText", i),
    text = "N",
    position = c(0.15, 0.2, 0),
    height = 0.5,
    width = 2,
    color = "#000000",
    font = "mozillavr"
  )
  # Not coral menu option
  menu_not_coral <- a_entity(
    .tag = "ring",
    .children = list(not_coral_label),
    id = paste0("menuNotCoral", i),
    class = "menu-item",
    position = c(0, 0, marker_z + delta),
    radius_outer = outer_radius + 0.2,
    radius_inner = outer_radius,
    theta_length = 90,
    color = "#969696",
    visible = FALSE
  )
  # # Menu container arc
  # menu_container_arc <- a_entity(
  #   .tag = "ring",
  #   id= paste0("menuContainerArc", i), # TODO: check if needed
  #   # class = "menu-items-container",
  #   position = c(0, 0, marker_z + delta),
  #   radius_outer = outer_radius + 0.30, # TODO: consider a-text w/ delta primitive box dimensions
  #   radius_inner = outer_radius + 0.24,
  #   theta_length = 180,
  #   color = "#00FFFF",
  #   opacity = 0.7
  #   # visible = FALSE
  # )
  # 
  
  # Note: The upper boundary is covered by the menu options
  # Used for intersection detection to help close menu if option not closed and a marker is no longer selected
  menu_circumference_lower_boundary <- a_entity(
    .tag = "ring",
    id= paste0("menuCircumferenceBoundary", i),
    position = c(0, 0, marker_z + delta),
    radius_outer = outer_radius + 0.01, # TODO: check dimensions
    radius_inner = outer_radius + 0.005,
    theta_length = 180,
    theta_start = 180,
    color = "#00FFFF",
    opacity = 0
  )
  
  # Marker circumference depicts location of the marker to user
  marker_circumference <- a_entity(
    .tag = "ring",
    id = paste0("markerCircumference", i),
    class = paste0("marker-circumference", i),
    position = c(0, 0, marker_z),
    radius_outer = outer_radius,
    radius_inner = inner_radius
  )

  ## Marker container: Encapsulate a marker and its menu options inside a parent container
  marker_container <- a_entity(
    .tag = "ring",
    .children = list(marker_circumference, marker_inside, menu_coral, menu_not_coral, menu_circumference_lower_boundary),
    id = paste0("markerContainer", i),
    class = paste0("marker-container", i),
    position = c(0, 0, marker_z),
    radius_inner = epsilon,
    radius_outer = epsilon,
    color = "#000000",
    opacity = 0,
    visible = FALSE,
    marked = FALSE, # TODO: check if allowed
    debug = "" # needed for x and y position after an update via web sockets
  )

  # Add markers to the list of entities to be rendered
  marker_i <- paste0("marker", i)
  list_of_children_entities[[initial_list_length + i]] <- assign(marker_i, marker_container)
}

### END POINT GENERATION ###

# Render entities into scene
animals <- a_scene(
  .children = list_of_children_entities,
  .websocket = TRUE,
  .websocket_host = IPv4_ADDRESS,
  .template = "empty",
  button_controls = "debug: true;",
  coral_cover_2d_buttons = "",
  intersection = "" #,
  # debug = "" # https://aframe.io/docs/master/components/debug.html#sidebar
)

##### FUNCTIONS #####

## Start the server
start <- function(){
  animals$serve(host = IPv4_ADDRESS)
}

## End the server
end <- function(){
  a_kill_all_scenes()
}

## Restart the server with file changes
restart <- function(){
  a_kill_all_scenes()
  source('C:/r2vr2020/r2vr/new_2D_coral_cover.R', echo=TRUE)
  animals$serve(host = IPv4_ADDRESS)
}


## Helper function for pop2
change_message <- function(messages, is_visible){
  ## Helper function for pop()
  for(jj in 1:length(messages)){
    if(messages[[jj]]$component == "visible")
      messages[[jj]]$attributes <- is_visible
  }
  return(messages)
}

# Toggle the visibility of the markers
# pop2 <- function(visible = TRUE){
#   if (numberOfPoints)
#   ## TODO: Refactor numberOfPoints?
#   for (i in 1:numberOfPoints) {
#     show_messages <- list(
#       a_update(id = paste0("markerContainer", i),
#                component = "visible",
#                attributes = TRUE)
#     )
# 
#     visible_message <- change_message(show_messages, visible)
#     animals$send_messages(visible_message)
#   }
# }


# 
# # Connect and retrieve infomation from database
# get_db <- function(){
#
# }

######

# Create a Point constructor
Point <- R6::R6Class("Point", public = list(
  x = NA,
  y = NA,
  r = NA,
  n = NA,
  initialize = function(x, y, n, r = outer_radius) {
    stopifnot(is.numeric(x), abs(x) <= 1.34) # note: image 4000x3000 => x = 4y/3 = 1.33
    stopifnot(is.numeric(y), abs(y) <= 1)
    stopifnot(is.numeric(n))
    stopifnot(is.numeric(r), r < 0.5)

    
    self$x <- x
    self$y <- y
    self$r <- r
    self$n <- n
  })
)

euclideanDistance2d <- function(p1, p2) {
  return(sqrt((p2$x - p1$x)^2 + (p2$y - p1$y)^2)) 
}

points.list <- list()

createPoints <- function(num = 5) {
  # Reset the color of the annnotation points
  # Note: only need to reset up to what the user sees => more efficient
  resetMarkersUI(num)
  
  # reset list of points back to initial value
  points.list <<- list()
  
  # Set a guard to prevent a possible infinite loop if n is large
  guard = 0
  
  # If max number of points reached, there will be no extra points to hide
  if (num != MAX_NUMBER_OF_POINTS) {
    startNumberOfRemainingPoints <- numberOfPoints + 1
    
    ## Update the remaining points to not be visible
    for (i in startNumberOfRemainingPoints:MAX_NUMBER_OF_POINTS) {
      ## Update the position
      update_entities <- list(
        a_update(
          id = paste0("markerContainer", i),
          component = "visible",
          attributes = FALSE
        )
      )
      animals$send_messages(update_entities)
    }
  }
  
  
  # note, in first case length will be 0, thus 0 to (n - 1) <=> 1 to n
  # For every circle we wish to create...
  while (length(points.list) < num) {
    overlapping = FALSE
    
    # note: image 4000x3000 => x = 4y/3 = 1.33
    x <- runif(1, -4/3 + outer_radius, 4/3 - outer_radius) 
    y <- runif(1, -1 + outer_radius, 1 - outer_radius)
    n <- length(points.list) + 1
    
    # ...Create a new point object...
    p <- Point$new(x, y, n)
    
    if (length(points.list) > 0) {
      # ...Determine if the new point intersects with any of the other points in list... 
      for (j in 1:length(points.list)) {
        circleInList = points.list[[j]]
        # Find the distance between the new point and the point in the list
        distance = euclideanDistance2d(p, circleInList)
        
        # If the new point overlaps with any current point set overlapping to true
        if (distance < 2 * outer_radius) {
          overlapping = TRUE
          break
          
        }
      }
    }
    # If there is no overlap then new point can be added to the list
    if (!overlapping) {
      points.list[[n]] <<- p
      update_entities <- list(
        a_update(
          id = paste0("markerContainer", n),
          component = "position",
          attributes = list(x = p$x, y = p$y, z = -1)
        ),
        # Update the specified number of points to be visible
        a_update(
          id = paste0("markerContainer", n),
          component = "visible",
          attributes = TRUE
        ),
        a_update(
          id = paste0("markerContainer", n),
          component = "marked",
          attributes = FALSE
        )
      )
      animals$send_messages(update_entities)
    }
    
    # Increment the guard for each while loop iteration
    guard = guard + 1
    if (guard > 1000) break
  }
  
  # return(points.list)
  
}


# Points (X and Y Flipped from Poor_accuracy_class.csv)
	

rangeTranslation <- function(oldMax, oldMin = 0, newMax = 1 , newMin = -1) {
  translation = function(oldValue) {
    if (oldValue < 0) {
      stop('Please enter a non-negative value')
    }
    if (oldValue > oldMax || oldValue < oldMin) {
      stop(paste('Please enter a value between', oldMin, 'and', oldMax, '. You entered:', oldValue))
    }
    ## To translate a point A on a scale with range (Omin, Omax) to a point B in a range (Nmin,        Nmax) then:
    ## B = [( A - O_min)/(O_max - O_min)](N_max - N_min) + N_min
    ((oldValue - oldMin)/(oldMax - oldMin)) * (newMax - newMin) + newMin
  }
  return(translation)
}


# TODO: delete temp fn
fixedPointsTemp <- function(points) {
  ## Generate the transformation functions
  xTranslation <- rangeTranslation(4000, 0, 4/3, -4/3)
  yTranslation <- rangeTranslation(3000)
  
  for(point in 1:length(points)) {
    ## Find the transformed x and y values
    fixedCoordinateX <- xTranslation(img1Points[[point]]$x)
    fixedCoordinateY <- -yTranslation(img1Points[[point]]$y)
    
    ## Update the position for the number of points specified
    update_entities <- list(
      a_update(
        id = paste0("markerContainer", point),
        component = "position",
        attributes = list(x = fixedCoordinateX, y = fixedCoordinateY, z = -1)
      ),
      ## Update the specified number of points to be visible
      a_update(
        id = paste0("markerContainer", point),
        component = "visible",
        attributes = TRUE
      )
    )
    animals$send_messages(update_entities)
  }
  
  startNumberOfRemainingPoints <- length(points)  + 1 # TODO: check !> 20
  
  ## Update the remaining points to not be visible
  for (point in startNumberOfRemainingPoints:MAX_NUMBER_OF_POINTS) {
    ## Update the position
    update_entities <- list(
      a_update(
        id = paste0("markerContainer", point),
        component = "visible",
        attributes = FALSE
      )
    )
    animals$send_messages(update_entities)
  }  
}


# TODO: consider breaking into helper functions
points <- function(numberOfPoints = 5, fixed = FALSE){
  if (!fixed) {
    # Check non-integer arguments are not passed
    if (numberOfPoints != round(numberOfPoints) || numberOfPoints < 0) {
      stop('Please enter a non-negative integer for the number of points you wish to create.')
    }
    # Check that no numeric vectors or other types that don't evaluate to an integer have been passed
    if (length(numberOfPoints) != 1) {
      stop('Please enter a single integer for the number of points you wish to create.')
    }
    ## Note: Re-assign the number of points to 20 if argument exceeds this limit
    if (numberOfPoints > MAX_NUMBER_OF_POINTS) {
      numberOfPoints <- MAX_NUMBER_OF_POINTS
      warning(paste('The maximum of', MAX_NUMBER_OF_POINTS, 'points has been set.'))
    }
    
    # TODO: Refactor global variable?
    numberOfPoints <<- numberOfPoints
    
    # Reset the color of the annnotation points
    # Note: only need to reset up to what the user sees => more efficient
    resetMarkersUI(numberOfPoints)
    
    ## Assign a new position and display the visibility for the number of points
    for (i in 1:numberOfPoints) {
      # TODO: Fixed points: by image id?
      # Generation of points - distribution => Uniform (random)
      # Note: Canvas: -1 < x < 1, -1 < y < 1
      random_coordinate_x <- runif(1, -1 + outer_radius, 1 - outer_radius)
      random_coordinate_y <- runif(1, -1 + outer_radius, 1 - outer_radius)
      # Update the position for the number of points specified
      update_entities <- list(
        a_update(
                 id = paste0("markerContainer", i),
                 component = "position",
                 attributes = list(x = random_coordinate_x, y = random_coordinate_y, z = -1)
        ),
        # Update the specified number of points to be visible
        a_update(
                 id = paste0("markerContainer", i),
                 component = "visible",
                 attributes = TRUE
        ),
        a_update(
          id = paste0("markerContainer", i),
          component = "marked",
          attributes = FALSE
        )
      )
      animals$send_messages(update_entities)
      
    }
    # If max number of points reached, there will be no extra points to hide
    if (numberOfPoints != MAX_NUMBER_OF_POINTS) {
      startNumberOfRemainingPoints <- numberOfPoints + 1
      
      ## Update the remaining points to not be visible
      for (i in startNumberOfRemainingPoints:MAX_NUMBER_OF_POINTS) {
        ## Update the position
        update_entities <- list(
          a_update(
            id = paste0("markerContainer", i),
            component = "visible",
            attributes = FALSE
          )
        )
        animals$send_messages(update_entities)
      }
    }
  } else {
    fixedNumberOfPoints <- 10
    print('fixed data')
    init.x <- -1
    init.y <- 0
    
    x.max.px <- 4000
    y.max.px <- 3000
    
    
    # Image: 49001074001
    
    
    # Points (X and Y Flipped)
    
    # 1. x = 313, y = 2237 => Hard Corals
    # 2. x = 3453, y = 1114 => Algae
    # 3. x = 2141, y = 2163 => Sand
    # 4. x = 1780, y = 265 => Hard Corals
    # 5. x = 579, y = 589 => Hard Corals
    # 6. x = 3116, y = 403 => Hard Corals
    
    
    ## Assign a new position and display the visibility for the number of points
    
    for (i in 1:fixedNumberOfPoints ) {
      # Generation of points
      # Note: Canvas: -4/3 < x < 4/3, -1 < y < 1
      # TODO: temp only, remove
      if (i == 1) {
        random_coordinate_x <- ((2 * 313 )/((3/4) * x.max.px)) - 4/3
        random_coordinate_y <- ((2 * 2237 )/y.max.px) - 1
   
      } else if (i == 2) {
        random_coordinate_x <- ((2 * 3453 )/((3/4) * x.max.px)) - 4/3
        random_coordinate_y <- ((2 * 1114 )/y.max.px) - 1
      } else if (i == 3) {
        random_coordinate_x <- ((2 * 2141 )/((3/4) * x.max.px)) - 4/3
        random_coordinate_y <- ((2 * 2163 )/y.max.px) - 1
      } else if (i == 4) {
        random_coordinate_x <- ((2 * 1780 )/((3/4) * x.max.px)) - 4/3
        random_coordinate_y <- ((2 * 265 )/y.max.px) - 1
      } else if (i == 5) {
        random_coordinate_x <- ((2 * 579 )/((3/4) * x.max.px)) - 4/3
        random_coordinate_y <- ((2 * 589 )/y.max.px) - 1
      } else if (i == 6) {
        random_coordinate_x <- ((2 * 3116 )/((3/4) * x.max.px)) - 4/3
        random_coordinate_y <- ((2 * 403 )/y.max.px) - 1
      } else if (i == 7) {
        random_coordinate_x <- ((2 * 0 )/((3/4) * x.max.px)) - 4/3
        random_coordinate_y <- ((2 * 0 )/y.max.px) - 1
      } else if (i == 8) {
        random_coordinate_x <- ((2 * x.max.px )/((3/4) * x.max.px)) - 4/3
        random_coordinate_y <- ((2 * y.max.px )/y.max.px) - 1
      } 

      # Update the position for the number of points specified
      update_entities <- list(
        a_update(
          id = paste0("markerContainer", i),
          component = "position",
          attributes = list(x = random_coordinate_x, y = random_coordinate_y, z = -1)
        ),
        # Update the specified number of points to be visible
        a_update(
          id = paste0("markerContainer", i),
          component = "visible",
          attributes = TRUE
        )
      )
      animals$send_messages(update_entities)
    }
    
    startNumberOfRemainingPoints <- fixedNumberOfPoints  + 1
    
    ## Update the remaining points to not be visible
    for (i in startNumberOfRemainingPoints:MAX_NUMBER_OF_POINTS) {
      ## Update the position
      update_entities <- list(
        a_update(
          id = paste0("markerContainer", i),
          component = "visible",
          attributes = FALSE
        )
      )
      animals$send_messages(update_entities)
    }
  }
}

## Helper function for points() to reset annotation marker colors
resetMarkersUI <- function(numberOfPointsToReset){
  
  # TODO: check numberOfPointsToReset !> 20
  
  for (i in 1:numberOfPointsToReset) {
    # Reset marker colors
    reset_marker_colors <- list(
      a_update(
        id = paste0("markerCircumference", i),
        component = "color",
        attributes = "#FFFFFF"
      )
    )
    animals$send_messages(reset_marker_colors)
  }
  
} 

rmBox <- function(){

  rm_entities_class <- list(
    a_remove_entity_class("boxclass")
  )

  animals$send_messages(rm_entities_class)
}

addBox <- function() {

  add_entities_c <- list(
    # a_add_entity("ring", "m1"),
    # a_add_entity("ring", "m4", "classn"),
    a_add_entity("box", "boxid1", "boxclass"),
    a_add_entity("box", "boxid2", "boxclass")
  )

  animals$send_messages(add_entities_c)

  update_entities_c <- list(
    a_update(
             id = "boxid1",
             component = "position",
             attributes = list(x = 1, y = 1, z = -3)
             ),
    a_update(
             id = "boxid1",
             component = "color",
             attributes = "#FF0000"
             ),
    a_update(
      id = "boxid2",
      component = "position",
      attributes = list(x = 1, y = 0, z = -3)
    ),
    a_update(
      id = "boxid2",
      component = "color",
      attributes = "#00FF00"
    )
  )

  animals$send_messages(update_entities_c)

}

# TODO: Refactor retrieval of image ID

# current_image <- img_paths[1]
# 
# go2 <- function(image_paths = img_paths, index = NA) {
#   # reset marker colour to white
#   # TODO
#   resetMarkersUI(MAX_NUMBER_OF_POINTS)
#   
#   # TODO: refactor higher - hide markers
#   
#   
#   # Update points to not be visible
#   for (point in 1:MAX_NUMBER_OF_POINTS) {
#     update_entities <- list(
#       a_update(
#         id = paste0("markerContainer", point),
#         component = "visible",
#         attributes = FALSEz
#       )
#     )
#     animals$send_messages(update_entities)
#   }
# 
#   # white <- "#ffffff"
# 
#   # Current image number
#   if(is.na(index)) { CONTEXT_INDEX <- 1 }
#   if(!is.na(index)){ CONTEXT_INDEX <- index }
# 
#   animal_contexts <- paste0("img", seq(1,length(image_paths),1))
# 
#   # TODO: Refactor as an argument?
#   context_rotations <- list(list(x = 0, y = 0, z = 0),
#                             list(x = 0, y = 0, z = 0),
#                             list(x = 0, y = 0, z = 0),
#                             list(x = 0, y = 0, z = 0))
# 
#   if(is.na(index)) {
#     CONTEXT_INDEX <<- ifelse(CONTEXT_INDEX > length(animal_contexts) - 1,
#                              yes = 1,
#                              no = CONTEXT_INDEX + 1)
#   }
# 
#   next_image <- animal_contexts[[CONTEXT_INDEX]]
#   current_image <<- img_paths[CONTEXT_INDEX] # TODO: refactor if more elegant way
#   print(next_image)
# 
# 
#   setup_scene <- list(
#     a_update(id = "canvas2d",
#              component = "material",
#              attributes = list(src = paste0("#",next_image))),
#     a_update(id = "canvas2d",
#              component = "src",
#              attributes = paste0("#",next_image)),
#     a_update(id = "canvas2d",
#              component = "rotation",
#              attributes = context_rotations[[CONTEXT_INDEX]]),
#     a_update(id = "canvas2d",
#              component = "class",
#              attributes = img_paths[CONTEXT_INDEX])
#   )
# 
#   for(jj in 1:length(setup_scene)){
#     if(setup_scene[[jj]]$id == "canvas2d"){
#       if(setup_scene[[jj]]$component == "material"){
#         setup_scene[[jj]]$attributes <- list(src = paste0("#",next_image))
#       }
#       if(setup_scene[[jj]]$component == "src"){
#         setup_scene[[jj]]$attributes <- paste0("#",next_image)
#       }
#       if(setup_scene[[jj]]$component == "rotation"){
#         setup_scene[[jj]]$attributes <- context_rotations[[CONTEXT_INDEX]]
#       }
#       if(setup_scene[[jj]]$component == "class"){
#         setup_scene[[jj]]$attributes <- image_paths[CONTEXT_INDEX]
#       }
#     }
#   }
# 
#   animals$send_messages(setup_scene)
# }

CONTEXT_INDEX <- 1

current_image <- img_paths[[1]]$img

# TODO: add context rotations for 3D
goImage <- function(image_paths = img_paths, index = NA) {
  if (!is.na(index) && index > length(img_paths)) {
    stop("Please ensure the index does not exceed the total number of images.")
  }
  # Prevent image change if last image is showing and no args for index have been passed
  if (is_last_image && is.na(index)) {
    stop("Please ensure the index is passed when it is the last image.")
  }
  # Prevent image change if an index has been passed but the last image is not displaying
  if (!is_last_image && !is.na(index)) {
    stop("Please ensure the index is not passed unless it is the last image and annotation has finished.")
  }
  
  # Reset marker colour to white
  resetMarkersUI(MAX_NUMBER_OF_POINTS)
  
  # Update points to not be visible
  for (point in 1:MAX_NUMBER_OF_POINTS) {
    update_entities <- list(
      a_update(
        id = paste0("markerContainer", point),
        component = "visible",
        attributes = FALSE
      )
    )
    animals$send_messages(update_entities)
  }
  
  current_image <<- img_paths[[CONTEXT_INDEX]]$img
  
  CONTEXT_INDEX <<- ifelse(!is.na(index),
                           yes = index,
                           no = CONTEXT_INDEX + 1
                           )
  
  if (CONTEXT_INDEX == length(img_paths)) {
    is_last_image <<- TRUE
  }
  
  next_image <- img_paths[[CONTEXT_INDEX]]$img
  next_image_el_id <- paste0("#img", CONTEXT_INDEX)
  print(next_image)
  
  setup_scene <- list(
    a_update(id = "canvas2d",
             component = "material",
             attributes = list(src = next_image_el_id)),
    a_update(id = "canvas2d",
             component = "src",
             attributes = next_image_el_id),
    a_update(id = "canvas2d",
             component = "class",
             attributes = next_image
    )
  )
  
  for(aUpdate in 1:length(setup_scene)){
    if(setup_scene[[aUpdate]]$id == "canvas2d"){
      if(setup_scene[[aUpdate]]$component == "material"){
        setup_scene[[aUpdate]]$attributes <- list(src = next_image_el_id)
      }
      if(setup_scene[[aUpdate]]$component == "src"){
        setup_scene[[aUpdate]]$attributes <- next_image_el_id
      }
      if(setup_scene[[aUpdate]]$component == "class"){
        setup_scene[[aUpdate]]$attributes <- next_image
      }
    }
  }
  
  animals$send_messages(setup_scene)
  
}



read <- function(url) {
  # Deserialize the payload so data can be read and converted from JSON to data frame
  data.df <<- jsonlite::fromJSON(httr::content(httr::GET(url), "text"), flatten = TRUE)

  return(data.df)
}

resetQuestionUI <- function(){
  # TODO: make 4 dynamic
  for (i in 1:(length(questions[[1]]) - 1)) {
    reset_response_colors <- list(
      a_update(
        id = paste0("option", i, "Plane"),
        component = "color",
        attributes = "#FFFFFF"
      )
    )
    animals$send_messages(reset_response_colors)
  }
  # TODO - possibly refactor?
  reset_post_color <- list(
    a_update(
      id = paste0("postPlane"),
      component = "color",
      attributes = "#FFFFFF"
    )
  )
  animals$send_messages(reset_post_color)
}

QUESTION_CONTEXT <- 1
# TODO check visible FALSE
question <- function(index = NA, visible = TRUE){
  if (!is.na(index) && index > length(questions)) {
    stop("The index of the question exceeds the total number of questions.")
  }
  if (!is.na(index)) {
    QUESTION_CONTEXT <<- index
    resetQuestionUI()
    text_messages <- list(
      a_update(id = "questionPlaneText",
               component = "value",
               attributes = questions[[index]]$question),
      a_update(id = "option1Text",
               component = "value",
               attributes = questions[[index]]$answer1),
      a_update(id = "option2Text",
               component = "value",
               attributes = questions[[index]]$answer2),
      a_update(id = "option3Text",
               component = "value",
               attributes = questions[[index]]$answer3),
      a_update(id = "option4Text",
               component = "value",
               attributes = questions[[index]]$answer4)
    )
    animals$send_messages(text_messages)
  }
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
  animals$send_messages(show_messages)
}

# pop2 <- function(visible = TRUE) {
#   show_messages <- list(
#     a_update(id = "questionPlane",
#              component = "visible",
#              attributes = TRUE),
#     a_update(id = "option1Plane",
#              component = "visible",
#              attributes = TRUE),
#     a_update(id = "option3Plane",
#              component = "visible",
#              attributes = TRUE),
#     a_update(id = "option4Plane",
#              component = "visible",
#              attributes = TRUE),
#     a_update(id = "option2Plane",
#              component = "visible",
#              attributes = TRUE),
#     a_update(id = "postPlane",
#              component = "visible",
#              attributes = TRUE),
#     a_update(id = "postPlaneBoundary",
#              component = "visible",
#              attributes = TRUE),
#     a_update(id = "option1Boundary",
#              component = "visible",
#              attributes = TRUE),
#     a_update(id = "option3Boundary",
#              component = "visible",
#              attributes = TRUE),
#     a_update(id = "option4Boundary",
#              component = "visible",
#              attributes = TRUE),
#     a_update(id = "option2Boundary",
#              component = "visible",
#              attributes = TRUE)
#   )
#   visible_message <- change_message(show_messages, visible)
#   animals$send_messages(visible_message)
# }


is_last_image <- FALSE

check <- function(imgNumber) {
  # Only check if all images are annotated
  if (!is_last_image) {
    stop('Please annotate all images before calling check!')
  }
  if (!is.na(imgNumber) && imgNumber > length(img_paths)) {
    stop("Please ensure the index does not exceed the total number of images.")
  }
  # TODO: handle case imgNumber not passed and remove goldStandardPoints
  
  imagePath <- img_paths[[imgNumber]]$img
  imageCoordinates <- img_paths[[imgNumber]]$imgPoints
  imageGoldStandard <- img_paths[[imgNumber]]$imgPointIsCoral
  
  # imgNumberCoordinates <- paste0('img', imgNumber, 'Points')
  # imgNumberGoldStandard <- paste0('img', imgNumber, 'PointsIsCoral')
  
  # img_paths[[i]]$imgPointIsCoral
  
  # fixedPointsTemp(imgNumberCoordinates)
  # go2(image_paths = img_paths, index = imgNumber)
  goImage(index = imgNumber)
  
  # Update the remaining points to not be visible
  resetMarkersUI(MAX_NUMBER_OF_POINTS) # is this being applied?
  
  for (i in 1:MAX_NUMBER_OF_POINTS) {
    ## Update the visbility
    update_entities <- list(
      a_update(
        id = paste0("markerContainer", i),
        component = "visible",
        attributes = FALSE
      )
    )
    animals$send_messages(update_entities)
  }
  
  check_entities <- list(
    a_check(
      imageId = imagePath,
      goldStandard = imageGoldStandard
    )
  )
  
  animals$send_messages(check_entities)
  
}

# fixedPointsTemp(img1Points)
# check()
# go2(image_paths = img_paths, index = 2)
# createPoints()


# data.df <- read("https://r2vr.herokuapp.com/annotated-image")
# data.df <- read("https://r2vr.herokuapp.com/evaluation")

### COMMANDS ###

# fixedPointsTemp(img1Points)
# go2(image_paths = img_paths, index = 2)
# createPoints()

# go2(image_paths = img_paths, index = 1)
# go2(image_paths = img_paths, index = 2)
# go2(image_paths = img_paths, index = 3)
# go2(image_paths = img_paths, index = 4)
# createPoints()
# pop2(FALSE)
# pop2()
# points(1)
# points(fixed=TRUE)
# addBox()
# rmBox()
# fixedPointsTemp(img1Points)

## Latest Commands ##

# fixedPointsTemp(img1Points)
# go2(image_paths = img_paths, index = 2)
# fixedPointsTemp(img2Points)
# go2(image_paths = img_paths, index = 3)
# fixedPointsTemp(img3Points)
# check(1, img1PointsIsCoral)
# check(2, img2PointsIsCoral)
# check(3, img3PointsIsCoral)

## LATEST ### 
# fixedPointsTemp(image1Points)
# goImage(2)
# fixedPointsTemp(image2Points)
# goImage(3)
# fixedPointsTemp(image3Points)
# check(1)
# check(2)
# check(3)
# question()
# question(2)