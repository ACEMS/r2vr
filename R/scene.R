A_Scene <-
  R6::R6Class("A_Scene",
              inherit = A_Entity,
              public = list(
                template = NULL,
                scene = NULL,
                title = NULL,
                description = NULL,
                initialize = function(template = "basic_map",
                                      title = "A-Frame VR scene created with r2vr",
                                      description = title,
                                      children = NULL,
                                      ...){

                  ## If template is not a file, assume it is a built-in
                  if (!file.exists(template)){
                    template_file <-
                      paste0(file.path("templates",template),".html")
                    template_file_path <- system.file(template_file, package = "r2vr")
                    if (!file.exists(template_file_path)){
                      stop("A-Frame Scene template: ", template ,", not found")
                    }
                  } else{
                    template_file_path <- template
                  }
                  self$template <- readr::read_file(template_file_path)

                  self$title <- title
                  self$description <- description

                  ## Call constructor for A_Entity
                  super$initialize(children = children, ...)
                },

                render = function(){
                  template_env <- new.env()

                  ## title
                  template_env$title <- self$title

                  ## description
                  template_env$description <- self$description

                  ## scene components
                  if (length(self$components) > 0) {
                    template_env$scene_components <-
                      paste0(self$render_component_list(), collapse = " ")
                  } else {
                    template_env$scene_components <- ""
                  }

                  ## entities
                  if (length(self$children) > 0){
                    ## ask children to render
                    child_tags <-
                      purrr::map(self$children, ~.$render())

                    ## indent them to correct position in template
                    ## paste into single block
                    template_env$entities <-
                      self$indent_to_level(paste0(child_tags, collapse = ""),
                                      "entities")

                  } else {
                    template_env$entities <- ""
                  }

                  ## assets
                  if(length(self$assets) > 0){
                    ## ask assets to render
                    asset_tags <-
                      purrr::map(self$assets, ~.$render())

                    template_env$assets <-
                      self$indent_to_level(paste0(asset_tags, collapse = "\n"),
                                      "assets")
                  } else {
                    template_env$assets <- ""
                  }

                  ## js_sources
                  if(length(self$js_sources) > 0){
                    source_tags <-
                      paste0("<script crossorigin src=\"", self$js_sources,"\"></script>",
                             collapse = "\n")

                    template_env$js_sources <-
                      self$indent_to_level(source_tags, "js_sources")
                  } else{
                    template_env$js_sources <- ""
                  }

                  stringr::str_interp(self$template, template_env)
                },

                indent_to_level = function(text, element){
                  ## find the indent level of the template element
                  regex <- paste0("\\n\\s*\\$\\{",element,"\\}")
                  elem_line <- stringr::str_extract(self$template, regex)
                  indent_level <- stringr::str_count(elem_line," ")

                  ## insert indents after every newline in text.
                  replacement <- paste0("\n",strrep(" ", indent_level))
                  stringr::str_replace_all(text,
                                           pattern = "\\n",
                                           replacement = replacement)
                },

                serve = function(...){
                  ## This function sets up a fiery server with routes to the
                  ## html scene html file and all the assets
                  ## Arguments are passed directly through to
                  ## the Fiery::Fire$new() method. Relevant args are
                  ## `host` defaulting to 127.0.0.1 and `port` defaulting to 8080.

                  ## Render Scene
                  scene_html <- self$render()

                  ## Create route for scene
                  root_route <- routr::Route$new()
                  root_route$add_handler('get', '/',
                                         function(request, response, keys, ...){
                                           response$status <- 200L
                                           response$type <- 'html'
                                           response$body <- scene_html
                                           return(FALSE)
                                         })

                  ## Create a route stack and add scene
                  route_stack <- routr::RouteStack$new()
                  route_stack$add_route(root_route, "root")

                  ## Deal with assets
                  if (length(self$assets) > 0){
                    ## Generate routes for assests
                    ## Compile routes in route stack
                    purrr::walk(self$assets, function(asset){
                      route_stack$add_route(self$generate_asset_routes(asset), asset$id)
                    })
                  }

                  ## Add and Serve the scene
                  self$scene <- fiery::Fire$new(...)
                  self$scene$attach(route_stack)
                  self$scene$ignite(block = FALSE)

                },

                ## TODO cache the assets somehow.
                generate_asset_routes = function(asset){
                  asset_routes <- routr::Route$new()

                  ## Get Asset Data
                  asset_data <- asset$get_asset_data()
                  ## Format of asset data:
                  ## path, content_type, accessor

                  ## Add routes for each row in asset_data
                  purrr::pwalk(asset_data, function(path, content_type, accessor){
                    ## sanitise path
                    ## remove a leading '.'
                    path <- gsub("^\\.+", "", path)

                    ## Ensure path starts with '/' and so is routable
                    ## Ugly regex: replace any string of chars not equal to '/'
                    ## at start of string with that same string of chars with
                    ## '/' prefixed
                    path <- gsub("(^[^/]+)", "/\\1", path)

                    ## Add get route
                    asset_routes$add_handler('get', path,
                                     function(request, response, keys, ...){
                                       response$status <- 200L
                                       response$type <- content_type
                                       response$body <- accessor()
                                       return(FALSE)
                                     }
                                     )
                    ## Add head route
                    asset_routes$add_handler('head', path,
                                       function(request, response, keys, ...){
                                         response$status <- 304L
                                         response$type <- content_type
                                         response$body <- ""
                                         return(FALSE)
                                       }
                                       )
                  })

                  asset_routes
                },

                stop = function(){
                  if (is.null(self$scene)){
                   stop("Cannot stop serving scene. Not currently serving scene.")
                  }
                  else {
                    self$scene$extinguish()
                    self$scene <- NULL
                  }
                },

                write = function(filename){
                  scene <- self$render()
                  readr::write_file(x =scene, path = filename)
                }
              ))


##' Create an A-Frame Scene
##'
##' This function creates an object that represents an A-Frame scene. A scene is
##' a special type of A-Frame entity that is the root entity of the WebVR scene.
##' Like regular entities it can have components added to it that change its
##' behaviour.
##'
##' A scene has a html representation that is based off a template supplied in
##' the `template` argument. The template is a partially filled out A-Frame html
##' that contains some Javascript js_sources, and potentially some convenient
##' entities, for example: a flat plane that forms the 'ground' of the scene in
##' the included "basic_map" template.
##'
##' A scene can render itself and all its child entities and assets to a single
##' html file that defines a WebVR scene that can be viewed in a browser. In
##' addition to this a scene can also be called upon to serve itself so that it
##' can be viewed immediately.
##'
##' Scene components are expressed as ... arguments passed to this function.
##'
##' Child entities are passed as list in the `children` argument.
##'
##' @title a_scene
##' @param template A name of a built in template or a path to a custom html template.
##' @param title Title of the scene passed into the HTML
##' @param description meta description of the scene passed into the HTML
##' @param children a list of child A-Frame entities of this scene.
##' @param ... components to be added to the scene.
##' @return An R6 object representing an A-Frame scene.
##' @export
a_scene <- function(template = "basic_map",
                    title = "A-Frame VR scene created with r2vr",
                    description = title,
                    children = NULL,
                    ...){
  A_Scene$new(template = template, title = title,
              description = title, children = children, ...)
}
