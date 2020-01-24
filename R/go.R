#' Go to next VR scene
#'
#' @param image_paths Character string of image paths from current working directory.
#' @param index Optional numeric input to select a specific image.
#' @param question_type Optional question type from \code{"binary"} or \code{"multivariable"}. Defaults to \code{"binary"}.
#' 
#' @examples 
#' \donttest{
#' image_paths <- c("img1.jpg", "img2.jpg", "img3.jpg")
#' 
#' go(image_paths, 2)
#' go(image_paths, 3)
#' }
#'
#' @export
go <- function(image_paths, index = NA, question_type = "binary"){
  
  white <- "#ffffff"
  
  # Current image number
  if(is.na(index)) { CONTEXT_INDEX <- 1 }
  if(!is.na(index)){ CONTEXT_INDEX <- index }
  
  animal_contexts <- paste("img", seq(1,length(image_paths),1), sep="")
  
  # TODO: Refactor as an argument?
  context_rotations <- list(list(x = 0, y = 0, z = 0),
                            list(x = 0, y = 0, z = 0),
                            list(x = 0, y = 0, z = 0),
                            list(x = 0, y = 0, z = 0))
  
  if(is.na(index)) {
    CONTEXT_INDEX <<- ifelse(CONTEXT_INDEX > length(animal_contexts) - 1,
                             yes = 1,
                             no = CONTEXT_INDEX + 1)
  }
  
  next_image <- animal_contexts[[CONTEXT_INDEX]]
  print(next_image)
  
  
  pop(FALSE, question_type )
  
  if(question_type == "binary"){
    setup_scene <- list(
      a_update(id = "canvas3d",
               component = "material",
               attributes = list(src = paste0("#","img1"))),
      a_update(id = "canvas3d",
               component = "src",
               attributes = paste0("#","img1")),
      a_update(id = "canvas3d",
               component = "rotation",
               attributes = list(x = 0, y = 0, z = 0)),
      a_update(id = "canvas3d",
               component = "class",
               attributes = image_paths[1]),
      a_update(id = "yesPlane",
               component = "color",
               attributes = white),
      a_update(id = "noPlane",
               component = "color",
               attributes = white))
  } else {
    setup_scene <-  list(
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
               attributes = img_paths[CONTEXT_INDEX]),
      a_update(id = "option1Plane",
               component = "color",
               attributes = white),
      a_update(id = "option3Plane",
               component = "color",
               attributes = white),
      a_update(id = "option4Plane",
               component = "color",
               attributes = white),
      a_update(id = "option2Plane",
               component = "color",
               attributes = white),
      a_update(id = "postPlane",
               component = "color",
               attributes = white))
  }
  
  for(jj in 1:length(setup_scene)){
    if(setup_scene[[jj]]$id == "canvas3d"){
      if(setup_scene[[jj]]$component == "material"){
        setup_scene[[jj]]$attributes <- list(src = paste0("#",next_image))
      }
      if(setup_scene[[jj]]$component == "src"){
        setup_scene[[jj]]$attributes <- paste0("#",next_image)
      }
      if(setup_scene[[jj]]$component == "rotation"){
        setup_scene[[jj]]$attributes <- context_rotations[[CONTEXT_INDEX]]
      }
      if(setup_scene[[jj]]$component == "class"){
        setup_scene[[jj]]$attributes <- image_paths[CONTEXT_INDEX]
      }
    }
  }
  
  # TODO: Consider passing this in as an argument as binary and multiple selections differ
  animals$send_messages(setup_scene)
} 