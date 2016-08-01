Description
===========

This repo contains the code and data submission for the final project of Getting and Cleaning data course on Coursera. 

To quote the assignment:

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


The raw data for the assignment was provided as a download from the following web link:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


The objective of the assignment was as follows:
You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


PROCESS OVERVIEW
================

	- All the work on the project was done on a Macbook Pro intel Core i5, 8GB RAM running OSX 10.11.6. 

	- The scripts were written in and tested in RStudio  Version 0.99.902. 

	- The R version details are as follows:
		R version 3.3.0 (2016-05-03) -- "Supposedly Educational"
		Copyright (C) 2016 The R Foundation for Statistical Computing
		Platform: x86_64-apple-darwin13.4.0 (64-bit)
	

DATA SOURCING
=============

	- The data was downloaded using the above link on July 19th, 2016 at 9:29 AM as a zip file named:
		+ UCI HAR Dataset.zip
	
	- The file was placed in a newly created directory that will be hencforth called the working directory(WD henceforth) for the assignment.
	
	- The zip file was exploded in the WD to create a folder called "UCI HAR Dataset". This folder contains the Raw data and its description. The zip file used is available in the repo as part of the process of providing a tidy data set and for purposes of reproducibility


RAW DATA ANALYSIS
=================

	The data obtained needs several steps to be done to make it tidy and ready for further analysis. Some of the problems include:
	- Lack of co-relation between the data files provided
	
	- Lack of headers
	
	- Variable names stored as rows in separate files
	
	- Observations split over mutiple files

UNDERSTANDING OF RAW DATA AND DESCRIPTION OF PROCESSING PERFORMED
=================================================================

	The raw data was available in several files. The locations used in this setting are all relative paths from the base directory into which the zip file with data was initially expanded. 

	The basic understanding of the files were as follows:

	- The activity_labels.txt is actually a data file with data related to identifying actity labels and their descriptions
 
	- The training and test data sets have the same file sets with the words _train and _test added to the file names to distinguish the set. NOTE: It may be easier to tidy the test and training data sets individually and then combine them to produce a final tidy data sets. The steps to tidy the data should not change between the test and training data sets.

	- The process of tidying should include appropriately naming the variables in each column and ensuring that the rows are also tagged with the activity they represent and the test subject who generated the readings. In addition, there is an implicit understanding that the rows are related by the sequence they appear in in each file. This needs to be rectified by inserting an explicit "Observation number" column in each file.  

	- The data set files all contain 2947 / 7352 rows (calling them observations may be a stretch with the lack of tidyness). This is true for every file in test and train folders and their subfolders.

	- The raw inertial signals data sets body_acc_?, body_gyro_? and total_acc_? all contain the 128 columns per row / observation
		+ for completion, these data files can also be tagged with the activity they represent and the test subject who generated the readings and the observation number. This is however beyond the scope of this exercise

	- X_test.txt / X_train.txt contain the 561-feature vector with time and frequency domain variables including the mean and std deviation measurements required for the final data sets.


Overview of Tidy data created
=============================

	- All the tidy data was created and stored in a folder called "tidyoutput" (TOP henceforth) in WD.
	
	- Temporary data created during the run of the script is place in the "tempData"(TMP) folder for reference
	
	- The "activity_labels.txt" file was used to create a data file  called "activity_master.csv" with the following charateristics:
		+ Two columns named 
			= activity_id: This is the id column used in raw data to join to the activity data in the other data files. This is the column we will use to denote the activity in all our tidy data files. 
			= activity_name: The description of the activity with a descriptive name.
		+ This intermediate file was stored in the intermediate folder as the tidy data contains the actual activity names and not the activity codes