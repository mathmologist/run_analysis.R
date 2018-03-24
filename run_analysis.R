# Getting and Cleaning Data Course Project

# Objectives:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation 
#    for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data 
#    set with the average of each variable for each activity and each 
#    subject.

# Get and unzip the data

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
path <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
files

# Read and begin to create the data set

xtrain = read.table(file.path(path, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(path, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
xtest = read.table(file.path(path, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(path, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(path, "test", "subject_test.txt"),header = FALSE)
features = read.table(file.path(path, "features.txt"),header = FALSE)
activityLabels = read.table(file.path(path, "activity_labels.txt"),header = FALSE)

# Organize data and use rbind() and cbind() to combine data

colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

bindtrain <- cbind(ytrain, subject_train, xtrain)
bindtest <- cbind(ytest, subject_test, xtest)
# Final step of data merge:
onedataset <- rbind(bindtrain, bindtest)

# Extract means and standard deviations by subsetting data

colNames = colnames(onedataset)
meanandstd = (grepl("activityId" , colNames) | grepl("subjectId" ,
                colNames) | grepl("mean.." , colNames) | grepl("std.." ,
                colNames))
setmeanandstd <- onedataset[ , meanandstd == TRUE]

# Complete the labeling of activities

setwithactivitynames <- merge(setmeanandstd, activityLabels, by='activityId', all.x=TRUE)

# Create new tidy data set of averages

secondtidydata <- aggregate(. ~subjectId + activityId, setwithactivitynames, mean)
secondtidydata <- secondtidydata[order(secondtidydata$subjectId, secondtidydata$activityId),]

# Write to text file

write.table(secondtidydata, "secondtidydata.txt", row.name=FALSE)



