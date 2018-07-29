
### Firstly we merge all training set together, then perform the same actions to merge all test set
### Finally, we merge both the cleaned training set and test set together.

run_analysis<- function(directory)
## 'directory' indicates the location of the files - place the master folder 'UCI HAR dataset within your working directory
## e.g. run_analysis("UCI HAR Dataset")

{

## define training/test labels ID to match to descriptive activity
activity_labels <- structure(list(V1 = 1:6, V2 = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LYING")), .Names = c("V1", "V2"), class = "data.frame", row.names = c("1", "2", "3", "4", "5", "6"))
        
##### ==== Clean up training set ==== ####
## read x train - training set
x_train<-read.table(paste0(getwd(),"/",directory,"/train/X_train.txt"),sep = "",header=FALSE)

## read y training data - test labels
y_train<-read.table(paste0(getwd(),"/",directory,"/train/y_train.txt"),sep = "",header=FALSE)

## read subject train
subjectTrain<-read.table(paste0(getwd(),"/",directory,"/train/subject_train.txt"),sep = "",header=FALSE)

## read feature names + transpose
features_train<-t(read.table(paste0(getwd(),"/",directory,"/","features.txt"),sep = "",header=FALSE))
names(features_train) <- features_train[1,]
#Get rid of the first row (i.e. ID number will be 1st row after transposing) so that it takes on the 2nd row with the feature names
features_train <- features_train[-1,]

##binding features + x train (i.e. add column headers)
train_features_bind<-rbind(features_train,x_train)
colnames(train_features_bind) <- as.character(unlist(train_features_bind[1,]))
train_features_bind = train_features_bind[-1, ]

##bind y train (training labels) & subject train with train_features_bind
traincleaneddata<-cbind(subjectTrain,y_train,train_features_bind)
colnames(traincleaneddata)[1]<-"Subject ID"
colnames(traincleaneddata)[2]<-"Activity Labels"

##### ==== Clean up test set ==== ####

## read x test - test set
x_test<-read.table(paste0(getwd(),"/",directory,"/test/X_test.txt"),sep = "",header=FALSE)

## read y test data - test labels
y_test<-read.table(paste0(getwd(),"/",directory,"/test/y_test.txt"),sep = "",header=FALSE)

## read subject test
subjectTest<-read.table(paste0(getwd(),"/",directory,"/test/subject_test.txt"),sep = "",header=FALSE)

## read feature names + transpose
features_test<-t(read.table(paste0(getwd(),"/",directory,"/","features.txt"),sep = "",header=FALSE))
names(features_test) <- features_test[1,]
#Get rid of the first row (i.e. ID number will be 1st row after transposing) so that it takes on the 2nd row with the feature names
features_test <- features_test[-1,]

##binding features + x test (i.e. add column headers)
test_features_bind<-rbind(features_test,x_test)
colnames(test_features_bind) <- as.character(unlist(test_features_bind[1,]))
test_features_bind = test_features_bind[-1, ]

##bind y test (training labels) & subject test with test_features_bind
testcleaneddata<-cbind(subjectTest,y_test,test_features_bind)
colnames(testcleaneddata)[1]<-"Subject ID"
colnames(testcleaneddata)[2]<-"Activity Labels"

## now to combine both traincleaneddata and testcleaneddata
finaldata<-rbind(testcleaneddata,traincleaneddata)

## extract only subject id, activity labels, mean and standard deviation
finaldata1 <- finaldata[ ,grepl("Subject ID|Activity Labels|mean()|std()" , names(finaldata)) ]
## now remove meanFreq since the first final data extracts everything that contains mean including meanFreq
finaldata2 <- finaldata1[ ,!grepl("meanFreq()" , names(finaldata1))]
## replace training labels with descriptive activity
finaldata2$`Activity Labels` <- activity_labels[,2][match(finaldata2$`Activity Labels`, activity_labels[,1])]

## transform character variables to numeric
finaldata2[3:ncol(finaldata2)] <- lapply(finaldata2[3:ncol(finaldata2)], as.numeric)
## split data by subject ID and activity levels
s<-split(finaldata2,list(finaldata2$`Subject ID`,finaldata2$`Activity Labels`))
## lapply to get means
getmeans<- lapply(s,function(x) colMeans(x[,c(3:68)]))
tidydata<-as.data.frame(do.call("rbind", getmeans))
write.csv(tidydata,paste0(getwd(),"/tidydata.csv"))
print(paste0("COMPLETED: Data cleansed and tidy data is saved in ",getwd(),"/as tidydata.csv!"))
}