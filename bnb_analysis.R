##### FINAL PROJECT

bnb= read.csv("/Users/andresperez/Desktop/R Files/bnb_project/Torerobnb_listing_rev.csv")

#### data cleaning

# eliminate id column
bnb = bnb[, !(names(bnb) == "id")]

# eliminate rows with no price
bnb = bnb %>% filter(bnb$price!=0)


# create bathroom columns: bathroom column = # bathrooms, shared column = shared or private 
library(stringr)
head(bnb)
table(bnb$bathrooms_text)
bnb$bathrooms = sapply(strsplit(bnb$bathrooms_text, " "), "[", 1)
bnb$bathrooms = as.integer(bnb$bathrooms)
summary(bnb$bathrooms)
bnb$shared = sapply(strsplit(bnb$bathrooms_text, " "), "[", 2)
bnb$shared = ifelse(bnb$shared=="shared",1,0)
table(bnb$shared)

# converting dates into numeric & extracting the year they pertain to. creating new columns specifically for the years
library(lubridate)
bnb$last_review = mdy(bnb$last_review)
bnb$last_review = as.integer(bnb$last_review)
bnb$last_review_year = year(as.Date(bnb$last_review, origin = "1970-01-01"))

bnb$host_since = mdy(bnb$host_since)
bnb$host_since = as.integer(bnb$host_since)
bnb$host_since_year = year(as.Date(bnb$host_since, origin = "1970-01-01"))

# converting variables from categorical to factors
bnb$neighbourhood = as.factor(bnb$neighbourhood)
bnb$neighbourhood_group = as.factor(bnb$neighbourhood_group)
bnb$room_type = as.factor(bnb$room_type)






### TASK 1 - Data exploration 
library(dplyr)

# which borough has the most rentals?
boroughs = bnb %>% group_by(neighbourhood_group) %>% 
  summarize(count=n()) %>% 
  arrange(-count)

# Does a particular borough have a typical rental price?
burough_counts = bnb %>% group_by(neighbourhood_group,room_type) %>% 
  summarize(count=n())

# which borough offers the most affordable rentals
most_affordable_borough = bnb %>% group_by(neighbourhood_group) %>%
  summarize(average_price = mean(price, na.rm = TRUE)) %>% 
  arrange(average_price)
  
# what is the price breakdown for the boroughs? 
borough_summary_price = bnb %>% group_by(neighbourhood_group) %>%
  summarize(
    min_price = min(price),
    max_price = max(price),
    average_price = mean(price),
    median_price = median(price),
    total_listings = n()
            ) %>% 
  arrange(average_price)

# do property types changed based on location? (room type)
borough_type = bnb %>% group_by(neighbourhood_group, room_type) %>% 
  summarize(count=n()) %>% 
  slice(which.max(count)) %>% 
  arrange(count)

# do property types changed based on location? (accommodates)
borough_accommodates = bnb %>% group_by(neighbourhood_group, accommodates) %>% 
  summarize(count=n()) %>% 
  slice(which.max(count)) %>% 
  arrange(count)


# what year had the largest number of new hosts? 
library(lubridate)
bnb_year = bnb %>%
  mutate(host_since = mdy(host_since),
         host_since_year = year(host_since)) %>% 
  na.omit()

new_hosts_per_year = bnb_year %>%
  group_by(host_since_year) %>%
  summarize(new_hosts_count = n())

