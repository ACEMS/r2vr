# cast
# https://www.vrfocus.com/2020/11/its-now-easy-to-cast-oculus-quest-content-to-pc/

# read in database, grab id and use as base point for seed (seed will increment by 
# total number of questions for each participant and match first participants id)
# also good for crash can just reset seed and go_to() the last recorded entry
#evaluation_3d.df <- read("http://r2vr.herokuapp.com/api/3d/evaluation")
seed = 114 #max(evaluation_3d.df['id']) + 1

################################################################################
#                            Antarctica R2VR Script                            #
################################################################################
# Install Local clone of package:
setwd("C:/Users/n10907700/OneDrive - Queensland University of Technology/Desktop/Antartica")
devtools::install('r2vr-2020-master')

################################################################################

# Load Libraries, set up Crucial Variables:
library(r2vr)
set_marker_and_props("3d", 1, "extra-small")
IPv4_ADDRESS <- find_IP()
set_colors() # Optional (See '?set_colors').

# Set User for Database Reference:
first_name = 'katie'
last_name = ''

set_user(paste0(first_name, '-', last_name, '-', seed)) 

################################################################################
#                             Images and Questions                             #
################################################################################

# Set List of Images (Relative to Working Directory):
img_paths <- list(
  list(img = "PHOTO_0062.jpg"),
  list(img = "PHOTO_0076.jpg"),
  list(img = "PHOTO_0110.jpg"),
  list(img = "PHOTO_0038.jpg"),
  list(img = "PHOTO_0127.jpg"),
  list(img = "PHOTO_0121.jpg"),
  list(img = "PHOTO_0158.jpg")
) # Image list can be expanded!

#list(img = "PHOTO_0158.jpg")
#list(img = "PHOTO_0062.jpg"),
#list(img = "PHOTO_0076.jpg"),
#list(img = "PHOTO_0078.jpg"),
#list(img = "PHOTO_0091.jpg"),
#list(img = "PHOTO_0101.jpg"),
#list(img = "PHOTO_0109.jpg"),
#list(img = "PHOTO_0127.jpg"),
#list(img = "PHOTO_0139.jpg"),
#list(img = "PHOTO_0149.jpg"),
#list(img = "PHOTO_0038.jpg")
#list(img = "PHOTO_0078.jpg"),
#list(img = "PHOTO_0065.jpg"),
#list(img = "PHOTO_0062.jpg"),
#list(img = "PHOTO_0110.jpg"),
#list(img = "PHOTO_0068.jpg")

set.seed(seed)
set_random_images(img_paths) # Random Image Order.


# Set List of Questions:
evaluation_questions <- list(
  #Q1:
  list(question = "This image is visually appealing.", answerOne = "Disagree +", answerTwo = "Disagree", answerThree = "Agree", answerFour = "Agree +"),
  #Q2:
  list(question = "There is evidence of human impact.", answerOne = "Disagree +", answerTwo = "Disagree", answerThree = "Agree", answerFour = "Agree +"),
  #Q3:
  list(question = "There are penguins or seals in the image.", answerOne = "Disagree +", answerTwo = "Disagree", answerThree = "Agree", answerFour = "Agree +"),
  #Q4:
  list(question = "There are other animals or plants in the image.", answerOne = "Disagree +", answerTwo = "Disagree", answerThree = "Agree", answerFour = "Agree +"),
  #Q5:
  list(question = "The landscape is covered in snow.", answerOne = "Disagree +", answerTwo = "Disagree", answerThree = "Agree", answerFour = "Agree +"),
  #Q6:
  list(question = "The colours in the image are monotonous.", answerOne = "Disagree +", answerTwo = "Disagree", answerThree = "Agree", answerFour = "Agree +"),
  #Q7:
  list(question = "There are many people in the image.", answerOne = "Disagree +", answerTwo = "Disagree", answerThree = "Agree", answerFour = "Agree +"),
  #Q8:
  list(question = "The weather is nice.", answerOne = "Disagree +", answerTwo = "Disagree", answerThree = "Agree", answerFour = "Agree +")
) # Question list can be expanded!

set_questions_and_responses(evaluation_questions) # Optional (See '?set_questions_and_responses').

end()
end()
################################################################################
#                            Virtual Reality Scene                             #
################################################################################

# Create Scene:
animals <- shared_setup_scene("3d", "testing") # Do Not Change.
start()

ask_question(1)
ask_question(2)
ask_question(3)
ask_question(4)
ask_question(5)
ask_question(6)
ask_question(7)
ask_question(8)

#4
go_to() + ask_question(1)
ask_question(2)
ask_question(3)
ask_question(4)
ask_question(5)
ask_question(6)
ask_question(7)
ask_question(8)


################################################################################
# Read dataframe result:
evaluation_3d.df <- read("http://r2vr.herokuapp.com/api/3d/evaluation")
tail(evaluation_3d.df)


go_to()
go_to()
go_to()
go_to()
go_to()
go_to()
go_to()


data.frame(names=c(image1Path,image2Path,image3Path,image4Path,
                   image5Path,image6Path,image7Path))
