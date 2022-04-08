library(r2vr)

# Set observer here e.g "John-Doe"
FULL_NAME <- "Firstname-Lastname"

# Set meta data
MODULE <- "2d"
MODULE_TYPE <- "training"
META_DATA <- paste0(MODULE, "/", MODULE_TYPE)

# Set the number of markers here
## NOTE: Do not exceed 20 for performance reasons
NUMBER_OF_MARKERS <- 40

# Colours
COLOR_MARKER <- "#FFFFFF"
COLOR_CORAL <- "#FF95BC"
COLOR_NOT_CORAL <- "#969696"
COLOR_TEXT <- "#000000"
COLOR_CAMERA_CURSOR <- "#FF0000"

# Find the user's IP address as it is required for WebSocket connection
IPv4_ADDRESS <- find_IP() # Note: If not on Windows, enter IP directly

is_IPv4_set <- identical(IPv4_ADDRESS, character(0))

if (!is_IPv4_set) {
  stop('IPv4 Address not found. Please try checking your internet connection!')
}

## TODO: Annotate markers correctly
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
  list(id = 1, x = 0, y = 0, isCoral = 0),
  list(id = 2, x = 4000, y = 3000, isCoral = 0)
)

img_paths <- list(
  # 2D image paths  4000x3000
  list(img = "./2dimages/latest/49001074001.jpeg", imgPoints = img1Points),
  list(img = "./2dimages/latest/49002256001.jpeg", imgPoints = img2Points),
  list(img = "./2dimages/latest/51010026001.jpeg", imgPoints = img3Points),
  list(img = "./2dimages/latest/49004035001.jpeg", imgPoints = img3Points),
  list(img = "./2dimages/latest/50003181001.jpeg", imgPoints = img3Points)
)



# Randomly select 3 out of the 6 images (any order)
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
    "./inst/js/training2d.js"
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
  checked = FALSE,
  opacity = 0,
  radius = 0
)

# Setup
list_of_children_entities <- list(canvas_2d, camera, user, meta_data)

list_length <- length(list_of_children_entities)

MARKER_OUTER_RADIUS <- 0.12
MARKER_INNER_RADIUS <- 0.09
MENU_OPTION_OUTER_RADIUS <- 0.3
MENU_OPTION_INNER_RADIUS <- MARKER_OUTER_RADIUS

### GENERATE POINTS ###
# TODO: Move higher
generatePoints <- function(numberOfMarkers = NUMBER_OF_MARKERS) {
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
      position = c(0, 0, canvas_z + 0.01),
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

generatePoints()

## RENDER SCENE
animals <- a_scene(
  .children = list_of_children_entities,
  .websocket = TRUE,
  .websocket_host = IPv4_ADDRESS,
  .template = "empty",
  button_controls = "debug: true;",
  toggle_menu_listen = ""
)

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


fixedPoints <- function(points) {
  ## Generate the transformation functions
  xTranslation <- rangeTranslation(4000, 0, 2, -2)
  yTranslation <- rangeTranslation(3000, 0, 3/2, -3/2)
  
  for(point in 1:length(points)) {
    ## Find the transformed x and y values
    # TODO: make dynamic
    fixedCoordinateX <- xTranslation(img3Points[[point]]$x)
    fixedCoordinateY <- -yTranslation(img3Points[[point]]$y)
    
    # Update the position for the number of points specified
    update_entities <- list(
      a_update(
        id = paste0("markerContainer", point),
        component = "position",
        attributes = list(x = fixedCoordinateX, y = fixedCoordinateY, z = canvas_z + 0.02)
      ),
      # Update the specified number of points to be visible
      a_update(
        id = paste0("markerContainer", point),
        component = "visible",
        attributes = TRUE
      )
    )
    animals$send_messages(update_entities)
  }
  
  startNumberOfRemainingPoints <- length(points) + 1
  
  if (startNumberOfRemainingPoints > NUMBER_OF_MARKERS) return() # TODO: Check edge cases
  
  # Update the remaining points to not be visible
  for (point in startNumberOfRemainingPoints:NUMBER_OF_MARKERS) {
    # Update the position
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
  source('C:/r2vr2020/r2vr/2D_training.R', echo=TRUE)
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

check <- function(imgNumber) {
  # Only check if all images are annotated
  if (!has_last_image_displayed) {
    stop('Please annotate all images before calling check!')
  }
  if (!is.na(imgNumber) && imgNumber > length(img_paths)) {
    stop("Please ensure the index does not exceed the total number of images.")
  }
  # TODO: handle case imgNumber not passed
  
  # Determine image path of the image to be checked
  imagePath <- img_paths[[imgNumber]]$img
  # Determine the gold standard of the image to be checked
  imageGoldStandard <- img_paths[[imgNumber]]$imgPoints
  # Display fixed points in the location previously annotated
  fixedPoints(imageGoldStandard)
  # Display the image to be checked
  goImage(imgNumber) # Note: Also reset markers back to white
  # Pick out id and isCoral from correctly annotated markers
  mutatedImageGoldStandard <- list()
  # Select id and isCoral from mutatedImageGoldStandard
  for (annotation in imageGoldStandard) {
    currentAnnotation <- list(id = annotation$id, isCoral = annotation$isCoral)
    mutatedImageGoldStandard[[length(mutatedImageGoldStandard) + 1]] <- currentAnnotation
  }
  # Check if markers are correct or incorrect
  check_entities <- list(
    a_check(
      imageId = imagePath,
      goldStandard = mutatedImageGoldStandard
    )
  )
  animals$send_messages(check_entities)
  
  checked_messages <- list(
    a_update(id = "metaData",
             component = "checked",
             attributes = TRUE)
  )
  animals$send_messages(checked_messages)
}

### COMMANDS ###
# rm(list=ls())
# start()
# fixedPoints(image1Points)
# goImage()
# fixedPoints(image2Points)
# goImage()
# fixedPoints(image3Points)
# check(1)
# check(2)
# check(3)