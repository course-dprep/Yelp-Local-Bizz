# Research Question 1
## Summary statistics for stars_business by elite_binary
elite_summary <- yelp_data %>%
  group_by(elite_binary) %>%
  summarise(
    count = n(),
    mean_elite_summary = mean(stars_business, na.rm = TRUE),
    sd_elite_summary = mean(stars_business, na.rm = TRUE),
    median_elite_summary = median(stars_business, na.rm = TRUE)
  )

print(elite_summary)

## Visualizing the distribution of stars_business by elite_binary
### Ensuring elite_binary is a factor
yelp_data$elite_binary <- as.factor(yelp_data$elite_binary)

### Creating a new column to change label from binary numbers to elite vs non-elite
yelp_data$elite_status <- ifelse(yelp_data$elite_binary == "1", "Elite", "Non-Elite")
yelp_data$elite_status <- as.factor(yelp_data$elite_status)

### Plot average_stars (average stars (cumulative) given to businesses) to elite_status
ggplot(yelp_data, aes(x = elite_status, y = average_stars, fill = elite_status)) +
  geom_boxplot(alpha = 0.6, outlier.color = "black", outlier.shape = 16) +
  labs(title = "Comparison of Average Stars Given to Businesses from Elite vs Non-Elite Users",
       x = "Elite Status",
       y = "Average Stars Given to Businesses") +
  theme_minimal() +
  scale_fill_manual(values = c("Non-Elite" = "lightpink", "Elite" = "lightblue")) +
  theme(legend.position = "none")

### Plot density stars_users (star given to business) to elite_status
ggplot(yelp_data, aes(x = stars_users, fill = elite_status)) +
  geom_density(alpha = 0.5) + 
  labs(title = "Density of Ratings by Elite vs. Non-Elite Users",
       x = "Rating Given to a Business",
       y = "Density") +
  theme_minimal() +
  scale_fill_manual(values = c("Non-Elite" = "lightpink", "Elite" = "lightblue"))

## Simple linear regression (t-test) for the relationship between elite_binary and stars_business
t_test_1 <- t.test(stars_users ~ elite_binary, data = yelp_data, var.equal = TRUE)
print(t_test_1)

model_1 <- lm(stars_users ~ elite_binary, data = yelp_data)
summary(model_1) # p-value: < 2.2e-16, this means that the relationship between elite status and the avg rating a business gets is statistically significant. this suggests that elite and non-elite users rate businesses differently, and the difference is unlikely by random chance. 

## Calculating effect size
elite_ratings <- yelp_data$stars_users[yelp_data$elite_status == "Elite"]
non_elite_ratings <- yelp_data$stars_users[yelp_data$elite_status == "Non-Elite"]
pooled_sd <- sqrt(((length(elite_ratings) - 1) * var(elite_ratings) + 
                     (length(non_elite_ratings) - 1) * var(non_elite_ratings)) / 
                    (length(elite_ratings) + length(non_elite_ratings) - 2))
cohens_d_1 <- (mean(elite_ratings) - mean(non_elite_ratings)) / pooled_sd
print(cohens_d_1) # Cohen's d 0.227 < 0.5 indicates that although significant, the practical difference is small (small effect size)

# Research Question 2
## Split data by fan percentile 
data_fans_50  <- subset(yelp_data, fan_category == 1)  # 0-50th percentile
data_fans_75  <- subset(yelp_data, fan_category == 2)  # 50-75th percentile
data_fans_90  <- subset(yelp_data, fan_category == 3)  # 75-90th percentile
data_fans_95  <- subset(yelp_data, fan_category == 4)  # 90-95th percentile
data_fans_100 <- subset(yelp_data, fan_category == 5)  # 95-100th percentile

## Running separate regression models
### Regression compares the effect of elite status on user ratings to a business across different fan groups
model_50  <- lm(stars_users ~ elite_status, data = data_fans_50)
model_75  <- lm(stars_users ~ elite_status, data = data_fans_75)
model_90  <- lm(stars_users ~ elite_status, data = data_fans_90)
model_95  <- lm(stars_users ~ elite_status, data = data_fans_95)
model_100 <- lm(stars_users ~ elite_status, data = data_fans_100)

