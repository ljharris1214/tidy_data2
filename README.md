# tidy_data2
repo for class project for course tidy data

The R code does the following:
1) reads in three sets of files,none of which have headers
  a) pertaining to a training dataset: includes subjects, activity labels, and the actual data
  b) pertaining to a test dataset: includes subjects, activity labels, and the actual data
  c) general files pertaining to both of above: description of features (in actual data) and activity labels
  
  2) merges the subject and activity files into the main (x) data file
  3) applies names from the features file to the main dataset
  4) combines the training and test data
  5) melts the data using id of subject and activity.  The various features are now listed in column "variable", with their values in "value"
  6) subsets the above to features containin "mean" and "std"
  7) combines the subsets
  8) creates new dataframe with  averages based on subject, activity and feature
  9)  writes dataframe to text file
  
  
  Variables:
  subject:  values 1:30.  just an id for the subject
  activty:  the activity performed
  variable: the name of the "feature"  - i.e. what is measured
  ave:  the value for the specified feature
