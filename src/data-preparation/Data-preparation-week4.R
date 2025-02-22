
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
regresssion_1=lm(stars_users ~ elite_binary+fans+elite_fans, restaurant_data)
regresssion_1
