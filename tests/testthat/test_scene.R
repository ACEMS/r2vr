context("Test scene class")

test_that("Scenes can read a built-in template",{
  test_scene <- A_Scene$new(template = "basic")

  expect_equal(
  {
    test_scene$template
  },
  {
    ## the basic.html template
    "<!DOCTYPE html>\n<html>\n    <head>\n    <meta charset=\"utf-8\">\n    <title> A test model</title>\n    <meta name=\"description\" content= \"A three js json model\">\n    <script crossorigin src=\"https://aframe.io/releases/0.8.0/aframe.min.js\"></script>\n    <script crossorigin src=\"https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.loaders.js\"></script>\n    <script crossorigin src=\"https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.controls.js\"></script>\n    <script crossorigin src=\"https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.primitives.js\"></script>\n    ${js_sources}\n    </head>\n    <body>\n        <a-scene ${scene_components}>\n            <a-assets>\n                ${assets}\n            </a-assets>\n            <a-camera movement-controls=\"fly: true; easingY: 15\" position=\"0 1.8 0\"\n                      rotation=\"0 0 0\"></a-camera>\n            <a-entity position=\"0 100 -30\" light=\"intensity:0.80;type:point\"></a-entity>\n            \n            <!-- Entities added in R -->\n            ${entities}\n\n            <!-- Ground -->\n            <a-grid geometry='height: 10; width: 10'></a-grid>\n        </a-scene>\n    </body>\n</html>\n"
  }
  )

})
test_that("Scenes determine template indent levels correctly and apply indents",{
  test_scene <- A_Scene$new(template = "basic")

  expect_equal(
  {
    test_scene$indent_to_level("Hello\nWorld!","entities")
  },
  {
    "Hello\n            World!"
  }
  )

 })

test_that("A scene can render the basic template",{

  ## test with no entities
  expect_equal(
  {
    my_empty_scene <- A_Scene$new()
    my_empty_scene$render()
  },
  {
    ## The basic.html temple with blanks where the placeholders are.
    "<!DOCTYPE html>\n<html>\n    <head>\n    <meta charset=\"utf-8\">\n    <title> A test model</title>\n    <meta name=\"description\" content= \"A three js json model\">\n    <script crossorigin src=\"https://aframe.io/releases/0.8.0/aframe.min.js\"></script>\n    <script crossorigin src=\"https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.loaders.js\"></script>\n    <script crossorigin src=\"https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.controls.js\"></script>\n    <script crossorigin src=\"https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.primitives.js\"></script>\n    \n    </head>\n    <body>\n        <a-scene >\n            <a-assets>\n                \n            </a-assets>\n            <a-camera movement-controls=\"fly: true; easingY: 15\" position=\"0 1.8 0\"\n                      rotation=\"0 0 0\"></a-camera>\n            <a-entity position=\"0 100 -30\" light=\"intensity:0.80;type:point\"></a-entity>\n            \n            <!-- Entities added in R -->\n            \n\n            <!-- Ground -->\n            <a-grid geometry='height: 10; width: 10'></a-grid>\n        </a-scene>\n    </body>\n</html>\n"
  })
  ## with simple entities using assets and js_sources
  expect_equal(
  {
    my_scene  <- a_scene(template = "basic",
                         fog = NULL, stats = NULL,
                         children = list(
                         a_entity(tag = "avatar",
                                  wasd_controls = list(acceleration = 100, fly = TRUE),
                                  an_extremely_long_component_name = NULL),

                         a_entity(id = "mine", tag = "box",
                                      position = c(0,0,0),
                                      scale="0 0 0",
                                  material = list(shader = "flat", sides = "double")),
                         a_entity(id = "tst",
                                  gltf_model = a_asset(id = "monster",
                                                       src = "/inst/monster.gltf"),
                                  animation_mixer = NULL,
                                  js_sources = list("./entitysource.js"))),
                         js_sources = list("./toplevelsource.js"))

    my_scene$render()
  }
 ,{
### Interpolated HTML
"<!DOCTYPE html>\n<html>\n    <head>\n    <meta charset=\"utf-8\">\n    <title> A test model</title>\n    <meta name=\"description\" content= \"A three js json model\">\n    <script crossorigin src=\"https://aframe.io/releases/0.8.0/aframe.min.js\"></script>\n    <script crossorigin src=\"https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.loaders.js\"></script>\n    <script crossorigin src=\"https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.controls.js\"></script>\n    <script crossorigin src=\"https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.primitives.js\"></script>\n    <script crossorigin src=\"./toplevelsource.js\"></script>\n    <script crossorigin src=\"./entitysource.js\"></script>\n    </head>\n    <body>\n        <a-scene fog stats>\n            <a-assets>\n                <a-asset-item id=\"monster\" src=\"/inst/monster.gltf\"></a-asset-item>\n            </a-assets>\n            <a-camera movement-controls=\"fly: true; easingY: 15\" position=\"0 1.8 0\"\n                      rotation=\"0 0 0\"></a-camera>\n            <a-entity position=\"0 100 -30\" light=\"intensity:0.80;type:point\"></a-entity>\n            \n            <!-- Entities added in R -->\n            <a-avatar wasd-controls=\"acceleration: 100; fly: true;\" an-extremely-long-component-name></a-avatar>\n            <a-box id=\"mine\" position=\"0 0 0\" scale=\"0 0 0\" material=\"shader: flat; sides: double;\"></a-box>\n            <a-entity id=\"tst\" gltf-model=\"#monster\" animation-mixer></a-entity>\n            \n\n            <!-- Ground -->\n            <a-grid geometry='height: 10; width: 10'></a-grid>\n        </a-scene>\n    </body>\n</html>\n"
 }
 )
  ## with nested entities using assets and js_sources
  expect_equal(
  {
    my_scene  <- a_scene(template = "basic",
                         fog = NULL, stats = NULL,
                         children = list(
                         a_entity(tag = "avatar",
                                  wasd_controls = list(acceleration = 100, fly = TRUE),
                                  an_extremely_long_component_name = NULL,
                                  children = list(
                                    a_entity(id = "mine", tag = "box",
                                             position = c(0,0,0),
                                             scale="0 0 0",
                                             material = list(shader = "flat", sides = "double")),
                                    a_entity(id = "tst",
                                             gltf_model = a_asset(id = "monster",
                                                                  src = "/inst/monster.gltf"),
                                             animation_mixer = NULL,
                                             js_sources = list("./entitysource.js"),
                                             children = list(
                                               a_entity(gltf_model =
                                                          a_asset(
                                                            id = "mask",
                                                            src = "/inst/mask.gltf"))
                                             )
                                             )))),
                         js_sources = list("./toplevelsource.js"))

    my_scene$render()
  }
 ,{
### Interpolated HTML
"<!DOCTYPE html>\n<html>\n    <head>\n    <meta charset=\"utf-8\">\n    <title> A test model</title>\n    <meta name=\"description\" content= \"A three js json model\">\n    <script crossorigin src=\"https://aframe.io/releases/0.8.0/aframe.min.js\"></script>\n    <script crossorigin src=\"https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.loaders.js\"></script>\n    <script crossorigin src=\"https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.controls.js\"></script>\n    <script crossorigin src=\"https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.primitives.js\"></script>\n    <script crossorigin src=\"./toplevelsource.js\"></script>\n    <script crossorigin src=\"./entitysource.js\"></script>\n    </head>\n    <body>\n        <a-scene fog stats>\n            <a-assets>\n                <a-asset-item id=\"monster\" src=\"/inst/monster.gltf\"></a-asset-item>\n                <a-asset-item id=\"mask\" src=\"/inst/mask.gltf\"></a-asset-item>\n            </a-assets>\n            <a-camera movement-controls=\"fly: true; easingY: 15\" position=\"0 1.8 0\"\n                      rotation=\"0 0 0\"></a-camera>\n            <a-entity position=\"0 100 -30\" light=\"intensity:0.80;type:point\"></a-entity>\n            \n            <!-- Entities added in R -->\n            <a-avatar wasd-controls=\"acceleration: 100; fly: true;\" an-extremely-long-component-name>\n              <a-box id=\"mine\" position=\"0 0 0\" scale=\"0 0 0\" material=\"shader: flat; sides: double;\"></a-box>\n              <a-entity id=\"tst\" gltf-model=\"#monster\" animation-mixer>\n                <a-entity gltf-model=\"#mask\"></a-entity>\n              </a-entity>\n            </a-avatar>\n            \n\n            <!-- Ground -->\n            <a-grid geometry='height: 10; width: 10'></a-grid>\n        </a-scene>\n    </body>\n</html>\n"
 })
})

