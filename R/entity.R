A_Entity <-
  R6::R6Class("A_Entity",
          public = list(
            assets = NULL,
            js_sources = NULL,
            components = NULL,
            children = NULL,
            tag = NULL,
            id = NULL,
            initialize = function(.tag = "entity", .js_sources = NULL, id = NULL,
                                  .children = NULL, .assets = NULL, ...){
              components <- list(...)
              self$tag <- .tag
              self$components <- list(...)
              self$js_sources <- list()

              ## add provided js sources if supplied.
              if(!is.null(.js_sources)){
                self$add_js_sources(.js_sources)
              }

              ## check assets supplied in .assets are all asset objects
              if (!purrr::every(.assets, ~is_a_asset(.))){
                stop("all elements of .assets must be asset objects created with a_asset()")
              }
              self$assets <- .assets

              ## fetch and add assets added in components
              self$add_assets(self$find_assets())

              ## Add children. It's imporant to do this after settting up assets
              ## and js_sources, since adding children will update these lists.
              self$children <- list()
              if (!is.null(.children)){
                if (!is.list(.children)){
                  stop(".children must be of type list or NULL.")
                }
                ## There are child entities to add.
                ## We call add_children on ourselves, but since it is setup to
                ## take ... we lift it to take list.
                purrr::lift_dl(self$add_children)(.children)
              }

              if (!is.null(id) && !is.character(id)){
                stop("id must be of type character or NULL")
              }
              self$id <- id
            },

            render = function(){
              ## Prepare render of my components
              component_expansion <- paste0(self$render_component_list(), collapse = " ")

              open_tag <- paste0(
                paste0("<a-", self$tag), # <a-tagtext
                ifelse(!is.null(self$id), paste0(' ',self$render_id()), ''), # id=""
                ifelse(length(component_expansion) > 0,
                       paste0(' ', component_expansion), ''), # comp1=""
                ">")

              if (length(self$children) > 0){
                ## We have children to nest. Add a newline to the end of the open_tag.
                open_tag <- paste0(open_tag,"\n")

                ## Tell all the children to render themselves
                child_tags <- purrr::map_chr(self$children, ~.$render())

                ## Add indentation to start of line in each tag
                child_tags <- gsub("(^|\\n(?!$))", "\\1  ", child_tags,
                                   perl = TRUE)

                ## Combine into 1 string.
                child_tags <- paste0(child_tags, collapse = "")
              } else {
                 child_tags <- NULL
              }

              closing_tag <- paste0("</a-", self$tag,">\n")

              ## Render all the html
              paste0(open_tag,
                     child_tags,
                     closing_tag)
            },

            get_assests = function(){},

            get_js_sources = function(){},

            add_children = function(...){
              children <- list(...)

              ## Add the child to my list
              if (purrr::some(children, ~!is_a_entity(.))){
                stop("Only entity objects can be added as children to entities.")
              }
              purrr::walk(children, function(child){
                if (!is.null(child$id)){
                  self$children[[child$id]] <- child
                }
                else {
                  self$children[[length(self$children)+1]] <- child
                }
                ## Add the child's js_sources to my js_sources and assets to my assets
                ## Only sources and assets we're not already tracking are added
                self$add_js_sources(child$js_sources)
                self$add_assets(child$assets)
              })
            },

            render_component_list = function(){
              purrr::map2(names(self$components),
                          self$components,
                          self$render_component)
            },

            render_component = function(key, value){
              ## replace underscores in names with dashes as appropriate.
              key <- self$escape_name(key)

              if (is_a_asset(value)){
                ## Special handling if it's an asset.
                ## Assets know how to render themselves
                paste0(key,'=\"',value$reference(),'"')
              }
              else if (is.null(value) | (is.character(value) && !nzchar(value))){
                ## just a component with no config.
                key
              }
              else if (is.character(value)){
                paste0(key,'=\"',value,'"')
              }
              else if (is.logical(value)){
                paste0(key,'=\"',tolower(value),'"')
              }
              else if (is.numeric(value)){
                paste0(key,'=\"',paste(value, collapse = " "),'"')
              }
              else if (is.list(value)){
                # for vectors of ints or numerics
                props = purrr::map2(names(value), value, self$render_property)
                paste0(key,'="',paste0(props, collapse = " "),'"')
              }
            }, # should be private

            render_property = function(key, value){
              key <- self$escape_name(key)

              if (is_a_asset(value)){
                paste0(key,": ",value$reference(),";")
              }
              else if (anyNA(value)){
                stop("tried to render NA value for ", key, "in property list")
              }
              else if (is.character(value)){
                paste0(key,": ",value,";")
              }
              else if (is.logical(value)){
                paste0(key,": ",tolower(value),";")
              }
              else if (is.numeric(value)){
                paste0(key,": ",paste(value, collapse = " "),";")
              }
            }, # should be private

            escape_name = function(key){
              ## This function holds the rules for escaping component names and
              ## component property keys. At present single '_' between words
              ## are replaced with '-' as is the A-Frame convention. Some
              ## community components do not adhere to this convention so names
              ## entered as `'this_is_a_real_component_name` - i.e. have a
              ## leading quote, will not be interfered with other than to have
              ## the leading quote removed.
              ##
              ##  If you used a name like `'this_thing` you're saying you don't
              ##  want entity to interfere with your underscores
              if (substring(key, 1, 1) != "'"){
                ## convert underscores('_') in keys to dashes ('-')
                key <- gsub(x = key, pattern = "(?<=[A-Za-z0-9])_(?=[A-Za-z0-9])",
                            replacement = "-", perl = TRUE)
              } else {
                ## Drop the leading quote if it existed.
                key <- substring(key, first = 2)
              }
              key
            },

            render_id = function(){
              if(is.null(self$id)) "" else paste0('id="',self$id,'"')
            }, # should be private

            find_assets = function(){
              assets <- purrr::keep(self$components, ~is_a_asset(.))
              nested_assets <-
                purrr::keep(self$components, is.list) %>%
                purrr::map(~purrr::keep(., ~is_a_asset(.))) %>%
                purrr::flatten()
              all_assets <- c(assets, nested_assets)
            },

            add_assets = function(assets){
              all_assets <- c(self$assets, assets)

              ## only keep unique combinations of asset src and id.
              asset_frame <-
                purrr::map(all_assets, ~data.frame(.$src,
                                                   .$id,
                                                   stringsAsFactors = FALSE)) %>%
                do.call(rbind, .)
              asset_duplicates <- duplicated(asset_frame)

              self$assets <- all_assets[!asset_duplicates]
            },

            add_js_sources = function(sources){
              if (is.character(sources)) {
                sources <- as.list(sources)
              }
              else if (is.list(sources)){
                if (!purrr::every(sources, is.character)){
                  stop("All js_sources must be of type character.")
                }
              }
              else {
                stop("js_sources must be of type character or a list of characters.")
              }
              self$js_sources <- union(self$js_sources, sources)
            }

  ))

