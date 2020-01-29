#' Find local IP address 
#'
#' @param IP IP identity from \code{ipconfig}. Defaults to \code{"IPv4"}
#'
#' @return
#' @export
#'
#' @examples
#' find_IP()
find_IP <- function(IP="IPv4"){
  if(.Platform$OS.type == 'windows') {
    ## Works for windows but need to test for IOS and Linux
    gsub(".*? ([[:digit:]])", "\\1", system("ipconfig", intern=T)[grep("IPv4", system("ipconfig", intern = T))])
  }
}