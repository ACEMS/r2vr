context("Test entity class")

test_that("A basic entity is rendered",{
  expect_equal(
  {
    test_entity <- A_Entity$new(tag = "box",
                                position = "0 0 0",
                                rotation = c(0,0,0))
    test_entity$render()
  },
  {
    '<a-box  position="0 0 0" rotation="0 0 0" ></a-box>'
  }
  )

})

test_that("a nested entity is rendered", {
  expect_equal(
  {
    my_entity <-
     A_Entity$new(id = "mine", tag = "box",
                  position = c(0,0,0),
                  scale="0 0 0",
                  material = list(shader = "flat", sides = "double"))
    my_entity$render()
  },
  {
    '<a-box  id=\"mine\" position=\"0 0 0\" scale=\"0 0 0\" material="shader: flat; sides: double;" ></a-box>'
  }
  )

})
