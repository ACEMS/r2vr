#' End VR server
#'
#' @export
#' 
#' @examples 
#' \donttest{
#' start("192.168.43.72")
#' end()
#' }
end <- function(){
  a_kill_all_scenes()
}
