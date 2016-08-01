library(dplyr)
library(tidyr)

# the script assumes that you have invoked it from the working directory that 
# contains a directory called "UCI HAR Dataset" with the raw data downloaded
# and expanded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


# define directories used commonly
#=================================

bdir <- "./UCI HAR Dataset"
tstdir <- file.path(bdir, "test")
trndir <- file.path(bdir, "train")
tdydir <- "./tidyoutput"
tmpdir <- "./tempData"


# setup working environment and output directories
#=================================================

indirs <- c(test=tstdir, train=trndir)
outdirs <- c(tdydir, tmpdir)
result <- lapply(outdirs, function(x)
    if (!file.exists(x)) {
        dir.create(x)
    })


# load the feature lables to use as column labels
# ===============================================

flbl <- read.delim(file.path(bdir,"features.txt"), header=FALSE, stringsAsFactors = FALSE, sep="")
ftrnms <- make.names(flbl$V2,unique = TRUE)




#create tidy version of activity master
#======================================


#column name vector for activity master
activitycolnames <- c("activity_id", "activity_name")

#read in activity master data and process
activitymaster <- tbl_df(read.delim(file.path(bdir,"activity_labels.txt"),
                                    header=FALSE,sep="",stringsAsFactors = FALSE))
colnames(activitymaster) <- activitycolnames

#write out tidy version
write.csv(activitymaster,file.path(tmpdir,"activity_master.csv"), row.names = FALSE)

#create a test and train vector to use for filenames
nsub <- c("test","train")



# Create tidy data for test and train set respectively, 
# and then combine into the final tidy data set
# ====================================================
finaldata <- data_frame()
for (sub in nsub) {

    # load the subject table list
    sbjdf <- tbl_df(read.delim(file.path(indirs[sub], paste("subject_",sub,".txt",sep="")),
                               stringsAsFactors = FALSE, header=FALSE))
    
    # set up the name for the column
    colnames(sbjdf) <- "Subject_id"
    
    
    # load the labels for activity
    lbldf <- tbl_df(read.delim(file.path(indirs[sub], paste("Y_",sub,".txt",sep="")),
                               stringsAsFactors = FALSE, header=FALSE))

    # modify labels to use descriptive names using activity master
    lbldf <- left_join(lbldf,activitymaster,by=c("V1"="activity_id")) %>% select(activity_name)

    #load the data
    dtdf <- tbl_df(read.delim(file.path(indirs[sub], paste("X_",sub,".txt",sep="")),
                               stringsAsFactors = FALSE, header=FALSE,sep=""))
    # setup column names for data
    colnames(dtdf) <- ftrnms

    dtout <- bind_cols(sbjdf,lbldf,dtdf)
    write.csv(dtout,file.path(tmpdir, paste(sub,"_tidy_data.csv",sep="")), row.names = FALSE)
    
    # aggregate the data to create the final clean data
    if (length(finaldata) > 0) {
        finaldata <- bind_rows(finaldata,dtout)
    } else {
        finaldata <- tbl_df(dtout)
    }
}

# Create the merged tidy data set
write.csv(finaldata,file.path(tdydir,"merged_all_data_tidy.csv"), row.names = FALSE)

# extract measurements on the mean and standard deviation for each
temp1 <- finaldata %>% select(Subject_id,activity_name)
temp2 <- finaldata %>% select(contains("mean"))
temp3 <- finaldata %>% select(contains("std"))
meanstddt <- bind_cols(temp1,temp2,temp3)

# write out tidy data for mean and standard deviation
write.csv(meanstddt,file.path(tdydir,"mean_stddev_only_data_tidy.csv"), row.names = FALSE)

# build names for new summarized data set of means
nmtmp <- names(meanstddt)
nmtmp <- c(nmtmp[1:2],sapply(nmtmp[3:length(nmtmp)],function(x) paste("average_of_",x,sep = "")))

# 
by_subact <- meanstddt %>% group_by(Subject_id, activity_name) %>% 
                summarize_each(funs(mean))

# assign new column names to reflect averages
colnames(by_subact) <- nmtmp

# write out tidy data for averages of mean and standard deviation
write.csv(by_subact,file.path(tdydir,"average_mean_stddev_tidy_by_subject_activity.csv"), row.names = FALSE)
# added as part of submission which asked specifically for write.table output
write.table(by_subact,file.path(tdydir,"average_mean_stddev_tidy_by_subject_activity.txt"), row.names = FALSE)
