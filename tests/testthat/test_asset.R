context("test asset class")

test_that("A non-inline asset outputs its tag and reference",{
  my_asset <- A_Asset$new(id = "QUT", src = test_path("QUT.jpg"))
  expect_equal(
  {
    my_asset$reference()
  },
  {
   '#QUT'
  })
  expect_equal(
  {
    my_asset$render()
  },
  {
    '<a-asset-item id="QUT" src="QUT.jpg"></a-asset-item>'
  })
})

test_that("An inline asset ouputs a url reference and no tag.",{
  my_asset <- A_Asset$new(id = "QUT", src = "QUT.jpg", inline = TRUE)
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
    'src="url(QUT.jpg)"'
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

test_that("Asset errors early when file are not found", {

  expect_error(a_asset(id = "nofile",
                       src = "./notfound.gltf")$get_asset_data(),
               "Error when rendering asset, file not found.*")

  expect_error(a_asset(id = "kangaroo",
                       src = test_path("Kangaroo_01.gltf"),
                       parts = c(test_path("Kangaroo_01.bin"), "notfound.gltf"))$get_asset_data(),
               "Error when rendering asset, file not found.*")

})

test_that("Asset errors if path not below src", {

  expect_error(a_asset(id = "kangaroo",
                       src = test_path("Kangaroo_01.gltf"),
                       parts = c(test_path("../Kangaroo_01.bin"), "notfound.gltf")),
               "Path to part must be at or below src.*")
})

