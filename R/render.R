af_render <- function(scene_title, object, scale){

  template <- readLines(system.file("templates/basic.html", package="aftool"))
  template_args <- new.env()
  template_args$title <- scene_title
  template_args$scale <- scale
  af_html <- purrr::map(template, ~stringr::str_interp(., template_args))

  # Handler for app root
  root_route <- routr::Route$new()
  root_route$add_handler('get', "/",
    function(request, response, keys, ...) {
      response$status <- 200L
      response$type <- 'html'
      response$body <- paste0(af_html, collapse = "\r\n")
      return(FALSE)
    }
  )

  # Handler for object JSON file
  object_route <- routr::Route$new()
  object_route$add_handler('get', "_object.json",
    function(request, response, keys, ...){
      response$status <- 200L
      response$type <- "json"
      response$body <- readLines(object)
      return(FALSE)
    }
  )

  # Create Route Stack
  routr_stack <- routr::RouteStack$new()
  routr_stack$add_route(root_route, "root")
  routr_stack$add_route(object_route, "object")

  # Create VR app
  app <- fiery::Fire$new()
  app$attach(routr_stack)
  app$ignite(block = TRUE)
  # In Terminal (or visit in browser)
  # curl http://127.0.0.1:8080/
}


