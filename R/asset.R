
A_Asset <-
  R6::R6Class("A_Asset",
              public = list(
                tag = NULL,
                id = NULL,
                src = NULL,
                parts = NULL,
                inline = NULL,
                initialize = function(id = "", src, parts = NULL,
                                      tag = "a-asset-item", inline = FALSE){
                  if (!inline){
                    if(!is.character(id) | length(id) != 1 | !nzchar(id)){
                      stop("An asset id is a length 1, non-empty character vector. Got:", id)
                    }
                  }
                  if (!is.character(src) | length(src) != 1 | !nzchar(src)){
                    stop("An asset src needs to be a url or path in a
                          length 1 character vector. Got:", src)
                  }

                  if (!is.null(parts)) {
                    if (!is.character(parts) | !all(nzchar(parts))){
                      stop("parts must be a character vector of files.")
                    }
                    self$parts <- parts
                  }

                  self$id <- id
                  self$src <- src
                  self$tag <- tag
                  self$inline <- inline
                },

                ## called by a_entity
                render = function(){
                  if (!self$inline){
                    paste0('<',self$tag,' ',
                           paste(self$render_id(), self$render_src()),
                           '></',self$tag,'>')
                  }
                  else {
                    ""
                  }
                },

                reference = function(){
                  if (self$inline){
                    paste0('src="url(',self$src,')"')
                  } else {
                  paste0('#',self$id)
                  }
                }, 

                ## called by a_scene
                get_asset_data = function(){
                  ## provide asset content to be served by scene server

                  ## get all paths
                  paths <- c(self$src, self$parts)

                  ## create an indicator columns for type
                  ## Source file, or part of.
                  asset_types <- c("src", rep("part", length(self$parts)))

                  ## guess content type of each
                  content_types <- mime::guess_type(paths)

                  ## Create an accessor function for each bit of content
                  ## This is handed off to the scene which calls it when it need
                  ## to serve the content
                  accessors <- purrr::map2(paths, content_types,
                                           function(path, content_type){

                                             if (!file.exists(path)){
                                               stop("Error when rendering asset, file not found: ",
                                                    path)
                                              }
                                             if (grepl("text/", content_type)){
                                               function(){readr::read_file(path)}
                                             } else {
                                               function(){readr::read_file_raw(path)}
                                             }
                                           })

                  ## combine into a tibble
                  tibble::tibble(
                            path = paths,
                            content_type = content_types,
                            accessor = accessors,
                            asset_type = asset_types
                          )
                },

                render_id = function(){
                 paste0('id="',self$id,'"')
                }, ## should be private

                render_src = function(){
                    paste0('src="',self$src,'"')
                } ## should be private

              )
  )

##' Create an A-Frame asset
##'
##' This function is used to create an asset that will be loaded before an
##' A-Frame scene loads in the browser. Assets are typically models, images,
##' videos, and audio files. The asset object understands there may be two
##' references to the asset: one in the <a-assets> block and the second refernce
##' in a component configuratuion. It knows how to render itself for both of
##' these differnt contexts. It can also be called with `inline=TRUE` which has
##' the effect of omitting it from the <a-assets> block and inserting a direct
##' link into the component configuration.
##'
##' @title a_asset
##' @param id an an id to be used by the asset item in the asset block. #id will be used to refernce the asset in component configuratuion.
##' @param tag the tag text to use in the asset block. Defaults to `a-asset-item`.
##' @param src the location of the asset
##' @param parts the location(s) of files referred to in the `src` file that need
##'   to be served with it. Examples are `.bin` files that accompany glTF models
##'   or texture images that accompany `.mtl` files.
##' @param inline boolean signifying if the asset is to be specified inline with the entity. If true, the containing A-Frame scene does not wait for the asset to load.
##' @return an asset object.
##' @export
a_asset <- function(id = "", src, parts = NULL,
                    tag = "a-asset-item", inline = FALSE){ 
  A_Asset$new(id = id, src = src, parts = parts, tag = tag, inline = inline)
}
