context("test entity class")

test_that("A basic entity is rendered",{
  expect_equal(
  {
    test_entity <- A_Entity$new(.tag = "box",
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
    entity1 <- a_entity(.tag = "camera",
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
     A_Entity$new(id = "mine", .tag = "box",
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
    A_Entity$new(id = "tst",
                 gltf_model = a_asset(id = "monster",
                                      src = test_path("Kangaroo_01.gltf")),
                 animation_mixer = NULL)
  expect_equal(
  {
    entity1$render()
  },
  {
    '<a-entity id="tst" gltf-model="#monster" animation-mixer></a-entity>\n' 
  })
})

test_that("An entity with a nested entity defined inline is rendered correctly.", {
  my_entity1 <- a_entity(.tag = "camera",
                         wasd_controls = list(acceleration = 100, fly = TRUE),
                         an_extremely_long_component_name = NULL,
                         .children = list(
                           a_entity(.tag = "sphere", color = "red", radius = 0.5)
                         ))
  expect_equal(
  {
    my_entity1$render()
  },
  {
   "<a-camera wasd-controls=\"acceleration: 100; fly: true;\" an-extremely-long-component-name>\n  <a-sphere color=\"red\" radius=\"0.5\"></a-sphere>\n</a-camera>\n"
    
  })

  
})

test_that("An entity with a nested entites with assets and js_sources exposes these correctly.", {
  my_entity1 <- a_entity(.tag = "entity",
                         .js_sources = list("one.js", "two.js"),
                         material = list(src = a_asset(id = "tree", src = 'QUT.jpg'),
                                         color = '#FFFFFF',
                                         roughness = 1,
                                         metalness = 0),
                         geometry = "primitive: cylinder",
                         .children = list(
                           a_entity(.tag = "plane",
                                    material = list(src = a_asset(id = "earth",
                                                                  src ='BURGR.jpg')),
                                    .js_sources = "three.js")
                         ))
  expect_equal(
  {
    my_entity1$render()
  },
  {
   '<a-entity material=\"src: #tree; color: #FFFFFF; roughness: 1; metalness: 0;\" geometry=\"primitive: cylinder\">\n  <a-plane material=\"src: #earth;\"></a-plane>\n</a-entity>\n'
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
    list("QUT.jpg", "BURGR.jpg")
  })
})

test_that("An entity with two nested entities defined inline is rendered correctly.", {
  my_entity1 <- a_entity(.tag = "camera", wasd_controls = list(acceleration = 100, fly = TRUE),
                         an_extremely_long_component_name = NULL,
                         .children = list(
                           a_entity(.tag = "sphere", color = "red", radius = 0.5),
                           a_entity(.tag = "sphere", color = "blue", radius = 0.5,
                                    .children = list(
                                      a_entity(.tag = "sphere", color = "green", radius = 0.5)))
                         ))
  expect_equal(
  {
    my_entity1$render()
  },
  {
   ### Nice nested html
    "<a-camera wasd-controls=\"acceleration: 100; fly: true;\" an-extremely-long-component-name>\n  <a-sphere color=\"red\" radius=\"0.5\"></a-sphere>\n  <a-sphere color=\"blue\" radius=\"0.5\">\n    <a-sphere color=\"green\" radius=\"0.5\"></a-sphere>\n  </a-sphere>\n</a-camera>\n"
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
                         .children = list(
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

  my_entity <- a_entity(.js_sources = list("myjsfile.js","myjsfile.js"))
  

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

  my_entity2 <- a_entity(.js_sources = list("myjsfile.js"),
                         .children = list(
                           a_entity(.js_sources = list("myjsfile.js"))))
  

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

test_that("a component that is a name only can be added with a blank character vector",{

  expect_equal(
  {
    my_entity <- a_entity(.tag = "camera", position = c(1,2,3), wasd_controls="")
    my_entity$render()
  },
  {
    "<a-camera position=\"1 2 3\" wasd-controls></a-camera>\n"
  })

  test_that("a double underscores in component names are not converted to dashes",{

    expect_equal(
    {
      my_entity <- a_entity(.tag = "box", event_set__click = "material.color: blue", position = c(1,2,3))
      my_entity$render()
    },
    {
      "<a-box event-set__click=\"material.color: blue\" position=\"1 2 3\"></a-box>\n"
    })
  })
})

test_that("'quoted' component names are not interfered with", {

  my_entity <- a_entity(`'a_hairy_yak` = "this.")

  expect_equal({
    my_entity$render()
  },{
    "<a-entity a_hairy_yak=\"this.\"></a-entity>\n"
  })
})

test_that("Assets passed in .assets are added to entity's assets, and passed to scene.", {

  my_entity <- a_entity(model = a_asset(id = "cube",
                                        src = test_path("cube.json")),
                        .assets = list(a_asset(id = "kangaroo",
                                               src = test_path("kangaroo_01.gltf"),
                                               .parts = test_path("Kangaroo_01.bin")),
                                       a_asset(id = "QUT",
                                               .tag = "img",
                                               src = test_path("QUT.png")))
                        )

  asset_srcs <-
    my_entity$assets %>%
    purrr::map(~.$src)

    expect_true({
      length(
        setdiff(asset_srcs,
                list(test_path("cube.json"),
                     test_path("kangaroo_01.gltf"),
                     test_path("QUT.png"))
                )) == 0
    })

    my_scene <-
      a_scene(.template = "empty",
              .children = list(my_entity))

    asset_srcs <-
      my_scene$assets %>%
      purrr::map(~.$src)

      expect_true({
        length(
          setdiff(asset_srcs,
                  list(test_path("cube.json"),
                       test_path("kangaroo_01.gltf"),
                       test_path("QUT.png"))
                  )) == 0
      })

})



test_that("A Scene only collects unique combinations of asset src and id.", {

  my_entity <- a_entity(model = a_asset(id = "cube",
                                        src = test_path("cube.json")),
                        .assets = list(a_asset(id = "kangaroo",
                                               src = test_path("kangaroo_01.gltf"),
                                               .parts = test_path("Kangaroo_01.bin")),
                                       a_asset(id = "QUT",
                                               .tag = "img",
                                               src = test_path("QUT.png")))
                        )

  ## QUT2 points to the same file as QUT but has a different id and should be kept.
  ## kangaroo points the same file and has the same id, so should be deduped by scene.
  my_scene <-
    a_scene(.template = "empty",
            .children = list(my_entity),
            .assets = list(a_asset(id = "kangaroo",
                                   src = test_path("kangaroo_01.gltf"),
                                   .parts = test_path("Kangaroo_01.bin")),
                           a_asset(id = "QUT2",
                                   .tag = "img",
                                   src = test_path("QUT.png"))))

  asset_srcs <-
    my_scene$assets %>%
    purrr::map(~.$src)

    duplicated_srcs <-  
      asset_srcs[duplicated(asset_srcs)]

    expect_true({
     (length(duplicated_srcs) == 1) & (duplicated_srcs[[1]] == test_path("QUT.png"))
    })

    expect_true({
      length(
        setdiff(asset_srcs,
                list(test_path("cube.json"),
                     test_path("kangaroo_01.gltf"),
                     test_path("QUT.png"))
              )) == 0
    })

})
