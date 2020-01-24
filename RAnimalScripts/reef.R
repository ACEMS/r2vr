library(r2vr)
library(httr)
library(jsonlite)

# Enter IP
IPv4_ADDRESS <- "192.168.43.72"

# Define image paths
img_paths <- c("../inst/ext/images/reef/100030039.jpg", 
               "../inst/ext/images/reef/120261897.jpg", 
               "../inst/ext/images/reef/130030287.jpg", 
               "../inst/ext/images/reef/130050093.jpg")

## Create binary qestion scene for animals
animals <- binary_question_scene("Do the live corals on this reef form a structurally complex habitat?", "Yes", "No", img_paths, IPv4_ADDRESS, "reef")

## Launch VR server
start(IPv4_ADDRESS)

## Pop a question for first scene
pop()

## Move to new scene
go(image_paths = img_paths, index = 3)

## Don't forget to pop the question!
pop()

# Get data from database with API GET request
read(url = "https://test-api-koala.herokuapp.com/reef")
