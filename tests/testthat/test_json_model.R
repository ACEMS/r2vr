context("test JSON model object")

test_that("JSON model can render correctly and be served", {

  my_model <- a_json_model(src = a_asset(id = "cube", src = test_path("cube.json")),
                           position = c(0,0,-2), scale = c(0.2, 0.2, 0.2))

  expect_equal({
    my_model$render()
  },
  {
    "<a-entity json-model=\"src: #cube;\" position=\"0 0 -2\" scale=\"0.2 0.2 0.2\"></a-entity>\n"
  })

  expect_equal({
    my_model$js_sources
  },
  {
    list("https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.1.2/dist/aframe-extras.loaders.min.js")
  })

  my_scene <- a_scene(.template = "empty",
                      .children = list(my_model))

  expect_true(stringr::str_detect(my_scene$render(),
                                  "<a-scene >\n            <a-assets>\n                <a-asset-item id=\"cube\" src=\"cube.json\"></a-asset-item>\n            </a-assets>\n            \n            <!-- Entities added in R -->\n            <a-entity json-model=\"src: #cube;\" position=\"0 0 -2\" scale=\"0.2 0.2 0.2\"></a-entity>\n            \n\n        </a-scene>\n"))

  my_scene$serve()

  expect_equal(
  {
    response <-  my_scene$scene$test_request(
                                  fiery::fake_request(url = paste0("https://127.0.0.1:8000/",
                                                                   test_path("cube.json"))))
    response$body
  },
  {
    readr::read_file_raw(test_path("cube.json"))
  })

  my_scene$stop()

  my_model2 <-
    a_json_model(src = a_asset(id = "cube", src = test_path("cube.json")),
                 mesh_smooth = TRUE,
                 position = c(0,0,-2), scale = c(0.2, 0.2, 0.2))

  expect_equal({
    my_model2$render()
  },
  {
    "<a-entity json-model=\"src: #cube;\" mesh-smooth position=\"0 0 -2\" scale=\"0.2 0.2 0.2\"></a-entity>\n"
  })

  expect_equal({
    my_model2$js_sources
  },
  {
    list(
      "https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.1.2/dist/aframe-extras.misc.min.js",
      "https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.1.2/dist/aframe-extras.loaders.min.js")
  })
})
