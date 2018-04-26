context("test asset class")

test_that("Asset outputs its reference",{
  expect_equal({
    my_asset <- A_Asset$new(id = "sky", src = "sky.jpg")
    my_asset$reference()
  },
  {
   '#sky'
  })

})
