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
