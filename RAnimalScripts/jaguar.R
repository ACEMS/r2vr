library(r2vr)
library(httr)
library(jsonlite)

# Enter IP
LOCAL_IP <- "192.168.43.72"

# Define image paths
image_paths <- c("../inst/ext/images/jaguars/WP14_360_002.jpg", "../inst/ext/images/jaguars/WP55_360_001.jpg", "../inst/ext/images/jaguars/WP56_360_001.jpg", "../inst/ext/images/jaguars/WP60_360_001.jpg")

# Colours
dark_red <- "#8c0000"
bright_red <- "#ff0000"
white <- "#ffffff"
black <- "#000000"

# Assign asset for each image path
for (i in 1:length(image_paths)) {
  image_number <- paste("image", i, sep = "")
  
  current_image <- a_asset(.tag = "image",
                           id = paste("img", i, sep = ""),
                           src = image_paths[i])
  
  assign(image_number, current_image)
}

# Create 3D Image
canvas_3d <- a_entity(.tag = "sky",
                      .js_sources = list("../inst/js/button_controls.js", "../inst/js/selection_interactions.js"),
                      id = "canvas3d",
                      class = image_paths[1],
                      src = image1,
                      rotation = c(0, 0, 0),
                      .assets = list(
                        image2, image3, image4))

# Create a cursor
cursor <- a_entity(
  .tag = "cursor",
  color = bright_red,
  id = "fileID",
  class = "jaguar"
)

# Position cursor in center of camera
camera <- a_entity(
  .tag = "camera",
  .children = list(cursor),
  position = c(0, 0, 0),
  rotation = "0 0 0",
  intersection = ''
)

jaguar_question_label <- a_label(
  text = "Do you see any of these habitat features in this image? If you do see a feature, click on the box to select it.",
  id = "questionPlaneText",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0.02, 0)
)

jaguar_question_plane <- a_entity(
  .tag = "plane",
  .children = list(jaguar_question_label),
  id = "questionPlane",
  visible = FALSE,
  position = c(0, 0, -2),
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
  position = c(0.8, 0, -2),
  color = white,
  height = 0.3,
  width = 0.3,
)

# Outer boundary for intersection detection
post_plane_boundary <- a_entity(
  .tag = "ring",
  id = "postPlaneBoundary",
  visible = FALSE,
  position = c(0.8, 0, -2),
  color = dark_red,
  radius_inner = 0.24,
  radius_outer = 0.25,
  segments_theta = 4,
  theta_start = 45
)

