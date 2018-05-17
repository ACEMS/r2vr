##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##' @title 
##' @param src 
##' @param sources 
##' @param ... 
##' @return 
##' @author Miles McBain
a_json_model <- function(src,
                         sources = list("https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.loaders.js"),
                         ...){
  a_entity(json_model = list(src = src), sources = sources, ...)
}
