library(r2vr)
library(lubridate)

## Name of participant
participant <- "First participant"
record_times <- function(participant, status, users.df){users.df <- rbind(users.df, data.frame(userID = c(participant), datetime = Sys.time(), status = c(status)))}
# users.df <- data.frame(userID = participant, datetime = Sys.time(), status = c("start")) # initialise once

# Enter IP
IPv4_ADDRESS <- "131.181.64.15"

# Define image paths
img_paths <- c("../inst/ext/images/koalas/KP5.jpg", 
               "../inst/ext/images/koalas/SP10.jpg", 
               "../inst/ext/images/koalas/foundKoala1.jpg", 
               "../inst/ext/images/koalas/foundKoala2.jpg")

## Create Koala VR environment
animals <- binary_question_scene("Do you see any koalas in this image?", "Yes", "No", img_paths, IPv4_ADDRESS, "koala")

## Launch VR server
start(IPv4_ADDRESS)

## First participants 
users.df <- record_times(participant, "start", users.df)

## Pop a question for first scene
pop()

## Move to new scene
go(image_paths = img_paths, index = 4)

## Don't forget to pop the question!
pop()

## When participant is done:
end()
users.df <- record_times(participant, "end", users.df)

# Get data from database with API GET request
koala.df <- read(url = "https://test-api-koala.herokuapp.com/koala")

users.df$datetime <- ymd_hms(users.df$datetime, tz = "Australia/Queensland")
koala.df$recordedOn <-  ymd_hms(koala.df$recordedOn, tz = "Australia/Queensland")

dplyr::mutate(koala.df, userID = dplyr::case_when(recordedOn %within% 
                                                    lubridate::interval(users.df[users.df$userID == participant & users.df$status == "start", "datetime"],
                                                                        users.df[users.df$userID == participant & users.df$status == "end", "datetime"]) ~ participant, 
                                                  TRUE ~ userID))

koala.df
