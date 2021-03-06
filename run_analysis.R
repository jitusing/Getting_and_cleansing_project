

library(plyr)
library(data.table)
library(tidyr)

library(reshape2)

filename <- "getdata_dataset.zip"

#upload the train data
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")


#upload the test data
x_test<-read.table("test/X_test.txt")
y_test<-read.table("test/y_test.txt")
subject_test<-read.table("test/subject_test.txt")


# mearging the test and traning data
x_data<-rbind(x_train,x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)


features <- read.table("features.txt")


##Extracts only the measurements on the mean and standard deviation for each measurement.


mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])


x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]

#naming the activities in the data set

activities <- read.table("activity_labels.txt")

##labeling the data set with descriptive variable names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

#tidy data set with the average 
#of each variable for each activity and each subject.
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)





