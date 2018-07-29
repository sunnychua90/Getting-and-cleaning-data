# Getting-and-cleaning-data
Repo for Peer Graded Assignment: Getting and cleaning data

## Section 1: This readme outlines specific instructions on how to run the "run_analysis.R" function. Specific details on how the function works are listed in the second section.

* To run the function "run_analysis.R", put the "run_analysis.R" file in the same working directory.
* Download the UCI HAR Dataset and put the folder into the same working directory
* Run the function by typing run_analysis("UCI HAR Dataset") in R. If the name of the folder is not UCI HAR Dataset, change the folder name accordingly.
* Once the analysis is completed, a message will be printed on R saying that analysis has been completed and a csv copy of the tidy data is saved in the working directory.
* Data is sorted by subject id and the activity label (e.g. 2.WALKING represents walking activity for subject ID 2)

## Section 2: Details of analysis
The analysis runs on 4 steps:

1. Merging dataset for training:
*Training set is first cleaned up by performing an rbind between X_train.txt and a transpose of features.txt to give column headers
*We then perform cbind with both y_train.txt and subject_train.txt to first derive a merged training data set

2. Merging dataset for test:
*The same steps as per the above are performed to obtain a merged test data set

3. Merging both dataset for test and training:
*rbind is performed to merge the dataset for test and training.
*We then use the grepl function to extract only Subject ID, Activity Labels and columns with mean() and standard deviation()
*Activity labels are replaced by descriptive activity names

4. Cleaning data
*Split function is used to split data by subject ID and activity
*Use lapply to obtain means
*Recombine the split data into data frames by using do.call command
*Finally, use write.csv function to export the clean dataset
