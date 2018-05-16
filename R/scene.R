A_Scene <-
  R6::R6Class("A_Scene",
              inherit = A_Entity,
              public = list(
                template = NULL,
                scene = NULL,
                initialize = function(template = "basic", ...){

                  ## If template is not a file, assume it is a built-in
                  if (!file.exists(template)){
                    template_file <-
                      paste0(file.path("inst","templates",template),".html")
                    template_file_path <- system.file(template_file, package = "r2vr")
                    if (!file.exists(template_file_path)){
                      stop("A-Frame Scene template: ", template ,", not found")
                    }
                  } else{
                    template_file_path <- template
                  }
                  self$template <- readr::read_file(template_file_path)

                  ## Call constructor for A_Entity
                  super$initialize(...)
                },

                render = function(){
                  template_env <- new.env()

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

                  ## sources
                  if(length(self$sources) > 0){
                    source_tags <-
                      paste0("<script crossorigin src=\"", self$sources,"\"></script>",
                             collapse = "\n")

                    template_env$sources <-
                      self$indent_to_level(source_tags, "sources")
                  } else{
                    template_env$sources <- ""
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

                serve = function(port = 8000){
                  ## This function sets up a fiery server with routes to the
                  ## html scene html file and all the assets

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
                      route_stack$add_route(self$generate_asset_route(asset), asset$id)
                    })
                  }

                  ## Add and Serve the scene
                  self$scene <- fiery::Fire$new(port = port)
                  self$scene$attach(route_stack)
                  self$scene$ignite(block = FALSE)
                  
                },

                ## TODO cache the assets somehow.
                generate_asset_route = function(asset){
                  asset_route <- routr::Route$new()

                  ## sanitise asset src
                  src <- gsub("^\\.+", "", asset$src)

                  ## Add get route
                  asset_route$add_handler('get', src,
                          function(request, response, keys, ...){
                            response$status <- 200L
                            response$type <- asset$content_type
                            response$body <- asset$get_content()
                            return(FALSE)
                          }
                          )
                  asset_route$add_handler('head', src,
                          function(request, response, keys, ...){
                            response$status <- 304L
                            response$type <- asset$content_type
                            response$body <- ""
                            return(FALSE)
                          }
                          )
                          
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
##' that contains some Javascript sources, and potentially some convenient
##' entities, for example: a flat plane that forms the 'ground' of the scene in
##' the included "basic" template.
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
##' @param template
##' @param children
##' @param ...
##' @return
##' @export
a_scene <- function(...){
  A_Scene$new(...)
}
