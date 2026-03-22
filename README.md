---
title: "Human Activity Recognition Using Smart Phones"
author: "Keith B"
date: "2026-03-22"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Introduction

The purpose of this assignment is to prepare a usable data set from data generated during a project to monitor human activity using sensors embedded in the users' cell phones. There were 30 participants in the project and they each performed six activities. The project captured data from two sensors in a Samsung Galaxy S II cell phone: the accelerometer and the gyroscope. The sensors captured data separately in the X, Y, and Z directions at a rate of 50 measurements per second.

The data provided consisted both of raw data and processed data. It was further separated into "test" and "training" data, with 70 percent (21 subjects) selected for the training set, and 30 percent (9 subjects) selected for the test set.

## The Raw Data

Although this assignment makes no direct use of the raw data, it is worth while to have a general idea of what it contains. The raw data is in the "**Inertial Signals**" directory under the test and train directories. Each directory contains nine files. There are three for the gyroscope readings (X, Y, and Z directions), three for the accelerometer, and a further three to separate the acceleration into body movements and gravity.

Each line in a file consists of 2.56 seconds of data gathered for one subject performing one activity. At a rate of 50 readings per second, this amounts to 128 per line. The lines overlap by 50 percent, so the last 64 readings in a line are the same as the first 64 in the next line, except of course for the first and last lines in a group.

The project did not collect an equal amount of data from each subject. By matching each subject to the data collected, we find that the data ranged from 281 to 409 lines per person. At 2.56 seconds per line with a 50 percent overlap, the subjects where tested for a minimum of six and a maximum of almost nine minutes.

## The Processed Data

Although the cell phone sensors took only nine different measurements (counting separation of body movement from gravity in the accelerometer), the researchers were able to derive 561 different "features" from the data. These included the maximum, minimum, mean, standard deviation, and more sophisticated variables involving angular velocity, jerk, Fourier transforms, and other functions.

Each line in the processed data file contains these 561 variables derived from the corresponding line of raw data in each of the nine raw data files in the "**Inertial Signals**" directory. Thus, there is a one-to-one relation between the raw data and the processed data.

The processed data includes two separate files relating the subjects and activities which apply to each line of the features file. The *subject_test.txt* and *subject_train.tx*t files relate individual subjects to each of the lines data. The *y_test.txt* and *y_train.txt* similarly relate the activities to the corresponding lines of data.

Another file, *features.txt*, in the base directory for the project, contains a list of the 561 features.

Thus the features.txt file contains the labels for the columns of the processed data sets, while the "y" and "subject" files identify each row of the data.

## Creating the Assignment Data Set

The assignment calls for creating a single data file from the eight files in the project directories using a subset of the columns in the original set of features. Then a second and final data file will summarize the data by producing a mean for each selected feature for each subject and activity. The files are:

1.  *features.txt*: the names of all 561 features. For some reason the names all end in a pair of parentheses.

2.  *activity_labels.txt*: the names of the six activities and the numeric codes that represent them in the "y" files.

3.  *x_train.txt* and *x_test.txt*: the files containing the features derived from the raw data files, with 561 features per line.

4.  *y_train.txt* and *y_test.txt*: the code numbers for the activities, with each line corresponding to a line in the "x" files.

5.  *subject_train.txt* and *subject_test.txt*: the numbers representing each of the 30 subjects, with each line corresponding to a line in the "x" files. The numbers are the only identifying information for the subjects.

The selected columns are those that contain mean and standard deviation features. The only information that identifies these features is the feature name. Any feature ending in either "std()" or "mean()" will be included in the selection. There are 33 of each type in the features list.

In order to merge the files and select the features required, it is necessary to add one column to the *x_test.txt* and *x_train.txt* files for the subjects, and another column for the activities. The default column heads must then be replaced by the names from the features list, and the code numbers for the activities must be replaced by the activity names from the activity labels file.

The final data set contains one row for each combination of subject and activity, and 68 columns for the 66 selected features plus the subject and activity columns. Thus, it will have 30 × 6 × 68 entries, or 12240 individual entries.

## Running the Script

The script *run_analysis.R* contains the commands needed to create the final data file. The script assumes that when it starts, the current directory is the base directory of the project files. The *test* and *train* directories will be subdirectories of the base directory. Users must set the current directory to this directory before running the script.

The comments in the script should be sufficient to describe the steps needed to create the final data file. When comparing the actions in the script to the five steps in the assignment statement, note that the script performs the step 1 and at the same time creates the final "tidy" data set at the end of the process. Since the "y" and "subject" files refer only to the "x" files in their respective "test" and "train" directories, it was desirable to merge these files and apply the column names and labels before merging "test" and "train" together.

The final step of the script is to save the final data file in the current directory under the name *HAR_Summary.txt.*
