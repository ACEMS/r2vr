##' Does string have a URL prefix
##'
##' returns true if string matches an internal set of URL prefixes. Vectorised
##' over URL parameter.
##' @title has_url_prefix
##' @param urls a character vector of urls
##' @return a logical vector the same length as url.
has_url_prefix <- function(urls){
  url_prefixes <- c("^https://","^http://","^//")

  detect_prefix <- function(url){
    purrr::map_lgl(url_prefixes,
                   ~stringr::str_detect(string = url, pattern = .)) %>%
      any()
  }

  purrr::map_lgl(urls, detect_prefix)
}
