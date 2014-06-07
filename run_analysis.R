run_analysis<-function(){
  
  ## FIRST PART --> CREATE TIDY DATA SET
  
  ## rename folder with data to a usable format (without spaces)
  file.rename("UCI HAR Dataset","UCI_HAR_Dataset")
  
  ## define column names of measurements
  colnames<-read.table("UCI_HAR_Dataset/features.txt") ## dim: 561 rows, 2 columns
  
  ## read data from txt files
  test<-read.table("UCI_HAR_Dataset/test/X_test.txt",col.names=colnames[,2]) ## dim: 2947 rows, 561 columns
  train<-read.table("UCI_HAR_Dataset/train/X_train.txt",col.names=colnames[,2]) ## dim: 7352 rows, 561 columns
  
  ## extract mean and stdev for each measurement
  ## find out which columns contain these values and subset these columns from test and train sets
  meas_req<-grepl("mean|std",colnames$V2)
  test_meanstd<-test[,meas_req]
  train_meanstd<-train[,meas_req]
  
  ## read activity types and subjects from files
  act_test<-read.table("UCI_HAR_Dataset/test/y_test.txt")
  subject_test<-read.table("UCI_HAR_Dataset/test/subject_test.txt")
  act_train<-read.table("UCI_HAR_Dataset/train/y_train.txt")
  subject_train<-read.table("UCI_HAR_Dataset/train/subject_train.txt")
  
  ## cbind activity label columns to test and training sets (give variable proper names)
  ## and also cbind subjects column for complete overview
  test_subject_act_meanstd<-cbind(subject_test,act_test,test_meanstd)
  names(test_subject_act_meanstd)[1:2]<-c("subject","activity")
  train_subject_act_meanstd<-cbind(subject_train,act_train,train_meanstd)
  names(train_subject_act_meanstd)[1:2]<-c("subject","activity")
  
  ## change activity numbers to activity descriptions
  ## load descriptions
  act_descr<-read.table("UCI_HAR_Dataset/activity_labels.txt")
  ## convert activity columns into factors
  test_subject_act_meanstd$activity<-as.factor(test_subject_act_meanstd$activity)
  train_subject_act_meanstd$activity<-as.factor(train_subject_act_meanstd$activity)
  ## change levels into activity descriptions instead of numbers
  levels(test_subject_act_meanstd$activity)<-act_descr$V2
  levels(train_subject_act_meanstd$activity)<-act_descr$V2
  
  ## To be able to distinguish between test and train data later if needed:
  ## add extra column that labels data as 'test' or 'train'
  test_new<-cbind(rep("test",2947),test_subject_act_meanstd)
  names(test_new)[1]<-"original_set"
  test_new$original_set<-as.character(test_new$original_set)
  train_new<-cbind(rep("train",7352),train_subject_act_meanstd)
  names(train_new)[1]<-"original_set"
  train_new$original_set<-as.character(train_new$original_set)
  
  ## Merge sets together to create one dataset, and sort on subject and activity type
  new_set<-rbind(test_new,train_new)
  new_set$subject<-formatC(new_set$subject, width=3, flag="0")
  sort_new_set <- new_set[order(new_set$subject, new_set$activity), ]
  
  ## First dataset finished
  tidy_data<<-sort_new_set
  
  ## Write tidy_data to csv
  write.csv(tidy_data,"tidy_data.csv",row.names=F)
  write.table(tidy_data,"tidy_data.txt",row.names=F)
  
  
  
  
  ## SECOND PART
  
  ## Instructions: Creates a second, independent tidy data set with the average of each variable 
  ## for each activity and each subject. 
  ## My interpretation: the function is supposed to create a second dataset, based on the first one
  ## containing the means and stdev's of each measurement, and average each variable/column per
  ## subject and activity type. --> This results in 30 subjects * 6 activities = 180 rows of data.
  
  ## 1) Basis: tidy data set with all req. variables (=tidy_data)
  ## 2) Create extra column that will serve as index for tapply function
        ## pasting subjects and activities together
        ## convert to factor
        ## add column to tidy_data to serve as tapply index
  subject.activity<-paste(tidy_data$subject,tidy_data$activity,sep=".")
  subject.activity<-as.factor(subject.activity)
  tidy_data_index<-cbind(subject.activity,tidy_data)
  
  ## 3) tapply is used (per column/variable) to calculate averages per subject/activity
        ## create dataframe 'df' in which results of tapply loop will be stored
        ## run for loop to loop over all variables (columns 5:83) and use tapply to calculate averages
        ## store resulting vectors in dataframe 'df'
  df<-data.frame(index=levels(subject.activity))
  
  for (i in 5:83){
    average<-tapply(tidy_data_index[,i],tidy_data_index$subject.activity,mean)
    df<-cbind(df,average)
  }
  
  ## 4) for clarity/convenience, add separate 'subject' and 'activity' columns to df.
  subject<-rep(1:30,each=6)
  activity<-rep(order(levels(tidy_data$activity)),30)
  df_tidy<-cbind(subject=subject,activity=activity,df)
  names(df_tidy)[4:82]<-names(tidy_data)[4:82]
 
  tidy_data_avg<<-df_tidy
  
  ## 5) save to csv :-)
  write.csv(tidy_data_avg,"tidy_data_avg.csv",row.names=F)
  write.table(tidy_data_avg,"tidy_data_avg.txt",row.names=F)

}