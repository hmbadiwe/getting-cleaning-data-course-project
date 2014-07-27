getting-cleaning-data-course-project
====================================

In order to run this script, source it from within R.
The easiest way to run this script is to execute it within the directory containing the test and train folders.
After sourcing the script, run generate_tidy_data()
A file will be created within your working directory called 'tidy_data.txt'. This is the default file name and can be changed.

### Description
	Reads the training/test data sets and returns a tidy data frame. It also saves the output to a file.

### Usage of generate_tidy_data
	generate_tidy_data( nrows_to_read = -1, output_file_name = "tidy_data.txt", dir = "./" )

###	Arguments
	nrows_to_read : The number of rows to read. Defaults to -1 ( reads all the data from the data files)
	output_file_name : Defaults to 'tidy_data.txt', which is created in the current working directory
	dir : location of training, test folders, labels, features.




