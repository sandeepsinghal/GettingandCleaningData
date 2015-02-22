makeTidySet <- function(dir) {
    
    library("sqldf")
    
    #Corresponds to a column in file test/X_test.txt or train/X_test.txt
    features <- read.table(paste(dir, "features.txt", sep="/"))
    
    # Activity labels indicating the activity type 
    activityLabels <- read.table(paste(dir, "activity_labels.txt", sep="/"))
    
    # test/y_test.txt indicates the activity for each row in test/X_test.txt
    
    # Get all column numbers from features that match "mean" or "std"
    featureSubsetTable <- sqldf("select * from features where V2 LIKE '%mean%' or V2 LIKE '%std%'")
    featureSubset <- featureSubsetTable[,1]
    featureHeaders <- featureSubsetTable[,2]

    testX <- read.table(paste(dir, "test", "X_test.txt", sep="/"))
    testXExtracted <- testX[, featureSubset]
    activites <- read.table(paste(dir, "test", "y_test.txt", sep="/"))
    activityDesc <- join(activites, activityLabels)[,2]
    
    data <- cbind(testXExtracted, activityDesc)
    columnHeadings <- append (as.character(featureHeaders), c("Activity"))
    
    names(data) <- columnHeadings
    write.table(data, file = "./tidy_data.txt")
}

