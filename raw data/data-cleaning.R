"In this section, we explore and clean the data set to only leave out information (columns) that are 
necessary for this research."

"Note: In the user data set, # compliment_* represents the number of compliments received by a user 
in different categories. In the review data set, the 'useful', 'cool', and 'funny' columns represent 
the number of times a review has been marked as such by other users. Lastly, in the business data set, 
the columns removed represent the precise location of the business, which are not relevant information 
to our research questions. Following the research question, we have decided these columns are not 
relevant."

# User data set
users <- users %>%
  select(-c(compliment_more, funny, compliment_note, useful, compliment_funny,
            compliment_photos, compliment_cool, friends, compliment_list,
            compliment_profile, compliment_plain, name, compliment_hot, yelping_since,
            compliment_cute, cool, compliment_writer))

# Review data set
reviews <- reviews %>%
  select(-c(date, useful, text, cool, funny)) 

# Business data set
business <- business %>%
  select(-c(postal_code, longitude, latitude, hours, city, is_open, state, address))

## Create the new, smaller, more usable, data set 
### Step 1: Get 10,000 random rows from the users data set
"All rows in the users data set have a unique user_id. Therefore, in order to create a smaller and a 
more usable data, we have decided to narrow down the sample size to 10,000 users.
The set.seed ensures reproducibility with the same users."

set.seed(123) 
sampled_users <- users %>% sample_n(10000)

### Step 2: Join sampled users with the reviews dataset, keeping only matching user IDs
"Next, we join the user sample set with the review data set. This means joining the reviews 
written to the users who have written them. "

user_reviews <- sampled_users %>% 
  inner_join(reviews, by = "user_id")

### Step 3: Join the resulting dataset with the business dataset, keeping only matching business IDs
"Here we create the final data set. We join our previously joined review and user data set with the 
business data set. This allows us to obtain all the information necessary about the businesses that 
our sample users have written reviews on. 
Since both the business data set and the user data set have the columns 'stars' and 'reviews_count', 
we add a suffix to these columns to indicate the data sets' origin."
final_dataset <- user_reviews %>% 
  inner_join(business, by = "business_id", suffix = c("_users", "_business"))

### Step 4: Final adjustments
"In our final data set, we aim to ensure that the data we use going on forward will only contain 
the necessary information for our research."

"First, we converted the NA values in our 'elite' column to an empty string. This is because NA 
values also have a meaning, but working with an empty string is easier and cleaner."

final_dataset$elite[is.na(final_dataset$elite)] <- ""

"Next, we create a new column named 'elite_binary' which has the value '1' if the user has been 
an elite user at lease once and the value '0' if the user has never been elite user. "

final_dataset$elite_binary <- ifelse(final_dataset$elite != "", 1, 0) 


"Lastly, we save our final data set as a new data set. Due to previous complications with loading 
the data set, this data set will ease further research and will be the data set we refer to going 
on forward. "

write.csv(final_dataset, "yelp_final.csv", row.names = FALSE)
