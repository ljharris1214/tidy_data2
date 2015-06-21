#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

#Here are the data for the project: 
     
   #  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

#    You should create one R script called run_analysis.R that does the following. 
#         Merges the training and the test sets to create one data set.
#         Extracts only the measurements on the mean and standard deviation for each measurement. 
#         Uses descriptive activity names to name the activities in the data set
#         Appropriately labels the data set with descriptive variable names. 
#         From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#following can be used to download the zip file, and then manually extract
#commented out because assignment presumes file is already downloaded
#if(!file.exists("./project")){dir.create("./project")}
#setwd("./project")
#if(!file.exists("./data")){dir.create("./data")}
#setwd("./data")
#fileUrl1 = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileUrl1,destfile="./zipfile.zip",method="curl")

#name the various files that will be read in
trainFile_labels<-"./UCI HAR dataset/train/y_train.txt"
trainFile_x<-"./UCI HAR dataset/train/X_train.txt"
trainFile_subjects<-"./UCI HAR dataset/train/subject_train.txt"

testFile_labels<-".UCI HAR dataset/test/y_test.txt"
testFile_x<-"./UCI HAR dataset/test/X_test.txt"
testFile_subjects<-"./UCI HAR dataset/test/subject_test.txt"
featureFile<-"./UCI HAR dataset/features.txt"
activitiesFile<-"./UCI HAR dataset/activity_labels.txt"

#read in the files
train_labels<-read.table(trainFile_labels, header=FALSE)
train_subjects<-read.table(trainFile_subjects, header=FALSE)
test_labels<-read.table(testFile_labels, header=FALSE)
test_subjects<-read.table(testFile_subjects, header=FALSE)
features<-read.table(featureFile)
activities<-read.table(activitiesFile)

# don't specify a separator as the files sometimes contain multiple spaces between elements
train_x<-read.table(trainFile_x, header=FALSE)
test_x<-read.table(testFile_x, header=FALSE)

#combine the subject, activity and data for training and test separately
train<-cbind(train_subjects, train_labels)
train<-cbind(train, train_x)

test<-cbind(test_subjects, test_labels)
test<-cbind(test, test_x)

#create a vector with column labels by combining subject, activity with the names listed in the features file
features<-as.vector(features[,2])
headers<-c("subject", "activity")
headers<-c(headers, features)

#apply the names to each dataframe
names(test)<-headers
names(train)<-headers

#combine the train and test sets; use data.table package for efficiency
library(data.table)
combined<-rbindlist(list(train, test))

#melt the data so that name of measurement appears as column "variable", and its value in column "value"
melted<-melt(combined, id=c("subject", "activity"))]

#extract the rows where a) "Mean" is included in variable name; b) "std" is included in variable name
means<-melted[grep("Mean",melted$variable),]
std<-melted[grep("std",melted$variable),]

#combine these two dataframes
combined2<-rbindlist(list(means,std))

#add descriptive activity names by merging the activities dataframe with the main dataframe
names(activities)<-c("id", "activity")
combined3<-merge(activities, combined2, by.x = "id", by.y = "activity", all=TRUE)

#obtain averges by subject, activity, and feature
library(dplyr)
groupby<-group_by(combined3, subject, activity, variable)
averages<-summarize(groupby, ave=mean(value, na.rm=TRUE))

#write out the file
write.table(averages,file="averages.txt", row.names = FALSE, quote=FALSE)
