#' Start VR server
#'
#' @param LOCAL_IP Character string of local ip address (\code{IPv4}). If unknown go to command window and enter \code{'ipconfig'}.
#'
#' @examples 
#' \donttest{
#' start("YOUR-LOCAL-IP")
#' start()
#' }
#' @export
start <- function(LOCAL_IP = find_IP()){
  animals$serve(host = LOCAL_IP)
} 