##' Create an A-Frame entity
##'
##' This function creates an A-Frame entity object to be inserted into to an
##' A-Frame scene. The A-Frame scene object instructs entities to render
##' themselves to html, when serving or writing itself.
##'
##' Function arguments supplied in `...` map directly to underlying entity
##' components expressed in the html. There two tricks to this: 1. components
##' specified in R must use an single underscore ('_') where a single dash would
##' appear in an A-Frame component name between words. It is converted to '-'
##' when rendered in HTML. Double underscores and leading/trailing underscores
##' are not converted. 2. Components specified by name only, without any
##' configuration must use the form `component_name = NULL` or component_name =
##' "". For example: to create an A-Frame entity with the `wasd-controls`
##' component attached, this function would be called as
##' `a_entity(wasd_controls="")`.
##'
##' Underscore conversion is provided as a convenience to save the user wrapping
##' many component names in ``. It can be swtiched off by supplying a "'" as the
##' first character of a property name, e.g.: list(`'this_is_really_what_want` =
##' "foo"). The leading "'" is stripped when rendering to HTML.
##'
##' Component configuration can be expressed in character form, e.g.
##' `wasd_controls = "fly: true; acceleration: 65"` in which case it is passed
##' into html directly. It can also be expressed as a list: `wasd_controls =
##' list(fly = TRUE, acceleration = 65)`, in which case it is converted to the
##' appropriate text.
##'
##' Child entities can be nested within the HTML tag of a parent entity by
##' supplying them as a list in the `children` argument.
##'
##' @title a_entity
##' @param id an optional id for the entity, useful if you want to later add children to it.
##' @param .tag text for the entity tag. The default is "a-entity", but it can be
##'   used to create any of the A-Frame built-ins for example using "a-sphere"
##' @param .js_sources a vector of links to Javascript files this entity depends on.
##'   Useful if adding a community-made component to an entity. The script file
##'   will be automatically be sourced in the html header by the parent scene.
##' @param .children a list of A-Frame entities to be nested within the HTML tag
##'   of this entity.
##' @param .assets any assets needed by this entity that are not assigned in
##'   component configuration. For example it may be that this entity begins
##'   the scene with one texture and later is changed to second texture due to
##'   an event. It is preferable that the second texture is loaded in the asset
##'   block and so is cached and ready to go when the event happens.
##' @param ... components to be added to the entity. See description.
##' @return A_Entity object
##' @export
a_entity <- function(.tag = "entity", .js_sources = NULL, id = NULL,
                     .children = NULL, .assets = NULL, ...){
  A_Entity$new(.tag = .tag, .js_sources = .js_sources, id = id, .children = .children,
               .assets = .assets, ...)
}

##' is this an A-Frame entity
##'
##' @title is_a_entity
##' @param x an object
##' @return true if object is an "A_Entity"
##' @export
is_a_entity <- function(x) inherits(x, "A_Entity")
