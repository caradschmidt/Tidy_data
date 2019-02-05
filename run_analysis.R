#Load required libraries.
library(tidyr)
library(dplyr)

#Load data sets
features<-read.delim("./UCI HAR Dataset/features.txt", header = FALSE)

x_test<-read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features[ ,1])
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activity")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

x_train<-read.table("./UCI HAR Dataset/train/x_train.txt", col.names = features[ ,1])
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activity")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

#Combine data
dat_test<-bind_cols(subject_test, y_test, x_test)
rm(features, x_test, y_test, subject_test)
dat_train<-bind_cols(subject_train, y_train, x_train)
rm(x_train, y_train, subject_train)
dat<-bind_rows(dat_test, dat_train)
rm(dat_test, dat_train)

#Select columns with means and standard deviations
dat_mean_std<-select(dat, "subject", "activity", contains("mean"), contains("std"))
rm(dat)

dat_1<-filter(dat_mean_std, activity == "1") %>%
    mutate(activity, activity = "Walking")
dat_2<-filter(dat_mean_std, activity == "2") %>%
    mutate(activity, activity = "Walking.Upstairs")
dat_3<-filter(dat_mean_std, activity == "3") %>%
    mutate(activity, activity = "Walking.Downstairs")
dat_4<-filter(dat_mean_std, activity == "4") %>%
    mutate(activity, activity = "Sitting")
dat_5<-filter(dat_mean_std, activity == "5") %>%
    mutate(activity, activity = "Standing")
dat_6<-filter(dat_mean_std, activity == "6") %>%
    mutate(activity, activity = "Laying")

#recombine
almost_tidy_dat<-bind_rows(dat_1, dat_2, dat_3, dat_4, dat_5, dat_6)
rm(dat_mean_std, dat_1, dat_2, dat_3, dat_4, dat_5, dat_6)

#Rename variables
names<-names(almost_tidy_dat)
names1<-sub("^X[0-9]\\.", "", names)
names2<-sub("^X[0-9][0-9]\\.", "", names1)
names3<-sub("^t", "Time", names2)
names4<-sub("^f", "Frequency", names3)
colnames(almost_tidy_dat)<-names4
rm(names, names1, names2, names3, names4)

#Group date by activity and subject and find the average
tidy_dat<-group_by(almost_tidy_dat, subject, activity) %>%
    summarise_all(mean)
rm(almost_tidy_dat)