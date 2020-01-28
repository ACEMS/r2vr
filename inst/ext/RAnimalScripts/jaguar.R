library(r2vr)
library(lubridate)

# Enter IP
IPv4_ADDRESS <- "192.168.43.72"

# Define image paths
img_paths <- c("../inst/ext/images/jaguars/WP14_360_002.jpg", 
               "../inst/ext/images/jaguars/WP55_360_001.jpg", 
               "../inst/ext/images/jaguars/WP56_360_001.jpg",
               "../inst/ext/images/jaguars/WP60_360_001.jpg")

## Create Jaguar VR environment
animals <- multivariable_question_scene("Do you see any of these habitat features in this image? If you do see a feature, click on the box to select it.",
                             "Water", "Jaguar tracks", "Scratch marks", "Dense Vegetation", img_paths, IPv4_ADDRESS)

## Launch VR server
start(IPv4_ADDRESS)

## Pop a question for first scene
pop(question_type = "multivariable")

## Move to new scene
go(image_paths = img_paths, index = 4, question_type = "multivariable")

## Don't forget to pop the question!
pop(question_type = "multivariable")

## When participant is done:
end()

# Get data from database with API GET request
jaguar.df <- read(url = "https://test-api-koala.herokuapp.com/jaguar")
jaguar.df$recordedOn <-  ymd_hms(jaguar.df$recordedOn, tz = "Australia/Queensland")
jaguar.df
