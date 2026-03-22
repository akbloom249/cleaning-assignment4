library(tidyverse)

datasets <- c("test", "train")

# get a vector of all the features (individual measurements in each row)
colheads <- read_table("features.txt", 
                       col_names=c("Code", "Measurement"), 
                       col_types="ic")$Measurement
n_features <- length(colheads)

#loop over the individual directories
for (dataset in datasets) {

# read a data frame with the feature measurements
file_name <- file.path(dataset, paste0(c("x_", dataset, ".txt"), collapse=""))
# R will automatically fix duplicate column names, but we don't care about
# the ones it is fixing, so suppress the warning message
suppressWarnings(
    measurements <- read_table(file_name, 
          col_names=colheads, 
	        col_types=paste(rep("n", n_features), collapse=""))
)

# find the positions of the features we want to keep and select those columns
selected_colheads <- grep("mean\\()|std\\()", colheads)
measurements <- measurements[selected_colheads]

# get a data frame with the activities associated with each row
file_name <- file.path(dataset, paste0(c("y_", dataset, ".txt"), collapse=""))
activities <- read_table(file_name, 
    col_names=c("Activity"), 
	  col_types=cols(col_character()))

# convert the code number for each activity to its name
activities <- activities |> mutate(Activity = recode_values(Activity, 
    "1" ~ "WALKING", 
    "2" ~ "WALKING_UPSTAIRS", 
    "3" ~ "WALKING_DOWNSTAIRS", 
    "4" ~ "SITTING", 
    "5" ~ "STANDING", 
    "6" ~ "LAYING"), .keep = "none") 

# get a data frame with the subjects associated with each row
file_name = file.path(dataset, paste0(c("subject_", dataset, ".txt"), collapse=""))
subjects <- read_table(file_name, col_names=c("Subject"), col_types=cols(col_integer()))

# combine the three data frames into one, and rename it using the current data set
df <- cbind(subjects, activities, measurements)
new_name <- paste0("df_", dataset)
assign(new_name, df)

print(paste0(new_name, ": expected 68 columns, found ", str_c(ncol(df_test))))
}

# now merge the training and test data sets to create one data set
HAR_data <- rbind(df_test, df_train) |> arrange(Subject, Activity)

# From the data set from steps 1 - 4, create a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
HAR_summary <- HAR_data |> 
    group_by(Subject, Activity) |> 
    summarize(.groups = "drop_last", across(.cols=1:66, ~ mean(.x)))

print("There should be 180 rows (30 subjects times 6 activities) in the final data set")
print(paste0("There are ", str_c(ncol(HAR_summary)), " columns and ", str_c(nrow(HAR_summary)),
               " rows in the HAR_summary data frame"))

write.table(HAR_summary, file = "HAR_Summary.txt", row.names = FALSE)
