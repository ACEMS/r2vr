##' Build an A-Frame Event Message
##'
##' Construct an A-Frame event to be sent to a scene in browser, using a
##' websocket connection. When the event is received by a scene with an active
##' websocket server, it will be routed to the entity specified by `id`. To
##' handle the event the entity needs to have components that attach appropriate
##' event handlers.
##' @title a_event
##' @param id the id of the entity that will have the event emitted on it.
##' @param event_name the name of the event.
##' @param event_detail data associated with the event.
##' @param bubbles TRUE if the event should bubble up to parents of the entity with `id`?
##' @return An object that represents an A-Frame event.
##' @export
a_event <- function(id, event_name, event_detail = "", bubbles = FALSE){
  event <- list(class = "event",
                id = id,
                message = list(eventName = event_name,
                               eventDetail = event_detail,
                               bubbles = bubbles))
  class(event) <- c("list", "r2vr_message")
  event
}
##' Build an A-Frame Update Message
##'
##' Construct an A-Frame component attribute update message to be applied to the
##' component of entity identified by `id`.
##'
##' Note for setting vector components: Due to a quirk in the A-Frame JS API,
##' setting vectors for position, rotation, scale etc must be done with a named
##' list: i.e.
##'
##' a_update(id = "my_box",
##'          component = "position",
##'          attributes = list(x = 1, y = 1, z = 1))
##'
##' @title a_update
##' @param id the id of the entity that will have the event emitted on it.
##' @param component the name of the component to have its attributes updated.
##' @param attributes the attributes to be set along with their values.
##' @param replaces_component if TRUE, any attributes not specified are set to
##'   their default values. This effectively makes this update a full
##'   replacement of the existing component.
##' @return An object that represents an A-Frame event.
##' @export
a_update <- function(id, component, attributes, replaces_component = FALSE){
  update <- list(class = "update",
                 id = id,
                 component = component,
                 attributes = attributes,
                 replaces_component = replaces_component)
  class(update) <- c("list", "r2vr_message")
  update
 }


##' Remove a component from an A-Frame entity
##'
##' Remove `component` from the entity with `id`.
##'
##' @title a_remove_component
##' @param id the id of the entity to have component removed
##' @param component the name of the component to remove.
##' @return An object that represents an A-Frame event.
##' @export
  a_remove_component <- function(id, component){
  removal <- list(class = "remove_component",
                  id = id,
                  component = component)
  class(removal) <- c("list", "r2vr_message")
  removal
}

##' Remove an A-Frame entity from the scene
##'
##' Remove the entity identified by 'id' from the scene.
##'
##' @title a_remove_entity
##' @param id id of the entity to be removed.
##' @return An object that represents an A-Frame Event.
##' @export
a_remove_entity <- function(id){
  removal <- list(class = "remove_entity",
                  id = id)
  class(removal) <- c("list", "r2vr_message")
  removal
}

##' Remove all A-Frame entities from the scene by class
##'
##' Remove the entitities identified by 'className' from the scene.
##'
##' @title a_remove_entity_class
##' @param className class of the entity to be removed.
##' @return An object that represents an A-Frame Event.
##' @export
a_remove_entity_class <- function(className){
  removal <- list(class = "remove_entity_class",
                  className = className)
  class(removal) <- c("list", "r2vr_message")
  removal
}

## TODO: Done by hand to test - look into R way (roxygen etc.)

##' Add an A-Frame entity from the scene
##'
##' Add the entity identified by a 'tag' and an 'id' input.
##'
##' @title a_add_entity
##' @param tag primitive A-Frame entity.
##' @param id the id of the new entity to be created
##' @param className the class of the new entity to be created
##' @param parentEntityId new entity nested within parent via its id
##' @return An object that represents an A-Frame Event.
##' @export
a_add_entity <- function(tag, id, className = "", parentEntityId = ""){
  add <- list(class = "add_entity",
                  tag = tag,
                  id = id,
                  className = className,
                  parentEntityId = parentEntityId)
  class(add) <- c("list", "r2vr_message")
  add
}

## TODO: Done by hand to test - look into R way (roxygen etc.)

##' Check if annotations are correct or incorrect
##'
##' Display the annotated marker ring entities as green if correct or red if incorrect
##'
##' @title a_check
##' @param imageId the image ID i.e. filename without extension
##' @param goldStandard a list of annotated markers for the corresponding image
##' @return An object that represents an A-Frame Event.
##' @export
a_check <- function(imageId, goldStandard){
  check <- list(class = "check",
              imageId = imageId,
              goldStandard = goldStandard)
  class(check) <- c("list", "r2vr_message")
  check
}

## Unexported helpers
is_r2vr_message <- function(x) inherits(x, "r2vr_message")

is_r2vr_message_list <- function(x) {
  is.list(x) & purrr::every(x, ~is_r2vr_message(.))
}
