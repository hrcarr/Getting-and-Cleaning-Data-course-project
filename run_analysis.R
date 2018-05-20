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
activityLabels = read.table('./data/Dataset/activity_labels.txt')

#Assign col. names to merge training and test sets to create one data set.
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
      
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
      
colnames(activity_label) <- c('activityId','activityType')

merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
Combined_Set <- rbind(merge_train, merge_test)

# remove individual data tables to save memory
rm(x_train, y_train, subject_train, x_test, y_test, subject_test)

#Extracts only the measurements on the mean and standard deviation for each measurement
col_names <- colnames(Combined_Set) # set col. names to calculate mean and std, & to remove extra cols.

mean_std <- (grepl("activityId" , col_names) | 
                 grepl("subjectId" , col_names) | 
                 grepl("mean" , col_names) | 
                 grepl("std" , col_names) 
                 )
#create subset data set
MeanAndStd <- Combined_Set[ , mean_std == TRUE]

#Uses descriptive activity names to name the activities in the data set: using activity_label
MeanAndStd <- merge(MeanAndStd, activity_label,
                              by='activityId',
                              all.x=TRUE)

# get column names
Cols <- colnames(MeanAndStd)

#Appropriately labels the data set with descriptive variable names.
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

# use new labels as column names in data set
colnames(MeanAndStd) <- Cols

#From the data set in step 4, creates a second, independent tidy data set w the avg of each var for each act and each sub.

TidyMean <- aggregate(. ~subjectId + activityId, MeanAndStd, mean)
Tidy <- TidyMean[order(TidyMean$subjectId, TidyMean$activityId),]

write.table(Tidy, "tidy_data.txt", row.names = FALSE, quote = FALSE)