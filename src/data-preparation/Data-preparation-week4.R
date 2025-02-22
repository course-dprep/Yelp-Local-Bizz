
#install & load nesseccary packages

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
```

#loading dataset

yelp_id <- "1_zEeMXNrsxDwcHfCTYxrba66eygPL0r_"
yelp_url <- paste0("https://drive.google.com/uc?id=", yelp_id)
yelp_data <- read_csv(yelp_url,show_col_types = FALSE)

#ensuring that there are no duplicates in our data

duplicates= duplicated(yelp_data)
yelp_data[duplicates, ]

#prepare data for implementing linear regression model:(RQ1)
##convert elite_binary to factor
yelp_data$elite_binary= factor(yelp_data$elite_binary)

### extract categories that include "restaurant"
restaurant_data <- yelp_data %>%
  filter(grepl("restaurant", categories, ignore.case = TRUE))

#number of records in restaurant dataset
nrow(restaurant_data)
str(restaurant_data)

#evaluate the average-star for each user type(elite/non elite)

table_user_type <- restaurant_data %>% group_by(elite_binary) %>% summarise(stars_users_ave=mean(stars_users))
t_test_result <- t.test(stars_users ~ elite_binary, data = restaurant_data,
                        var.equal = TRUE)
print(t_test_result)

#design the model(interaction elite & fans)

library(data.table)
setDT(restaurant_data)
restaurant_data=restaurant_data[, elite_fan := as.numeric(elite_binary) * fans]
View(restaurant_data)

#fit model
regression=lm(stars_users ~ elite_binary+fans+elite_fan, restaurant_data);summary(regression)

##visualization
###Predicted vs Actual
restaurant_data$predicted = predict(regression)
ggplot(restaurant_data, aes(x = predicted, y = stars_users)) +
  geom_point(color = "blue", alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Regression Model: Predicted vs Actual",
       x = "Predicted Stars",
       y = "Actual Stars") +
  theme_minimal()

###fan versus stars_users
ggplot(restaurant_data, aes(x = fans, y = stars_users)) +
  geom_point(color = "blue", alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Fans vs Stars Users",
       x = "Fans",
       y = "Stars Users") +
  theme_minimal()
###elite-fan versus stars_users
ggplot(restaurant_data, aes(x = elite_fan, y = stars_users)) +
  geom_point(color = "green", alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Elite Fan vs Stars Users",
       x = "Elite Fan",
       y = "Stars Users") +
  theme_minimal()


#creating data for non-restaurant category
non_restaurant_data = yelp_data %>%
  filter(!grepl("restaurant", categories, ignore.case = TRUE))

table_user_type2 <- non_restaurant_data %>% group_by(elite_binary) %>% summarise(stars_users_ave=mean(stars_users))
t_test_result2 <- t.test(stars_users ~ elite_binary, data = non_restaurant_data,
                        var.equal = TRUE)
print(t_test_result2)

#design the model(interaction elite & fans)

library(data.table)
setDT(non_restaurant_data)
non_restaurant_data=non_restaurant_data[, elite_fan := as.numeric(elite_binary) * fans]
View(non_restaurant_data)

#fit model
regression2=lm(stars_users ~ elite_binary+fans+elite_fan, non_restaurant_data);summary(regression2)

##visualization
###Predicted vs Actual
non_restaurant_data$predicted = predict(regression2)
ggplot(non_restaurant_data, aes(x = predicted, y = stars_users)) +
  geom_point(color = "blue", alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Regression Model: Predicted vs Actual",
       x = "Predicted Stars",
       y = "Actual Stars") +
  theme_minimal()

###fan versus stars_users
ggplot(non_restaurant_data, aes(x = fans, y = stars_users)) +
  geom_point(color = "blue", alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Fans vs Stars Users",
       x = "Fans",
       y = "Stars Users") +
  theme_minimal()
###elite-fan versus stars_users
ggplot(non_restaurant_data, aes(x = elite_fan, y = stars_users)) +
  geom_point(color = "green", alpha = 0.5) +
  geom_smooth(method = "lm", color = "blue") +
  labs(title = "Elite Fan vs Stars Users",
       x = "Elite Fan",
       y = "Stars Users") +
  theme_minimal()
