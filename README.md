# Yelp Local Businesses: How Elite Status Shapes Business Ratings

![yelp image](https://localmarketinginstitute.com/wp-content/uploads/2020/03/yelp-reviews.png)

## Introduction
 Yelp, founded in 2004, is a major online review platform that influences consumer decisions by allowing users to rate and review businesses. Research suggests that consumers value reviews under certain conditions and rely on cues like reviewer expertise, consistency, and overall rating trends to assess credibility [(Fogel & Zachariah, 2017)](https://doi.org/10.4067/S0718-18762017000100005). Additionally, reviews are perceived as more trustworthy when they align with majority opinions and come from experienced sources, such as Yelp Elite users, whose status signals credibility and influence (Lim & Van Der Heide, 2015). These findings highlight how Yelp's user-generated content shapes consumer trust and business reputations. In this project we aim to analyze different types of user-generated content (reviews) and the different impact it has on businesses. 

## Research Question
In this section we provide the research questions for this project. For the motivation behind the questions we refer you to the report. <br>
__Is there a correlation between Yelp user type and the rating given to a business?__

 ### Sub Questions
1. __Does the number of fans an elite Yelp user has moderate the relationship between user type and the rating a business receives from this user?__
2. __Does the relationship differ when analyzing only restaurants compared to non-restaurant businesses?__

## Data set variables
The data set has 14 columns, their meaning can be found in the following table:
 | Variable | Data Type | Explanation |
|:----------|:----------|:----------|
| fans | Numeric integer | The number of fans a user has. |
| user_id| Character string | Unique, 22 character long ID that defines which user wrote the review. |
| review_count_users | Numeric float | Number that represents the amount of reviews the user wrote in total. |
| elite | Numeric integer | Long integer showing all the years a user was elite. If user never was elite it shows NA. |
| average_stars | Numeric float | Average rating of all reviews a user has given in the past. |
| review_id | Character string | Unique, 22 character long ID that defines the review. |
| business_id | Character string | Unique, 22 character long ID that defines the business for which the review was given. |
| stars_users | Numeric integer | Star rating that was given by the user with the review. |
| categories | Array of strings | Array of strings which includes the categories a business has. |
| attributes | Object | Business attributes to logic values. Please note: some attributes might be objects of attributes to logic values again. | 
| name | Character string | Business' name. |
| stars_business | Numeric float | Averge stars a business got from the reviews they have received. The amount of stars are rounded to half-stars. |
| review_count_business | Numeric integer | The amount of reviews a business has gotten in total. |
| elite_binary | Binary | A binary telling whether the user has ever, at least once, had the elite status before (1) or not (0). |

## Research Method
The methods used in this project for answering our research questions are:
1. Simple Linear Regression (T-Test). 
2. Moderated Multiple Linear Regression
3. Two-way ANOVA

For a more extensive explanation on how these methods will be used, we refer you to the report.

## Preview of Findings 
- Describe the gist of your findings (save the details for the final paper!)
- How are the findings/end product of the project deployed?
- Explain the relevance of these findings/product. 

## Discussion
### Relevance of Findings
This research holds significance for multiple stakeholders, including consumers, business owners, online review platforms, and the academic community.  

For __consumers__, the findings provide insights into how different types of reviewers shape business ratings, enabling them to make more informed purchasing decisions. By understanding the influence of elite and non-elite users, as well as the role of reviewer popularity, consumers can better assess the credibility of ratings and reviews before choosing a business. This knowledge allows them to navigate potential biases in online reviews, ensuring that their decisions are based on a more accurate representation of a business’s quality and service.  

For __business owners__, this study highlights the factors that influence online reputation, helping them better understand how different types of reviewers affect consumer perceptions. By recognizing the impact of elite reviewers and highly followed users, businesses can refine their engagement strategies, respond more effectively to feedback, and leverage online reviews to build stronger customer relationships. Understanding these dynamics can also help businesses anticipate potential biases in ratings and adjust their marketing efforts accordingly.  

For __online review platforms__, such as Yelp, can also benefit from this research by gaining deeper insights into how reviewer characteristics shape rating distributions. These findings can inform platform policies regarding elite status designations, ranking algorithms, and review visibility, ultimately improving the fairness and reliability of their rating systems. Platforms can use this research to enhance user trust and engagement, ensuring that reviews provide an accurate reflection of business quality.  

For the __academic community__, this study contributes to the broader literature on online reviews, consumer purchasing behavior, and the influence of digital opinion leaders. By analyzing how elite status and reviewer influence impact business ratings, this research deepens the understanding of social dynamics in digital review platforms. It provides a foundation for future studies exploring trust in user-generated content, platform design, and the psychological factors that drive consumer decision-making. As online reviews continue to play a critical role in e-commerce and digital marketing, these findings offer valuable perspectives for researchers in marketing, behavioral economics, and information systems.

### Future Analysis
One limitation of this study is that it categorizes businesses into only two broad groups: restaurants and non-restaurants. While this approach provides a general understanding of how reviewer type influences ratings across different business types, it overlooks potential nuances within more specific industries. For example, customer expectations and rating behaviors may differ significantly between hotels, rental services, beauty salons, or fitness centers. A more granular analysis of distinct business categories could offer deeper insights into how elite and non-elite reviewers interact with different types of businesses.  

Additionally, due to the immense size of the dataset, this study analyzes a reduced sample of 10,000 Yelp users rather than the full dataset. While this sample allows for computational efficiency and meaningful statistical analysis, it may not fully capture the broader trends present in the complete dataset. Future research could expand this work by utilizing the entire Yelp dataset, ensuring a more representative analysis and potentially uncovering additional patterns in reviewer behavior.

## Repository Overview 

Once more code will be created, a diagram that illustrates the repository structure will be added here.
```{r}
├── README.md
├── makefile
├── .gitignore
├── raw data
│   ├── load-packages.R
│   ├── download-data.R
│   ├── data-cleaning.R
│   ├── final_data.R
├── reporting
│   ├── report.Rmd
│   ├── start_app.R
├── src
│   ├── analysis
│   │   ├── analysis.R
│   ├── data-preparation
│   │   ├── Data_exploration.Rmd
│   │   ├── Data-preparation.R
```

## Dependencies 
In order to run the code for this project the following packages should be installed and loaded in R. To install the packages, please run this code:
```{r}
install.packages("googledrive")
install.packages("dplyr")
install.packages("readr")
install.packages("data.table")
install.packages("httr")
install.packages("ggplot2")
install.packages("tidyverse")
install.packages("tinytex")
install.packages("knitr")
install.packages("car")
install.packages("effsize")
```
Then to load the packages, please run this code:
```{r}
library(googledrive)
library(dplyr)
library(readr)
library(data.table)
library(httr)
library(ggplot2)
library(tidyverse)
library(tinytex)
library(knitr)
library(car)
library(effsize)
```

## Running Instructions 
For this workflow to properly work, the following steps should be followed:
_Please note that step 2 and 3 take a lot of time and storage. Thses steps create the final data set used for this project and can be skipped since the final data set will also be directly loaded in step 4._
1. Run load-packages.R OR run the code in the Dependencies section.
2. Run download-data.R (optional)
3. Run data-cleaning.R (optional)
4. Run final-data.R to load the data set that will be used for the project. 
5. Next, to prepare the data for the exploration and research run Data-preparation.R 
6. In order to get to know the data set, please run the Data-exploration.Rmd file. 
7. For the data analysis used to answer the research questions. Please run analysis.R

## About 

This project is set up as part of the Master's course [Data Preparation & Workflow Management](https://dprep.hannesdatta.com/) at the [Department of Marketing](https://www.tilburguniversity.edu/about/schools/economics-and-management/organization/departments/marketing), [Tilburg University](https://www.tilburguniversity.edu/), the Netherlands.

The project is implemented by team 9 which includes the members: 
- Mitsal Athaya Minantoputra (2153569)
- Amartya Iqra Akhlaqi (2099128)
- Naomi Parmentier (2053479)
- Niusha Amri (2149204)
- Lan Vu (2055251)

## References
1. Fogel, J., & Zachariah, S. (2017). Intentions to use the Yelp review website and purchase behavior after reading reviews. _Journal of Theoretical and Applied Electronic Commerce Research, 12(1)_, 17–30. https://doi.org/10.4067/S0718-18762017000100005
2. Karaca-Mandic, P., Norton, E. C., & Dowd, B. (2012). Interaction terms in nonlinear models. _Health Services Research, 47(1 Pt 1)_, 255–274. https://doi.org/10.1111/j.1475-6773.2011.01314.x
3. Lim, Y., & Van Der Heide, B. (2015). Evaluating the wisdom of strangers: The perceived credibility of online consumer reviews on Yelp. _Journal of Computer-Mediated Communication, 20(1)_, 67–82. https://doi.org/10.1111/jcc4.12093
4. Luca, M. (2016). Reviews, reputation, and revenue: The case of Yelp.com. _Harvard Business School NOM Unit Working Paper No. 12-016_. https://doi.org/10.2139/ssrn.1928601
5. Luepsen, H. (2023). ANOVA with binary variables: The F-test and some alternatives. _Communications in Statistics - Simulation and Computation, 52(3)_, 745–769. https://doi.org/10.1080/03610918.2020.1869983
6. Moe, W. W., & Trusov, M. (2011). The value of social dynamics in online product ratings forums. _Journal of Marketing Research, 48(3)_, 444-456. https://doi.org/10.1509/jmkr.48.3.444
7. Su, X., Yan, X., & Tsai, C.-L. (2012). Linear regression. _Wiley Interdisciplinary Reviews: Computational Statistics, 4(3)_, 275–294. https://doi.org/10.1002/wics.1198
8. Su, Y., Gao, X., Li, X., & Tao, D. (2012). Multivariate multilinear regression. _IEEE Transactions on Systems, Man, and Cybernetics, Part B (Cybernetics), 42(6)_. https://doi.org/10.1109/TSMCB.2012.2195171
