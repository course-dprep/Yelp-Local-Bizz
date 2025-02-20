"All used data sets were uploaded to a Google Drive, which is accessed to obtain the data sets."
user_id <- "1IArMMvDBMw_G7a830qo7bYc6ovtghzCj"
business_id <- "1dtpNmg3wiC-R3PXit4IakuuMrnFdRcy3"
review_id <- "1FSXZCQqXXMeXr2R99BBLPPCtpg63rFuk"
user_url <- paste0("https://drive.google.com/uc?id=", user_id)
business_url <- paste0("https://drive.google.com/uc?id=", business_id)
review_url <- paste0("https://drive.google.com/uc?id=", review_id)

"When running the next line of code, you will be required to authenticate your account via Google. 
Please enter 1 in the console to do so. This needs to be done due to the size of the file exceeding 
100MB, which then enables the virus scanner on files uploaded through Google Drive. Once this is 
finished, the file will be loaded locally on your device."

# Download the file from Google Drive
drive_download(as_id(review_id), path = "reviews.csv", overwrite = TRUE)
drive_download(as_id(user_id), path = "users.csv", overwrite = TRUE)

# Reading CSV files
"As mentioned previously, the size for the data set 'review' and 'users' are over the maximum megabytes 
(100 MB) to be loaded without going through the Google Drive virus scan, therefore, it may take at least
45 minutes to load up the files. Following up, we will then create a new, smaller sample from the larger
data set which will be seen later in this file." 

"Note: the data set 'business' is under 100 MB so, 
it can be loaded directly from the Google Drive URL through its ID."

# Read the large file using fread (faster for large files)
reviews <- read_csv("reviews.csv")
users <- read_csv("users.csv")
business <- read_csv(business_url)