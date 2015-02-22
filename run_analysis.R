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

    dataTest <- extractData (dir, "test", "X_test.txt", featureSubset, featureHeaders, activityLabels)
    
    columnHeadings <- append (as.character(featureHeaders), c("Activity"))
    
    names(dataTest) <- columnHeadings
    write.table(dataTest, file = "./tidy_data.txt")
}

extractData <- function (dir, subdir, filename, featureSubset, featureHeaders, activityLabels) {
    
    testX <- read.table(paste(dir, subdir, filename, sep="/"))
    testXExtracted <- testX[, featureSubset]
    activityFileName <- paste("y_", subdir, ".txt", sep="")
    activites <- read.table(paste(dir, subdir, activityFileName, sep="/"))
    activityDesc <- join(activites, activityLabels)[,2]
    data <- cbind(testXExtracted, activityDesc)
    
    return(data)
}
