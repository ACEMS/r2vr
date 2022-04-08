library(r2vr)

# Set meta data
META_DATA <- "2d/testing"

# Set observer here
USER <- "Jon-Peppinck"

# Set total number of markers
NUMBER_OF_MARKERS <- 50

# Find the user's IP address as it is required for WebSocket connection
IPv4_ADDRESS <- find_IP()

# 2D image paths  4000x3000
img_paths <- list(
  list(img = "./2dimages/latest/49001074001.jpeg"),
  list(img = "./2dimages/latest/49002256001.jpeg"),
  list(img = "./2dimages/latest/51010026001.jpeg"),
  list(img = "./2dimages/latest/49004035001.jpeg"),
  list(img = "./2dimages/latest/50003181001.jpeg")
)

# Set evaluation questions
evaluationQuestions <- list(
  list(question = "Did you enjoy this experiment?", answerOne = "Very much", answerTwo = "Yes", answerThree = "A little", answerFour = "No"),
  list(question = "On a scale of 1-4, how would you rate your experience?", answerOne = "1", answerTwo = "2", answerThree = "3", answerFour = "4")
)

# Colours
COLOR_MARKER <- "#FFFFFF"
COLOR_PLANE <- "#FFFFFF"
COLOR_CORAL <- "#FF95BC"
COLOR_NOT_CORAL <- "#969696"
COLOR_TEXT <- "#000000"
COLOR_CAMERA_CURSOR <- "#FF0000"

# Randomly select 3 out of the (5) images (any order) to avoid order bias
img_paths <- sample(img_paths, 3, replace=FALSE)

for (i in 1:length(img_paths)) {
  currentImgPath <- img_paths[[i]]$img # string
  # image1, ... , image<n>, s.t. n = index of last image path
  image_number <- paste0("image", i)
  image_path <- paste0("image", i, "Path")
  image_number_points <- paste0("image", i, "Points") # image1Points, ... , image<n>Points
  currentImgPoints <- img_paths[[i]]$imgPoints # list of lists
  # Create image asset with id="img<i>" (to select DOM element)
  current_image <- a_asset(
    .tag = "image",
    id = paste0("img", i),
    src = currentImgPath
  )
  # Assign image<n> variable to its corresponding image asset
  assign(image_number, current_image)
  # Assign image<n>Path variable to its corresponding image path
  assign(image_path, currentImgPath)
  # Assign image<n>Points variable to its corresponding image points
  assign(image_number_points, currentImgPoints)
}

# Z-index positions
## Note: z-index of camera > z-index of entities
canvas_z = -3
marker_z = -1
camera_z = 0

# Create a canvas for the image to be attached to
canvas_2d <- a_entity(
  .tag = "plane",
  # TODO: change to CDN ?
  .js_sources = list(
    "https://cdn.jsdelivr.net/gh/ACEMS/r2vr@master/inst/js/button_controls.js",
    "./inst/js/testing2d.js"
  ),
  .assets = list(image2, image3),
  id = "canvas",
  src = image1,
  class = img_paths[[1]]$img,
  height = 3,
  width = 4,
  position = c(0, 0, canvas_z + 0.01)
)

# Create a cursor
cursor <- a_entity(
  .tag = "cursor",
  camera = "",
  color = COLOR_CAMERA_CURSOR
)

# Position cursor in center of camera
camera <- a_entity(
  .tag = "camera",
  .children = list(cursor),
  cursor = "",
  position = c(0, 0, 0)
)

# Invisble entity to store user name for client side JS
user <- a_entity(
  .tag = "circle",
  id = "user",
  class = USER,
  opacity = 0,
  radius = 0
)

# Invisble entity to store meta data for client side JS
meta_data <- a_entity(
  .tag = "circle",
  id = "metaData",
  class = META_DATA,
  opacity = 0,
  radius = 0
)

# Setup
list_of_children_entities <- list(canvas_2d, camera, user, meta_data)

list_length <- length(list_of_children_entities) # TODO: check if needed

MARKER_OUTER_RADIUS <- 0.12
MARKER_INNER_RADIUS <- 0.09
MENU_OPTION_OUTER_RADIUS <- 0.3
MENU_OPTION_INNER_RADIUS <- MARKER_OUTER_RADIUS