ggplot(new_hosts_per_year, aes(x = factor(host_since_year), y = new_hosts_count)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(x = "Year", y = "Number of New Hosts", title = "Distribution of New Hosts Over Years")

# which host is most profitable?
bnb_host = bnb %>% 
  mutate(Revenue = price * number_of_reviews)

most_profitable_host = bnb_host %>% 
  group_by(host_id, host_name) %>% 
  summarize(Total_Revenue = sum(Revenue, na.rm=TRUE)) %>% 
  arrange(-Total_Revenue)

# how much has TBB earned from NYC rentals?
tbb_revenue = sum(bnb_host$Revenue, na.rm=TRUE)
tbb_earnings = 0.03*tbb_revenue
tbb_earnings

# exploring relationship between room type and price
ggplot(bnb, aes(x = room_type, y = price)) +
  geom_boxplot() +
  labs(title = "Relationship Between Room Type and Price",
       x = "Room Type",
       y = "Price") +
  theme_minimal()

# making plots to find relationships between categories and price
# splitting the data by borough
manhattan_data = bnb %>% filter(neighbourhood_group=="Manhattan")
brooklyn_data = bnb %>% filter(neighbourhood_group=="Brooklyn")
staten_data = bnb %>% filter(neighbourhood_group=="Staten Island")
queens_data = bnb %>% filter(neighbourhood_group=="Queens")
bronx_data = bnb %>% filter(neighbourhood_group=="Bronx")

# room type versus price - Manhattan
ggplot(manhattan_data, aes(x = room_type, y = price)) +
  geom_boxplot(fill="darkgoldenrod1") +
  labs(title = "Relationship Between Room Type and Price in Manhattan",
       x = "Room Type",
       y = "Price") +
  theme_minimal()

# room type versus price - Brooklyn
ggplot(brooklyn_data, aes(x = room_type, y = price)) +
  geom_boxplot(fill="brown1") +
  labs(title = "Relationship Between Room Type and Price in Brooklyn",
       x = "Room Type",
       y = "Price") +
  theme_minimal()

# room type versus price - Staten Island
ggplot(staten_data, aes(x = room_type, y = price)) +
  geom_boxplot(fill="darkseagreen4") +
  labs(title = "Relationship Between Room Type and Price in Staten Island",
       x = "Room Type",
       y = "Price") +
  theme_minimal()

# room type versus price - Queens 
ggplot(queens_data, aes(x = room_type, y = price)) +
  geom_boxplot(fill="darkmagenta") +
  labs(title = "Relationship Between Room Type and Price in Queens",
       x = "Room Type",
       y = "Price") +
  theme_minimal()

# room type versus price - Bronx 
ggplot(bronx_data, aes(x = room_type, y = price)) +
  geom_boxplot(fill="blue4") +
  labs(title = "Relationship Between Room Type and Price in Bronx",
       x = "Room Type",
       y = "Price") +
  theme_minimal()

# exploring the relationship of accommodates vs price
accommodates_data = bnb %>%
  group_by(neighbourhood_group, accommodates) %>% 
  summarize(Average_Price = mean(price, na.rm=TRUE)) %>% 
  arrange(-Average_Price)
ggplot(accommodates_data, aes(x = accommodates, y = Average_Price, color = neighbourhood_group)) +
  geom_point() +
  labs(title = "Scatterplot of Accommodates vs. Price by Borough",
       x = "Accommodates", y = "Average Price") +
  scale_color_manual(values = c("Manhattan" = "darkgoldenrod1",
                                "Brooklyn" = "brown1",
                                "Staten Island" = "darkseagreen4",
                                "Queens" = "darkmagenta",
                                "Bronx" = "blue4"),
                     name="Borough") +
  scale_x_continuous(breaks = seq(min(bnb_man_accommodates$accommodates),
                                  max(bnb_man_accommodates$accommodates),
                                  by = 1)) +
  theme_minimal()

# exploring the relationship of bathroom vs price
bathroom_data = bnb %>% 
  group_by(neighbourhood_group, bathrooms) %>% 
  summarize(Average_Price = mean(price, na.rm=TRUE)) %>% 
  arrange(-Average_Price)

ggplot(bathroom_data, aes(x = bathrooms, y = Average_Price, color = neighbourhood_group)) +
  geom_point() +
  labs(title = "Scatterplot of Number of Bathrooms vs. Price by Borough",
       x = "Number of Bathrooms", y = "Average Price") +
  scale_color_manual(values = c("Manhattan" = "darkgoldenrod1",
                                "Brooklyn" = "brown1",
                                "Staten Island" = "darkseagreen4",
                                "Queens" = "darkmagenta",
                                "Bronx" = "blue4"),
                     name="Borough") +
  theme_minimal()

# exploring the relationship of bathroom type vs price
bathroomType = bnb %>% 
  group_by(neighbourhood_group, shared) %>% 
  summarize(Average_Price = mean(price, na.rm=TRUE)) %>% 
  arrange(-Average_Price)
bathroomType$shared <- factor(bathroomType$shared, levels = c("0", "1","NA"), labels = c("Not Shared", "Shared","NA"))

ggplot(bathroomType, aes(x = neighbourhood_group, y = Average_Price, fill = shared)) +
  geom_bar(stat = "identity", position=position_dodge(), alpha =0.75) +
  labs(title = "Average Price by Bathroom Sharing and Borough",
       x = "Borough",
       y = "Average Price",
       fill = "Shared Bathrooms") +
  scale_fill_manual(values = c("Not Shared" = "skyblue", "Shared" = "brown1","NA"="grey")) +
  theme_minimal()

# exploring the relationships of bedrooms vs price 
bedrooms_data = bnb %>%
  group_by(neighbourhood_group, bedrooms) %>% 
  summarize(Average_Price = mean(price, na.rm=TRUE)) %>% 
  arrange(-Average_Price)
print(bedrooms_data, n=42)
ggplot(bedrooms_data, aes(x = bedrooms, y = Average_Price, color = neighbourhood_group)) +
  geom_point() +
  labs(title = "Scatterplot of Bedrooms vs. Price by Borough",
       x = "Number of Bedrooms", y = "Average Price") +
  scale_color_manual(values = c("Manhattan" = "darkgoldenrod1",
                                "Brooklyn" = "brown1",
                                "Staten Island" = "darkseagreen4",
                                "Queens" = "darkmagenta",
                                "Bronx" = "blue4"),
                     name="Borough") +
  theme_minimal()

# exploring the relationships of beds vs price 
beds_data = bnb %>%
  group_by(neighbourhood_group, beds) %>% 
  summarize(Average_Price = mean(price, na.rm=TRUE)) %>% 
  arrange(-Average_Price)
print(beds_data, n=42)
ggplot(beds_data, aes(x = beds, y = Average_Price, color = neighbourhood_group)) +
  geom_point() +
  labs(title = "Scatterplot of Beds vs. Price by Borough",
       x = "Number of Beds", y = "Average Price") +
  scale_color_manual(values = c("Manhattan" = "darkgoldenrod1",
                                "Brooklyn" = "brown1",
                                "Staten Island" = "darkseagreen4",
                                "Queens" = "darkmagenta",
                                "Bronx" = "blue4"),
                     name="Borough") +
  theme_minimal()

# exploring the relationship of number of reviews vs price
reviews_data = bnb %>%
  group_by(neighbourhood_group, number_of_reviews) %>% 
  summarize(Average_Price = mean(price, na.rm=TRUE)) %>% 
  arrange(-Average_Price)

reviews_data = bnb %>%
  group_by(neighbourhood_group, number_of_reviews) %>% 
  summarize(Average_Price = mean(price, na.rm=TRUE)) %>% 
  group_by(neighbourhood_group) %>%
  mutate(z_score1 = scale(number_of_reviews), z_score2=scale(Average_Price)) %>%
  filter(abs(z_score1) <= 1.5) %>% 
  filter(abs(z_score2)<=2) %>% 
  select(-z_score1) %>% 
  select(-z_score2)
ggplot(reviews_data, aes(x = number_of_reviews, y = Average_Price, color = neighbourhood_group)) +
  geom_point() +
  labs(title = "Scatterplot of Number of Reviews vs. Price by Borough",
       x = "Number of Reviews", y = "Average Price") +
  scale_color_manual(values = c("Manhattan" = "darkgoldenrod1",
                                "Brooklyn" = "brown1",
                                "Staten Island" = "darkseagreen4",
                                "Queens" = "darkmagenta",
                                "Bronx" = "blue4"),
                     name="Borough") +
  theme_minimal()

# exploring the relationship of host since Vs price
bnb_year2 = bnb %>%
  mutate(host_since = mdy(host_since),
         host_since_year = year(host_since),
         Average_Price = price) %>% 
  group_by(neighbourhood_group, host_since_year) %>%
  summarize(Average_Price = mean(Average_Price, na.rm = TRUE)) %>% 
  arrange(neighbourhood_group, -host_since_year)

ggplot(bnb_year2, aes(x = host_since_year, y = Average_Price, group = neighbourhood_group, color = neighbourhood_group)) +
  geom_line(size = 1.5) +
  labs(title = "Average Price by Host Since Year",
       x = "Host Since Year",
       y = "Average Price") +
  scale_color_manual(values = c("Manhattan" = "darkgoldenrod1",
                                "Brooklyn" = "brown1",
                                "Staten Island" = "darkseagreen4",
                                "Queens" = "darkmagenta",
                                "Bronx" = "blue4"),
                     name="Borough") +
  scale_y_continuous(limits = c(50, NA))

# exploring the relationship between last reviewed and price
bnb_last_review = bnb %>%
  mutate(last_review = mdy(last_review),
         last_review_year = year(last_review),
         Average_Price = price) %>% 
  group_by(neighbourhood_group, last_review_year) %>%
  summarize(Average_Price = mean(Average_Price, na.rm = TRUE)) %>% 
  arrange(neighbourhood_group, -last_review_year) 

ggplot(bnb_last_review, aes(x = last_review_year, y = Average_Price, color = neighbourhood_group)) +
  geom_point() +
  labs(title = "Scatterplot of Last Review Year vs. Price by Borough",
       x = "Last Review Year", y = "Average Price") +
  scale_color_manual(values = c("Manhattan" = "darkgoldenrod1",
                                "Brooklyn" = "brown1",
                                "Staten Island" = "darkseagreen4",
                                "Queens" = "darkmagenta",
                                "Bronx" = "blue4"),
                     name="Borough") +
  theme_minimal()


## MAPS
library(dplyr)
library(caret)
library(RANN)
library(leaflet)

### remove rows with no price
DF.sub = bnb %>% filter(bnb$price!=0)

### plotting all points, too many points so choosing the first 1000
leaflet(DF.sub[1:1000,]) %>% 
  addTiles() %>% addMarkers(~longitude, ~latitude)

#### We are going to group the points to the nearest latitude and longitude. The more decimal points, then more granular the data. Fewer decimal points mean larger grids.
DF.sub$Lat = round(DF.sub$latitude,4)
DF.sub$Lon = round(DF.sub$longitude,4)

### It's often better to look at the log() of the variable because it's more normal. So we tranform the price variable by taking the log().
DF.sub$logprice = log(DF.sub$price)

### We are now ready to create a data frame grouped by the neighborhood, longitude, and latitude. 
### We calculate the average price and average log(price).
DF.sub.plot = DF.sub %>% group_by(neighbourhood,Lon,Lat) %>% summarize(Price=mean(price),LogPrice=mean(logprice), .groups="drop")

### We want to create a color scale to match our range of values
pricemax = max(DF.sub.plot$LogPrice)
bins = seq(0,ceiling(pricemax),0.75)
pal = colorBin("YlOrRd",domain =DF.sub.plot$LogPrice,bins=bins)

### We are not ready to create the graph
leaflet(DF.sub.plot) %>% addTiles() %>% addCircles(lng=~Lon, lat=~Lat, radius = ~LogPrice,stroke=FALSE,
                                                   fillColor=~pal(LogPrice), fillOpacity = 0.5,
                                                   label=~paste0(neighbourhood,": ",format(round(Price),big.mark=","), " (Lat,Lon): ",Lat,", ",Lon)) %>%
  addLegend(pal = pal, values=~LogPrice, opacity = 0.8)



### Instead of taking the log(price), if we want to look at the price directly, then the range of values would be larger.
### We set the color ranges accordingly. 
pricemax = max(DF.sub.plot$Price)
pal = colorNumeric("YlOrRd", domain = DF.sub.plot$Price)
# ColorRange = colorNumeric("YlOrRd", domain = DF.sub.plot$Price)

### We are not ready to create the graph, note that I am varying the radius of the circles using the LogPrice parameter
leaflet(DF.sub.plot) %>% addTiles() %>% addCircles(lng=~Lon, lat=~Lat, radius = ~5*LogPrice,stroke=FALSE,
                                                   fillColor=~pal(Price), fillOpacity = 0.5,
                                                   label=~paste0(neighbourhood,": ",format(round(Price),big.mark=","), " (Lat,Lon): ",Lat,", ",Lon)) %>%
  addLegend(pal=pal, values=~Price, opacity = 0.8)







########### TASK 2 - Predictive Models

# creating different data frames based on borough
manhattan = subset(bnb, neighbourhood_group=="Manhattan")
brooklyn = subset(bnb, neighbourhood_group=="Brooklyn")
staten = subset(bnb, neighbourhood_group=="Staten Island")
queens = subset(bnb, neighbourhood_group=="Queens")
bronx = subset(bnb, neighbourhood_group=="Bronx")

# Manhattan Models
# making predictive model for Manhattan data (first, must take care of the missing values)
preProc.man = preProcess(manhattan %>% select(neighbourhood, accommodates, bedrooms, beds,
                                              bathrooms, shared, number_of_reviews, last_review_year, host_since_year,
                                              latitude, longitude, room_type, price),
                     method = "knnImpute")

impute_manhattan = predict(preProc.man, manhattan)
summary(impute_manhattan)

procNames.man <- data.frame(col = names(preProc.man$mean), mean = preProc.man$mean, sd = preProc.man$std)
for(i in procNames.man$col){
  impute_manhattan[i] <- impute_manhattan[i]*preProc.man$std[i]+preProc.man$mean[i] 
}
impute_manhattan

# Creating hot neighborhoods areas in Manhattan
xlist = impute_manhattan %>% group_by(neighbourhood) %>% summarize(avg_price=mean(price)) %>% arrange(-avg_price)
N=4
hot_neighbourhoods = xlist$neighbourhood[1:N]
impute_manhattan$hot = as.integer(impute_manhattan$neighbourhood %in% hot_neighbourhoods)
# 1.linear regression without sub-setting  
library(caTools)
set.seed(123)
split = sample.split(impute_manhattan$price, SplitRatio = 0.7)
train.manhattan=subset(impute_manhattan,split==TRUE)
test.manhattan=subset(impute_manhattan,split==FALSE)

manhattan.mod = lm(price ~ accommodates+last_review_year+room_type+bathrooms+neighbourhood+host_id+bedrooms+beds+shared,
                   data = train.manhattan)
summary(manhattan.mod)
pred.mod.man = predict(manhattan.mod, newdata=test.manhattan)
SSE.manhattan = sum((test.manhattan$price-pred.mod.man)^2)
RMSE.manhattan = sqrt(SSE.manhattan/nrow(test.manhattan))
RMSE.manhattan
# 2. linear regression model 2 models by sub-setting neighborhoods (hot neighborhoods & not hot neighborhoods)

# checking to see average prices of hot vs not hot neighborhoods
hot_neighbourhoods_average_price = train.manhattan %>% 
  group_by(hot) %>% summarize(Average_Price = mean(price, na.rm=TRUE))

train.manhattan.hot = subset(train.manhattan, hot==1)
train.manhattan.not.hot = subset(train.manhattan, hot==0)
test.manhattan.hot = subset(test.manhattan, hot==1)
test.manhattan.not.hot = subset(test.manhattan, hot==0)

manhattan.mod1.hot = lm(price ~ accommodates+last_review_year+shared+room_type+bathrooms+beds+neighbourhood, 
                        data = train.manhattan.hot)
summary(manhattan.mod1.hot)
pred.mod1.hot = predict(manhattan.mod1.hot, newdata=test.manhattan.hot)
SSE.manhattan.hot = sum((test.manhattan.hot$price-pred.mod1.hot)^2)
RMSE.manhattan.hot = sqrt(SSE.manhattan.hot/nrow(test.manhattan.hot))
RMSE.manhattan.hot

manhattan.mod1.not.hot = lm(price ~ accommodates+room_type+bathrooms+last_review_year+shared+bedrooms+beds+neighbourhood, 
                            data = train.manhattan.not.hot)
summary(manhattan.mod1.not.hot)
pred.mod1.not.hot = predict(manhattan.mod1.not.hot, newdata=test.manhattan.not.hot)
SSE.manhattan.not.hot = sum((test.manhattan.not.hot$price-pred.mod1.not.hot)^2)
RMSE.manhattan.not.hot = sqrt(SSE.manhattan.not.hot/nrow(test.manhattan.not.hot))
RMSE.manhattan.not.hot

# 3. linear regression model 2 models by sub-setting shared bathrooms (shared vs not shared)
# Creating with hot and not hot shared bathrooms 
## WINNER WINNER CHICKEN DINNER FOR MANHATTAN
# subsetting data shared vs not sharred
train.manhattan$hot.s = ifelse(train.manhattan$shared == 0,1,0) # if shared=0, then it's hot because not shared is preferred to shared. 
table(train.manhattan$hot.s)
test.manhattan$hot.s = ifelse(test.manhattan$shared == 0,1,0)
table(test.manhattan$hot.s)

train2.manhattan.hot=subset(train.manhattan, hot.s==1)
train2.manhattan.not.hot = subset(train.manhattan, hot.s==0)
test2.manhattan.hot = subset(test.manhattan, hot.s==1)
test2.manhattan.not.hot = subset(test.manhattan, hot.s==0)
# understanding relationship for bathrooms (shared vs. not shared) and average pricee 
impute_manhattan$shared = as.integer(impute_manhattan$shared)
Manhattan_bathrooms = impute_manhattan %>% 
  group_by(neighbourhood, shared) %>% 
  summarize(Average_Price = mean(price)) %>% 
  arrange(neighbourhood)
print(Manhattan_bathrooms, n=80)
Manhattan_bathrooms$shared <- factor(Manhattan_bathrooms$shared, levels = c("0", "1"), labels = c("Not Shared", "Shared"))

ggplot(Manhattan_bathrooms, aes(x = reorder(neighbourhood, -Average_Price), y = Average_Price, fill = shared)) +
  geom_bar(stat = "identity", position = position_dodge(), alpha = 0.75) +
  labs(title = "Average Price by Bathroom Sharing and Manhattan Neighborhood",
       x = "Manhattan Neighborhood",
       y = "Average Price",
       fill = "Shared Bathrooms") +
  scale_fill_manual(values = c("Not Shared" = "skyblue", "Shared" = "brown1")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# model for shared vs not shared
manhattan.mod2.hot = lm(price ~ accommodates+last_review_year+room_type+bathrooms+neighbourhood+host_id+bedrooms+beds,
                        data = train2.manhattan.hot)
summary(manhattan.mod2.hot)
pred.mod2.hot = predict(manhattan.mod2.hot, newdata=test2.manhattan.hot)
SSE.manhattan2.hot = sum((test2.manhattan.hot$price-pred.mod2.hot)^2)
RMSE.manhattan2.hot = sqrt(SSE.manhattan2.hot/nrow(test2.manhattan.hot))
RMSE.manhattan2.hot

manhattan.mod2.not.hot = lm(price~ accommodates+last_review_year+room_type+bathrooms+beds+neighbourhood,
                            data=test2.manhattan.not.hot)
summary(manhattan.mod2.not.hot)
pred.mod2.not.hot = predict(manhattan.mod2.not.hot, newdata=test2.manhattan.not.hot)
SSE.manhattan2.not.hot = sum((test2.manhattan.not.hot$price-pred.mod2.not.hot)^2)
RMSE.manhattan2.not.hot = sqrt(SSE.manhattan2.not.hot/nrow(test2.manhattan.not.hot))
RMSE.manhattan2.not.hot

# Brooklyn Model
# making predictive model for Brooklyn data (first, must take care of the missing values)
preProc.brooklyn = preProcess(brooklyn %>% select(neighbourhood, accommodates, bedrooms, beds,
                                              bathrooms, shared, number_of_reviews, last_review_year, host_since_year,
                                              latitude, longitude, room_type, price),
                         method = "knnImpute")

impute_brooklyn = predict(preProc.brooklyn, brooklyn)
summary(impute_brooklyn)

procNames.brooklyn <- data.frame(col = names(preProc.brooklyn$mean), mean = preProc.brooklyn$mean, sd = preProc.brooklyn$std)
for(i in procNames.brooklyn$col){
  impute_brooklyn[i] <- impute_brooklyn[i]*preProc.brooklyn$std[i]+preProc.brooklyn$mean[i] 
}
impute_brooklyn

# 1.linear model brooklyn - forward selection 
set.seed(123)
split = sample.split(impute_brooklyn$price, SplitRatio = 0.7)
train.brooklyn=subset(impute_brooklyn,split==TRUE)
test.brooklyn=subset(impute_brooklyn,split==FALSE)

mod3.brooklyn = lm(price ~ accommodates+room_type+bathrooms+shared+bedrooms+beds+last_review_year+number_of_reviews+longitude+latitude+neighbourhood,
                   data=train.brooklyn)
summary(mod3.brooklyn)
pred.mod3 = predict(mod3.brooklyn, newdata=test.brooklyn)
SSE.brooklyn = sum((test.brooklyn$price-pred.mod3)^2)
RMSE.brooklyn = sqrt(SSE.brooklyn/nrow(test.brooklyn))
RMSE.brooklyn


# creating linear 2 models sub-setted by shared or not shared bathrooms
train.brooklyn$hot.s = ifelse(train.brooklyn$shared == 0,1,0) # if shared=0, then it's hot because not shared is preferred to shared. 
table(train.brooklyn$hot.s)
test.brooklyn$hot.s = ifelse(test.brooklyn$shared == 0,1,0)
table(test.brooklyn$hot.s)

train.brooklyn.hot=subset(train.brooklyn, hot.s==1)
train.brooklyn.not.hot = subset(train.brooklyn, hot.s==0)
test.brooklyn.hot = subset(test.brooklyn, hot.s==1)
test.brooklyn.not.hot = subset(test.brooklyn, hot.s==0)
# looking at relationship for brooklyn shared vs not shared and price by neighborhood
impute_brooklyn$shared = as.integer(impute_brooklyn$shared)
brooklyn_bathrooms = impute_brooklyn%>% 
  group_by(neighbourhood, shared) %>% 
  summarize(Average_Price = mean(price)) %>% 
  arrange(neighbourhood)
print(brooklyn_bathrooms, n=80)
brooklyn_bathrooms$shared <- factor(brooklyn_bathrooms$shared, levels = c("0", "1"), labels = c("Not Shared", "Shared"))

ggplot(brooklyn_bathrooms, aes(x = reorder(neighbourhood, -Average_Price), y = Average_Price, fill = shared)) +
  geom_bar(stat = "identity", position = position_dodge(), alpha = 0.75) +
  labs(title = "Average Price by Bathroom Sharing and Brooklyn Neighborhood",
       x = "Brooklyn Neighborhood",
       y = "Average Price",
       fill = "Shared Bathrooms") +
  scale_fill_manual(values = c("Not Shared" = "skyblue", "Shared" = "brown1")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

brooklyn.mod4.hot = lm(price ~ accommodates+room_type+bathrooms+bedrooms+beds+last_review_year+number_of_reviews+longitude+latitude+neighbourhood,
                        data = train.brooklyn.hot)
summary(brooklyn.mod4.hot)
pred.mod4.hot = predict(brooklyn.mod4.hot, newdata=test.brooklyn.hot)
SSE.brooklyn4.hot = sum((test.brooklyn.hot$price-pred.mod4.hot)^2)
RMSE.brooklyn4.hot = sqrt(SSE.brooklyn4.hot/nrow(test.brooklyn.hot))
RMSE.brooklyn4.hot

brooklyn.mod2.not.hot = lm(price~ accommodates+room_type+bathrooms+last_review_year+longitude+latitude,
                            data=test.brooklyn.not.hot)
summary(brooklyn.mod2.not.hot)
pred.mod4.not.hot = predict(brooklyn.mod2.not.hot, newdata=test.brooklyn.not.hot)
SSE.brooklyn4.not.hot = sum((test.brooklyn.not.hot$price-pred.mod4.not.hot)^2)
RMSE.brooklyn4.not.hot = sqrt(SSE.brooklyn4.not.hot/nrow(test.brooklyn.not.hot))
RMSE.brooklyn4.not.hot


# Staten Island Model
# making predictive model for Manhattan data (first, must take care of the missing values)
preProc.staten = preProcess(staten %>% select(neighbourhood, accommodates, bedrooms, beds,
                                                  bathrooms, shared, number_of_reviews, last_review_year, host_since_year,
                                                  latitude, longitude, room_type, price),
                              method = "knnImpute")

impute_staten = predict(preProc.staten, staten)
summary(impute_staten)

procNames.staten<- data.frame(col = names(preProc.staten$mean), mean = preProc.staten$mean, sd = preProc.staten$std)
for(i in procNames.staten$col){
  impute_staten[i] <- impute_staten[i]*preProc.staten$std[i]+preProc.staten$mean[i] 
}
impute_staten


# linear regression forward selection

set.seed(123)
split = sample.split(impute_staten$price, SplitRatio = 0.7)
train.staten=subset(impute_staten,split==TRUE)
test.staten=subset(impute_staten,split==FALSE)

mod5.staten = lm(price ~ accommodates+bathrooms+beds+number_of_reviews,
                   data=train.staten)
summary(mod5.staten)
pred.mod5 = predict(mod5.staten, newdata=test.staten)
SSE.staten = sum((test.staten$price-pred.mod5)^2)
RMSE.staten = sqrt(SSE.staten/nrow(test.staten))
RMSE.staten

# Queens Model
# making predictive model for Manhattan data (first, must take care of the missing values)
preProc.queens = preProcess(queens %>% select(neighbourhood, accommodates, bedrooms, beds,
                                                  bathrooms, shared, number_of_reviews, last_review_year, host_since_year,
                                                  latitude, longitude, room_type, price),
                              method = "knnImpute")

impute_queens = predict(preProc.queens, queens)
summary(impute_queens)

procNames.queens<- data.frame(col = names(preProc.queens$mean), mean = preProc.queens$mean, sd = preProc.queens$std)
for(i in procNames.queens$col){
  impute_queens[i] <- impute_queens[i]*preProc.queens$std[i]+preProc.queens$mean[i] 
}
impute_queens

# linear regression for queens
set.seed(123)
split = sample.split(impute_queens$price, SplitRatio = 0.7)
train.queens=subset(impute_queens,split==TRUE)
test.queens=subset(impute_queens,split==FALSE)

mod6.queens = lm(price ~ accommodates+room_type+bathrooms+bedrooms+last_review_year+number_of_reviews+neighbourhood,
                 data=train.queens)
summary(mod6.queens)
pred.mod6 = predict(mod6.queens, newdata=test.queens)
SSE.queens = sum((test.queens$price-pred.mod6)^2)
RMSE.queens = sqrt(SSE.queens/nrow(test.queens))
RMSE.queens

# Bronx Model 
# making predictive model for Manhattan data (first, must take care of the missing values)
preProc.bronx = preProcess(bronx %>% select(neighbourhood, accommodates, bedrooms, beds,
                                                  bathrooms, shared, number_of_reviews, last_review_year, host_since_year,
                                                  latitude, longitude, room_type, price),
                              method = "knnImpute")

impute_bronx = predict(preProc.bronx, bronx)
summary(impute_bronx)

procNames.bronx <- data.frame(col = names(preProc.bronx$mean), mean = preProc.bronx$mean, sd = preProc.bronx$std)
for(i in procNames.bronx$col){
  impute_bronx[i] <- impute_bronx[i]*preProc.bronx$std[i]+preProc.bronx$mean[i] 
}
impute_bronx

# linear regression bronx
set.seed(123)
split = sample.split(impute_bronx$price, SplitRatio = 0.7)
train.bronx=subset(impute_bronx,split==TRUE)
test.bronx=subset(impute_bronx,split==FALSE)

mod7.bronx = lm(price ~ accommodates+room_type+bathrooms+bedrooms+last_review_year+number_of_reviews+longitude+latitude+neighbourhood,
                 data=train.bronx)
summary(mod7.bronx)
pred.mod7 = predict(mod7.bronx, newdata=test.bronx)
SSE.bronx = sum((test.bronx$price-pred.mod7)^2)
RMSE.bronx = sqrt(SSE.bronx/nrow(test.bronx))
RMSE.bronx



##### EVAL SET

evalset = read.csv("/Users/andresperez/Desktop/evalset_rev.csv")

# editing evaluation set
# create bathroom columns: bathroom column = # bathrooms, shared column = shared or private 
library(stringr)
head(evalset)
table(evalset$bathrooms_text)
evalset$bathrooms = sapply(strsplit(evalset$bathrooms_text, " "), "[", 1)
evalset$bathrooms = as.numeric(evalset$bathrooms)
summary(evalset$bathrooms)
evalset$shared = sapply(strsplit(evalset$bathrooms_text, " "), "[", 2)
evalset$shared = ifelse(evalset$shared=="shared",1,0)
table(evalset$shared)

# converting dates into numeric & extracting the year they pertain to. creating new columns specifically for the years
library(lubridate)
evalset$last_review = ymd(evalset$last_review)
evalset$last_review = as.integer(evalset$last_review)
evalset$last_review_year = year(as.Date(evalset$last_review, origin = "1970-01-01"))

evalset$host_since = ymd(evalset$host_since)
evalset$host_since = as.integer(evalset$host_since)
evalset$host_since_year = year(as.Date(evalset$host_since, origin = "1970-01-01"))

# converting variables from categorical to factors
evalset$neighbourhood = as.factor(evalset$neighbourhood)
evalset$neighbourhood_group = as.factor(evalset$neighbourhood_group)
evalset$room_type = as.factor(evalset$room_type)

# impute evalset
preproc.eval = preProcess(evalset %>% select(neighbourhood, accommodates, bedrooms, beds,
                                             bathrooms, shared, number_of_reviews, last_review_year, host_since_year,
                                             latitude, longitude, room_type), method="knnImpute")

impute_evalset = predict(preproc.eval, evalset)
summary(impute_evalset)

procNames.eval <- data.frame(col = names(preproc.eval$mean), mean = preproc.eval$mean, sd = preproc.eval$std)
for(i in procNames.eval$col){
  impute_evalset[i] <- impute_evalset[i]*preproc.eval$std[i]+preproc.eval$mean[i] 
}
impute_evalset

# creating hot.s column to evalset
impute_evalset$hot.s = as.numeric(impute_evalset$shared == 0)

# creating hot column to evalset
top_neighborhoods = as.character(xlist$neighbourhood[1:4])
impute_evalset$hot = as.numeric(evalset$neighbourhood %in% top_neighborhoods)
str(impute_evalset)


evalset=impute_evalset
# applying the models to the evalset
evalset$predicted_price <- NA

# Apply models based on borough and bathroom sharing condition

evalset$predicted_price[evalset$neighbourhood_group == "Manhattan" & evalset$shared == 0] <- predict(manhattan.mod2.hot, newdata = evalset[evalset$neighbourhood_group == "Manhattan" & evalset$shared == 0, ])

evalset$predicted_price[evalset$neighbourhood_group == "Manhattan" & evalset$shared == 1] <- predict(manhattan.mod2.not.hot, newdata = evalset[evalset$neighbourhood_group == "Manhattan" & evalset$shared == 1, ])

evalset$predicted_price[evalset$neighbourhood_group == "Brooklyn" & evalset$shared == 0] <- predict(brooklyn.mod4.hot, newdata = evalset[evalset$neighbourhood_group == "Brooklyn" & evalset$shared == 0, ])

evalset$predicted_price[evalset$neighbourhood_group == "Brooklyn" & evalset$shared == 1] <- predict(brooklyn.mod2.not.hot, newdata = evalset[evalset$neighbourhood_group == "Brooklyn" & evalset$shared == 1, ])

evalset$predicted_price[evalset$neighbourhood_group == "Staten Island"] <- predict(mod5.staten, newdata = evalset[evalset$neighbourhood_group == "Staten Island", ])

evalset$predicted_price[evalset$neighbourhood_group == "Queens"] <- predict(mod6.queens, newdata = evalset[evalset$neighbourhood_group == "Queens", ])

evalset$predicted_price[evalset$neighbourhood_group == "Bronx"] <- predict(mod7.bronx, newdata = evalset[evalset$neighbourhood_group == "Bronx", ])


setwd("/Users/andresperez/Desktop")
write.csv(evalset, "bnb_evalset.csv")

