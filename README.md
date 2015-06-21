#Class Project for Getting and Cleaning Data class in Coursera
*Author: Rushil Kapoor*  
*Date: June 21, 2015*  
*Version: 2.0*  


The project required us the create a script to perform some operations on some input files to create a tidy data set. This document explains how the script **run_analysis.R** works and a breif introduction of the input files and the desired output.


##Input Data
The given dataset includes various measurements made by instruments installed in the smartphone Samsung Galaxy S II for the following 6 Activities:  
1. WALKING  
2. WALKING UPSTAIRS  
3. WALKING DOWNSTAIRS  
4. SITTING  
5. STANDING  
6. LAYING


30 individuals were asked to perform these activities while the phone recorded 561 distinct measurements related to 17 features (belonging to either 3-axial linear acceleration or 3-axial angular velocity).


The obtained dataset had been randomly partitioned into two sets, where 70% of the volunteers were selected for generating the training data and 30% for test data (corresponding to different files in the input data).


We downdload the dataset from the given link, unzip the file and place it in the working directory for this project.


##Objective
Given the dataset, the project required us to:  
1. Combine the data from the test source and the training source  
2. Extracts only the measurements on the mean and standard deviation for each measurement  
3. Uses descriptive activity names to name the activities in the data set  
4. Appropriately label the data set with descriptive variable names  
and finally,  
5. creates an independent tidy data set with the average of each variable for each activity and each subject  


##The Script: run_analysis.R
One should know that at this point, the unzipped version of the input dataset is in the working directory of the R project.


The script is well commented, but following is a step by step summary of what happens inside the script.  
1. First we read the activity label file and give the variables descriptive names  
2. Then we read the activity data from both sources (train and test) while also giving them similar descriptive names as in Step 1. We store them in two different data frames.  
3. Then we merge the activity label data frame from step one with both data frames generated from Step 2, so as to have access to activity names in the same data frame as activity data.  
4. Then we read the subject data from both sources (train and test) and give them descriptive names. We store them in two different data frames.  
5. We then read the data for the actual measurements from both sources and store them in two different data frames.  
6. We now combine the measurements' data frame, activity label data frame and subject info data frame for both sources resulting in two data frames (one for test and one for train)  
7. Now we combine the two data frames formed in Step 6 into one big data fram called allData which has all the information we require and more.  
8. Now we read in the feature labels files in a separate data frame and record the names and indices of the features that have the string "mean()" or "std()". This gives us a record of all the relevant variables that we require and their column numbers in the allData data frame made in Step 7.  
9. Now we use the results from Step 8, to filter out only the columns that we need and also name them with appropriate description.  
10. Lastly, we melt the data frame in Step 8 to hold all means and standard deviation values in one column
11. Then we use dcast() fucntion to find the mean for all activities for each relavant variable for each activity.  
12. In the end we write out the results found in Step 11 to a text file called "MeanOfAllVariablesBySubjectByActivity.txt" using rowNames=FALSE.


##Output
A tidy data set matchign all requirements mentioned in the OBJECTIVE section of this file.  
The output file name is **"MeanOfAllVariablesBySubjectByActivity.txt"**