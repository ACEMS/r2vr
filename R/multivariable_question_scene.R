#' Create a multivariable question scene
#'
#' @param the_question Question message to display
#' @param answer_1 Answer option 1
#' @param answer_2 Answer option 2
#' @param answer_3 Answer option 3
#' @param answer_4 Answer option 4
#' @param img_paths Character string of image paths from current working directory
#' @param IPv4_ADDRESS The same IPv4 addressed used to start VR server
#' @param message_height Optional numeric value for height of question and answer boxes (default \code{1.5})
#'
#' @return
#' @export
#'
#' @examples
#' \donttest{
#' animals <- multivariable_question_scene("Do you see any of these habitat features in this image? If you do see a feature, click on the box to select it.",
#' "water", "Jaguar tracks", "Scratch marks", "Dense Vegetation", img_paths)
#' }
#' 
multivariable_question_scene <- function(the_question, answer_1, answer_2, answer_3, answer_4, img_paths, IPv4_ADDRESS, message_height = 1.5){
  
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
                        .js_sources = list("https://cdn.jsdelivr.net/gh/ACEMS/r2vr@master/inst/js/button_controls.js", "https://cdn.jsdelivr.net/gh/ACEMS/r2vr@master/inst/js/selection_interactions.js"),
                        id = "canvas3d",
                        class = img_paths[1],
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
  
  question_label <- a_label(
    text = the_question,
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
    text = answer_1,
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
    text = answer_2,
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
    text = answer_3,
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
    text = answer_4,
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
  
  # Create Scene
  animals <- a_scene(.children = list(canvas_3d, option_1_plane_boundary, option_2_plane_boundary, option_3_plane_boundary, option_4_plane_boundary, camera, question_plane, option_1_plane, option_2_plane, option_3_plane, option_4_plane, post_plane, post_plane_boundary),
                     .websocket = TRUE,
                     .websocket_host = IPv4_ADDRESS,
                     .template = "empty",
                     button_controls="debug: true;",
                     selection_button_controls = ""
  )
  return(animals)
}
