#' Set meta data values (needed for HTTP requests to appropriate table in database)
#'
#' @param module String "2d" || "3d"
#' @param module_type String "training" || "testing"
#'
#' @examples 
#' \donttest{
#' set_metadata("2d", "training")
#' set_metadata("2d", "testing")
#' set_metadata("3d", "training")
#' set_metadata("3d", "testing")
#' }
#'
#' @export
set_metadata <- function(module, module_type) {
  is_module_ok <- module == "2d" || module == "3d"
  is_module_type_ok <- module_type == "training" || module_type == "testing"
  if (!is_module_ok) {
    stop("Invalid module param - Please input the string '2d' or '3d'")
  } else if (!is_module_type_ok) {
    stop("Invalid module_type param - Please input the string 'training' or 'testing'")
  }
  assign("MODULE", module, envir = .GlobalEnv)
  assign("MODULE_TYPE", module_type, envir = .GlobalEnv)
  assign("META_DATA", paste0(MODULE, "/", MODULE_TYPE), envir = .GlobalEnv)
}