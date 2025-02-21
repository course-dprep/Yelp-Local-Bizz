### Ensuring elite_binary is a factor
yelp_data$elite_binary <- as.factor(yelp_data$elite_binary)

### Creating a new column to change label from binary numbers to elite vs non-elite
yelp_data$elite_status <- ifelse(yelp_data$elite_binary == "1", "Elite", "Non-Elite")
yelp_data$elite_status <- as.factor(yelp_data$elite_status)