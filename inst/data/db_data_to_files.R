### CREATE DATAFRAMES FROM DB
## gold_standard, annotated_images, estimated_coral_cover, compare_coral_cover, image_difficulty

library(dplyr)

### GOLD STANDARD ###

# Read existing files to get the gold standard estimated coral cover
df_outputs <- read.csv("data/Database_outputs.csv")
df_labelset <- read.csv("data/labelset_full_edited.csv")

# Convert factors into characters for labelset
drop_label_factor <- c("label")
parse_labelset_label_to_char <- as.character(df_labelset$label)
# Use all rows excluding the label column
df_labelset <- df_labelset[,!(names(df_labelset) %in% drop_label_factor)]
# Replace / Add new column with the parsed label type
df_labelset$label = parse_labelset_label_to_char

# Convert factors into characters for outputs
parse_ouptputs_label_to_char <- as.character(df_outputs$label)
# Use all rows excluding the label column
df_outputs <- df_outputs[,!(names(df_outputs) %in% drop_label_factor)]
# Replace / Add new column with the parsed label type
df_outputs$label = parse_ouptputs_label_to_char

# Inner join of labelset and outputs filtered by region/label
df_tot<-inner_join(df_outputs,df_labelset%>%filter(region=="Australia"),by="label")%>%dplyr::select(id.x:label,fg_global)

# Get the number of classication per image
df_tot%>%group_by(qid)%>%tally()

# Get % coral cover per image
gold_standard <- data.frame(df_tot%>%
  filter(!fg_global=="Hard corals")%>%
  group_by(qid)%>%tally()%>%
  mutate(No.coral.cover=(n/50)*100)%>%
  mutate(Coral.cover=100-No.coral.cover)%>%
  dplyr::select(qid,Coral.cover))

colnames(gold_standard)<-c("image_id","grand_total")
# Write to file
write.csv(gold_standard,'data/gold_standard.csv')


### ESTIMATED CORAL COVER

## NOTE: dataBack from DB
# Read file from DB/API GET request
annotated_images <- read.csv('data/annotated_images.csv')

# Find the coral count for each observation
observation_coral_count <- annotated_images%>%filter(is_coral==1)%>%group_by(observation_number)%>%tally()%>%mutate(coral.count=n)%>%dplyr::select(observation_number,coral.count)

# Find the not coral count for each observation
observation_not_coral_count <- annotated_images%>%filter(is_coral==0)%>%group_by(observation_number)%>%tally()%>%mutate(not.coral.count=n)%>%dplyr::select(observation_number,not.coral.count)

# Merge the tables based on 
merged_observation_count <- merge(x=observation_coral_count,y=observation_not_coral_count,by="observation_number",all=TRUE)
# Set the count for any NA to 0
merged_observation_count[is.na(merged_observation_count)] <- 0
# Find the total number of annotations for each observation number
total_observation_count <- annotated_images%>%group_by(observation_number,image_id)%>%tally()
# Create DF based on these counts on observation number
estimated_coral_cover <- inner_join(merged_observation_count,total_observation_count,by="observation_number")
colnames(estimated_coral_cover)<-c("observation_number","coral_selected", "not_coral", "image_id", "total_sites")
# Write to file
write.csv(estimated_coral_cover, 'data/estimated_coral_cover.csv')


### COMPARE CORAL COVER


# Read in the the created files
parsed_ecc <- read.csv('data/estimated_coral_cover.csv')
parsed_gs <- read.csv('data/gold_standard.csv')
# Create a dataframe via an inner join based on the image_id
compare_coral_cover <- data.frame(inner_join(parsed_ecc,parsed_gs,by="image_id"))
# Work out the percentage of coral cover
est_cc_percentage <- (compare_coral_cover$coral_selected/compare_coral_cover$total_sites) * 100
# Update DF to contain this percentage and select the desired columns
compare_coral_cover <- compare_coral_cover%>%mutate(estimated_coral_cover=est_cc_percentage)%>%dplyr::select(observation_number,image_id,estimated_coral_cover,grand_total)
# Write to file
write.csv(compare_coral_cover, 'data/compare_coral_cover.csv')


### DIFFICULTY TO CLASSIFY IMAGE


# Work out the average estimated coral cover based on all of the observation scores for each image
# Find the difference between the gold standards percentage and the users' estimates
# Categorise the difficulty based on the difference
image_difficulty <- aggregate(compare_coral_cover[, 3:4], list(compare_coral_cover$image_id), mean)%>%mutate(difference_in_cc = abs(estimated_coral_cover - grand_total))%>%mutate(category=cut(difference_in_cc, breaks=c(0,25,50,100), labels=c("easy","moderate","hard")))
# Label the columns
colnames(image_difficulty)<-c("image_id", "avg_estimated_cc", "grand_total", "difference_in_cc", "category")
# Write to file
write.csv(image_difficulty, 'data/image_difficulty.csv')
