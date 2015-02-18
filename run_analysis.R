makeTidySet <- function(dir) {
    
    library("sqldf")
    
    #Corresponds to a column in file test/X_test.txt or train/X_test.txt
    features <- read.table(paste(dir, "features.txt", sep="/"))
    
    # Activity labels indicating the activity type 
    activityLabels <- read.table(paste(dir, "activity_labels.txt", sep="/"))
    
    # test/y_test.txt indicates the activity for each row in test/X_test.txt
    
    # Get all column numbers from features that match "mean" or "std"
    featureSubset <- sqldf("select * from features where V2 LIKE '%mean%' or V2 LIKE '%std%'")[,1]

    testX <- read.table(paste(dir, "test", "X_test.txt", sep="/"))
    testXExtracted <- testX[, featureSubset]
    
    print(featureSubset)
}

