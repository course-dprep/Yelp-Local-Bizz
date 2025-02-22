yelp_id <- "1_zEeMXNrsxDwcHfCTYxrba66eygPL0r_"
yelp_url <- paste0("https://drive.google.com/uc?id=", yelp_id)

##  influence of Yelp’s reviewer status (elite vs. non-elite) on the average rating of the business

#select relevant variables for the main RQ
yelp_RQ1 <- yelp_data %>% select(stars_business, elite_binary)

#average business rating for 2 status of reviewers
yelp_RQ1<-yelp_RQ1 %>%
  group_by (elite_binary) %>% 
  mutate (avg_rating= mean(stars_business))

## number of fans an elite reviewer has correlates with greater influence in business ratings.

#select relevant variables
yelp_RQ2 <- yelp_data %>% select(stars_business, elite_binary,fan_category)
#filter observation with elite users
yelp_RQ2 <- yelp_RQ2 %>% filter(elite_binary==1)
#average rating of business for every fan category
yelp_RQ2 <- yelp_RQ2 %>% group_by(fan_category)  %>% mutate(avg_rating=mean(stars_business))


##the effect of reviewer type on business ratings differs between restaurant vs non-restaurant

#select relevant variables for non-restaurant
non_restaurant_data <- non_restaurant_data %>% select (stars_business,elite_binary)

#average nonrestaurant rating for 2 status of reviewers
non_restaurant_data<-non_restaurant_data%>%
  group_by (elite_binary) %>% 
  mutate (avg_rating= mean(stars_business))

#select relevant variables for restaurant
restaurant_data <- restaurant_data %>% select (stars_business,elite_binary)

#average restaurant rating for 2 status of reviewers
restaurant_data<-restaurant_data%>%
  group_by (elite_binary) %>% 
  mutate (avg_rating= mean(stars_business))


