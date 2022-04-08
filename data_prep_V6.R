############## Antartica data preparation 
rm(list=ls())

library(ggplot2)
library(tidyr)
library(dplyr)
library(purrr)


# set working directory to the dropbx folder 

setwd("C:/Users/n10907700/OneDrive - Queensland University of Technology/Desktop/Antartica")

# Read data 

dat.raw <- read.csv("./parsed_results.csv") %>% data.frame()

#overall check data
map(dat.raw, ~sum(is.na(.))) 

length(unique(dat.raw$person_id)) # 43 people 
length(unique(dat.raw$image)) # 16 images 

# Spread data table 

dat.spread<-dat.raw%>%
  dplyr::select(image:visited_id,question,response_id) %>%
  gather(variable, value, -(image:question)) %>%
  unite(temp,question, variable) %>%
  spread(temp, value)

### Response variable

response <- dat.spread$`This image is visually appealing._response_id`

### Transform image id
#ImageID <- as.numeric(dat.spread$image)
images_map=c(1:length(unique(dat.raw$image)))
names(images_map)=unique(dat.raw$image)
ImageID <- as.numeric(images_map[dat.spread$image])

### Centred continuous covariates (aesthetic indicators)

covariates.cont<-dat.spread %>%
  dplyr:::select(`The colours in the image are monotonous._response_id`:`There is evidence of human impact._response_id`) %>%
  mutate_all(funs(.-0.5)) 
colnames(covariates.cont) <- c("colour_image","snow_presence","good_weather","human_presence","biodiversity_presence","iconic_species_presence",
                               "human_impact_presence")

## Baseline for categorical covariates
##################### Define class 2 [26-45] as baseline
##################### Define group 1 (ACEMS) as baseline
##################### Define gender 1 (women) as baseline

#table(dat.raw$age_id)
#table(dat.raw$group_id)
#table(dat.raw$gender_id)
#table(dat.raw$gender_id)
#table(dat.raw$published_id) # NOT USED YET
#ggplot(data= dat.raw,aes(x=group_id,fill=as.factor(published_id))) +geom_bar() # only group 3 and 4 published paper
#table(dat.raw$visited_id) #NOT USED YET
#ggplot(data= dat.raw,aes(x=group_id,fill=as.factor(visited_id))) +geom_bar() # only group 3 and 4 visited antartica 

covariates.cat<-dat.spread %>%
  mutate(age_fct = factor(age_id, levels = c(2, 1, 3))) %>%
  mutate(grp_fct = factor(group_id, levels = c(3,2, 1, 4))) %>%
  mutate(gender_fct = factor(gender_id, levels = c(1,2))) %>%
  dplyr:::select(age_fct,grp_fct,gender_fct,gender_fct)

covariates.ready<-cbind(covariates.cont,covariates.cat)


### Add uncertainty for each question

# Spread data table 

dat.spread.unc<-dat.raw%>%
  dplyr::select(image:visited_id,question,confidence_id) %>%
  gather(variable, value, -(image:question)) %>%
  unite(temp,question, variable) %>%
  spread(temp, value)%>%
  dplyr::select(9:16)

colnames(dat.spread.unc) <- c("colour_image_unc","snow_presence_unc","good_weather_unc","human_presence_unc","biodiversity_presence_unc",
                              "iconic_species_presence_unc",
                               "human_impact_presence_unc","beauty_unc")




save.image(file="input_V6.RData")
