#' Start VR server
#'
#' @param LOCAL_IP Character string of local ip address (\code{IPv4}). If unknow go to command window and enter 'ipconfig'.
#'
#' @examples 
#' \donttest{
#' start("192.168.43.72")
#' }
#' @export
start <- function(LOCAL_IP){
  
  animals$serve(host = LOCAL_IP)
} 
