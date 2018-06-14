A_In_Memory_Asset <-
  R6::R6Class("A_In_Memory_Asset",
              inherit = A_Asset,
              public = list(
                data = NULL,
                initialize = function(data, ...){
                  self$data <- data
                  super$initialize(...)
                },
                get_asset_data = function(){

                  ## get all paths
                  paths <- c(self$src, self$parts)
                  
                  ## If data is a list it must match combined length of src and parts.
                  if (is.list(self$data)){
                    if (length(self$data) != length(paths)){
                      stop("Length of `data` arg list must equal length of c(src, parts).")
                    }
                    if (!purrr::every(self$data, is.chracter)){
                      stop("Every element of `data` in list form must be a character vector.")
                    }
                  }
                  ## else data should be a character vector representing what would
                  ## (notionally) be read at self$src. self$parts must be NULL.
                  else if (is.character(self$data)){
                    if (!is.null(self$parts)){
                      stop("If `data` is a character vector self$parts must be NULL. Use a `data` list for multi-part in-memory assets.")
                      }
                
                  }
                  ## `data` was not a character vector or list of character vectors.
                  else{
                    stop("`data` must be either a single character vector or list of character vectors representing data file content.")
                  }

                  ## guess content type of each
                  content_types <- mime::guess_type(paths)

                  ## create an accessor for each bit of content in `data`. The
                  ## content is already in memory so unlike the base A_Asset
                  ## class, here we just need to pass a reference to it.
                  accessors <- purrr::map(self$data, function(data_item){
                    if (length(data_item) > 1){
                      stop("Only length 1 character vectors are suitable for in memory assets. The entire file must be a single string. See readr::read_file, readr::read_file_raw.")
                    }
                    ## Return an acessor that returns the string.
                    function(){data_item}
                  })

                  ## combine into a tibble
                  tibble::tibble(
                            path = paths,
                            content_type = content_types,
                            accessor = accessors
                          )
                }

              ))

##' Create an A-Frame asset hosted in R's memory.
##'
##' To understand this object you will almost certainly need to familiarise yourself with its base class 'A_Asset' first. See \code{\link{a_asset}}.
##' 
##' This function is used to create a special kind of A-Frame asset that is only
##' notionally backed by a file. The primary use of this is for passing CRAN's
##' vignette checks, testing, and demonstration. From the end-user's perspective
##' an in-memory-asset appears exactly like a regular asset file. However the
##' scene creates a route to `src` and `parts` that reference the contents of
##' `data` rather than files specified by the paths in `src` and `parts`.
##'
##' An example usecase: Serving a JSON transform of an built-in R dataframe as an
##' asset without writing an intermediate JSON file to disk.
##'
##' It is still necessary to supply a 'real looking' path to the asset. The path must be
##' relative to the current R working directory, but other than that is doesn't
##' matter what it is. The most important aspect of this notional path is the
##' file extension, since this is used to determine the HTTP mime-type header
##' when the asset is served.
##'
##' `data` is either a length one character vector or a list of length one
##' character vectors. It must have the same length as the number of paths
##' supplied in `src` + `parts`. The character vectors are strings that contain
##' the entire contents of a notional file. For non-text files they would need
##' to contain the equivalent encoded text of calling readr::read_file_raw().
##' 
##' @title a_in_mem_asset()
##' @param data a string containing file content or a list of such strings.
##' @param ... additional parameters passed to `a_asset()`
##' @return an asset object.
a_in_mem_asset <- function(data, ...){
  A_In_Memory_Asset$new(data = data, ...)
}
