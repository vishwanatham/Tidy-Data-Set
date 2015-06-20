run_analysis <- function(){
#Load standing data
features <- read.table("UCI HAR Dataset/features.txt", col.names=c("featureId", "featureLabel"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activityId", "activityLabel"))
activities$activityLabel <- gsub("_", " ", as.character(activities$activityLabel))


#Load Test data
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt")
X_test = read.table("UCI HAR Dataset/test/X_test.txt")
Y_test = read.table("UCI HAR Dataset/test/Y_test.txt")


#Load train data
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt")
X_train = read.table("UCI HAR Dataset/train/X_train.txt")
Y_train = read.table("UCI HAR Dataset/train/Y_train.txt")

#Merge the training and the test sets to create one data set.
subject <- rbind(subject_test, subject_train)
X <- rbind(X_test, X_train)
Y <- rbind(Y_test, Y_train)


#Label the data set with appropraiet and descriptive variable names. 
names(subject) <- "subjectId"
names(X) <- gsub("\\(|\\)", "", features$featureLabel)
names(Y) = "activityId"

activity <- merge(Y, activities, by="activityId")$activityLabel


#Extract only the measurements on the mean and standard deviation for each measurement.
includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureLabel)
X <- X[, includedFeatures]


# merge data frames of different columns to form one data table
data <- cbind(subject, activity, X)


#creates a second, independent tidy data set with the average of each variable
#for each activity and each subject.
library(data.table)
dataDT <- data.table(data)
calculatedData <- dataDT[, lapply(.SD,mean), by=c("subjectId", "activity")]

write.table(calculatedData, "calculated_tidy_data.txt")

}