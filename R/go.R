#' Go to next VR scene
#'
#' @param image_paths character string of image paths 
#' @param setup_scene aframe entities for scene setup
#' @param index optional input to select a specific image
#'
#' @export
go <- function(image_paths, setup_scene, index = NA){
  
  # Current image number
  CONTEXT_INDEX <- 1
  
  animal_contexts <- paste("img", seq(1,length(image_paths),1), sep="")
  
  # TODO: Refactor as an argument?
  context_rotations <- list(list(x = 0, y = 0, z = 0),
                            list(x = 0, y = 0, z = 0),
                            list(x = 0, y = 0, z = 0),
                            list(x = 0, y = 0, z = 0))
  
  if(!is.na(index)) CONTEXT_INDEX <<- index
  
  if(is.na(index)) {
    CONTEXT_INDEX <<- ifelse(CONTEXT_INDEX > length(animal_contexts) - 1,
                             yes = 1,
                             no = CONTEXT_INDEX + 1)
  }
  
  
  next_image <- animal_contexts[[CONTEXT_INDEX]]
  
  pop(FALSE)
  
  # TODO: Consider passing this in as an argument as binary and multiple selections differ
  animals$send_messages(list(
    a_update(id = "canvas3d",
             component = "material",
             attributes = list(src = paste0("#",next_image))),
    a_update(id = "canvas3d",
             component = "src",
             attributes = paste0("#",next_image)),
    a_update(id = "canvas3d",
             component = "rotation",
             attributes = context_rotations[[CONTEXT_INDEX]]),
    a_update(id = "canvas3d",
             component = "class",
             attributes = image_paths[CONTEXT_INDEX]),
    a_update(id = "yesPlane",
             component = "color",
             attributes = white),
    a_update(id = "noPlane",
             component = "color",
             attributes = white)
  ))
} 