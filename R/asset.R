
A_Asset <-
  R6::R6Class("A_Asset",
              public = list(
                tag = NULL,
                id = NULL,
                src = NULL,
                parts = NULL,
                inline = NULL,
                initialize = function(id = "", src, .parts = NULL,
                                      .tag = "a-asset-item", .inline = FALSE){
                  if (!.inline){
                    if(!is.character(id) | length(id) != 1 | !nzchar(id)){
                      stop("An asset id is a length 1, non-empty character vector. Got:", id)
                    }
                  }
                  if (!is.character(src) | length(src) != 1 | !nzchar(src)){
                    stop("An asset src needs to be a url or path in a
                          length 1 character vector. Got:", src)
                  }

                  if (!is.null(.parts)) {
                    if (!is.character(.parts) | !all(nzchar(.parts))){
                      stop("parts must be a character vector of files.")
                    }

                    purrr::walk(.parts, function(part){
                      relative_path <- fs::path_rel(part, fs::path_dir(src))
                      if (stringr::str_detect(relative_path, "\\.\\.")){
                        stop("Path to part must be at or below src. Not so for: ", part)
                      }
                    })

                    self$parts <- .parts
                  }

                  self$id <- id
                  self$src <- src
                  self$tag <- .tag
                  self$inline <- .inline
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

                  ## Asset cannot provide data if it points to a URL.
                  if(!self$is_local()){
                    stop("An asset pointing to a URL was requested to fetch its data.")
                  }
                  
                  ## get all paths
                  paths <- c(self$src, self$parts)

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
                            accessor = accessors
                          )
                },

                render_id = function(){
                 paste0('id="',self$id,'"')
                }, ## should be private

                render_src = function(){
                    paste0('src="',self$src,'"')
                }, ## should be private

              is_local = function(){
                ## If asset points to a URL, it is not local and doesn't need to
                ## be served and should not be called upon to fetch its data.
                !has_url_prefix(self$src)
              })
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
##' Assets in the <a-assets> block are loaded before the scene is rendered. This
##' can delay the scene at a blank white page while they are fetched. Assets
##' defined inline do not delay scene rendering.
##'
##' Assets can be located on local disk, or at remote URLs. The asset
##' declaration will examine the `src` parameter to see if it conforms to known
##' URL conventions. If so r2vr will not attempt to serve the asset, but it will
##' generate the required references to is in the output scene.
##'
##' @title a_asset
##' @param id an an id to be used by the asset item in the asset block. #id will
##'   be used to refernce the asset in component configuratuion.
##' @param .tag the tag text to use in the asset block. Defaults to
##'   `a-asset-item`. Another common choices is "img" for images.
##' @param src the location of the asset
##' @param .parts the location(s) of files referred to in the `src` file that
##'   need to be served with it. Examples are `.bin` files that accompany glTF
##'   models or texture images that accompany `.mtl` files. These are referred
##'   to in 'src' by relative paths, so must reside at or below the same
##'   directory as `src`.
##' @param .inline boolean signifying if the asset is to be specified inline with the entity. If true, the containing A-Frame scene does not wait for the asset to load.
##' @return an asset object.
##' @export
a_asset <- function(id = "", src, .parts = NULL,
                    .tag = "a-asset-item", .inline = FALSE){ 
  A_Asset$new(id = id, src = src, .parts = .parts, .tag = .tag, .inline = .inline)
}

##' is this an A-Frame Asset
##'
##' @title is_a_asset
##' @param x an object
##' @return true if object is an "A_Asset"
##' @export
is_a_asset <- function(x) inherits(x, "A_Asset")
