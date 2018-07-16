context("test url asset class")

test_that("A url asset can be used as a texture", {
  my_asset <- a_url_asset(id = "QUT",
                          url = "https://cdn.rawgit.com/MilesMcBain/r2vr/9987bbd2/tests/testthat/QUT.png")

  my_cube <- a_entity("box", depth="2", height="2", width="2",
                      position = c(0, 2, -2),
                      src = my_asset)

  my_scene <- a_scene(children = list(my_cube))

} )
