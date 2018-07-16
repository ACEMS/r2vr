A_URL_Asset <-
  R6::R6Class("A_URL_Asset",
              inherit = A_Asset,
              public = list(
                initialize = function(id = "",
                                      url,
                                      tag = "a-asset-item",
                                      inline = FALSE
                                      ){
                  super$initialize(id = id,
                                   url = src,
                                   tag = tag,
                                   inline = inline) 
                },

                get_asset_data = function(){

                  tibble() %>%
                  purrr::pwalk(print("hello"))


                }

              ))
