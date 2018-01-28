# set the desired working directory
# download the given dataset in the working directory
# after downloading, unzip the downloaded zip file

library(dplyr)

# reading the train data from directory
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# reading the test data from directory
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# reading the description of the data
variable_names <- read.table("./UCI HAR Dataset/features.txt")

# reading the activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# 1. Merging the training and the test sets to create one data set.
x_total <- rbind(x_train, x_test)
y_total <- rbind(y_train, y_test)
sub_total <- rbind(sub_train, sub_test)

# 2. Extract only the measurements on the mean and standard deviation for each measurement.
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
x_total <- x_total[,selected_var[,1]]

# 3. Use descriptive activity names to name the activities in the data set
colnames(y_total) <- "activity"
y_total$activitylabel <- factor(y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y_total[,-1]

# 4. Appropriately label the data set with the descriptive variable names.
colnames(x_total) <- variable_names[selected_var[,1],2]

# 5. Using the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(sub_total) <- "subject"
total <- cbind(x_total, activitylabel, sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_all(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)