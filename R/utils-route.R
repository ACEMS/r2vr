sanitise_route_path <- function(path){
  ## remove a leading '.'
  path <- gsub("^\\.+", "", path)

  ## Ensure path starts with '/' and so is routable
  ## Ugly regex: replace any string of chars not equal to '/'
  ## at start of string with that same string of chars with
  ## '/' prefixed
  path <- gsub("(^[^/]+)", "/\\1", path)
  path
}

is_ws_handler_fn <- function(handler){
  # The setdiff will be an empty vector if handler contains only message, id.
  length(setdiff(methods::formalArgs(handler), c("message", "id"))) == 0
}
