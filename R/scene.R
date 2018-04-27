A_Scene <- R6::R6Class("A_Scene",
                       public = list(
                         template = NULL,
                         components = NULL,
                         children = NULL,
                         assets = NULL,
                         sources = NULL,
                         initialize = function(template = "basic", ...){
                         }
                       )
            )
