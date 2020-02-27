#' Create a binary question scene
#'
#' @param the_question Question message to display
#' @param answer_1 Binary answer for \code{1} (Yes)
#' @param answer_2 Binary answer for \code{0} (No)
#' @param img_paths Character string of image paths from current working directory
#' @param IPv4_ADDRESS The same IPv4 addressed used to start VR server
#' @param animal_class Character string for database 
#' @param message_height Optional numeric value for height of question and answer boxes (default \code{1.5})
#'
#' @return
#' @export
#'
#' @examples
#' \donttest{
#' animals <- binary_question_scene("Do you see any koalas in this image?", "Yes", "No", img_paths)
#' }
#' 
binary_question_scene <- function(the_question, answer_1, answer_2, img_paths, IPv4_ADDRESS, animal_class, message_height = 1.5){
  
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
                        .js_sources = list("https://cdn.jsdelivr.net/gh/milesmcbain/r2vr@master/inst/js/button_controls.js", 
                                           "https://cdn.jsdelivr.net/gh/milesmcbain/r2vr@master/inst/js/binary_interactions.js"),
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
    class = animal_class
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
    height = 0.2,
    width = 1,
    position = c(0, 0.02, 0)
  )
  
  question_plane <- a_entity(
    .tag = "plane",
    .children = list(question_label),
    id = "questionPlane",
    visible = FALSE,
    position = c(0, message_height+0, -1),
    color = white,
    height = 0.15,
    width = 0.8
  )
  
  yes_label <- a_label(
    text = answer_1,
    id = "yesText",
    color = black,
    font = "mozillavr",
    height = 1,
    width = 1,
    position = c(0, 0, 0)
  )
  
  yes_plane <- a_entity(
    .tag = "plane",
    .children = list(yes_label),
    id = "yesPlane",
    visible = FALSE,
    position = c(-0.25,message_height+-0.3, -1),
    color = white,
    height = 0.3,
    width = 0.3
  )
  
  # Outer boundary for intersection detection
  yes_plane_boundary <- a_entity(
    .tag = "ring",
    id = "yesPlaneBoundary",
    position = c(-0.25, message_height+-0.3, -1),
    visible = FALSE,
    color = dark_red,
    radius_inner = 0.24,
    radius_outer = 0.25,
    segments_theta = 4,
    theta_start = 45
  )
  
  no_label <- a_label(
    text = answer_2,
    id = "noText",
    color = black,
    font = "mozillavr",
    height = 1,
    width = 1,
    position = c(0, 0, 0)
  )
  
  no_plane <- a_entity(
    .tag = "plane",
    .children = list(no_label),
    id = "noPlane",
    visible = FALSE,
    position = c(0.25, message_height+-0.3, -1),
    color = white,
    height = 0.3,
    width = 0.3
  )
  
  # Outer boundary for intersection detection
  no_plane_boundary <- a_entity(
    .tag = "ring",
    id = "noPlaneBoundary",
    visible = FALSE,
    position = c(0.25,message_height+-0.3, -1),
    color = dark_red,
    radius_inner = 0.24,
    radius_outer = 0.25,
    segments_theta = 4,
    theta_start = 45
  )
  
  # Create Scene
  animals <- a_scene(.children = list(canvas_3d, yes_plane_boundary, no_plane_boundary, camera, question_plane, yes_plane, no_plane),
                     .websocket = TRUE,
                     .websocket_host = IPv4_ADDRESS,
                     .template = "empty",
                     button_controls="debug: true;",
                     binary_button_controls = ""
  )
  return(animals)
}
