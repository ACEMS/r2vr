#' Generates the entities needed for the specified number of markers for the module
#'
#' @param module String to indicate if "2d" or "3d"
#'
#' @examples 
#' \donttest{
#' shared_generate_markers("2d")
#' shared_generate_markers("3d")
#' }
#'
#' @export
shared_generate_markers <- function(module = MODULE, module_type = MODULE_TYPE) {
  # Append markers to the end of the list of children entities
  list_length <- length(list_of_children_entities)
  
  # TODO: consider refactoring
  if (module == "2d") {
    for (i in 1:NUMBER_OF_MARKERS) {
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
      
      coral_label_text_x <- -2 * MARKER_OUTER_RADIUS - TEXT_BOX_EDGE_SIZE
      not_coral_label_text_x <- MARKER_OUTER_RADIUS + TEXT_BOX_EDGE_SIZE
      text_size <- 25 * MARKER_OUTER_RADIUS
      
      coral_label <- a_entity(
        .tag = "text",
        id = paste0("coralText", i),
        value = "C",
        width = text_size,
        color = COLOR_TEXT,
        position = c(coral_label_text_x, 0, 0),
        geometry = list(primitive = "box", width = DELTA, height = DELTA, depth = DELTA)
      )
      
      not_coral_label <- a_entity(
        .tag = "text",
        id = paste0("notCoralText", i),
        value = "N",
        width = text_size,
        color = COLOR_TEXT,
        position = c(not_coral_label_text_x, 0, 0),
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
        position = c(0, 0, canvas_z + 0.02),
        radius_inner = 0.00001, # TODO: check 0?
        radius_outer = 0.00001,
        opacity = 0,
        debug = "", # needed for x and y position after an update via web sockets
        visible = FALSE
      )
      
      marker_container_number <- paste0("markerContainer", i)
      list_of_children_entities[[list_length + i]] <<- assign(marker_container_number, marker_container)
    }
  } else if (module == "3d") {
      for (i in 1:NUMBER_OF_MARKERS) {
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
        
        coral_label_text_x <- -2 * MARKER_OUTER_RADIUS - TEXT_BOX_EDGE_SIZE
        not_coral_label_text_x <- MARKER_OUTER_RADIUS + TEXT_BOX_EDGE_SIZE
        text_size <- 25 * MARKER_OUTER_RADIUS
        
        coral_label <- a_entity(
          .tag = "text",
          id = paste0("coralText", i),
          value = "C",
          width = text_size,
          color = COLOR_TEXT,
          position = c(coral_label_text_x, 0, 0.2),
          geometry = list(primitive = "box", width = DELTA, height = DELTA, depth = DELTA),
        )
        
        not_coral_label <- a_entity(
          .tag = "text",
          id = paste0("notCoralText", i),
          value = "N",
          width = text_size,
          color = COLOR_TEXT,
          position = c(not_coral_label_text_x, 0, 0.2),
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
          radius_inner = 0.00001,
          radius_outer = 0.00001,
          opacity = 0,
          debug = "", # needed for x, y, and z position after an update via web sockets
          visible = FALSE
        )
        
        marker_container_number <- paste0("markerContainer", i)
        list_of_children_entities[[list_length + i]] <<- assign(marker_container_number, marker_container)
      }
  }
}
