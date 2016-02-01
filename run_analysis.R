#setwd("./UCI HAR Dataset")
#reading test data
subtest<-read.table("./test/subject_test.txt",col.names="subject")  #dim = 2947    1
xtest<-read.table("./test/X_test.txt")  #dim = 2947  561
ytest<-read.table("./test/y_test.txt",col.names="activity") #dim = 2947    1


#reading train data
subtrain<-read.table("./train/subject_train.txt",col.names="subject")#dim = 7352    1
xtrain<-read.table("./train/X_train.txt")#dim = 7352  561
ytrain<-read.table("./train/y_train.txt",col.names="activity")#dim = 7352    1

#1-Merging the training and the test sets to create one data set
dtest<-cbind(subtest,ytest,xtest)#dim = 2947  563
dtrain<-cbind(subtrain,ytrain,xtrain)#dim =  7352  563
mydata<-rbind(dtest,dtrain)#dim  = 10299   563

# 2-Extracts only the measurements for  mean and standard deviation.
#reading data to get different features
ftures <- read.table("features.txt",stringsAsFactors=FALSE) #dim = 561   2
names(mydata)[3:563]<-ftures$V2 #Get all column names of mydata
meanstd<-ftures$V2[grep("mean\\(\\)|std\\(\\)", ftures$V2)] #length = 66

# 3-reading different activity labels and rename
actlabels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
mydata$activity <- actlabels[mydata$activity, 2]

#4-Appropriately labels the data set with descriptive variable names
vnames<-names(mydata)
vnames <- tolower(gsub("[^[:alpha:]&^[:digit:]]", ".", vnames)) #special character replaced by .
vnames <- gsub("[\\.]{2,}", ".", vnames)#removing multiple .
vnames <- gsub("[\\.]$", "", vnames)#removing end .
names(mydata)<-vnames #renaming variable names

#5-Creating tidy datasets
mytidydata<- aggregate(mydata[, 3:ncol(mydata)],by=list(subject = mydata$subject,activity = mydata$activity),mean)
#mytidydata is 180 by 563
write.table(format(mytidydata, scientific=T), "mytidydata.txt",quote=F,row.names=F)



