#' Sets up the canvas, camera/cursor, and metadata for the selected module and module type. Also renders USER and META DATA  as invisible entities for the DOM to access data for network requests
#'
#' @param module String "2d" || "3d"
#' @param module_type String "training" || "testing"
#'
#' @return A-Frame entity scene
#'
#' @examples 
#' \donttest{
#' shared_setup_scene("2d", "training")
#' shared_setup_scene("2d", "testing")
#' shared_setup_scene("3d", "training")
#' shared_setup_scene("3d", "testing")
#' }
#'
#' @export
shared_setup_scene <- function(module, module_type){
  is_module_ok <- module == "2d" || module == "3d"
  is_module_type_ok <- module_type == "training" || module_type == "testing"
  if (!is_module_ok) {
    stop("Invalid module param - Please input the string '2d' or '3d'")
  } else if (!is_module_type_ok) {
    stop("Invalid module_type param - Please input the string 'training' or 'testing'")
  }
  
  # NOTE: Import to set META DATA for network requests
  set_metadata(module, module_type)
  
  cdn_js_folder <- "https://cdn.jsdelivr.net/gh/Jon-Peppinck/r2vr-2020@temp3/inst/js/"
  # TODO: TEMP ONLY - DEBUG
  # if (module == "3d" && module_type == "testing") {
  #   cdn_js_folder <<- "https://cdn.jsdelivr.net/gh/Jon-Peppinck/r2vr-2020@temp/inst/js/"
  # }
  js_file <- paste0(module_type, module, ".js")
  js_cdn <- paste0(cdn_js_folder, js_file)
  button_controls_cdn <- paste0(cdn_js_folder, "button_controls.js")
  look_at_cdn <- paste0(cdn_js_folder, "look_at.js")
  # TODO: dev
  # cdn_js_file_dev <- paste0("./inst/js/", js_file)
  
  if (module == "2d") {
    # Create a canvas for the image to be attached to
    canvas <- a_entity(
      .tag = "plane",
      # TODO: CDN Subject to change
      .js_sources = list(
        button_controls_cdn,
        js_cdn
        # cdn_js_file_dev
      ),
      .assets = list_of_non_first_images,
      id = "canvas",
      src = image1,
      class = image1Path,
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
  } else if (module == "3d") {
    # Create 3D sky with images
    canvas <- a_entity(
      .tag = "sky",
      .js_sources = list(
        button_controls_cdn,
        look_at_cdn,
        js_cdn
      ),
      id = "canvas",
      class = image1Path,
      src = image1,
      rotation = c(0, 0, 0),
      .assets = list_of_non_first_images
    )
    # Create a cursor
    cursor <- a_entity(
      .tag = "cursor",
      look_controls = "",
      camera = "",
      color = COLOR_CAMERA_CURSOR
    )
  }
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
  # Invisible entity to store colors
  colors <- a_entity(
    .tag = "circle",
    id = "colors",
    class = COLORS_RESPONSIVE,
    checked = FALSE,
    opacity = 0,
    radius = 0
  )
  # Position cursor in center of camera
  camera <- a_entity(
    .tag = "camera",
    .children = list(cursor),
    cursor = "",
    position = c(0, 0, 0)
  )

  assign("list_of_children_entities", list(canvas, camera, user, meta_data, colors), envir = .GlobalEnv)
  
  if (module_type == "testing") {
    generate_evaluation_questions()
  }
  
  shared_generate_markers(module, module_type)
  ## Render Scene
  animals <- a_scene(
    .children = list_of_children_entities,
    .websocket = TRUE,
    .websocket_host = IPv4_ADDRESS,
    .template = "empty",
    button_controls = "debug: true;",
    toggle_menu_listen = ""
  )
  return(animals)
}