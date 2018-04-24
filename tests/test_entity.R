my_entity <-
  A_Entity$new(id = "mine", tag = "box",
               position = c(0,0,0),
               scale="0 0 0",
               material = list(shader = "flat", sides = "double"))

my_entity$render()