## Displaying models
summary(model_50) #elite users tend to give slightly higher ratings than non-elite users
summary(model_75) #the difference is still there, but smaller than in the 50th percentile
summary(model_90) #the gap between elite and non-elite users is shrinking as we move up in the number of fans
summary(model_95) #at this higher fan level, non-elite users are actually giving higher ratings than elite users. this suggests that highly followed elite users may be more critical
summary(model_100) #at the highest fan percentile, elite and non-elite users give nearly identical ratings; no meaningful differences

## Cohen's d per fan percentile
cohen_50  <- cohen.d(data_fans_50$stars_users, data_fans_50$elite_status)
cohen_75  <- cohen.d(data_fans_75$stars_users, data_fans_75$elite_status)
cohen_90  <- cohen.d(data_fans_90$stars_users, data_fans_90$elite_status)
cohen_95  <- cohen.d(data_fans_95$stars_users, data_fans_95$elite_status)
cohen_100 <- cohen.d(data_fans_100$stars_users, data_fans_100$elite_status)

## Displaying Cohen's d per fan percentile
print(cohen_50)
print(cohen_75)
print(cohen_90)
print(cohen_95)
print(cohen_100)

cohen_table <- data.frame(
  Percentile = c("50%", "75%", "90%", "95%", "100%"),
  Cohen_d = c(0.307, 0.213, 0.167, -0.284, 0.057),
  Effect_Size = c("Small", "Small", "Negligible", "Small (negative)", "Negligible"),
  Interpretation = c(
    "Elite users give slightly higher ratings than non-elite users",
    "The difference is still small but is weaker",
    "Almost no difference at this percentile",
    "Non-elite users give slightly higher ratings than elite users",
    "No meaningful difference between elite and non-elite users"
  )
)
    
kable(cohen_table, caption = "Cohen's d Effect Sizes for Elite vs. Non-Elite User Ratings Across Fan Percentiles")
    
## Plot moderation effect of fan category on elite status and user ratings
ggplot(yelp_data, aes(x = fan_category, y = stars_users, color = elite_status, group = elite_status)) +
  stat_summary(fun = mean, geom = "point", size = 3) +  # Mean business ratings by fan category
  stat_summary(fun = mean, geom = "line") +  # Connect points to show trend
  labs(title = "Moderation Effect of Fan Category on Elite Status & User Ratings",
       x = "Fan Category (Percentiles)",
       y = "User Rating to a Business",
       color = "Elite Status") +
  theme_minimal() +
  scale_color_manual(values = c("Elite" = "lightblue", "Non-Elite" = "lightpink"))

# Research Question 3
## Split restaurant vs non-restaurant in binary values
yelp_data$restaurant_binary <- ifelse(grepl("Restaurant", yelp_data$categories, ignore.case = TRUE), 1, 0)
yelp_data$restaurant_category <- ifelse(grepl("Restaurant", yelp_data$categories, ignore.case = TRUE), 
                                        "Restaurant", "Non-Restaurant")
yelp_data$restaurant_category <- as.factor(yelp_data$restaurant_category)

## ANOVA
anova_model <- aov(stars_users ~ elite_status * restaurant_category, data = yelp_data)
summary(anova_model)

anova_results <- data.frame(
  Factor = c("Elite Status", "Restaurant Category", "Interaction (Elite × Restaurant)", "Residuals"),
  Df = c(1, 1, 1, 32646),
  Sum_Sq = c(599, 155, 123, 72022),
  Mean_Sq = c(599.0, 155.2, 123.4, 2.2),
  F_value = c(271.53, 70.37, 55.94, NA),
  P_value = c("< 2e-16", "< 2e-16", "7.65e-14", NA)
)

kable(anova_results, caption = "Two-Way ANOVA Results: Effect of Elite Status & Business Category on User Ratings")

## Plot user ratings by elite status and business category
ggplot(yelp_data, aes(x = elite_status, y = stars_users, fill = restaurant_category)) +
  geom_boxplot(alpha = 0.6) +
  labs(title = "User Ratings by Elite Status and Business Category",
       x = "Elite Status",
       y = "User Ratings",
       fill = "Business Category") +
  scale_fill_manual(values = c("Non-Restaurant" = "lightblue", "Restaurant" = "lightpink")) +
  theme_minimal()

