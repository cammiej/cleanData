# You should create one R script called run_analysis.R that does the following. 
#get column names
cNames <- read.table("/Users/cammiepartelow/Downloads/UCI HAR Dataset/features.txt")
actNames <- read.table("/Users/cammiepartelow/Downloads/UCI HAR Dataset/activity_labels.txt")

# Merges the training and the test sets to create one data set.
testSet <- cbind(read.table("/Users/cammiepartelow/Downloads/UCI HAR Dataset/test/y_test.txt", col.names ="activity"), read.table("/Users/cammiepartelow/Downloads/UCI HAR Dataset/test/subject_test.txt", col.names ="subject"), read.table("/Users/cammiepartelow/Downloads/UCI HAR Dataset/test/X_test.txt", colClasses = "numeric", col.names = cNames[,2]))
trainSet <- cbind(read.table("/Users/cammiepartelow/Downloads/UCI HAR Dataset/train/y_train.txt", col.names ="activity"), read.table("/Users/cammiepartelow/Downloads/UCI HAR Dataset/train/subject_train.txt", col.names ="subject"), read.table("/Users/cammiepartelow/Downloads/UCI HAR Dataset/train/X_train.txt", colClasses = "numeric", col.names = cNames[,2]))
fullSet <- rbind(testSet, trainSet)

# Extracts only the measurements on the mean and standard deviation for each measurement. if have time, revisit this section - use dplyr and make neater
library(dplyr)
meanCol <- cbind(select(fullSet, contains("activity")), select(fullSet, contains("subject")), select(fullSet, contains("std")), select(fullSet, contains("mean")))

# Uses descriptive activity names to name the activities in the data set
actMean <- merge(actNames, meanCol, by.x="V1", by.y="activity")

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. Why won't V1 rename?
tidyData <- actMean %>% group_by(V2,subject) %>% summarise_each(funs(mean)) %>% rename(tidyData, activity=V2, act_id = V1)
write.table(tidyData,"/Users/cammiepartelow/Downloads/UCI HAR Dataset/tidySet.txt", row.name=FALSE)