### GENERATE POINTS ###
# TODO: Move higher
generatePoints <- function(numberOfMarkers = NUMBER_OF_MARKERS) {
  # Append markers to the end of the list of children entities
  list_length <- length(list_of_children_entities)
  
  # TODO: check typeof arg for for int, check called once only
  for (i in 1:numberOfMarkers) {
    marker_boundary <- a_entity(
      .tag = "ring",
      raycaster_listen = "",
      id = paste0("markerBoundary", i),
      class = "marker-boundary",
      radius_outer = MARKER_OUTER_RADIUS,
      radius_inner = MARKER_INNER_RADIUS,
      color = COLOR_MARKER
    )
    
    marker_inner <- a_entity(
      .tag = "circle",
      raycaster_listen = "",
      id= paste0("markerInner", i),
      class = "marker-inner",
      radius = MARKER_INNER_RADIUS,
      opacity = 0
    )
    
    TEXT_BOX_EDGE_SIZE <- 0.005
    DELTA <- 0.0001 # Make primitive box of text label small enought so it is hidden
    
    coral_label <- a_entity(
      .tag = "text",
      id = paste0("coralText", i),
      value = "C",
      width = 1.2,
      color = COLOR_TEXT,
      position = c(-MENU_OPTION_OUTER_RADIUS + TEXT_BOX_EDGE_SIZE, 0, 0),
      geometry = list(primitive = "box", width = DELTA, height = DELTA, depth = DELTA)
    )
    
    not_coral_label <- a_entity(
      .tag = "text",
      id = paste0("notCoralText", i),
      value = "N",
      width = 1.2,
      color = COLOR_TEXT,
      position = c(MARKER_OUTER_RADIUS + TEXT_BOX_EDGE_SIZE, 0, 0),
      geometry = list(primitive = "box", width = DELTA, height = DELTA, depth = DELTA),
    )
    
    delta <- 0.001 # Small value to position menu options in-front of other markers
    
    menu_coral <- a_entity(
      .tag = "ring",
      .children = list(coral_label),
      raycaster_listen = "",
      id= paste0("menuCoral", i),
      class = "menu-item",
      position = c(0, 0, delta),
      radius_outer = MENU_OPTION_OUTER_RADIUS,
      radius_inner = MENU_OPTION_INNER_RADIUS,
      theta_length = 180,
      theta_start = 90,
      color = COLOR_CORAL,
      visible = FALSE,
    )
    
    menu_not_coral <- a_entity(
      .tag = "ring",
      .children = list(not_coral_label),
      raycaster_listen = "",
      id = paste0("menuNotCoral", i),
      class = "menu-item",
      position = c(0, 0, delta),
      radius_outer = MENU_OPTION_OUTER_RADIUS,
      radius_inner = MENU_OPTION_INNER_RADIUS,
      theta_length = 180,
      theta_start = 270,
      color = COLOR_NOT_CORAL,
      visible = FALSE
    )
    
    # Marker container: Encapsulate a marker and its menu options inside a parent container
    marker_container <- a_entity(
      .tag = "ring",
      .children = list(marker_boundary, marker_inner, menu_coral, menu_not_coral),
      id = paste0("markerContainer", i),
      class = "marker-container",
      position = c(0, 0, canvas_z + 0.01), # TODO: dynamic
      radius_inner = 0.00001, # TODO: check 0?
      radius_outer = 0.00001,
      opacity = 0,
      debug = "", # needed for x and y position after an update via web sockets
      visible = FALSE
    )
    
    marker_container_number <- paste0("markerContainer", i)
    list_of_children_entities[[list_length + i]] <<- assign(marker_container_number, marker_container)
  }
}

