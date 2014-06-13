CODEBOOK - run_analysis.R
========================================================

This codebook contains information on the contents of tidy_data and tidy_data_avg,
which are returned by the run_analysis() function.

**tidy_data**

tidy_data is a tidy data frame in which the 'test'  and 'train' observations from the
UCI HAR Dataset are merged into one frame. Detailed descriptions of the variables is available
in the features_info.txt file that comes with the UCI HAR Dataset.

Each observation contains information on:

- the studied subject (1 - 30),
- the studied activity (Laying, Sitting, Standing, Walking, Walking downstairs, Walking upstairs),
- the subset of means, mean frequencies and standard deviations of all measurements contained in the UCI HAR Dataset:  
tBodyAcc-XYZ  
tGravityAcc-XYZ  
tBodyAccJerk-XYZ  
tBodyGyro-XYZ  
tBodyGyroJerk-XYZ  
tBodyAccMag  
tGravityAccMag  
tBodyAccJerkMag  
tBodyGyroMag  
tBodyGyroJerkMag  
fBodyAcc-XYZ  
fBodyAccJerk-XYZ  
fBodyGyro-XYZ  
fBodyAccMag  
fBodyAccJerkMag  
fBodyGyroMag  
fBodyGyroJerkMag  
  

**tidy_data_avg**

tidy_data_avg is a data frame, based on tidy data, in which for all variables only averages 
are provided for each subject and activity. This results in 180 observations (30 subjects times
6 activities) with the averages of the measurements of the variables as described above.


