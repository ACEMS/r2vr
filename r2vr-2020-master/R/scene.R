## A global to hold references to all scenes to provide a kill-all function.
globalVariables(c(".r2vr_all_running_scenes"), "r2vr")
.r2vr_all_running_scenes <- new.env(parent = emptyenv())

A_Scene <-
  R6::R6Class("A_Scene",
              inherit = A_Entity,
              public = list(
                template = NULL,
                scene = NULL,
                title = NULL,
                description = NULL,
                aframe_version = NULL,
                global_id = NULL,
                ws_message_hooks = list(),
                initialize = function(.template = "basic_map",
                                      .title = "A-Frame VR scene created with r2vr",
                                      .description = .title,
                                      .aframe_version = "0.8.2",
                                      .js_sources = NULL,
                                      .children = NULL,
                                      ...){

                  ## If template is not a file, assume it is a built-in
                  if (!file.exists(.template)){
                    template_file <-
                      paste0(file.path("templates",.template),".html")
                    template_file_path <- system.file(template_file, package = "r2vr")
                    if (!file.exists(template_file_path)){
                      stop("A-Frame Scene template: ", .template ,", not found")
                    }
                  } else{
                    template_file_path <- .template
                  }
                  self$template <- readr::read_file(template_file_path)


                  self$global_id <- uuid::UUIDgenerate(use.time = TRUE)
                  self$title <- .title
                  self$description <- .description
                  self$aframe_version <- .aframe_version

                  ## Call constructor for A_Entity
                  super$initialize(.js_sources = .js_sources,
                                   .children = .children, ...)
                },

                render = function(){
                  template_env <- new.env()

                  ## title
                  template_env$title <- self$title

                  ## description
                  template_env$description <- self$description

                  ## A-Frame Version
                  template_env$aframe_version <- self$aframe_version

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
                  stringr::str_interp(string = self$template, env = template_env)
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

                  ## Instantiate a server for the scene
                  self$scene <- fiery::Fire$new(...)

                  ## Instaniate a http route stack to contain http routes.
                  route_stack <- routr::RouteStack$new()

                  ## Create http routes for scene server
                  ## Add route route.
                  root_route <- routr::Route$new()
                  root_route$add_handler('get', '/',
                                         function(request, response, keys, ...){
                                           response$status <- 200L
                                           response$type <- 'html'
                                           response$body <- scene_html
                                           return(FALSE)
                                         })
                  route_stack$add_route(root_route, "root")

                  ## identify assests that are local and require http routes
                  routable_assets <- purrr::keep(self$assets, ~.$is_local())

                  ## Deal with routable assets
                  if (length(routable_assets) > 0){

                    ## Generate routes for assests
                    ## add routes into http route stack
                    purrr::walk(routable_assets, function(asset){
                      route_stack$add_route(self$generate_asset_routes(asset), asset$id)
                    })
                  }

                  ## identify local Javascript sources that need http routes.
                  routable_sources <- self$js_sources[!has_url_prefix(self$js_sources)]

                  ## Deal with routable sources
                  if(length(routable_sources) > 0){

                    ## generate routes to sources
                    ## add to route stack.
                    purrr::walk(routable_sources, function(source){
                      assert_file_exists(source)
                      route_stack$add_route(self$generate_source_routes(source),
                                            name = fs::path_file(source))
                    })
                  }

                  ## Add http route stack to the scene
                  self$scene$attach(route_stack)


                  ## setup the app to handle ws messages
                  self$scene$on('message', function(server,
                                                    id,
                                                    binary,
                                                    message,
                                                    request,
                                                    arg_list){
                    ## Only bother parsing message if hooks are present
                    if(length(self$ws_message_hooks) == 0) return(NULL)

                    if(binary) stop("recieved a binary websocket payload. I cannot deparse.")

                    message_JSON <- jsonlite::toJSON(message, auto_unbox =  TRUE)

                    ## Walk all the attached hooks calling with the message and sender id.
                    purrr::walk(self$ws_message_hooks, ~.x(message = message_JSON,
                                                           id = id))
                    return(NULL)
                  })

                  ## Start serving
                  self$scene$ignite(block = FALSE)

                  ## Add to pool of all running scenes
                  self$add_to_global_pool()

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
                    path <- sanitise_route_path(path)

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

                generate_source_routes = function(source){
                  source_data <- readr::read_file(source)
                  path <- sanitise_route_path(source)
                  source_routes <- routr::Route$new()

                  ## Add get route
                  source_routes$add_handler('get', path,
                                            function(request, response, keys, ...){
                                              response$status <- 200L
                                              response$type <- mime::guess_type(source)
                                              response$body <- source_data
                                              return(FALSE)
                                            })

                  ## Add head route
                  source_routes$add_handler('head', path,
                                            function(request, response, keys, ...){
                                              response$status <- 304L
                                              response$type <- mime::guess_type(source)
                                              response$body <- ""
                                              return(FALSE)
                                            })


                },

                stop = function(){
                  if (is.null(self$scene)){
                   stop("Cannot stop serving scene. Not currently serving scene.")
                  }
                  else {
                    self$scene$extinguish()
                    self$scene <- NULL
                    self$remove_from_global_pool()
                  }
                },

                write = function(filename){
                  scene <- self$render()
                  readr::write_file(x =scene, path = filename)
                },

                add_to_global_pool = function(){
                  assign(x = self$global_id,
                         value = self,
                         envir = .r2vr_all_running_scenes)
                },

                remove_from_global_pool = function(){
                  rm(list = self$global_id,
                     envir = .r2vr_all_running_scenes)
                },

                attach_ws_msg_hook = function(handler){
                  ## Assert handler(message, client_id)
                  if(!is_ws_handler_fn(handler))
                    stop("Websocket message handlers can only have two arguments: message, id")

                  handler_id <- uuid::UUIDgenerate(use.time = TRUE)
                  self$ws_message_hooks[[handler_id]] <- handler
                  handler_id
                },

                send_messages = function(messages, ...){
                  ## ... is further args passed to Fire::send(message, id)

                  ## Check if messages is a single message or list
                  ## if it's a single message, need to wrap in list() so that
                  ## the JSON will look correct to the javascript in the scene
                  if (is_r2vr_message(messages)){
                    ## It's a single message, wrap.
                    messages <- list(messages)
                  }
                  if (!is_r2vr_message_list(messages)){
                    stop("r2vr can only send objects of type 'r2vr_message'. An object of another type was supplied in messages")
                  }
                  ## Peel off the class in each
                  self$scene$send(jsonlite::toJSON(messages, auto_unbox = TRUE), ...)
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
##' entities. Included templates are:
##'     * 'basic' Scene which is empty but for a 10m x 10m grid for ground.
##'     Default lights are injected by A-Frame.
##'     * 'basic_map' As per basic but camera position starts higher, and WASD
##'     movement controls are added. A bright light is situated high in the sky.
##'     * 'empty' an empty scene. Default lights are injected by A-Frame.
##' The built-in templates are intended for debugging/construction purposes. Use
##' 'empty' for real scenes or build your own template.
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
##' @param .template A name of a built in template or a path to a custom html template.
##' @param .title Title of the scene passed into the HTML
##' @param .description meta description of the scene passed into the HTML
##' @param .aframe_version The version of A-Frame to serve the scene with, defaults to 0.8.2
##' @param .js_sources a character vector of javascript scources to be added to
##'   scene html. Local sources will be served remote sources will not.
##' @param .children a list of child A-Frame entities of this scene.
##' @param .websocket TRUE if this scene should try to connect to its server with
##'   a websocket connection when served. This can be used to pass messages
##'   containing aframe events or entity updates from R to VR.
##' @param .websocket_host The host for the websocket in the client's browser to
##'   connect to (IP of r2vr sever).
##' @param .websocket_port The port for the
##'   websocket in the client's browser to connect to on the host.
##' @param ... components to be added to the scene.
##' @return An R6 object representing an A-Frame scene.
##' @export
a_scene <- function(.template = "basic_map",
                    .title = "A-Frame VR scene created with r2vr",
                    .description = .title,
                    .aframe_version = "0.8.2",
                    .js_sources = NULL,
                    .children = NULL,
                    .websocket = FALSE,
                    .websocket_host = "localhost",
                    .websocket_port = 8080,
                    ...){
  scene_args <- list(.template = .template, .title = .title,
                     .description = .title, .aframe_version = .aframe_version,
                     .js_sources = .js_sources,
                     .children = .children, ...)
  if(.websocket){
    ## If websocket desired, add the r2vr components js source.
    # TODO: change source when made public
    # scene_args$.js_sources <- c(scene_args$.js_sources,
    #                             "https://cdn.jsdelivr.net/gh/ACEMS/r2vr@interactions/inst/js/r2vr_components.js")
    # TODO: Consider addings arg so web sockets functionality works w/o r2vr2 script
    # scene_args$.js_sources <- c(scene_args$.js_sources,
    #                            "https://cdn.jsdelivr.net/gh/ACEMS/r2vr@coral-cover/inst/js/r2vr_components.js")
    scene_args$r2vr_message_router = list(host = .websocket_host,
                                          port = .websocket_port)
  }
  do.call(A_Scene$new, scene_args)
}

##' Kill all running A-Frame Scenes
##'
##' Frequently in development you may accidentally loose a handle to a running
##' scene, meaning it will block a port you wish to run a new scene on. This
##' kills all running scenes to free up all ports being used to serve by r2vr.
##'
##' @title a_kill_all_scenes
##' @return nothing.
##' @export
a_kill_all_scenes <- function(){
  active_scenes <- ls(envir = .r2vr_all_running_scenes)

  purrr::map(active_scenes, function(scene){
    aframe_scene <- get(scene, envir = .r2vr_all_running_scenes)
    aframe_scene$stop()
  })

}
##' is this an A-Frame scene
##'
##' @title is_a_scene
##' @param x an object
##' @return true if object is an "A_Scene"
##' @export
is_a_scene <- function(x) inherits(x, "A_Scene")
