# A first stab at an entity that can work with code in fictional_API.md

A_Entity <-
  R6::R6Class("A_Entity",
          public = list(
            paths = NULL,
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
              paste(
                    paste0("<a-", self$tag),
                    self$render_id(),
                    paste(component_expansion, collapse = " "),
                    paste0("></a-", self$tag,">")) # At some point children will get added in here
            },

            get_paths = function(){},

            get_assests = function(){},

            get_sources = function(){},

            add_child = function(){},

            render_component = function(key, value){
              if(is.null(value)){
                ## just a component with no config.
                key
              }
              else if(is.character(value)){
                paste0(key,'=\"',value,'"')
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
              if(is.na(value)){
                stop("tried to render NA value for ", key, "in property list")
              }
              if(is.character(value)){
                paste0(key,": ",value,";")
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
