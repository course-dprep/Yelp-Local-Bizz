"In this file we run the code to open the final data set that'll be used for the rest of this project."

yelp_id <- "1_zEeMXNrsxDwcHfCTYxrba66eygPL0r_"
yelp_url <- paste0("https://drive.google.com/uc?id=", yelp_id)


# Download the file from Google Drive
yelp_data <- read_csv(yelp_url)
