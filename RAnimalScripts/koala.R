library(r2vr)
library(httr)
library(jsonlite)

# Enter IP
IPv4_ADDRESS <- "192.168.43.72"

# Define image paths
img_paths <- c("../inst/ext/images/koalas/KP5.jpg", "../inst/ext/images/koalas/SP10.jpg", "../inst/ext/images/koalas/foundKoala1.jpg", "../inst/ext/images/koalas/foundKoala2.jpg")

# Colours
dark_red <- "#8c0000"
bright_red <- "#ff0000"
white <- "#ffffff"
black <- "#000000"

# Assign asset for each image path
for (i in 1:length(img_paths)) {
  image_number <- paste("image", i, sep = "")

  current_image <- a_asset(.tag = "image",
                        id = paste("img", i, sep = ""),
                        src = img_paths[i])

  assign(image_number, current_image)
}

# Create 3D Image
canvas_3d <- a_entity(.tag = "sky",
                      .js_sources = list("../inst/js/button_controls.js", "../inst/js/binary_interactions.js"),
                      id = "canvas3d",
                      class = img_paths[1],
                      src = image1,
                      rotation = c(0, 0, 0), # TODO: Check all rotations
                      .assets = list(
                        image2, image3, image4))

# Create a cursor
cursor <- a_entity(
  .tag = "cursor",
  color = bright_red,
  id = "fileID",
  class = "koala"
)

# Position cursor in center of camera
camera <- a_entity(
  .tag = "camera",
  .children = list(cursor),
  position = c(0, 0, 0),
  rotation = "0 0 0",
  intersection = ''
)

koala_question_label <- a_label(
  text = "Do you see any koalas in this image?",
  id = "questionPlaneText",
  color = black,
  font = "mozillavr",
  height = 0.2,
  width = 1,
  position = c(0, 0.02, 0)
)

koala_question_plane <- a_entity(
  .tag = "plane",
  .children = list(koala_question_label),
  id = "questionPlane",
  visible = FALSE,
  position = c(0, 0, -1),
  color = white,
  height = 0.15,
  width = 0.8
)

koala_yes_label <- a_label(
  text = "Yes",
  id = "yesText",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

koala_yes_plane <- a_entity(
  .tag = "plane",
  .children = list(koala_yes_label),
  id = "yesPlane",
  visible = FALSE,
  position = c(-0.25, -0.3, -1),
  color = white,
  height = 0.3,
  width = 0.3
)

# Outer boundary for intersection detection
koala_yes_plane_boundary <- a_entity(
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

koala_no_label <- a_label(
  text = "No",
  id = "noText",
  color = black,
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

koala_no_plane <- a_entity(
  .tag = "plane",
  .children = list(koala_no_label),
  id = "noPlane",
  visible = FALSE,
  position = c(0.25, -0.3, -1),
  color = white,
  height = 0.3,
  width = 0.3
)

# Outer boundary for intersection detection
koala_no_plane_boundary <- a_entity(
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
animals <- a_scene(.children = list(canvas_3d, koala_yes_plane_boundary, koala_no_plane_boundary, camera, koala_question_plane, koala_yes_plane, koala_no_plane),
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

# TODO: Refactor
show_messages <- list(
  a_update(id = "questionPlane",
           component = "visible",
           attributes = TRUE),
  a_update(id = "yesPlane",
           component = "visible",
           attributes = TRUE),
  a_update(id = "noPlane",
           component = "visible",
           attributes = TRUE),
  a_update(id = "yesPlaneBoundary",
           component = "visible",
           attributes = TRUE),
  a_update(id = "noPlaneBoundary",
           component = "visible",
           attributes = TRUE)
)

hide_messages <- list(
  a_update(id = "questionPlane",
           component = "visible",
           attributes = FALSE),
  a_update(id = "yesPlane",
           component = "visible",
           attributes = FALSE),
  a_update(id = "noPlane",
           component = "visible",
           attributes = FALSE),
  a_update(id = "yesPlaneBoundary",
           component = "visible",
           attributes = FALSE),
  a_update(id = "noPlaneBoundary",
           component = "visible",
           attributes = FALSE)
)

# Toggle Question
pop <- function(animal_messages = displayed_messages, visible = TRUE){
  if (visible) {
    animals$send_messages(show_messages)
  } else {
    animals$send_messages(hide_messages)
  }
}

# Current image number
CONTEXT_INDEX <- 1

contexts <- paste("img", seq(1,length(img_paths),1), sep="")
# TODO: Rotation of images should be passed in
# NOTE: These rotations are on the go() fn => the first image needs to be rotated when its rendered (near top: canvas_3d - rotation)
context_rotations <- list(list(x = 0, y = 0, z = 0),
                          list(x = 0, y = 0, z = 0),
                          list(x = 0, y = 0, z = 0),
                          list(x = 0, y = 0, z = 0))

# Next (or particular) image
# TODO: Either add more params or refactor or both - emphasis on changing setup_scene
go <- function(image_paths = img_paths, setup_scene = context_rotations , index = NA){
  
  if(!is.na(index)) CONTEXT_INDEX <<- index

  if(is.na(index)) {
    CONTEXT_INDEX <<- ifelse(CONTEXT_INDEX > length(contexts) - 1,
                             yes = 1,
                             no = CONTEXT_INDEX + 1)
  }


  next_image <- contexts[[CONTEXT_INDEX]]

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
             attributes = white),
    a_update(id = "noPlane",
             component = "color",
             attributes = white)
  ))
}

# Get data from database with API GET request
read <- function(url = "https://test-api-koala.herokuapp.com/koala"){
  # Deserialize the payload so data can be read and converted from JSON to data frame
  data.df <<- jsonlite::fromJSON(httr::content(httr::GET(url), "text"), flatten = TRUE)
  return(data.df)
}
