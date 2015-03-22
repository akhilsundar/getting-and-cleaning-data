#course project

#read the file given that it's in the directory

#activity
aTest = read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE);
aTrain = read.table(file.path(path, "train" , "Y_train.txt" ),header = FALSE);
#subject
sTest = read.table(file.path(path, "test" , "subject_test.txt" ),header = FALSE);
sTrain = read.table(file.path(path, "train" , "subject_train.txt" ),header = FALSE);
#features
fTest = read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE);
fTrain = read.table(file.path(path, "train" , "X_train.txt" ),header = FALSE);

#merging the sets
dataA = rbind(aTrain,aTest);
dataS = rbind(sTrain,sTest);
dataF = rbind(fTrain,fTest);
names(dataA) = c("activity");
names(dataS) = c("subject");
featureNames <- read.table(file.path(path, "features.txt"),head=FALSE);
names(dataF) = featureNames$V2;

saCombo = cbind(dataS,dataA);
dataFull = cbind(dataF,saCombo);

#extract mean,std dev
subNames = featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)];
thisNames = c(as.character(subNames),"subject","activity");
dataFull = subset(dataFull, select=thisNames);

#name the activities
dataFull$activity = as.character(dataFull$activity);
dataFull$activity[dataFull$activity==1] = "Walking";
dataFull$activity[dataFull$activity==2] = "Walking Upstairs";
dataFull$activity[dataFull$activity==3] = "Walking Downstairs";
dataFull$activity[dataFull$activity==4] = "Sitting";
dataFull$activity[dataFull$activity==5] = "Standing";
dataFull$activity[dataFull$activity==6] = "Laying";
dataFull$activity = as.factor(dataFull$activity);

#label with decriptive variable names
names(dataFull)=gsub("Acc", "Accelerator", names(dataFull))
names(dataFull)=gsub("Mag", "Magnitude", names(dataFull))
names(dataFull)=gsub("^f", "Frequency", names(dataFull))
names(dataFull)=gsub("^t", "Time", names(dataFull))
names(dataFull)=gsub("Gyro", "Gyroscope", names(dataFull))

#create the tidy data set
data = aggregate(. ~subject+activity,dataFull,mean)
data = data[order(data$subject,data$activity),]
write.table(data, file = "TidyData.txt", row.name = FALSE);

#codebook
write(names(data),file = "Variables.txt", ncolumns = 1);

