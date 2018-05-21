context("test PC Controls Class")

test_that("PC controlled camera can render correctly", {

  my_cam <- a_pc_control_camera(position = c(0,0,-2))

  expect_equal({
    my_cam$render()
  },
  {
    "<a-camera movement-controls=\"fly: true; easingY: 15; acceleration: 100;\" position=\"0 0 -2\"></a-camera>\n"
  })
  })
