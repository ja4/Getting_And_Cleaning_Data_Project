##step1
test_file <- cbind(read.csv("test/X_test.txt",colClasses="character",sep="",header=FALSE),read.csv("test/y_test.txt",colClasses="character",sep="",header=FALSE))
test_file <- cbind(test_file,read.csv("test/subject_test.txt",colClasses="character",sep="",header=FALSE))

train_file <- cbind(read.csv("train/X_train.txt",colClasses="character",sep="",header=FALSE),read.csv("train/y_train.txt",colClasses="character",sep="",header=FALSE))
train_file <- cbind(train_file,read.csv("train/subject_train.txt",colClasses="character",sep="",header=FALSE))
result_data <- rbind(test_file,train_file)

##step2
feature_file <- read.csv("features.txt",colClasses="character",sep="",header=FALSE)

extracted_feature = as.numeric(grep(pattern = "mean|std",x = feature_file[,2]))
result_data2 <- result_data[,as.numeric(extracted_feature)]   
result_data_col = ncol(result_data)
   ##subject & activity added
result_data <- cbind(result_data2,result_data[,result_data_col-1],result_data[,result_data_col])


##step3
activity_label = read.csv("activity_labels.txt",colClasses="character",sep="",header=FALSE)
data = gsub(activity_label[1,1],activity_label[1,2],result_data[,80])
data = gsub(activity_label[2,1],activity_label[2,2],data)
data = gsub(activity_label[3,1],activity_label[3,2],data)
data = gsub(activity_label[4,1],activity_label[4,2],data)
data = gsub(activity_label[5,1],activity_label[5,2],data)
data = gsub(activity_label[6,1],activity_label[6,2],data)
result_data[,80] = data

##step4
header_name = c(feature_file[extracted_feature,2],"activity","subject")
names(result_data) <- header_name

##step5
result_data[,1:79] = sapply(result_data[,1:79],as.numeric)
##tapply(result_data[,1],result_data[,c(80,81)],mean)
final_result = aggregate(result_data[,1:79],by=list(result_data[,81],result_data[,80]),mean,na.rm=TRUE)
names(final_result)[1] = 'subject'
names(final_result)[2] = 'activity'
write.table(final_result, './final_result.txt',sep='\t',row.name=FALSE);