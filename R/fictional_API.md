## Some fictional syntax

```
library(r2vr)

 my_scene <-
   a_scene(template = a_scene_template("grid")) %>%
   add_a_entity(a_json_model(path = "path/to/file.json", position = "0 0 0", scale = "0.1 0.1 0.1")) %>%
   add_a_entity(a_json_model(path = "path/to/file.json", position = "0 0 0", scale = "0.1 0.1 0.1")) %>%
   add_a_entity(a_entity(tag = "box", shadow = NULL, spinner = NULL, material = list(texture = a_asset("./texture.png")),
                         sources = "cdn://somescript.js", assets = a_asset(type = "image")))
```


