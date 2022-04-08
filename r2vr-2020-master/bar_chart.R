## TODO: remove or upgrade significantly

library(r2vr)
library(purrr)
library(tibble)

cursor <- a_entity(.tag = "camera", position = c(0.9,1.6,2),
                   .children = list(
                     a_entity(.tag = "cursor", position = c(0,0,3)
                              )
                     )
                   )

dimensions <- c(2,2,2)
## make each axis
x_axis <- a_entity(line = list(start = c(0,0,0),
                               end = c(dimensions[[1]], 0, 0),
                               color = "#000000")
                   )
y_axis <- a_entity(line = list(start = c(0,0,0),
                               end = c(0, dimensions[[2]], 0),
                               color = "#000000")
                   )
z_axis <- a_entity(line = list(start = c(0,0,0),
                               end = c(0, 0, dimensions[[3]]),
                               color = "#000000")
                   )

box1 <- a_entity(
  .tag = "box",
  position = c(0.5, 0, 1),
  color = "#FF95BC",
  height = 1.5,
  width = 0.5,
  depth = 0.5
)

box2 <- a_entity(
  .tag = "box",
  position = c(1.5, 0, 1),
  color = "#969696",
  height = 2,
  width = 0.5,
  depth = 0.5
)


plot <- a_entity(position = c(1,0.1,-3),  
                 .children = c(x_axis, y_axis, z_axis, box1, box2)
                 )

# plot 2

x_axis2 <- a_entity(line = list(start = c(0,0,0),
                               end = c(dimensions[[1]], 0, 0),
                               color = "#000000")
)
y_axis2 <- a_entity(line = list(start = c(0,0,0),
                               end = c(0, dimensions[[2]], 0),
                               color = "#000000")
)
z_axis2 <- a_entity(line = list(start = c(0,0,0),
                               end = c(0, 0, dimensions[[3]]),
                               color = "#000000")
)

box1_2 <- a_entity(
  .tag = "box",
  position = c(0.5, 0, 1),
  color = "#FF95BC",
  height = 3,
  width = 0.5,
  depth = 0.5
)

box2_2 <- a_entity(
  .tag = "box",
  position = c(1.5, 0, 1),
  color = "#969696",
  height = 1,
  width = 0.5,
  depth = 0.5
)


plot2 <- a_entity(position = c(-2,0.1,-3),  
                 .children = c(x_axis2, y_axis2, z_axis2, box1_2, box2_2)
)

# legend

box1_legend_text <- a_label(
  text = "Coral",
  color = "#000000",
  font = "mozillavr",
  height = 2,
  width = 4,
  position = c(0.7, 0.2, -0.4)
)


box2_legend_text <- a_label(
  text = "Not Coral",
  color = "#000000",
  font = "mozillavr",
  height = 2,
  width = 4,
  position = c(0.7, 0.2, 0.1)
)

box1_legend <- a_entity(
  .tag = "box",
  position = c(0, 0, -0.4),
  color = "#FF95BC",
  height = 0.2,
  width = 0.2,
  depth = 0.2
)

box2_legend <- a_entity(
  .tag = "box",
  position = c(0, 0, 0),
  color = "#969696",
  height = 0.2,
  width = 0.2,
  depth = 0.2
)

my_scene <- a_scene(.template = "basic",
                    .title = "Coral cover",
                    .children = c(cursor, plot, plot2, box1_legend, box2_legend, box1_legend_text, box2_legend_text)
                    )

start <- function() {
  my_scene$serve()
}

end <- function() {
  my_scene$stop()
}

## my_scene$serve()
## my_scene$stop()
