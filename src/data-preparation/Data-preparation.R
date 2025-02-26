### Create percentiles
percentiles <- quantile(yelp_data$fans, probs = c(0.50, 0.75, 0.90, 0.95), na.rm = TRUE)

### Ensuring elite_binary is a factor
yelp_data$elite_binary <- as.factor(yelp_data$elite_binary)

### Creating a new column to change label from binary numbers to elite vs non-elite
yelp_data$elite_status <- ifelse(yelp_data$elite_binary == "1", "Elite", "Non-Elite")
yelp_data$elite_status <- as.factor(yelp_data$elite_status)

### Split restaurant vs non-restaurant in binary values
yelp_data$business_binary <- ifelse(grepl("Restaurant", yelp_data$categories, ignore.case = TRUE), 1, 0)
yelp_data$business_category <- ifelse(grepl("Restaurant", yelp_data$categories, ignore.case = TRUE), 
                                      "Restaurant", "Non-Restaurant")
yelp_data$business_category <- as.factor(yelp_data$business_category)

### We create a new column to classify users into different percentile groups based on their number of fans. This allows for a structured segmentation of users based on their influence.
yelp_data$fan_category <- cut(
  yelp_data$fans,
  breaks = c(-Inf, percentiles[1], percentiles[2], percentiles[3], percentiles[4], Inf),
  labels = c(1, 2, 3, 4, 5), # Assigns numeric labels for each group
  right = TRUE
)

yelp_data$fan_category <- as.numeric(as.character(yelp_data$fan_category))

### We create two new data sets with restaurant and non restaurant data
restaurant_data <- yelp_data %>%
  filter(str_detect(categories, "Restaurant"))

# Create a data set with rows that do NOT contain "Restaurant"
non_restaurant_data <- yelp_data %>%
  filter(!str_detect(categories, "Restaurant"))