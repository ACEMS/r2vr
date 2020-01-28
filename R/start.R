#' Start VR server
#'
#' @param LOCAL_IP Character string of local ip address (\code{IPv4}). If unknown go to command window and enter \code{'ipconfig'}.
#'
#' @examples 
#' \donttest{
#' start("YOUR-LOCAL-IP")
#' }
#' @export
start <- function(LOCAL_IP){
  
  animals$serve(host = LOCAL_IP)
 
  ## temporary fix (if needed)
  # animals$js_sources[[2]] <- paste0(dirname(animals$js_sources[[1]]),"/",basename(animals$js_sources[[2]]))
  # animals$js_sources[[3]] <- paste0(dirname(animals$js_sources[[1]]),"/",basename(animals$js_sources[[3]]))
} 
