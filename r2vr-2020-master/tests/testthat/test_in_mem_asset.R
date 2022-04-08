context("test in memory ass set class")

test_that("An in memory asset can be routed to by a scene", {

  my_json <- readr::read_file(test_path("cube.json"))

  my_asset <- a_in_mem_asset(.data = my_json,
                             id = "cube",
                             src = "./roberto_cuberto.json")

  my_model <- a_json_model(src = my_asset,
                           position = c(0, 1, -3),
                           scale = c(0.2, 0.2, 0.2))

  my_scene <- a_scene(.template = "empty",
                      .children = list(my_model))
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

test_that("Only character vectors of length one are accepted",{

  my_json <- readr::read_file(test_path("cube.json"))
  my_json2 <- readr::read_lines(test_path("cube.json"))

  expect_error({

    my_asset <- a_in_mem_asset(.data = my_json2,
                               id = "cube",
                               src = "./roberto_cuberto.json")

  }, "Length of `data` arg list")

  
  expect_error({

    my_asset <- a_in_mem_asset(.data = list(my_json, my_json2),
                               id = "cube",
                               src = "./roberto_cuberto.json",
                               .parts = "./hello.json")

  }, "Every element of `data` in list form must be a length one character vector.")

  expect_error({

    my_asset <- a_in_mem_asset(.data = list(my_json, my_json),
                               id = "cube",
                               src = "./roberto_cuberto.json")

  }, "Length of `data` arg list")

  expect_error({

    my_asset <- a_in_mem_asset(.data = my_json,
                               id = "cube",
                               src = "./roberto_cuberto.json",
                               .parts = "./cube.json")

  }, "Length of `data` arg list")
})
