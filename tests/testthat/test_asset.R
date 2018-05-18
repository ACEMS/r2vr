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

test_that("Asset data reflects assets and parts",{
  my_asset <- a_asset(id = "kangaroo", src = test_path("Kangaroo_01.gltf"),
                       parts = test_path("Kangaroo_01.bin"))
  my_asset_data <- my_asset$get_asset_data()

  expect_equal({
    my_asset_data$accessor[[1]]()
  },
  {
    readr::read_file_raw(test_path("Kangaroo_01.gltf"))
  })

  expect_equal({
    my_asset_data$accessor[[2]]()
  },
  {
    readr::read_file_raw(test_path("Kangaroo_01.bin"))
  })
})
