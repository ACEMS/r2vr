
  root_route <- Route$new()
  root_route$add_handler('get', "/",
    function(request, response, keys, ...) {
      response$status <- 200L
      response$type <- "html"
      response$body <- readr::read_file("./tests/testthat/fiery_test.html")
      return(FALSE)
    }
  )

  js_route <- Route$new()
  js_route$add_handler('get', "/req_json.js",
    function(request, response, keys, ...) {
      response$status <- 200L
      response$type <- "javascript"
      response$body <- readr::read_file("./tests/testthat/req_json.js")
      return(FALSE)
    }
  )
  
  json_route <- Route$new()
  json_route$add_handler('get', "/test.json",
    function(request, response, keys, ...) {
      response$status <- 200L
      response$type <- "json"
      response$body <- readr::read_file("./tests/testthat/test_carolina.json")
      return(FALSE)
    }
  )
  
  
  # Create Route Stack
  routr_stack <- routr::RouteStack$new()
  routr_stack$add_route(root_route, "root")
  routr_stack$add_route(js_route, "js")
  routr_stack$add_route(json_route, "json")

  app <- fiery::Fire$new()
  app$attach(routr_stack)
  app$ignite(block = TRUE)
  # In Terminal (or visit in browser)
  # curl http://127.0.0.1:8080/

