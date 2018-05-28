context("test entity class")

test_that("A basic entity is rendered",{
  expect_equal(
  {
    test_entity <- A_Entity$new(tag = "box",
                                position = "0 0 0",
                                rotation = c(0,0,0))
    test_entity$render()
  },
  {
    '<a-box position="0 0 0" rotation="0 0 0"></a-box>\n'
  }
  )

})

test_that("underscore components are converted to dashes",{
  expect_equal(
  {
    entity1 <- a_entity(tag = "camera",
                        wasd_controls = list(acceleration = 100, fly = TRUE),
                        an_extremely_long_component_name = NULL)
    entity1$render()
  },
  {
   '<a-camera wasd-controls="acceleration: 100; fly: true;" an-extremely-long-component-name></a-camera>\n'
  }
  )
})

test_that("an entity with no components can render",{
  my_entity <-
    A_Entity$new()

  expect_equal(
  {
   my_entity$render() 
  },
  {
    "<a-entity ></a-entity>\n"
  })

})

test_that("an enitity with nested components is rendered", {
  expect_equal(
  {
    my_entity <-
     A_Entity$new(id = "mine", tag = "box",
                  position = c(0,0,0),
                  scale="0 0 0",
                  material = list(shader = "flat", sides = "double"))
    my_entity$render()
  },
  {
    '<a-box id=\"mine\" position=\"0 0 0\" scale=\"0 0 0\" material="shader: flat; sides: double;"></a-box>\n'
  }
  )

})

test_that("An entity renders it's assets", {
  entity1 <-
    A_Entity$new(id = "tst", gltf_model = a_asset(id = "monster", src = "/inst/monster.gltf"), animation_mixer = NULL)
  expect_equal(
  {
    entity1$render()
  },
  {
    '<a-entity id="tst" gltf-model="#monster" animation-mixer></a-entity>\n' 
  })
})

test_that("An entity with a nested entity defined inline is rendered correctly.", {
  my_entity1 <- a_entity(tag = "camera", wasd_controls = list(acceleration = 100, fly = TRUE),
                         an_extremely_long_component_name = NULL,
                         children = list(
                           a_entity(tag = "a-sphere", color = "red", radius = 0.5)
                         ))
  expect_equal(
  {
    my_entity1$render()
  },
  {
   "<a-camera wasd-controls=\"acceleration: 100; fly: true;\" an-extremely-long-component-name>\n  <a-a-sphere color=\"red\" radius=\"0.5\"></a-a-sphere>\n</a-camera>\n"
    
  })

  
})

test_that("An entity with a nested entites with assets and js_sources exposes these correctly.", {
  my_entity1 <- a_entity(tag = "entity",
                         js_sources = list("one.js", "two.js"),
                         material = list(src = a_asset(id = "tree", src = 'treebark.jpg'),
                                         color = '#FFFFFF',
                                         roughness = 1,
                                         metalness = 0),
                         geometry = "primitive: cylinder",
                         children = list(
                           a_entity(tag = "a-plane",
                                    material = list(src = a_asset(id = "earth",
                                                                  src ='ground.jpg')),
                                    js_sources = "three.js")
                         ))
  expect_equal(
  {
    my_entity1$render()
  },
  {
   '<a-entity material=\"src: #tree; color: #FFFFFF; roughness: 1; metalness: 0;\" geometry=\"primitive: cylinder\">\n  <a-a-plane material=\"src: #earth;\"></a-a-plane>\n</a-entity>\n'
  })
  expect_equal(
  {
    my_entity1$js_sources
  },
  {
    list("one.js", "two.js", "three.js")
  })
  expect_equal(
  {
    purrr::map(my_entity1$assets, ~.$src) %>%
      setNames(NULL)
  },
  { 
    list("treebark.jpg", "ground.jpg")
  })
})

test_that("An entity with two nested entities defined inline is rendered correctly.", {
  my_entity1 <- a_entity(tag = "camera", wasd_controls = list(acceleration = 100, fly = TRUE),
                         an_extremely_long_component_name = NULL,
                         children = list(
                           a_entity(tag = "a-sphere", color = "red", radius = 0.5),
                           a_entity(tag = "a-sphere", color = "blue", radius = 0.5,
                                    children = list(
                                      a_entity(tag = "a-sphere", color = "green", radius = 0.5)))
                         ))
  expect_equal(
  {
    my_entity1$render()
  },
  {
   ### Nice nested html
    "<a-camera wasd-controls=\"acceleration: 100; fly: true;\" an-extremely-long-component-name>\n  <a-a-sphere color=\"red\" radius=\"0.5\"></a-a-sphere>\n  <a-a-sphere color=\"blue\" radius=\"0.5\">\n    <a-a-sphere color=\"green\" radius=\"0.5\"></a-a-sphere>\n  </a-a-sphere>\n</a-camera>\n"
  })

  
})

test_that("An entity only collects unique assets from its components & children", {

  my_entity <- a_entity(thing1 = a_asset(id = "cube", src = "cube.json"),
                        thing2 = a_asset(id = "cube", src = "cube.json"))
                        

  expect_equal(
  {
    length(my_entity$assets)
  },
  {
    1
  })

  expect_equal(
  {
    my_entity$assets[[1]]$src
  },
  {
    "cube.json"
  })

  expect_equal(
  {
    my_entity$assets[[1]]$id
  },
  {
    "cube"
  })

  my_entity2 <- a_entity(thing1 = a_asset(id = "cube", src = "cube.json"),
                         children = list(
                           a_entity(thing2 = a_asset(id = "cube", src = "cube.json"))))
  

  expect_equal(
  {
    length(my_entity2$assets)
  },
  {
    1
  })

  expect_equal(
  {
    my_entity2$assets[[1]]$src
  },
  {
    "cube.json"
  })

  expect_equal(
  {
    my_entity2$assets[[1]]$id
  },
  {
    "cube"
  })

})

test_that("an entity only collects unique JS sources from its components and children",{

  my_entity <- a_entity(js_sources = list("myjsfile.js","myjsfile.js"))
  

  expect_equal(
  {
    length(my_entity$js_sources)
  },
  {
    1
  })

  expect_equal(
  {
    my_entity$js_sources[[1]]
  },
  {
    "myjsfile.js"
  })

  my_entity2 <- a_entity(js_sources = list("myjsfile.js"),
                         children = list(
                           a_entity(js_sources = list("myjsfile.js"))))
  

  expect_equal(
  {
    length(my_entity2$js_sources)
  },
  {
    1
  })

  expect_equal(
  {
    my_entity2$js_sources[[1]]
  },
  {
    "myjsfile.js"
  })
})
