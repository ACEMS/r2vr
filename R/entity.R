A_Entity <-
  R6::R6Class("A_Entity",
          public = list(
            assets = NULL,
            sources = NULL,
            components = NULL,
            children = NULL,
            tag = NULL,
            id = NULL,
            initialize = function(tag = "entity", sources = "", ...){
              components = list(...)
              self$tag <- tag
              self$components <- list(...)
              self$sources <- sources

              ## fetch and add assets
              self$assets <- self$find_assets()
            },

            render = function(){
              component_expansion <- purrr::map2(names(self$components),
                                        self$components,
                                        self$render_component)

              paste0(
                    paste0("<a-", self$tag),' ',
                    ifelse(!is.null(self$id), paste0(self$render_id(),' '), ''),
                    paste(component_expansion, collapse = " "),
                    paste0("></a-", self$tag,">")) # At some point children will get added in here
            },

            get_assests = function(){},

            get_sources = function(){},

            add_child = function(){},

            render_component = function(key, value){
              ## convert underscores('_') in keys to dashes ('-') 
              key <- gsub( x = key, pattern = "_", replacement = "-")

              if(is.null(value)){
                ## just a component with no config.
                key
              }
              else if(is.character(value)){
                paste0(key,'=\"',value,'"')
              }
              else if(is.logical(value)){
                paste0(key,'=\"',tolower(value),'"')
              }
              else if(is.numeric(value)){
                paste0(key,'=\"',paste(value, collapse = " "),'"')
              }
              else if(is.list(value)){
                # for vectors of ints or numerics
                props = purrr::map2(names(value), value, self$render_property)
                paste0(key,'="',paste0(props, collapse = " "),'"')
              }
              else if(is(value, "A_Asset")){
                ## Special handling if it's an asset.
                ## Assets know how to render themselves
                paste0(key,'=\"',value$reference(),'"')
              }
            }, # should be private

            render_property = function(key, value){
              ## convert underscores('_') in keys to dashes ('-') 
              key <- gsub( x = key, pattern = "_", replacement = "-")

              if(is.na(value)){
                stop("tried to render NA value for ", key, "in property list")
              }
              if(is.character(value)){
                paste0(key,": ",value,";")
              }
              else if(is.logical(value)){
                paste0(key,": ",tolower(value),";")
              }
              else if(is.numeric(value)){
                paste0(key,": ",paste(value, collapse = " "),";")
              }
              else if(is(value, "A_Asset")){
                paste0(key,": ",value$reference(),";")
              }
            }, # should be private

            render_id = function(){
              if(is.null(self$id)) "" else self$id
            }, # should be private

            find_assets = function(){
              assets <- purrr::keep(self$components, ~is(., "A_Asset")) 
              nested_assets <-
                purrr::keep(self$components, is.list) %>%
                purrr::map(~purrr::keep(., ~is(., "A-Asset"))) %>%
                purrr::flatten()
              c(assets, nested_assets)
            }
          )
  )

##' Create an A-Frame entity
##'
##' This function creates an A-Frame entity object to be inserted into to an
##' A-Frame scene. The A-Frame scene object instructs entities to render
##' themselves to html, when serving or writing itself.
##'
##' Function arguments map directly to underlying entity components expressed in
##' the html. There two tricks to this: 1. components specified in R must use an
##' underscore ('_') where a dash would appear in an A-Frame component name. 2.
##' components specified by name only, without any configuration must use the
##' form `component_name = NULL`. For example: to create an A-Frame entity with
##' the `wasd-controls` component attached, this function would be called as
##' `a_entity(wasd_controls = NULL)`.
##'
##' Component configuration can be expressed in character form, e.g.
##' `wasd_controls = "fly: true; acceleration: 65"` in which case it is passed
##' into html directly. It can also be expressed as a list: `wasd_controls =
##' list(fly = TRUE, acceleration = 65)`, in which case it is converted to the
##' appropriate text.
##'
##' @title a_entity
##' @param id an optional id for the entity, useful if you want to later add children to it.
##' @param tag text for the entity tag. The default is "a-entity", but it can be
##'   used to create any of the A-Frame built-ins for example using "a-sphere"
##' @param sources a vector of links to Javascript files this entity depends on.
##'   Useful if adding a community-made component to an entity. The script file
##'   will be automatically be sourced in the html header by the parent scene.
##' @param ... components to be added to the entity. See description.
##' @return A_Entity object
##' @export
a_entity <- function(...){
  A_Entity$new(...)
}
