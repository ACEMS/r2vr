library(r2vr)
library(httr)
library(jsonlite)

# Enter IP
IPv4_ADDRESS <- "192.168.43.72"

# Define image paths
image_paths <- c("../inst/ext/images/reef/100030039.jpg", "../inst/ext/images/reef/120261897.jpg", "../inst/ext/images/reef/130030287.jpg", "../inst/ext/images/reef/130050093.jpg")

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
                      .js_sources = list("../inst/js/button_controls.js", "../inst/js/binary_interactions.js"),
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
  class = "reef"
)

# Position cursor in center of camera
camera <- a_entity(
  .tag = "camera",
  .children = list(cursor),
  position = c(0, 0, 0),
  rotation = "0 0 0",
  intersection = ''
)

reef_question_label <- a_label(
  text = "Do the live corals on this reef form a structurally complex habitat?",
  id = "questionPlaneText",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0.02, 0)
)

reef_question_plane <- a_entity(
  .tag = "plane",
  .children = list(reef_question_label),
  id = "questionPlane",
  visible = FALSE,
  position = c(0, 0, -1),
  color = white,
  height = 0.15,
  width = 0.8
)

reef_yes_label <- a_label(
  text = "Yes",
  id = "yesText",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

reef_yes_plane <- a_entity(
  .tag = "plane",
  .children = list(reef_yes_label),
  id = "yesPlane",
  visible = FALSE,
  position = c(-0.25, -0.3, -1),
  color = white,
  height = 0.3,
  width = 0.3
)

# Outer boundary for intersection detection
reef_yes_plane_boundary <- a_entity(
  .tag = "ring",
  id = "yesPlaneBoundary",
  position = c(-0.25, -0.3, -1),
  visible = FALSE,
  color = dark_red,
  radius_inner = 0.24,
  radius_outer = 0.25,
  segments_theta = 4,
  theta_start = 45
)

reef_no_label <- a_label(
  text = "No",
  id = "noText",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

reef_no_plane <- a_entity(
  .tag = "plane",
  .children = list(reef_no_label),
  id = "noPlane",
  visible = FALSE,
  position = c(0.25, -0.3, -1),
  color = white,
  height = 0.3,
  width = 0.3
)

# Outer boundary for intersection detection
reef_no_plane_boundary <- a_entity(
  .tag = "ring",
  id = "noPlaneBoundary",
  visible = FALSE,
  position = c(0.25, -0.3, -1),
  color = dark_red,
  radius_inner = 0.24,
  radius_outer = 0.25,
  segments_theta = 4,
  theta_start = 45
)

# Create Scene
animals <- a_scene(.children = list(canvas_3d, reef_yes_plane_boundary, reef_no_plane_boundary, camera, reef_question_plane, reef_yes_plane, reef_no_plane),
                   .websocket = TRUE,
                   .websocket_host = LOCAL_IP,
                   .template = "empty",
                   button_controls="debug: true;",
                   binary_button_controls = ""
)


# Start the server
start <- function(LOCAL_IP = IPv4_ADDRESS){
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
    a_update(id = "yesPlane",
             component = "visible",
             attributes = visible),
    a_update(id = "noPlane",
             component = "visible",
             attributes = visible),
    a_update(id = "yesPlaneBoundary",
             component = "visible",
             attributes = visible),
    a_update(id = "noPlaneBoundary",
             component = "visible",
             attributes = visible)
  ))
}

# Current image number
CONTEXT_INDEX <- 1

reef_contexts <- paste("img", seq(1,length(image_paths),1), sep="")
context_rotations <- list(list(x = 0, y = 0, z = 0),
                          list(x = 0, y = 0, z = 0),
                          list(x = 0, y = 0, z = 0),
                          list(x = 0, y = 0, z = 0))

# Next (or particular) image
go <- function(index = NA){

  if(!is.na(index)) CONTEXT_INDEX <<- index

  if(is.na(index)) {
    CONTEXT_INDEX <<- ifelse(CONTEXT_INDEX > length(reef_contexts) - 1,
                             yes = 1,
                             no = CONTEXT_INDEX + 1)
  }


  next_image <- reef_contexts[[CONTEXT_INDEX]]

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
    a_update(id = "yesPlane",
             component = "color",
             attributes = "#FFFFFF"),
    a_update(id = "noPlane",
             component = "color",
             attributes = "#FFFFFF")
  ))
}


# Get data from database with API GET request
read <- function(url = "https://test-api-koala.herokuapp.com/reef"){
  # Deserialize the payload so data can be read and converted from JSON to data frame
  data.df <<- jsonlite::fromJSON(httr::content(httr::GET(url), "text"), flatten = TRUE)
  return(data.df)
}