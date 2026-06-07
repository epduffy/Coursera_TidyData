# For Coursera class: Getting and cleaning data, peer-reviewed assignment

# Load required package(s)
pacman::p_load(tidyverse)

# Set working directory
setwd("GettingCleaningData")

# Download & unzip data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("UCI_HAR_dataset.zip")) {
  download.file(url, destfile = "UCI_HAR_dataset.zip", mode = "wb")
  }

if (!dir.exists("UCI HAR Dataset")) {
  unzip("UCI_HAR_dataset.zip")
  }


# Import data into R
## Metadata
features <- read.table("UCI HAR Dataset/features.txt") 
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

## Training Data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Assign descriptive column names
colnames(activities) <- c("activity", "activity_label")

colnames(x_train) <- features$V2
colnames(x_test) <- features$V2 

colnames(y_train) <- "activity"
colnames(y_test) <- "activity"

colnames(subject_train) <- "subject"
colnames(subject_test) <- "subject"

# Merge subject IDs, data, and labels for training then test dataframes
training.df <- cbind(subject_train, y_train, x_train)
test.df <- cbind(subject_test, y_test, x_test)

# Combine training and test dataframes (Part 1 of assignment)
all.df <- rbind(training.df, test.df)

# Extract mean and sd columns (Part 2 of assignment)
sd.mean <- grepl("subject|activity|mean|std", colnames(all.df))
all.df2 <- all.df[, sd.mean]

# Add more descriptive activity labels (part 3 of assignment)
all.df2$activity <- factor(all.df2$activity,
                           levels = activities$activity, # level = activity number code
                           labels = activities$activity_label) # label = activity label

# Clean up column names (part 4 of assignment)
colnames(all.df2) <- gsub("\\(\\)", "", colnames(all.df2))
colnames(all.df2) <- gsub("-", "", colnames(all.df2))


# Create new tidy dataset, average of each variable for each activity and each subject
tidy.data <- all.df2 %>%
  group_by(subject, activity) %>%
  summarise(across(everything(), mean))


# Export cleaned dataset
write.csv(tidy.data, "tidydata.csv", row.names = FALSE)

