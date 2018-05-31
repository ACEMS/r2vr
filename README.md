# r2vr
[![Travis-CI Build Status](https://travis-ci.org/MilesMcBain/r2vr.svg?branch=master)](https://travis-ci.org/MilesMcBain/r2vr)
  [![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) 
  [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/milesmcbain/r2vr?branch=master&svg=true)](https://ci.appveyor.com/project/milesmcbain/r2vr)

This package helps you generate and serve A-Frame scenes. It provides a suite of objects representing A-Frame scenes, entities, and assets that can be composed using a functional R interface.

# Installation

`devtools::install_github("milesmcbain/r2vr")`

# R objects for building A-Frame Scenes

The core of `r2vr` is 3 classes that map to A-Frame entities, assets, and
scenes. A scene may contain many child entities which may themselves contain
many child entities and assets. Entities may have many components added to define their behaviour.

Objects of these classes are defined using functions: `a_entity()`, `a_asset()`, `a_scene()`. 
Given a structure of these objects, `r2vr` does the work of:
* Rendering them as A-Frame HTML and combining into a selected HTML template. 
* Collecting their assets and required javascript sources and placing them in the appropriate HTML sections.
* Serving the HTML scene and asset files.

## Entities
In the A-Frame [entity-component architecture](https://aframe.io/docs/0.8.0/introduction/entity-component-system.html) a scene is composed of entities. These are defined in HTML like:

```html
<a-entity geometry="primitive: box" material="color: red"></a-entity>
```

Entities are customised using HTML element properties that map configuration to appearance and behaviour. A-Frame provides many 'convenience' tags to simplify the definition of commonly used entity configurations. For example the above entity can also be defined:

```html
<a-box color="red">
```

`r2vr` respects these same definition types. It provides the added convenience of defining component configuration as R lists. The above can be defined in R any of:

```r
a_entity(geometry = "primitive: box", material = "colour: red")
a_entity(geometry = list(primitve = "box"), material = list(color = "red"))
a_entity(tag = "box", color = "red")
```

Notice that entity components are attached using `...` arguments to the
`a_entity()` function. 

### Component Naming

For components with multi-word-names in A-Frame, the convention is to separate with `-`, e.g. `wasd-controls`, when attaching these in `r2vr` you swap the `-` for `_` since the dash is not legal as a bare symbol in R. So take this HTML:

```html
<a-camera wasd-controls="fly: true;"></a-camera>
```

Possible `r2vr` equivalents are:

```r
a_entity(tag="camera", wasd_controls = list(fly = TRUE))
a_entity(tag="camera", wasd_controls = "fly: true;")
```

One current issue is that you cannot supply an component without configuration neatly. So to use `wasd-controls` with default configuration we must write:

```r
a_entity(tag="camera", wasd_controls=NULL)
```

### Nesting entities

In A-Frame entities can have child entities nested within them. This is often
extremely convenient to do since nested entities inherit the position and
rotation of their parent. So in this HTML:

```html
<a-box position="1 1 1", rotation="45 45 45" color="blue">
  <a-sphere position="1 0 0" color="green"></a-sphere>
</a-box>
```

The green sphere inherits `position` and `rotation` from its blue box parent.
It's own position is interpreted as offset from its parent. So the sphere's
absolute position is `2 1 1`.

In `r2v2` child entities are nested as a list supplied to the parent's `children` argument. So the above pair are defined:

```r
a_entity(tag = "box", position = c(1, 1, 1), rotation = c(45, 45, 45), 
         color="blue",
         children = list(
           a_entity(tag = "sphere", positon = c(2, 1, 1))
         ))
```

Because the nested `a_entity` call returns an object it's possible to break up the nesting a bit, if it aids readability:

```r
sphere <- a_entity(tag = "sphere", positon = c(2, 1, 1))

box <- a_entity(tag = "box", position = c(1, 1, 1),
                rotation = c(45, 45, 45),
                children = list(sphere))
```

## Scene
A scene outer container for all entities.

TODO.

## Assets
Assets are media like models, images, videos, sounds etc that need to be
downloaded by the user before they can experience the scene properly. Assets are
attached to entities using the appropriate component. Most commonly the `src` argument.

# Example Usage
To serve a scene containing JSON model and a glTF model, you can write R code that looks like this:

```r
library(r2vr)
  ## Assests
  cube <- a_asset(id = "cube", src = "./cube.json")
  kangaroo <- a_asset(id = "kangaroo",
                      src = "./Kangaroo_01.gltf",
                      parts = "./Kangaroo_01.bin")

  ## Scene structure
  my_scene <- a_scene(template = "empty",
                      title = "A kangaroo and a cube.",
                      children = list(
                        a_json_model(src_asset = cube,
                                     position = c(0,0,-2),
                                     scale = c(0.2, 0.2, 0)),
                          
                        a_entity(tag = "gltf-model",
                                 src = kanagaroo,
                                 position = c(2, 2, -3), 
                                 height = 1, width = 1)
                          ))
  ## View HTML
  my_scene$render()

  ## Serve HTML
  my_scene$serve()

  ## Stop Serving
  my_scene$stop()
```

that will allow you to serve HTML that looks like this:

```html
<!DOCTYPE html>
<html>
    <head>
    <meta charset="utf-8">
    <title>A kangaroo and a cube.</title>
    <meta name="description" content= "A kangaroo and a cube.">
    <script crossorigin src="https://aframe.io/releases/0.8.0/aframe.min.js"></script>
    <script crossorigin src="https://cdn.rawgit.com/donmccurdy/aframe-extras/v4.0.2/dist/aframe-extras.loaders.js"></script>
    </head>
    <body>
        <a-scene >
            <a-assets>
                <a-asset-item id="cube" src="./cube.json"></a-asset-item>
                <a-asset-item id="kangaroo" src="./Kangaroo_01.gltf"></a-asset-item>
            </a-assets>
            
            <!-- Entities added in R -->
            <a-entity json-model="src: #cube;" position="0 0 -2" scale="0.2 0.2 0"></a-entity>
            <a-gltf-model position="2 2 -3" height="1" width="1" src="#kangaroo"></a-gltf-model>
            

            <!-- Ground -->
            <a-grid geometry='height: 10; width: 10'></a-grid>
        </a-scene>
    </body>
</html>
```

Scenes are served using the [Fiery webserver framework](https://github.com/thomasp85/fiery).
