# -----------------------
# Research Question 1
# -----------------------

# -----------------------
# Summary statistics for stars_business by elite_binary
# -----------------------
elite_summary <- yelp_data %>%
  group_by(elite_binary) %>%
  summarise(
    count = n(),
    mean_elite_summary = mean(stars_business, na.rm = TRUE),
    sd_elite_summary = mean(stars_business, na.rm = TRUE),
    median_elite_summary = median(stars_business, na.rm = TRUE)
  )

print(elite_summary) 


# -----------------------
# Visualizing the distributions
# -----------------------
# Step 1: Ensuring elite_binary is a factor
# -----------------------
yelp_data$elite_binary <- as.factor(yelp_data$elite_binary)

# -----------------------
# Step 2: Creating a new column to change label from binary numbers to elite vs non-elite
# -----------------------
yelp_data$elite_status <- ifelse(yelp_data$elite_binary == "1", "Elite", "Non-Elite")
yelp_data$elite_status <- as.factor(yelp_data$elite_status)

# -----------------------
# Step 3: Plot average_stars (average stars (cumulative) given to businesses) to elite_status
#   this shows comparison of average_stars by elite_status
# -----------------------
ggplot(yelp_data, aes(x = elite_status, y = average_stars, fill = elite_status)) +
  geom_boxplot(alpha = 0.6, outlier.color = "black", outlier.shape = 16) +
  labs(title = "Comparison of Average Stars Given to Businesses from Elite vs Non-Elite Users",
       x = "Elite Status",
       y = "Average Stars Given to Businesses") +
  theme_minimal() +
  scale_fill_manual(values = c("Non-Elite" = "lightpink", "Elite" = "lightblue")) +
  theme(legend.position = "none")

# -----------------------
# Step 4: Plot density stars_users (star given to business) to elite_status
#   this shows comparison of stars_users by elite_status
# -----------------------
ggplot(yelp_data, aes(x = stars_users, fill = elite_status)) +
  geom_density(alpha = 0.5) + 
  labs(title = "Density of Ratings by Elite vs. Non-Elite Users",
       x = "Rating Given to a Business",
       y = "Density") +
  theme_minimal() +
  scale_fill_manual(values = c("Non-Elite" = "lightpink", "Elite" = "lightblue"))


# -----------------------
# Analyzing the relationship
# -----------------------

# -----------------------
# Step 1: Simple linear regression (t-test) for the relationship between elite_binary and stars_users
# -----------------------
t_test_1 <- t.test(stars_users ~ elite_binary, data = yelp_data, var.equal = TRUE)
print(t_test_1)

model_1 <- lm(stars_users ~ elite_binary, data = yelp_data)
summary(model_1) 

# p-value: < 2.2e-16, this means that the relationship between elite status and the avg rating a business gets is statistically significant. this suggests that elite and non-elite users rate businesses differently, and the difference is unlikely by random chance. 

# -----------------------
# Step 2: Calculating effect size
# -----------------------
elite_ratings <- yelp_data$stars_users[yelp_data$elite_status == "Elite"]
non_elite_ratings <- yelp_data$stars_users[yelp_data$elite_status == "Non-Elite"]
pooled_sd <- sqrt(((length(elite_ratings) - 1) * var(elite_ratings) + 
                     (length(non_elite_ratings) - 1) * var(non_elite_ratings)) / 
                    (length(elite_ratings) + length(non_elite_ratings) - 2))
cohens_d_1 <- (mean(elite_ratings) - mean(non_elite_ratings)) / pooled_sd
print(cohens_d_1) 

# Cohen's d 0.227 < 0.5 indicates that although significant, the practical difference is small



# -----------------------
# Research Question 2
# -----------------------

# -----------------------
# Step 1: Ensure that fan_category is a factor and create a new column to indicate the percentile per level
# -----------------------
yelp_data$fan_category <- cut(
  yelp_data$fans,
  breaks = c(-Inf, percentiles[1], percentiles[2], percentiles[3], percentiles[4], Inf),
  labels = c(1, 2, 3, 4, 5),
  right = TRUE
)

yelp_data$fan_percentile <- factor(
  yelp_data$fan_category,
  levels = c(1,2,3,4,5),
  labels = c("50%", "75%", "90%", "95%", "100%"))

# -----------------------
# Step 2: Fit a moderation model
#   this tests whether fan_category moderates the effect of elite_binary on stars_users
# -----------------------
model_moderation <- lm(stars_users ~ elite_binary * fan_category, data = yelp_data)
summary(model_moderation)

# -----------------------
# Step 3: Create a data frame for predicted values
# -----------------------
pred_data <- expand.grid(
  elite_binary = unique(yelp_data$elite_binary),
  fan_category = levels(yelp_data$fan_category)
)

pred_data$predicted_rating <- predict(model_moderation, newdata = pred_data)
pred_data <- pred_data %>%
  mutate(elite_binary = if_else(elite_binary == 1, "Elite", "Non-Elite"),
         elite_binary = factor(elite_binary, levels = c("Non-Elite", "Elite")))

# -----------------------
# Step 4: Plotting the moderation effect
# -----------------------
ggplot(pred_data, aes(x = fan_category, y = predicted_rating, 
                      color = elite_binary, group = elite_binary)) +
  geom_line(size = 1.2) +
  geom_point(size = 3) +
  labs(
    title = "Moderation of Fan Percentile on Elite Status and User Ratings",
    x = "Fan Percentile",
    y = "Predicted Rating",
    color = "Elite Status"
  ) +
  theme_minimal() +
  scale_color_manual(values = c("Elite" = "lightblue", "Non-Elite" = "lightpink"))

# -----------------------
# Cohen's d
#   this shows the effect size of each percentile
# -----------------------

cohen_fan <- lapply(split(yelp_data, yelp_data$fan_percentile), 
                    function(df) cohen.d(df$stars_users, df$elite_binary))
print(cohen_fan)



# -----------------------
# Research Question 3
# -----------------------

# -----------------------
# Step 1: Split restaurant vs non-restaurant in binary values
# -----------------------
yelp_data$business_binary <- ifelse(grepl("Restaurant", yelp_data$categories, ignore.case = TRUE), 1, 0)
yelp_data$business_category <- ifelse(grepl("Restaurant", yelp_data$categories, ignore.case = TRUE), 
                                      "Restaurant", "Non-Restaurant")
yelp_data$business_category <- as.factor(yelp_data$business_category)

# -----------------------
# Step 2: ANOVA
# -----------------------
anova_model <- aov(stars_users ~ elite_status * business_category, data = yelp_data)
summary(anova_model)

# -----------------------
# Step 3: Cohen's d
#   this shows the effect size
# -----------------------
cohen_restaurant <- lapply(split(yelp_data, yelp_data$business_category), 
                           function(df) cohen.d(df$stars_users, df$elite_status))

print(cohen_restaurant)

# -----------------------
# Step 4: Plot user ratings by elite status and business category
# -----------------------
ggplot(yelp_data, aes(x = elite_status, y = stars_users, fill = business_category)) +
  geom_boxplot(alpha = 0.6) +
  labs(title = "User Ratings by Elite Status and Business Category",
       x = "Elite Status",
       y = "User Ratings",
       fill = "Business Category") +
  scale_fill_manual(values = c("Non-Restaurant" = "lightblue", "Restaurant" = "lightpink")) +
  theme_minimal() 