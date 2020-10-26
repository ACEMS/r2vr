#' Set the full name of the user globally
#'
#' @param full_name String ideally in the form 'Firstname-LastName' e.g. 'John-Doe'
#'
#' @examples 
#' \donttest{
#' set_user("Jon-Peppinck")
#' }
#'
#' @export
set_user <- function(full_name) {
  if (!is.character(full_name)) {
    stop("Please ensure the user name is a string, ideally of the form 'Firstname-LastName' e.g. 'John-Doe'")
  } else if (full_name == "Firstname-Lastname") {
    stop("Please ensure you set your full name")
  }
  
  assign("USER", full_name, envir = .GlobalEnv)
}