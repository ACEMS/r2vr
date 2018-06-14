context("test in memory ass set class")

test_that("An in memory can be routed to by a scene", {

  my_json <- readr::read_file(test_path("cube.json"))

  my_asset <- a_in_mem_asset(data = my_json,
                             id = "cube",
                             src = "./roberto_cuberto.json")

  my_model <- a_json_model(src_asset = my_asset,
                           position = c(0, 1, -3),
                           scale = c(0.2, 0.2, 0.2))

  my_scene <- a_scene(template = "empty",
                      children = list(my_model))
  my_scene$serve()

  expect_equal({
    response <-
      my_scene$scene$test_request(
                     fiery::fake_request(url = paste0("https://127.0.0.1:8000/",
                                                      test_path("roberto_cuberto.json")))
                     )
    response$body
  },{
   my_json
  })
  my_scene$stop()
})