test_that("A scene can serve itself and some assets", {

  my_scene <-
    a_scene(children = list(
              a_entity(tag = "plane", position = c(0, 2, -3), height = 1, width = 1,
                       src = a_asset(tag = "img", id = "qut", src = test_path("QUT.png")))
            ))
  my_scene$serve()

  expect_equal({
    response1 <- my_scene$scene$test_request(fiery::fake_request(url = "https://127.0.0.1:8000/"))
    response1$body
  },
  {
    my_scene$render()
  })

  response2 <-
    my_scene$scene$test_request(fiery::fake_request(url = paste0("https://127.0.0.1:8000/",
                                                                 test_path("QUT.png"))))
  raw_image <- readr::read_file_raw(test_path("QUT.png"))
  expect_equal(

  {
    response2$body
  },
  {
    raw_image
  })



  my_scene$stop()
})

test_that("A scene can serve itself and glTF models", {

  my_scene <-
    a_scene(template = "empty",
            children = list(
              a_entity(tag = "gltf-model", position = c(0, 2, -3), height = 1, width = 1,
                       src = a_asset(id = "kangaroo", src = test_path("Kangaroo_01.gltf"),
                                     parts = test_path("Kangaroo_01.bin")))
            ))
  my_scene$serve()

  expect_equal({
    response1 <-
      my_scene$scene$test_request(
                       fiery::fake_request(url = paste0("https://127.0.0.1:8000/",
                                                        test_path("Kangaroo_01.gltf"))))
    response1$body
  },
  {
    readr::read_file_raw(test_path("Kangaroo_01.gltf"))
  })
  expect_equal({
    response1 <-
      my_scene$scene$test_request(
                       fiery::fake_request(url = paste0("https://127.0.0.1:8000/",
                                                        test_path("Kangaroo_01.bin"))))
    response1$body
  },
  {
    readr::read_file_raw(test_path("Kangaroo_01.bin"))
  })

  my_scene$stop()
})