### GENERATE EVALUATION QUESTIONS ###
# TODO: Move higher
generateEvaluationQuestions <- function() {
  message_height <- 1
  
  list_length <- length(list_of_children_entities)
  
  question_label <- a_label(
    text = evaluationQuestions[[1]]$question,
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
    text = evaluationQuestions[[1]]$answerOne,
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
    text = evaluationQuestions[[1]]$answerTwo,
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
    text = evaluationQuestions[[1]]$answerThree,
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
    text = evaluationQuestions[[1]]$answerFour,
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

generateEvaluationQuestions() # Note: Call before generatePoints() for DOM rendering

generatePoints()

# TODO: move higher
rangeTranslation <- function(oldMax, oldMin = 0, newMax = 1 , newMin = -1) {
  translation = function(oldValue) {
    if (oldValue < 0) {
      stop('Please enter a non-negative value')
    }
    if (oldValue > oldMax || oldValue < oldMin) {
      stop(paste('Please enter a value between', oldMin, 'and', oldMax, '. You entered:', oldValue))
    }
    # To translate a point A on a scale with range (Omin, Omax) to a point B in a range (Nmin,        Nmax) then: B = [( A - O_min)/(O_max - O_min)](N_max - N_min) + N_min
    ((oldValue - oldMin)/(oldMax - oldMin)) * (newMax - newMin) + newMin
  }
  return(translation)
}

### RANDOMIZE POINTS ###
# TODO: Have 3d extend 2d Point
Point <- R6::R6Class("Point", public = list(
  x = NA,
  y = NA,
  n = NA,
  initialize = function(x, y, n) {
    stopifnot(is.numeric(x) || is.numeric(y))
    stopifnot(is.numeric(n))
    
    self$x <- x
    self$y <- y
    self$n <- n
  })
)

# TODO: generalize
euclideanDistance2d <- function(p1, p2) {
  return(sqrt((p2$x - p1$x)^2 + (p2$y - p1$y)^2))
}

points.list <- list()

randomizePoints <- function() {
  ## TODO: consider refactoring rangeTranslation higher
  # Reset the color of the annnotation points
  resetMarkersUI()
  # reset list of points back to initial value
  points.list <<- list()
  # Set a guard to prevent a possible infinite loop if n is too large
  guard = 0
  # Create annotation markers
  while (length(points.list) < NUMBER_OF_MARKERS) {
    # TODO: investigate canvas size and x/2
    # Note: Canvas: -2/3 < x < 2/3, -1/2 < y < 1/2 # TODO: update
    random_coordinate_x <- runif(1, -2 + MARKER_OUTER_RADIUS, 2 - MARKER_OUTER_RADIUS)
    random_coordinate_y <- runif(1, -1.5 + MARKER_OUTER_RADIUS, 1.5 - MARKER_OUTER_RADIUS)
    n <- length(points.list) + 1
    overlapping = FALSE

    # Create a new point object
    p <- Point$new(random_coordinate_x, random_coordinate_y, n)

    if (length(points.list) > 0) {
      # Determine if the new point intersects with any of the other points in list
      for (j in 1:length(points.list)) {
        markerInList = points.list[[j]]
        # Find the distance between the new point and the point in the list
        distance = euclideanDistance2d(p, markerInList)
        # If the new point overlaps with any current point set overlapping to true
        if (distance < 2 * MARKER_OUTER_RADIUS) {
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
          attributes = list(
            x = random_coordinate_x, y = random_coordinate_y, z = canvas_z + 0.01
          )
        ),
        # Update the specified number of points to be visible
        a_update(
          id = paste0("markerContainer", n),
          component = "visible",
          attributes = TRUE
        )
      )
      animals$send_messages(update_entities)
    }
    # Increment the guard for each while loop iteration
    guard = guard + 1
    if (guard > 1000) break
  }
}

## RENDER SCENE
animals <- a_scene(
  .children = list_of_children_entities,
  .websocket = TRUE,
  .websocket_host = IPv4_ADDRESS,
  .template = "empty",
  button_controls = "debug: true;",
  toggle_menu_listen = ""
)

### FUNCTIONS ###

## Start the Fiery server, establishing a WebSocket connection with the client
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
  source('C:/r2vr2020/r2vr/2D_testing.R', echo=TRUE)
  animals$serve(host = IPv4_ADDRESS)
}

## Helper function for points() to reset annotation marker colors
resetMarkersUI <- function(numberOfPointsToReset = NUMBER_OF_MARKERS){
  # TODO: check numberOfPointsToReset !> 20
  for (i in 1:numberOfPointsToReset) {
    # Reset marker colors
    reset_marker_colors <- list(
      a_update(
        id = paste0("markerBoundary", i),
        component = "color",
        attributes = COLOR_MARKER
      )
    )
    animals$send_messages(reset_marker_colors)
  }
}

# TODO: move higher
## Helper function for question() to hide the visibility of the markers
hideMarkers <- function(numberOfMarkersToHide = NUMBER_OF_MARKERS){
  # TODO: check numberOfPointsToReset !> 20
  for (point in 1:numberOfMarkersToHide) {
    container_messages <- list(
      a_update(
        id = paste0("markerContainer", point),
        component = "visible",
        attributes = FALSE
      )
    )
    animals$send_messages(container_messages)
  }
}

## Go to next image
CONTEXT_INDEX <- 1

current_image <- img_paths[[1]]$img # TODO: check if needed

has_last_image_displayed <- FALSE

goImage <- function(index = NA, image_paths = img_paths) {
  if (!is.na(index) && index > length(img_paths)) {
    stop("Please ensure the index does not exceed the total number of images.")
  }
  # Prevent image change if last image has showed and no args for index have been passed
  if (has_last_image_displayed && is.na(index)) {
    stop("Please ensure the index is passed when it is the last image.")
  }
  # Prevent image change if an index has been passed but the last image has not displayed
  if (!has_last_image_displayed && !is.na(index)) {
    stop("Please ensure the index is not passed unless it is the last image and annotation has finished.")
  }
  # Reset marker colour to white
  resetMarkersUI()
  
  # Relative path of current image
  current_image <<- img_paths[[CONTEXT_INDEX]]$img
  
  # Set the index of the next image to be displayed
  CONTEXT_INDEX <<- ifelse(!is.na(index),
                           yes = index,
                           no = CONTEXT_INDEX + 1
  )
  # Indicate if the last image has displayed (Allows to go back to an image to check it)
  if (CONTEXT_INDEX == length(img_paths)) {
    has_last_image_displayed <<- TRUE
  }
  # Set the next image path and ID
  next_image <- img_paths[[CONTEXT_INDEX]]$img
  next_image_el_id <- paste0("#img", CONTEXT_INDEX)
  print(paste("Image", CONTEXT_INDEX, "is displayed from", next_image))
  
  setup_scene <- list(
    a_update(id = "canvas",
             component = "material",
             attributes = list(src = next_image_el_id)),
    a_update(id = "canvas",
             component = "src",
             attributes = next_image_el_id),
    a_update(id = "canvas",
             component = "class",
             attributes = next_image
    )
  )
  
  for(aUpdate in 1:length(setup_scene)){
    if(setup_scene[[aUpdate]]$id == "canvas"){
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

QUESTION_CONTEXT <- 1
# TODO check visible FALSE
# TODO: refactor so after first question and visible true, no need to a_update visibility
# TODO: either require index (1,2,3,...) or not need it by tracking index globally
# TODO: markers display if question()
question <- function(index = NA, visible = TRUE){
  if (!is.na(index) && index > length(evaluationQuestions)) {
    stop("The index of the question exceeds the total number of questions.")
  }
  if (!is.na(index)) {
    QUESTION_CONTEXT <<- index
    
    if (QUESTION_CONTEXT == 1) {
      hideMarkers()
    }
    
    text_messages <- list(
      a_update(id = "questionPlaneText",
               component = "value",
               attributes = evaluationQuestions[[index]]$question),
      a_update(id = "optionOneText",
               component = "value",
               attributes = evaluationQuestions[[index]]$answerOne),
      a_update(id = "optionTwoText",
               component = "value",
               attributes = evaluationQuestions[[index]]$answerTwo),
      a_update(id = "optionThreeText",
               component = "value",
               attributes = evaluationQuestions[[index]]$answerThree),
      a_update(id = "optionFourText",
               component = "value",
               attributes = evaluationQuestions[[index]]$answerFour)
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

### COMMANDS ###
# rm(list=ls())
# start()
# randomizePoints()
# goImage()
# randomizePoints()
# goImage()
# randomizePoints()
# question(1)
# question(2)