library(r2vr)
library(httr)
library(jsonlite)
devtools::document()

# Enter IP
IPv4_ADDRESS <- "131.181.64.15"

# Define image paths
img_paths <- c("../inst/ext/images/koalas/KP5.jpg", 
               "../inst/ext/images/koalas/SP10.jpg", 
               "../inst/ext/images/koalas/foundKoala1.jpg", 
               "../inst/ext/images/koalas/foundKoala2.jpg")

animals <- binary_question_scene("Do you see any koalas in this image?", "Yes", "No", img_paths)

## Launch VR server
start(IPv4_ADDRESS)

## Pop a question for first scene
pop()

## Move to new scene
go(image_paths = img_paths, index = 3)

## Don't forget to pop the question!
pop()

## Read database results
read(url = "https://test-api-koala.herokuapp.com/koala")

