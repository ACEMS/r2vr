context("test text label object")

test_that("Text label can be rendered correctly and served", {

  my_label <- a_label(text = "This is not a label.",
                      color = "#F442DF",
                      font = "mozillavr",
                      position = c(0, 1, -2)
                      )

  expect_equal({
    my_label$render() 
  },
  {
    "<a-text value=\"This is not a label.\" color=\"#F442DF\" font=\"mozillavr\" align=\"center\" geometry=\"primitive: box; width: 0.2; height: 0.2; depth: 0.2;\" material=\"transparent: true; opacity: 0;\" position=\"0 1 -2\"></a-text>\n"
  })

  my_scene <-
    a_scene(.template = "empty", .children = list(my_label) )
  my_scene$serve()

  expect_equal({
    a_response <- my_scene$scene$test_request(fiery::fake_request(url = "/"))
    a_response$body
  },
  {
    "<!DOCTYPE html>\n<html>\n    <head>\n    <meta charset=\"utf-8\">\n    <title>A-Frame VR scene created with r2vr</title>\n    <meta name=\"description\" content= \"A-Frame VR scene created with r2vr\">\n    <script crossorigin src=\"https://aframe.io/releases/0.8.2/aframe.min.js\"></script>\n    \n    </head>\n    <body>\n        <a-scene >\n            <a-assets>\n                \n            </a-assets>\n            \n            <!-- Entities added in R -->\n            <a-text value=\"This is not a label.\" color=\"#F442DF\" font=\"mozillavr\" align=\"center\" geometry=\"primitive: box; width: 0.2; height: 0.2; depth: 0.2;\" material=\"transparent: true; opacity: 0;\" position=\"0 1 -2\"></a-text>\n            \n\n        </a-scene>\n    </body>\n</html>\n"
  })

  my_scene$stop()

})
