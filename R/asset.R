
A_Asset <-
  R6::R6Class("A_Asset",
              public = list(
                tag = NULL,
                id = NULL,
                src = NULL,
                inline = NULL,

                initialize = function(id = "", src, tag = "a-asset-item", inline=FALSE){
                  if(!inline){
                    if(!is.character(id) | length(id) != 1 | !nzchar(id)){
                      stop("An asset id is a length 1, non-empty character vector. Got:", id)
                    }
                  }
                  if(!is.character(src) | length(src) != 1 | !nzchar(src)){
                    stop("An asset src needs to be a url or path in a
                          length 1 character vector. Got:", src)
                  }
                  self$id <- id
                  self$src <- src
                  self$tag <- tag
                  self$inline <- inline
                },

                render = function(){
                  if(!self$inline){
                    paste0('<',self$tag,' ',
                           paste(self$render_id(), self$render_src()),
                           '></',self$tag,'>')
                  }
                  else {
                    ""
                  }
                },

                reference = function(){
                  if(self$inline){
                    paste0('src="url(',self$src,')"')
                  }
                  else{
                  paste0('#',self$id)
                  }
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
##' link into the component configuratuion.
##'
##' @title a_asset
##' @param id an an id to be used by the asset item in the asset block. #id will be used to refernce the asset in component configuratuion.
##' @param tag the tag text to use in the asset block. Defaults to `a-asset-item`.
##' @param src the location of the asset
##' @param inline boolean signifying if the asset is to be specified inline with the entity. If true, the containing A-Frame scene does not wait for the asset to load.
##' @return an asset object.
##' @export
a_asset <- function(...){ 
  A_Asset$new(...)
}
