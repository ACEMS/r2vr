context("test asset class")

test_that("Asset non-inline asset outputs its tag and reference",{
  my_asset <- A_Asset$new(id = "sky", src = "sky.jpg")
  expect_equal(
  {
    my_asset$reference()
  },
  {
   '#sky'
  })
  expect_equal(
  {
    my_asset$render()
  },
  {
    '<a-asset-item id="sky" src="sky.jpg"></a-asset-item>'
  })
})

test_that("An inline asset ouputs a url reference and no tag.",{
  my_asset <- A_Asset$new(id = "sky", src = "sky.jpg", inline = TRUE)
  expect_equal({
    my_asset$render()
  },
  {
   ""
  })
  expect_equal(
  {
    my_asset$reference()
  },
  {
    'src="url(sky.jpg)"'
  })

})

test_that("Content types are extracted from the extension if not supplied",{
  my_asset <- A_Asset$new(id = "sky", src = "sky.jpg", inline = TRUE)
  my_asset2 <- a_asset(id = "monster", src = "./files/monster.gltf")
  expect_equal({
    c(my_asset$content_type, my_asset2$content_type)
  },
  {
    c("jpg","gltf")
  })
})

