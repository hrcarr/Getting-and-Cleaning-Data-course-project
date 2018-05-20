# Getting-and-Cleaning-Data-course-project
This is the CodeBook for the Getting and Cleaning Data Assignment from Week 4.

This project used data came from the UCI Machine Learning Repository. More specifically, the data collected from the accelerometer and gyroscope of the Samsung Galaxy S smartphone was downloaded, loaded, and cleaned to create a tidy data set.

This repository includes the following files:

README.md: provides an overview of the data set and how it was created.
tidy_data.txt: contains the data set.
CodeBook.md:describes the contents of the data set.
run_analysis.R: R script used to create the data set (see the Creating the data set section below)
Study design

Data set

The R script run_analysis.R was used to create the data set. The script retrieves the source data set and transforms it to produce the final data set by implementing the following steps (see the Code book for futher details):

Download and unzip source data (if it doesn't exist already).
Read data.
Merge the training and the test sets to create one data set.
Extract the mean and standard deviation for each measurement.
Use descriptive activity names to name the activities in the data set.
Appropriately label the data set with descriptive variable names.
Create a second, independent tidy set with the average of each variable for each activity and each subject.
Write the data set to the tidy_data.txt file.
The tidy_data.txt in this repository was created by running the run_analysis.R script using R version 3.4.4 (2018-03-15).

The dplyr package (version 0.7.4) was used to create this script.
