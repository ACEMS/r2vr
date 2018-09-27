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
  update
}
