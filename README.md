# Tidy_data

This project uses the "Human Activity Recognition Using Smartphones Dataset" Version 1.0.  The experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, they captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded to label the data manually. The obtained dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

This code combines the test and training data and groups it by subject and activity.  It then takes the mean of each of the groups to give the average result across all variables for each subject and activity.

### Prerequisites
Load required libraries.

```library(tidyr)```
```library(dplyr)```


### Load data sets

```features<-read.delim("./UCI HAR Dataset/features.txt", header = FALSE)``` 
This loads the variable names

Load the test data including features as the column names

```x_test<-read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features[ ,1])```
```y_test<-read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activity")```
```subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")```

Load the training data including features as the column names

```x_train<-read.table("./UCI HAR Dataset/train/x_train.txt", col.names = features[ ,1])```
```y_train<-read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activity")```
```subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")```


### Combine data

Combine test data
```dat_test<-bind_cols(subject_test, y_test, x_test)```

Remove test files no longer needed
```rm(features, x_test, y_test, subject_test)```

Combine training data
```dat_train<-bind_cols(subject_train, y_train, x_train)```

Remove training files no longer needed
```rm(x_train, y_train, subject_train)```

Join test and training data
```dat<-bind_rows(dat_test, dat_train)```

Remove test and training sets
```rm(dat_test, dat_train)```

### Select columns with means and standard deviations

```dat_mean_std<-select(dat, "subject", "activity", contains("mean"), contains("std"))```

```rm(dat)```

Rename activities to align with name of activity
```dat_1<-filter(dat_mean_std, activity == "1") %>%```
    ```mutate(activity, activity = "Walking")```
```dat_2<-filter(dat_mean_std, activity == "2") %>%```
    ```mutate(activity, activity = "Walking.Upstairs")```
```dat_3<-filter(dat_mean_std, activity == "3") %>%```
    ```mutate(activity, activity = "Walking.Downstairs")```
```dat_4<-filter(dat_mean_std, activity == "4") %>%```
    ```mutate(activity, activity = "Sitting")```
```dat_5<-filter(dat_mean_std, activity == "5") %>%```
    ```mutate(activity, activity = "Standing")```
```dat_6<-filter(dat_mean_std, activity == "6") %>%```
    ```mutate(activity, activity = "Laying")```

### Recombine the data

```almost_tidy_dat<-bind_rows(dat_1, dat_2, dat_3, dat_4, dat_5, dat_6)```
```rm(dat_mean_std, dat_1, dat_2, dat_3, dat_4, dat_5, dat_6)```

### Rename variables

```names<-names(almost_tidy_dat)```
```names1<-sub("^X[0-9]\\.", "", names)```
```names2<-sub("^X[0-9][0-9]\\.", "", names1)```
```names3<-sub("^X[0-9][0-9][0-9]\\.", "", names2)```
```names4<-sub("^t", "Time", names3)```
```names5<-sub("^f", "Frequency", names4)```
```colnames(almost_tidy_dat)<-names5```
```rm(names, names1, names2, names3, names4, names5)```

#### Group date by activity and subject and find the average

```tidy_dat<-group_by(almost_tidy_dat, subject, activity) %>%```
    ```summarise_all(mean)```
    
```rm(almost_tidy_dat)```
