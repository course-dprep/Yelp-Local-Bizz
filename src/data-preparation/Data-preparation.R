# Load necessary libraries
library(dplyr)
library(ggplot2)

# Load the data (assuming your data is in a CSV file)
yelp_data <- read.csv("yelp_reviews.csv")

# Descriptive statistics: Summarize the data
summary_stats <- yelp_data %>%
  group_by(elite_binary) %>%
  summarize(mean_rating = mean(stars_users), sd_rating = sd(stars_users), count = n())

print(summary_stats)

# Visualize the distribution of ratings by user type
ggplot(yelp_data, aes(x = factor(elite_binary), y = stars_users)) +
  geom_boxplot() +
  labs(x = "User Type (0 = Non-Elite, 1 = Elite)", y = "Rating", title = "Distribution of Ratings by User Type")

# Correlation analysis: Perform a t-test to compare the means of the two groups
t_test_result <- t.test(stars_users ~ elite_binary, data = yelp_data)
print(t_test_result)


# Create the interaction term
yelp_data <- yelp_data %>%
  mutate(interaction_term = elite_binary * fans)

# Fit the regression model
model <- lm(stars_users ~ elite_binary + fans + interaction_term, data = yelp_data)

# Summarize the model
summary(model)

# Visualize the interaction effect
ggplot(yelp_data, aes(x = fans, y = average_stars, color = factor(elite_binary))) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", aes(group = elite_binary), se = FALSE) +
  labs(x = "Number of Fans", y = "Rating", color = "User Type (0 = Non-Elite, 1 = Elite)", title = "Interaction Effect of User Type and Number of Fans on Ratings")

# Check the interaction term significance
interaction_p_value <- summary(model)$coefficients["interaction_term", "Pr(>|t|)"]
print(paste("P-value for the interaction term:", interaction_p_value))