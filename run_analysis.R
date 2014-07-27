library(data.table)
nrows_to_read <- function(){ -1 }

dir_prefix <- function(){'./'}

current_resource <- function(resource){
  x<-paste(dir_prefix(), resource, sep="")
  x
}

activity.labels <- function( total_activities, activity_labels ){
  if( nrows_to_read() == -1 ){
    factor( total_activities$V1, labels=activity_labels$V2)
  }
  else{
    present_levels <- as.numeric(levels(factor(total_activities$V1)))
    rel_activities <- activity_labels[ present_levels,]
    total.activities.factor <- factor( total_activities$V1, labels= rel_activities$V2 )
    total.activities.factor
  }
}

generate_tidy_data <- function(){
  test_activities <- read.table(current_resource('test/y_test.txt'), nrows = nrows_to_read())
  train_activities <- read.table(current_resource('train/y_train.txt'), nrows = nrows_to_read())
  total_activities <- rbind( train_activities, test_activities )
  activity_labels <- activity.labels(total_activities, activity_labels)
  subject_train <- read.table(current_resource('train/subject_train.txt'), nrows = nrows_to_read())
  subject_test <- read.table(current_resource('test/subject_test.txt'), nrows = nrows_to_read() )
  subject <- rbind( subject_train, subject_test )
  training_set <- NULL
  test_set <- NULL
  features <- read.csv2('features.txt', sep="", header = FALSE, stringsAsFactors=FALSE )
  
  training_set <- read.csv2( 'train/X_train.txt', sep = "", header = FALSE, nrows = nrows_to_read(),
                             stringsAsFactors = FALSE)
  test_set <- read.csv2( 'test/X_test.txt', sep = "", header = FALSE, nrows = nrows_to_read(),
                         stringsAsFactors = FALSE )
  mean_std_dev_cols <- grep("mean[()]{2}|std[()]{2}", features$V2 )
  
  total <- rbind( training_set, test_set)
  total <- total[, mean_std_dev_cols]
  
  for( i in 1:ncol(total)){
    total[ , i ] <- as.numeric( total[, i])
  }
  
  mean_std_dev_features <- features$V2[mean_std_dev_cols]
  mean_std_dev_features <- gsub('-|[()]+[.]?', '.', mean_std_dev_features )
  mean_std_dev_features <- gsub( '[.]+', '.', mean_std_dev_features)
  mean_std_dev_features <- sub( '[.]{1}$', '', mean_std_dev_features)
  colnames( total ) <- mean_std_dev_features
  total$activities <- activity_labels
  total$subjects <- subject$V1
  
  total <- split( total, list(total$subjects, total$activities))
  end_result <- NULL
  for( i in names(total)){
    dt <- data.table( total[[i]])
    dt[, c('subjects', 'activities') := NULL]
    dt_col_means <- as.list( colMeans( dt ) )
    activity <- as.character(total[[i]]$activities[1])
    subject <- as.character(total[[i]]$subjects[1])
    info_list <- list( subject = subject, activity = activity )
    dt_col_means <- append( info_list, dt_col_means )
    end_result <- rbind( end_result, dt_col_means )
  }
  rownames(end_result) <- NULL
  write.table( end_result, file="tidy_data.txt")
}

generate_tidy_data()









