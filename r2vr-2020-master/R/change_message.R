change_message <- function(messages, is_visible){
  ## Helper function for pop()
  for(jj in 1:length(messages)){
    if(messages[[jj]]$component == "visible")
      messages[[jj]]$attributes <- is_visible
  }
  return(messages)
}