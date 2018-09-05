context("Test websocket communications")

test_that("A websocketed scene can resolve r2vr event messages",
{

  sources <- a_entity(js_sources = c("https://unpkg.com/aframe-event-set-component@^4.0.0/dist/aframe-event-set-component.min.js") )

  ## Setup a box that will respond to some events
  box <- a_entity("box", id = "block",
                  position = c(0, 1, -4),
                  material = list(color = "red"),
                  event_set__1 = list(`_event` = "switch_colour", material.color = "blue"),
                  event_set__2 = list(`_event` = "rotate", rotation = c(0, 45, 0)))

  my_scene <- a_scene(template = "basic",
                      children = list(box, sources),
                      websocket = TRUE)


  test_event <- list(a_event(id = "block",
                             event_name = "switch_colour",
                             event_detail = "any",
                             bubbles = FALSE),
                     a_event(id = "block",
                             event_name = "rotate",
                             event_detail = "any",
                             bubbles = FALSE)
                     )

  my_scene$serve()

  my_scene$stop()
  a_kill_all_scenes()

  

})

test_that("A websocketed scene can resolve r2vr update messages", {

  ## Setup a box that can be updated.
  box <- a_entity("box", id = "block",
                  position = c(0, 1, -4),
                  material = list(color = "red"))

  my_scene <- a_scene(template = "basic",
                      children = list(box),
                      websocket = TRUE)

  test_update <- list(a_update(id = "block",
                               component = "position",
                               attributes = list(x = 0, y = 0, z = -4)),
                      a_update(id = "block",
                               component = "color",
                               attributes = "green"))

  my_scene$send_messages(test_update)

  my_scene$serve()
  my_scene$stop()
})
