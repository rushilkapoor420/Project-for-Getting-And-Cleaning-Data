
#-------------------OBJECTIVE OF SCRIPT-------------------#
## This script aims at reading relevant data from the data files obtained from Human Activity Recognition database 
## built from the recordings of 30 subjects performing  six different activities of daily living (ADL) 
## while carrying a waist-mounted smartphone (Samsung Galaxy S II) with embedded inertial sensors
## and eventually converting it to a tidy data set with the following requirements:
##   1. The "training" and "test" datasets need to be merged
##   2. Only measurements on the mean and standard deviation of each measurement need to be extracted

## Another objective of this script is to create a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

## Loading relevant libraries
library(dplyr)
library(reshape2)

## Clearing wrking space
rm(list=ls())

## Defining constants to be used later in the script here
actID <- "ActivityID"
actNm <- "ActivityName"
varIndex <- "FeatureIndex"
varNm <- "FeatureName"
subID <- "SubjectID"

## Reading activity label table
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE, sep="", colClasses=c("integer", "factor"))
names(activityLabels) <- c(actID, actNm)
## Reading Train Activity Data
trainActivityData <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="", colClasses="integer")
names(trainActivityData) <- c(actID)
trainActivityData <- merge(trainActivityData, activityLabels, by = actID)
## Reading Test Activity Data
testActivityData <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE, sep="", colClasses="integer")
names(testActivityData) <- c(actID)
testActivityData <- merge(testActivityData, activityLabels, by = actID)

## Reading Subject Data for train
trainSubjectData <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep="", colClasses="factor")
names(trainSubjectData) <- c(subID)
## Reading Subject Data for test
testSubjectData <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep="", colClasses="factor")
names(testSubjectData) <- c(subID)


## Read train data into a data frame 'trainData' and merging activity data
trainData <- read.table("UCI HAR Dataset/train/X_train.txt", header =FALSE, sep="", colClasses = "numeric")
trainData <- cbind(trainData, trainActivityData[actNm], trainSubjectData[subID])

## Read test data into a data frame 'testData' and merging activity data
testData <- read.table("UCI HAR Dataset/test/X_test.txt", header =FALSE, sep="", colClasses = "numeric")
testData <- cbind(testData, testActivityData[actNm], testSubjectData[subID])

## Merging test and train data into a data frame called allData
allData <- rbind(trainData, testData)

## Read features file
featureLables <- read.table("UCI HAR Dataset/features.txt", header =FALSE, sep="", colClasses = c("numeric", "character"))
names(featureLables) <- c(varIndex, varNm)

## Find the rows in features table corresponding to mean and std of measurements
## Also record the variable names
featureMeanSubset <- featureLables[grep("mean()", featureLables[[varNm]], fixed=TRUE), ]
featureSTDSubset <- featureLables[grep("std()", featureLables[[varNm]], fixed=TRUE), ]
colIndexSubset <- c(featureMeanSubset[ ,varIndex], featureSTDSubset[ ,varIndex])
colNamesSubset <- c(featureMeanSubset[ ,varNm], featureSTDSubset[ ,varNm])

## Adding Activity Column, Subject Column and TrainOrTestData Column to the subset vetors
subColIndex <- ncol(allData)
actColIndex <- (subColIndex -1)
colIndexSubset <- c(colIndexSubset, actColIndex, subColIndex)
subColName <- names(allData)[subColIndex]
actColName <- names(allData)[actColIndex]
colNamesSubset <- c(colNamesSubset, actColName, subColName)

## Subset allData to include columns only with Mean and Standard Deviation of measurements
allTidyData <- allData[ ,colIndexSubset]
names(allTidyData) <- colNamesSubset

## Finding out the mean of all relevant variables for each activitya and subjectID combination
dataMelt <- melt(allTidyData, id = c(actColName, subColName))
meanTable <- dcast(dataMelt, ActivityName + SubjectID ~ variable, mean)

# Writing out the mean output file as a text file
write.table(meanTable, file = "MeanOfAllVariablesBySubjectByActivity.txt", sep = "," , row.names = FALSE)
