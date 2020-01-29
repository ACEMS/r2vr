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
  ## Works for windows but need to test for IOS and Linux
  ip_config <- system("ipconfig", intern=TRUE)
  ip_loc <- stringr::str_detect(ip_config, IP)
  stringr::str_remove(ip_config[ip_loc], "   IPv4 Address. . . . . . . . . . . : ")
}