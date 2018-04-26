
A_Asset <-
  R6::R6Class("A_Asset",
              public = list(
                tag = NULL,
                id = NULL,
                src = NULL, 

                initialize = function(id, src, tag = "a-asset"){
                  if(!is.character(id) | length(id) != 1 | !nzchar(id)){
                    stop("An asset id is a length 1, non-empty character vector. Got:", id)
                  }
                  if(!is.character(src) | length(src) != 1 | !nzchar(src)){
                    stop("An asset src needs to be a url or path in a
                          length 1 character vector. Got:", src)
                  }
                  self$id <- id
                  self$src <- src
                },

                render = function(){
                  paste0('<',tag,
                         paste(self$render_id(), self$render_src()),
                         '></',tag,'>')
                },

                reference = function(){
                  paste0('#',self$id)
                },

                render_id = function(){
                 paste0('id=',self$id) 
                }, ## should be private

                render_src = function(){
                  paste0('id=',self$src)
                } ## should be private

              )
  )
