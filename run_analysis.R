#Assignment for Getting and Cleaning Data

#Install plyr package
install.packages("plyr")
library(plyr)

#Load in the test and training data for x, y, and subjects
xTest = read.table("X_test.txt")
xTrain = read.table("X_train.txt")
yTest = read.table("Y_test.txt")
yTrain = read.table("Y_train.txt")
subjectTest = read.table("subject_test.txt")
subjectTrain = read.table("subject_train.txt")

#Load in the column labels for the test and training data
colLabels = read.table("features.txt")

#Load the activity labels
activities = read.table("activity_labels.txt")

#Rename the columns for the test and training data
subjectTest <-  rename(subjectTest, replace = c("V1"= "Participant"))
yTest <-  rename(yTest, replace = c("V1"= "Activity"))

subjectTrain <-  rename(subjectTrain, replace = c("V1"= "Participant"))
yTrain <-  rename(yTrain, replace = c("V1"= "Activity"))


#Loop 561 since 561 columns in the xTest and xTrain data sets.
for (i in 1:561)
{  
  newColName <- colLabels[i, 2]
  newColName <- as.character(newColName)   #Force from a factor to a character vector
  
  #Rename the column
  colnames(xTest)[i] <- newColName   
  colnames(xTrain)[i] <- newColName   
}

#Install dplyr package
install.packages("dplyr")
library(dplyr)

#Bind the columns for the test data
test = bind_cols(subjectTest, yTest, xTest)

#Bind the columns for the training data
train = bind_cols(subjectTrain, yTrain, xTrain)


#Combine the test and training data
TestTrain = bind_rows(test, train)

#Create a new dataset that just contains the Participant, Activity, mean(), std() columns
subTestTrain <- select(TestTrain, contains("Participant"), contains("Activity"), contains("mean()"), contains("std()"))

subTestTrain$Activity <- as.character(subTestTrain$Activity)

#Rename the activity codes (1 through 6) with the labels stored in the dataset activities

for (i in 1:6)
{
  
  actID <- as.character(activities[i, 1])
  actName <- as.character(activities[i, 2])
  subTestTrain$Activity[subTestTrain$Activity == actID] <-  actName
  
}

#Create a tidy data set the shows for each activity and participant the averages of the variables.
averages <- subTestTrain %>% group_by(Activity, Participant) %>% summarise_each(funs(mean))


#write.csv(averages, "averages.csv")


#Create txt file of the average data
write.table(averages, "averages1.txt", row.names = FALSE)
write.table(averages, "averages2.txt", row.names = FALSE, col.names = FALSE)  #This removes the column (headers)