# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#four things you should have
#The raw data
#A tidy data set
# A Code book describing each variable and its values in the tidy data set
# An explicit and exact recipe you used to go from 1 -> 2,3

#Each variable you measure should be in one column
#Each different observation of that variable should be in a different row
#There should be one table for each "kind" of variable
#If you have multiple tables, they should include a column in the table that allows them to be linked

#The code book
#Information about the variables (including units!) in the data set not contained in the tidy data
#Information about the summary choices you made
#Information about the experimental study design you used

# The instruction list
# Ideally a computer script (in R :-), but I suppose Python is ok too...)
# The input for the script is the raw data
# The output is the processed, tidy data
# There are no parameters to the script


if(!file.exists("./data")){dir.create("./data")}

fileurl <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Gather all the relevant files we'll need
train_data_subject <- read.table(unz("./data/dataset.zip", "UCI HAR Dataset/train/subject_train.txt"))
train_data_x       <- read.table(unz("./data/dataset.zip", "UCI HAR Dataset/train/X_train.txt"))
train_data_y       <- read.table(unz("./data/dataset.zip", "UCI HAR Dataset/train/y_train.txt"))

test_data_subject    <-read.table(unz("./data/dataset.zip", "UCI HAR Dataset/test/subject_test.txt"))
test_data_x          <-read.table(unz("./data/dataset.zip", "UCI HAR Dataset/test/X_test.txt"))	  
test_data_y          <-read.table(unz("./data/dataset.zip", "UCI HAR Dataset/test/y_test.txt"))

#and the labels
activity_labels      <-read.table(unz("./data/dataset.zip", "UCI HAR Dataset/activity_labels.txt"))
test_row_names   <- apply(test_data_y, 2 ,   function(x) activity_labels$V2[x] )
train_row_names  <- apply(test_data_y, 2 ,   function(x) activity_labels$V2[x] )

#Do some manipulation of the labels to make the data tidy
for(i in 1:nrow(test_row_names)) {
    test_row_names[[i,1]] <- paste("Subject #", test_data_subject[[i,1]], test_row_names[[i,1]] , i ,collapse="")
}


train_row_names  <- apply(train_data_y, 2 ,   function(x) activity_labels$V2[x] )

for(i in 1:nrow(train_row_names)) {
    train_row_names[[i,1]] <- paste("Subject #", train_data_subject[[i,1]], train_row_names[[i,1]] , i ,collapse="")
}

#assign the rownames (measurement number and test subject number)
rownames(test_data_x)  <- test_row_names
rownames(train_data_x) <- train_row_names


#combined measurements of the train_data and the test_data
combined_measurements <- rbind(train_data_x,test_data_x);


#Extracting the mean and the sd for each measurement
features       <- read.table (unz("./data/dataset.zip", "UCI HAR Dataset/features.txt"))

#Using grep to get only the mean and std columns that we want (as per the assignment)
features_mean_std   <- grepl( "mean()|std()" ,  features$V2, perl=TRUE)



mean_std_combined_measurements <- combined_measurements[features_mean_std]

#apply names to the features(measurements) collected during each measurement (the column)
colnames(mean_std_combined_measurements) <- features$V2[features_mean_std]


#write a table out of this data (this data is step4)
write.table(mean_std_combined_measurements, "test.csv")



#now creating a second, independant tidy data set
#with the average of each variable for each activity and subject

mean_table <- apply( mean_std_combined_measurements,1,mean )
write.table(mean_table, "mean_table.txt" , row.name=FALSE)

