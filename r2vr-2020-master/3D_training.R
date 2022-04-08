library(r2vr)

# Set meta data
META_DATA <- "3d/training"

# Set observer here
USER <- "Jon-Peppinck"

# Set total number of markers
NUMBER_OF_MARKERS <- 3

# Find the user's IP address as it is required for WebSocket connection
IPv4_ADDRESS <- find_IP() 

# TODO: Annotate markers correctly
img1Points = list(
  list(id = 1, x = -0.268, y = -0.739, z = 0.616, isCoral = 0), # sand ?
  list(id = 2, x =  -0.8979, y = -0.0452, z = -0.4377, isCoral = 0),
  list(id = 3, x = -0.4749, y = -0.7584, z = 0.4463, isCoral = 0)
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

# 3D image paths (2400x1200px)
img_paths <- list(
  # TODO: update image paths
  list(img = "https://cdn.jsdelivr.net/gh/Jon-Peppinck/r2vr-2020@r2vr-build/inst/ext/images/reef/100030039.jpg", imgPoints = img1Points),
  list(img = "https://cdn.jsdelivr.net/gh/Jon-Peppinck/r2vr-2020@r2vr-build/inst/ext/images/reef/100030039.jpg", imgPoints = img2Points),
  list(img = "https://cdn.jsdelivr.net/gh/Jon-Peppinck/r2vr-2020@r2vr-build/inst/ext/images/reef/100030039.jpg", imgPoints = img3Points),
  list(img = "https://cdn.jsdelivr.net/gh/Jon-Peppinck/r2vr-2020@r2vr-build/inst/ext/images/reef/100030039.jpg", imgPoints = img4Points)
  # list(img = "./inst/ext/images/reef/100030039.jpg", imgPoints = img1Points),
  # list(img = "./inst/ext/images/reef/120261897.jpg", imgPoints = img2Points),
  # list(img = "./inst/ext/images/reef/130030287.jpg", imgPoints = img3Points),
  # list(img = "./inst/ext/images/reef/130050093.jpg", imgPoints = img4Points)
)

# Colours
COLOR_MARKER <- "#FFFFFF"
COLOR_CORAL <- "#FF95BC"
COLOR_NOT_CORAL <- "#969696"
COLOR_TEXT <- "#000000"
COLOR_CAMERA_CURSOR <- "#FF0000"

# Randomly select 3 out of the (4) images (any order) to avoid order bias
img_paths <- sample(img_paths, 3, replace=FALSE)

# Create image assets for selected images
for (i in 1:length(img_paths)) {
  currentImgPath <- img_paths[[i]]$img
  image_number <- paste0("image", i) # image1, ... , image<n>
  image_path <- paste0("image", i, "Path") # image1Path, ... , image<n>Path
  image_number_points <- paste0("image", i, "Points") # image1Points, ... , image<n>Points
  currentImgPoints <- img_paths[[i]]$imgPoints # list of lists

  current_image <- a_asset(
    .tag = "image",
    id = paste0("img", i), # id = "img<i>" used to select DOM element
    src = currentImgPath
  )
  
  # Assign image<n> variable to its corresponding image asset
  assign(image_number, current_image)
  # Assign image<n>Path variable to its corresponding image path
  assign(image_path, currentImgPath)
  # Assign image<n>Points variable to its corresponding image points
  assign(image_number_points, currentImgPoints)
}

# Create 3D sky with images
canvas_3d <- a_entity(
  .tag = "sky",
  .js_sources = list(
    "./inst/js/button_controls.js",
    "./inst/js/look_at.js",
    "./inst/js/training3d.js"
  ),
  id = "canvas",
  class = img_paths[[1]]$img,
  src = image1,
  rotation = c(0, 0, 0),
  .assets = list(
    image2,
    image3
  )
)

# Create a cursor
cursor <- a_entity(
  .tag = "cursor",
  look_controls = "",
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

## Markers
list_of_children_entities <- list(canvas_3d, camera, user, meta_data)

list_length <- length(list_of_children_entities)

MARKER_OUTER_RADIUS <- 4
MARKER_INNER_RADIUS <- 3
MENU_OPTION_OUTER_RADIUS <- 9
MENU_OPTION_INNER_RADIUS <- MARKER_OUTER_RADIUS

### GENERATE POINTS ###
# TODO: Move higher
generatePoints <- function(numberOfMarkers = NUMBER_OF_MARKERS) {
  # TODO: check typeof arg for for int, check called once only
  for (i in 1:numberOfMarkers) {
  sphere_radius = 500 # TODO: check if can delete
  u <- runif(1, -1, 1)
  theta <- runif(1, -pi, 0) # Full sphere: runif(1, 0, pi)
  x <- sqrt(1 - u^2) * cos(theta)
  y <- sqrt(1 - u^2) * sin(theta)
  z <- u
  # TODO check if x, y, and z can be 0
  # Check if menu position needed on generation of points

  marker_boundary <- a_entity(
    .tag = "ring",
    look_at = "[cursor]",
    raycaster_listen = "",
    id = paste0("markerBoundary", i),
    class = "marker-boundary",
    radius_outer = MARKER_OUTER_RADIUS,
    radius_inner = MARKER_INNER_RADIUS,
    color = COLOR_MARKER,
    side = "double"
  )

  marker_inner <- a_entity(
    .tag = "circle",
    look_at = "[cursor]",
    raycaster_listen = "",
    id= paste0("markerInner", i),
    class = "marker-inner",
    radius = MARKER_INNER_RADIUS,
    opacity = 0
  )

  TEXT_BOX_EDGE_SIZE <- 0.5
  DELTA <- 0.0001 # Make primitive box of text label small enought so it is hidden

  coral_label <- a_entity(
    .tag = "text",
    id = paste0("coralText", i),
    value = "C",
    width = 100,
    color = COLOR_TEXT,
    position = c(-MENU_OPTION_OUTER_RADIUS + TEXT_BOX_EDGE_SIZE, 0, 0.1),
    geometry = list(primitive = "box", width = DELTA, height = DELTA, depth = DELTA) # ,
    # material = list(transparent = TRUE, opacity = 0.5) # TODO: remove
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

  menu_coral <- a_entity(
    .tag = "ring",
    .children = list(coral_label),
    look_at = "[cursor]",
    raycaster_listen = "",
    id= paste0("menuCoral", i),
    class = "menu-item",
    radius_outer = MENU_OPTION_OUTER_RADIUS,
    radius_inner = MENU_OPTION_INNER_RADIUS,
    theta_length = 180,
    theta_start = 90,
    color = COLOR_CORAL,
    side = "double",
    visible = FALSE,
  )

  menu_not_coral <- a_entity(
    .tag = "ring",
    .children = list(not_coral_label),
    look_at = "[cursor]",
    raycaster_listen = "",
    id = paste0("menuNotCoral", i),
    class = "menu-item",
    radius_outer = MENU_OPTION_OUTER_RADIUS,
    radius_inner = MENU_OPTION_INNER_RADIUS,
    theta_length = 180,
    theta_start = 270,
    color = COLOR_NOT_CORAL,
    side = "double",
    visible = FALSE
  )

  # Marker container: Encapsulate a marker and its menu options inside a parent container
  marker_container <- a_entity(
    .tag = "ring",
    .children = list(marker_boundary, marker_inner, menu_coral, menu_not_coral),
    id = paste0("markerContainer", i),
    class = "marker-container",
    position = c(x, y, z),
    radius_inner = 0.00001,
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

fixedPoints <- function(points) {
  for(point in 1:length(points)) {
    fixedCoordinateX <- 100 * points[[point]]$x
    fixedCoordinateY <- 100 * points[[point]]$y
    fixedCoordinateZ <- 100 * points[[point]]$z

    # Update the position for the number of points specified
    update_entities <- list(
      a_update(
        id = paste0("markerContainer", point),
        component = "position",
        attributes = list(x = fixedCoordinateX, y = fixedCoordinateY, z = fixedCoordinateZ)
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

### RENDER SCENE

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
  source('C:/r2vr2020/r2vr/3D_training.R', echo=TRUE)
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
