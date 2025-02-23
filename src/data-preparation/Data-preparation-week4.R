
#install & load necessary packages

install.packages("data.table")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("readr")
install.packages("httr")
install.packages("tidyverse")
install.packages("tinytex")
install.packages("knitr")

library(data.table)
library(ggplot2)
library(dplyr)
library(readr)
library(httr)
library(tidyverse)
library(tinytex)
library(knitr)


#loading data set

yelp_id <- "1_zEeMXNrsxDwcHfCTYxrba66eygPL0r_"
yelp_url <- paste0("https://drive.google.com/uc?id=", yelp_id)
yelp_data <- read_csv(yelp_url,show_col_types = FALSE)

#ensuring that there are no duplicates in our data

duplicates= duplicated(yelp_data)
yelp_data[duplicates, ]

#(RQ1:the effect of elite/non-elite on stars_users)
##prepare data for implementing linear regression model

nrow(restaurant_data)
str(restaurant_data)

###evaluate the average-star for each user type(elite/non elite)

table_user_type <- restaurant_data %>% group_by(elite_binary) %>% summarise(stars_users_ave=mean(stars_users))

####T-test to see whether the model is significant
t_test_result <- t.test(stars_users ~ elite_binary, data = restaurant_data,
                        var.equal = TRUE)
print(t_test_result)


#RQ2: examine the effect of fans(as a moderator) to previouse model
##design the model(interaction elite & fans)
restaurant_data=restaurant_data[, elite_fan := as.numeric(elite_binary) * fan_category]
View(restaurant_data)

###fit model

regression=lm(stars_users ~ elite_binary+fan_category+elite_fan, restaurant_data);summary(regression)

#visualization
##Predicted vs Actual User Ratings for Restaurant Businesses

restaurant_data$predicted = predict(regression)
ggplot(restaurant_data, aes(x = predicted, y = stars_users)) +
  geom_point(color = "blue", alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Regression Model: Predicted vs Actual UserRatings for Restaurant Businesses",
       x = "Predicted Stars",
       y = "Actual Stars") +
  theme_minimal()


#RQ3-examine Q1 & Q2 on the other Industries(non-restaurant)
##preparing data for non-restaurant category

table_user_type2 <- non_restaurant_data %>% group_by(elite_binary) %>% summarise(stars_users_ave=mean(stars_users))
t_test_result2 <- t.test(stars_users ~ elite_binary, data = non_restaurant_data,
                        var.equal = TRUE)
print(t_test_result2)

###fit model(interaction elite & fans)
regression2=lm(stars_users ~ elite_binary+fan_category+elite_fan, non_restaurant_data);summary(regression2)

#visualization
##Predicted vs Actual User Ratings for Non-Restaurant Businesses
non_restaurant_data$predicted = predict(regression2)
ggplot(non_restaurant_data, aes(x = predicted, y = stars_users)) +
  geom_point(color = "blue", alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Regression Model:Predicted vs Actual UserRatings for Non-Restaurant Businesses",
       x = "Predicted Stars",
       y = "Actual Stars") +
  theme_minimal()