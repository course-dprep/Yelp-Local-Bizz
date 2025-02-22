yelp_id <- "1_zEeMXNrsxDwcHfCTYxrba66eygPL0r_"
yelp_url <- paste0("https://drive.google.com/uc?id=", yelp_id)

##  influence of Yelp’s reviewer status (elite vs. non-elite) on the average rating of the business
#select relevant variables for the main RQ
yelp_RQ1 <- yelp_data %>% select(stars_business, elite_binary)

#average business rating for 2 status of reviewers
yelp_RQ1<-yelp_RQ1 %>%
  group_by (elite_binary) %>% 
  mutate (avg_rating= mean(stars_business))

##



