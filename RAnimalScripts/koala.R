library(r2vr)

LOCAL_IP <- "192.168.0.101"

image_path_3d <- "../images/koalas/KP5.jpg"

image_3d <- a_asset(.tag = "image",
                    id = "img1",
                    src = image_path_3d)

canvas_3d <- a_entity(.tag = "sky",
                      .js_sources = list("../js/button_controls.js", "../js/binary_interactions.js", "../js/selection_interactions.js"),
                      id = "canvas3d",
                      src = image_3d,
                      rotation = c(0, 0, 0))
# Create a cursor
cursor <- a_entity(
  .tag = "cursor",
  color = "#ff0000"
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
  text = "Do you see a koala?",
  id = "koalaPlaneText",
  color = "#FF0000",
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

koala_question_plane <- a_entity(
  .tag = "plane",
  .children = list(koala_question_label),
  id = "koalaPlane",
  position = c(0, 0, -1),
  color = "#FFFFFF",
  height = 0.4,
  width = 0.8,
)

koala_yes_label <- a_label(
  text = "Yes",
  id = "koalaYesText",
  color = "#FF0000",
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

koala_yes_plane <- a_entity(
  .tag = "plane",
  .children = list(koala_yes_label),
  id = "koalaYesPlane",
  button_controls="debug: true;",
  position = c(-0.25, -0.4, -1),
  color = "#FFFFFF",
  height = 0.3,
  width = 0.3
)

# Outer boundary for intersection detection
koala_yes_plane_boundary <- a_entity(
  .tag = "ring",
  id = "koalaYesPlaneBoundary",
  position = c(-0.25, -0.4, -1),
  color = "#FF0000",
  radius_inner = 0.24,
  radius_outer = 0.25,
  segments_theta = 4,
  theta_start = 45
)

koala_no_label <- a_label(
  text = "No",
  id = "koalaNoText",
  color = "#FF0000",
  font = "mozillavr",
  height = 1,
  width = 1,
  position = c(0, 0, 0)
)

koala_no_plane <- a_entity(
  .tag = "plane",
  .children = list(koala_no_label),
  id = "koalaNoPlane",
  position = c(0.25, -0.4, -1),
  color = "#FFFFFF",
  height = 0.3,
  width = 0.3,
)

# Outer boundary for intersection detection
koala_no_plane_boundary <- a_entity(
  .tag = "ring",
  id = "koalaNoPlaneBoundary",
  position = c(0.25, -0.4, -1),
  color = "#FF0000",
  radius_inner = 0.24,
  radius_outer = 0.25,
  segments_theta = 4,
  theta_start = 45
)

tour <- a_scene(.children = list(canvas_3d, koala_yes_plane_boundary, koala_no_plane_boundary, camera, koala_question_plane, koala_yes_plane, koala_no_plane),
                .websocket = TRUE,
                .websocket_host = LOCAL_IP,
                .template = "empty",
                button_controls_test = "")

# Start the server
start <- function(){
  tour$serve(host = LOCAL_IP)
}

# End the server
end <- function(){
  a_kill_all_scenes()
}
