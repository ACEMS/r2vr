library(r2vr)
library(httr)
library(jsonlite)

# Enter IP
IPv4_ADDRESS <- "131.181.64.15"

# Define image paths
img_paths <- c("../inst/ext/images/jaguars/WP14_360_002.jpg", 
               "../inst/ext/images/jaguars/WP55_360_001.jpg", 
               "../inst/ext/images/jaguars/WP56_360_001.jpg",
               "../inst/ext/images/jaguars/WP60_360_001.jpg")


animals <- multivariable_question_scene("Do you see any of these habitat features in this image? If you do see a feature, click on the box to select it.",
                             "water", "Jaguar tracks", "Scratch marks", "Dense Vegetation", img_paths)

## Launch VR server
start(IPv4_ADDRESS)

## Pop a question for first scene
pop(question_type = "multivariable")

## Move to new scene
go(image_paths = img_paths, index = 2, question_type = "multivariable")

## Don't forget to pop the question!
pop(question_type = "multivariable")

# Get data from database with API GET request
read(url = "https://test-api-koala.herokuapp.com/jaguar")