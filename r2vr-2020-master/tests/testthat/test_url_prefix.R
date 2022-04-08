context("test URL prefix detection")

test_that("URL prefixes are detected",{

  expect_equal({
    urls <- c("http://foo.com",
              "//cdn.blah.com",
              "https://site.com",
              "milesmcbain.xyz/file.js",
              "./stuff/image.png")
    has_url_prefix(urls)
  },{
    c(TRUE, TRUE, TRUE, FALSE, FALSE)
  })

  expect_true({
    has_url_prefix("//cdn.com")
  })
})
