#library(dplyr) 
#library(data.table) 
#library(lubridate)
# rm(list=ls())
#check working directory getwd(), set if necessary

#Getting and Cleaning data project: Create one R script called run_analysis.R that does the following:

# Get data: download, unzip, and save in working directory 

dataset <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "Users/hilarycarr/Desktop/R_directory/Cleaning/week4/Dataset.zip"
download.file(dataset, destfile="./Data/Dataset.zip",method="curl")
unzip(zipfile="./Data/Dataset.zip",exdir="./Data")

# Look at files in downloaded, unzipped folder
#path_data <- file.path("./Data" , "Dataset")
#files<-list.files(path_data, recursive=TRUE)
#files

#Read data
# Reading trainings tables:
x_train <- read.table("./Data/Dataset/train/X_train.txt")
y_train <- read.table("./Data/Dataset/train/y_train.txt")
subject_train <- read.table("./Data/Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./Data/Dataset/test/X_test.txt")
y_test <- read.table("./Data/Dataset/test/y_test.txt")
subject_test <- read.table("./Data/Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./data/Dataset/features.txt')

# Reading activity labels:
activities = read.table('./data/Dataset/activity_labels.txt')
colnames(activities) <- c("activityId", "activityLabel")

# 1 - Merge the training and the test sets 

Merged <- rbind(
  cbind(x_train, y_train, subject_train),
  cbind(x_test, y_test, subject_test)
)

# set column names
colnames(Merged) <- c("subject", features[, 2], "activity")

# 2 - Extract measurements on the mean and standard deviation or each measurement (subset w/ desired cols.):
Sub <- grepl("subject|activity|mean|std", colnames(Merged))

Merged <- Merged[, Sub]

# 3 - Use descriptive activity names to name the activities in the data set: replace activity values with named factor levels
Merged$activity <- factor(Merged$activity, levels = activities[, 1], labels = activities[, 2])

# 4 - Appropriately label the data set with descriptive variable names

Cols <- colnames(Merged) # set column names

# remove special characters
Cols <- gsub("[\\(\\)-]", "", Cols)

# abbreviations and clean names
Cols <- gsub("^f", "frequency", Cols)
Cols <- gsub("^t", "time", Cols)
Cols <- gsub("Acc", "Accelerometer", Cols)
Cols <- gsub("Gyro", "Gyroscope", Cols)
Cols <- gsub("Mag", "Magnitude", Cols)
Cols <- gsub("Freq", "Frequency", Cols)
Cols <- gsub("mean", "Mean", Cols)
Cols <- gsub("std", "StandardDeviation", Cols)

# typo
Cols <- gsub("BodyBody", "Body", Cols)

# use new labels as column names
colnames(Merged) <- Cols

# 5 - Create a second, independent tidy set with the average of each variable for each activity and each subject

# group data by subject and activity and summarise using mean
TidyMean <- Merged %>% 
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# create "tidy_data.txt" file, Why isn't string appearing???
write.table(TidyMean, "tidy_data.txt", row.names = FALSE, quote = FALSE)