jaguar_water_label <- a_label(
  text = "Water",
  id = "waterText",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

jaguar_water_plane <- a_entity(
  .tag = "plane",
  .children = list(jaguar_water_label),
  id = "waterPlane",
  visible = FALSE,
  position = c(-0.35, -0.45, -2),
  color = white,
  height = 0.4,
  width = 0.4
)

# Outer boundary for intersection detection
jaguar_water_plane_boundary <- a_entity(
  .tag = "ring",
  id = "waterPlaneBoundary",
  position = c(-0.35, -0.45, -2),
  visible = FALSE,
  color = dark_red,
  radius_inner = 0.34,
  radius_outer = 0.35,
  segments_theta = 4,
  theta_start = 45
)

jaguar_prey_label <- a_label(
  text = "Jaguar tracks", # TODO: Change prey to jaguar tracks
  id = "preyText",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

jaguar_prey_plane <- a_entity(
  .tag = "plane",
  .children = list(jaguar_prey_label),
  id = "preyPlane",
  visible = FALSE,
  position = c(-0.35, -1, -2),
  color = white,
  height = 0.4,
  width = 0.4
)

# Outer boundary for intersection detection
jaguar_prey_plane_boundary <- a_entity(
  .tag = "ring",
  id = "preyPlaneBoundary",
  position = c(-0.35, -1, -2),
  visible = FALSE,
  color = dark_red,
  radius_inner = 0.34,
  radius_outer = 0.35,
  segments_theta = 4,
  theta_start = 45
)

jaguar_trees_label <- a_label(
  text = "Scratch marks", # TODO: change treesplane to Scratch marks
  id = "treesText",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

jaguar_trees_plane <- a_entity(
  .tag = "plane",
  .children = list(jaguar_trees_label),
  id = "treesPlane",
  visible = FALSE,
  position = c(0.35, -0.45, -2),
  color = white,
  height = 0.4,
  width = 0.4,
)

# Outer boundary for intersection detection
jaguar_trees_plane_boundary <- a_entity(
  .tag = "ring",
  id = "treesPlaneBoundary",
  visible = FALSE,
  position = c(0.35, -0.45, -2),
  color = dark_red,
  radius_inner = 0.34,
  radius_outer = 0.35,
  segments_theta = 4,
  theta_start = 45
)

jaguar_vegetation_label <- a_label(
  text = "Dense Vegetation",
  id = "vegetationText",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

jaguar_vegetation_plane <- a_entity(
  .tag = "plane",
  .children = list(jaguar_vegetation_label),
  id = "vegetationPlane",
  visible = FALSE,
  position = c(0.35, -1, -2),
  color = white,
  height = 0.4,
  width = 0.4,
)

# Outer boundary for intersection detection
jaguar_vegetation_plane_boundary <- a_entity(
  .tag = "ring",
  id = "vegetationPlaneBoundary",
  visible = FALSE,
  position = c(0.35, -1, -2),
  color = dark_red,
  radius_inner = 0.34,
  radius_outer = 0.35,
  segments_theta = 4,
  theta_start = 45
)

# Create Scene
animals <- a_scene(.children = list(canvas_3d, jaguar_water_plane_boundary, jaguar_trees_plane_boundary, jaguar_vegetation_plane_boundary, jaguar_prey_plane_boundary, camera, jaguar_question_plane, jaguar_water_plane, jaguar_trees_plane, jaguar_vegetation_plane, jaguar_prey_plane, post_plane, post_plane_boundary),
                   .websocket = TRUE,
                   .websocket_host = LOCAL_IP,
                   .template = "empty",
                   button_controls="debug: true;",
                   binary_button_controls = ""
)


# Start the server
start <- function(){
  animals$serve(host = LOCAL_IP)
}

# End the server
end <- function(){
  a_kill_all_scenes()
}

# Toggle Question
pop <- function(visible = TRUE){
  
  animals$send_messages(list(
    a_update(id = "questionPlane",
             component = "visible",
             attributes = visible),
    a_update(id = "waterPlane",
             component = "visible",
             attributes = visible),
    a_update(id = "treesPlane",
             component = "visible",
             attributes = visible),
    a_update(id = "vegetationPlane",
             component = "visible",
             attributes = visible),
    a_update(id = "preyPlane",
             component = "visible",
             attributes = visible),
    a_update(id = "postPlane",
             component = "visible",
             attributes = visible),
    a_update(id = "postPlaneBoundary",
             component = "visible",
             attributes = visible),
    a_update(id = "waterPlaneBoundary",
             component = "visible",
             attributes = visible),
    a_update(id = "treesPlaneBoundary",
             component = "visible",
             attributes = visible),
    a_update(id = "vegetationPlaneBoundary",
             component = "visible",
             attributes = visible),
    a_update(id = "preyPlaneBoundary",
             component = "visible",
             attributes = visible)
  ))
}

# Current image number
CONTEXT_INDEX <- 1

jaguar_contexts <- paste("img", seq(1,length(image_paths),1), sep="")
context_rotations <- list(list(x = 0, y = 0, z = 0),
                          list(x = 0, y = 0, z = 0),
                          list(x = 0, y = 0, z = 0),
                          list(x = 0, y = 0, z = 0))

# Next (or particular) image
go <- function(index = NA){
  
  if(!is.na(index)) CONTEXT_INDEX <<- index
  
  if(is.na(index)) {
    CONTEXT_INDEX <<- ifelse(CONTEXT_INDEX > length(jaguar_contexts) - 1,
                             yes = 1,
                             no = CONTEXT_INDEX + 1)
  }
  
  
  next_image <- jaguar_contexts[[CONTEXT_INDEX]]
  
  pop(FALSE)
  
  animals$send_messages(list(
    a_update(id = "canvas3d",
             component = "material",
             attributes = list(src = paste0("#",next_image))),
    a_update(id = "canvas3d",
             component = "src",
             attributes = paste0("#",next_image)),
    a_update(id = "canvas3d",
             component = "rotation",
             attributes = context_rotations[[CONTEXT_INDEX]]),
    a_update(id = "canvas3d",
             component = "class",
             attributes = image_paths[CONTEXT_INDEX]),
    a_update(id = "waterPlane",
             component = "color",
             attributes = white),
    a_update(id = "treesPlane",
             component = "color",
             attributes = white),
    a_update(id = "vegetationPlane",
             component = "color",
             attributes = white),
    a_update(id = "preyPlane",
             component = "color",
             attributes = white),
    a_update(id = "postPlane",
             component = "color",
             attributes = white)
  ))
}

# Get data from database with API GET request
read <- function(){
  # Deserialize the payload so data can be read and converted from JSON to data frame
  jaguar_data.df <<- jsonlite::fromJSON(httr::content(httr::GET("https://test-api-koala.herokuapp.com/jaguar"), "text"), flatten = TRUE)
}
