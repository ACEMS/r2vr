test_that("JSON model can render correctly and be served", {

  my_model <- a_json_model(src = a_asset(id = "cube", src = test_path("cube.json")),
                           position = c(0,0,-2), scale = c(0.2, 0.2, 0.2))

  expect_equal({
    my_model$render()
  },
  {
    "<a-entity json-model=\"src: #cube;\"></a-entity>\n"
  })

  expect_equal({
    my_model$js_sources
  },
  {
    list("https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.loaders.js")
  })

  my_scene <- a_scene(template = "empty",
                      children = list(my_model))
  expect_equal({
    my_scene$render()
  },
  {
    "<!DOCTYPE html>\n<html>\n    <head>\n    <meta charset=\"utf-8\">\n    <title>A-Frame VR scene created with r2vr</title>\n    <meta name=\"description\" content= \"A-Frame VR scene created with r2vr\">\n    <script crossorigin src=\"https://aframe.io/releases/0.8.0/aframe.min.js\"></script>\n    <script crossorigin src=\"https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.loaders.js\"></script>\n    </head>\n    <body>\n        <a-scene >\n            <a-assets>\n                <a-asset-item id=\"cube\" src=\"tests/testthat/cube.json\"></a-asset-item>\n            </a-assets>\n            \n            <!-- Entities added in R -->\n            <a-entity json-model=\"src: #cube;\"></a-entity>\n            \n\n            <!-- Ground -->\n            <a-grid geometry='height: 10; width: 10'></a-grid>\n        </a-scene>\n    </body>\n</html>\n"
  })

  my_scene$serve()

  expect_equal(
  {
    response <-  my_scene$scene$test_request(
                                  fiery::fake_request(url = paste0("https://127.0.0.1:8000/",
                                                                   test_path("cube.json"))))
    response$body
  },
  {
    readr::read_file(test_path("cube.json"))
  })

  my_scene$stop()

})
