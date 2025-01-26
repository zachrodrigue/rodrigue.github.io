# Setting up R environment 

if (!require("tidyverse")) install.packages("tidyverse")
if (!require("lubridate")) install.packages("lubridate")
if (!require("skimr")) install.packages("skimr")
if (!require("janitor")) install.packages("janitor")


# Loading required packages

library(tidyverse)
library(lubridate)
library(skimr)
library(janitor)


# Load datasets

daily_activity <- read_csv("~/data_carpentry/projects/Bellabeat_case_study/data/raw/dailyActivity_merged.csv")
sleep_data <- read_csv("~/data_carpentry/projects/Bellabeat_case_study/data/raw/sleepDay_merged.csv")
intensity_data <- read_csv("~/data_carpentry/projects/Bellabeat_case_study/data/raw/hourlyIntensities_merged.csv")

# View the structure and summary of the datasets

glimpse(daily_activity)
glimpse(intensity_data)
glimpse(sleep_data)


# Data Cleaning and Manipulation

# First, checked for missing values in the datasets.
# Check for missing values
sum(is.na(daily_activity))
sum(is.na(sleep_data))
sum(is.na(intensity_data))


# Then, checked for duplicated data
# Checking for duplicate Data
sum(duplicated(daily_activity))
sum(duplicated(sleep_data))
sum(duplicated(intensity_data))

# Removed duplicated data in sleep_data
sleep_data_clean <- distinct(sleep_data) 

# Checking for unrealistic values in daily_activity
unrealistic_values <- daily_activity %>%
  filter(TotalSteps<=0 & TotalDistance<= 0 & Calories<=0)
print(unrealistic_values)

daily_activity_clean <- daily_activity %>%
  filter(!(TotalSteps<=0 & TotalDistance<= 0 & Calories<=0))

# Renamed all columns to lowercase for datasets
sleep_data_clean <- sleep_data_clean %>%
  rename_with(tolower)

daily_activity_clean <- daily_activity_clean %>%
  rename_with(tolower)

intensity_data_clean <- intensity_data %>%
  rename_with(tolower)



# Formatted dates appropriately for the datasets

# daily activity
daily_activity_clean$activitydate=as.POSIXct(daily_activity_clean$activitydate, format="%m/%d/%Y", tz=Sys.timezone())

# sleep
sleep_data_clean$sleepday=as.POSIXct(sleep_data_clean$sleepday, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())

# intensity
intensity_data_clean$activityhour=as.POSIXct(intensity_data_clean$activityhour, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
intensity_data_clean$time <- format(intensity_data_clean$activityhour, format = "%H:%M:%S")
intensity_data_clean$date <- format(intensity_data_clean$activityhour, format = "%m/%d/%y")


# Viewing the data with head() function
head(intensity_data_clean)
head(sleep_data_clean)
head(daily_activity_clean)

# Cross-checking missing Values
sum(is.na(daily_activity_clean))
sum(is.na(sleep_data_clean))
sum(is.na(intensity_data_clean))

# 'date' columns in  daily_activity_clean and sleep_data_clean are renamed 'date' for merge
sleep_data_clean <- sleep_data_clean %>%
  rename(date = sleepday)

daily_activity_clean <- daily_activity_clean %>%
  rename(date = activitydate)

# Exploring and Summarizing data

# Number of distinct participants in each dataset
n_distinct(daily_activity_clean$id)
n_distinct(sleep_data_clean$id)
n_distinct(intensity_data_clean$id)

#Checked the number of rows/observations in each dataset
nrow(sleep_data_clean)
nrow(daily_activity_clean)
nrow(intensity_data_clean)

# daily activity
daily_activity_clean %>%  
  select(totalsteps,
         totaldistance,
         sedentaryminutes, calories) %>%
  summary()

# explore number of active minutes per category
daily_activity_clean %>%
  select(veryactiveminutes, fairlyactiveminutes, lightlyactiveminutes) %>%
  summary()

# sleep
sleep_data_clean %>%
  select(totalsleeprecords, totalminutesasleep, totaltimeinbed) %>%
  summary()

#intensity
 intensity_data_clean %>%
   select(totalintensity, averageintensity)%>%
   summary()



# Merging datasets
# Merging the cleaned sleep_data and daily_activity by "id" and "date"
merged_data <- merge(sleep_data_clean, daily_activity_clean, by = c("id", "date"))
head(merged_data)


# Number of distinct participants in merged data
n_distinct(merged_data$id)

# Converted relevant columns from double to integer
merged_data$totalsleeprecords <- as.integer(merged_data$totalsleeprecords)
merged_data$totalsteps <- as.integer(merged_data$totalsteps)
merged_data$totalminutesasleep <- as.integer(merged_data$totalminutesasleep)
merged_data$totaltimeinbed <- as.integer(merged_data$totaltimeinbed)
merged_data$veryactiveminutes <- as.integer(merged_data$veryactiveminutes)
merged_data$fairlyactiveminutes <- as.integer(merged_data$fairlyactiveminutes)
merged_data$lightlyactiveminutes <- as.integer(merged_data$lightlyactiveminutes)
merged_data$sedentaryminutes <- as.integer(merged_data$sedentaryminutes)
merged_data$calories <- as.integer(merged_data$calories)


# Exploratory Data Analysis (EDA)

# What are the activity trends (e.g., steps, active minutes) across users?

# Are there correlations between activity levels and sleep patterns?

# What percentage of users achieve recommended activity or sleep levels?

# Activity Trends across Users

# Summarized activity trends
activity_summary <- daily_activity_clean %>%
  group_by(date) %>%
  summarise(
    avg_steps = mean(totalsteps, na.rm = TRUE),
    avg_calories = mean(calories, na.rm = TRUE),
    avg_active_minutes = mean(veryactiveminutes + fairlyactiveminutes + lightlyactiveminutes, na.rm = TRUE)
  )

print(activity_summary)

# Step distribution
ggplot(daily_activity_clean, aes(x = totalsteps)) +
  geom_histogram(fill = "steelblue", color = "black", bins = 30) +
  labs(title = "Distribution of Total Steps", x = "Total Steps", y = "Count") +
  theme_minimal()

# Total Steps vs. Calories burned
ggplot(daily_activity_clean, aes(x = totalsteps, y = calories)) +
  geom_jitter(alpha = 0.6, color = "darkgreen") +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(title = "Total Steps vs. Calories Burned" , x = "Total Steps", y = "Calories Burned") +
  theme_minimal()

# Assessing activity intensity over hourly time
# Summarizing by mean of total intensity, group by time
int_summary <- intensity_data_clean %>%
  group_by(time) %>%
  summarise(mean_total_int = mean(totalintensity))


# Visualizing Average intensity vs. Time

# Convert time back to POSIXct for proper ordering in the chart
int_summary$time <- as.POSIXct(int_summary$time, format = "%H:%M")

# Plot line chart
ggplot(int_summary, aes(x = time, y = mean_total_int)) +
  geom_line(color = "blue", size = 1) +
  geom_smooth(method = "loess", color = "red", linetype = "dashed") + 
  labs(
    title = "Average Total Intensity vs. Time",
    x = "Time of Day",
    y = "Average Total Intensity"
  ) +
  scale_x_datetime(
    date_labels = "%I %p",  # Format x-axis as "6 AM," "12 PM"
    date_breaks = "2 hours"  # Break axis labels every 2 hours
  ) +
  theme_minimal()


# Scatter Plot: Steps Taken vs. Sedentary Minutes
ggplot(daily_activity_clean, aes(x = totalsteps, y = sedentaryminutes)) +
  geom_jitter(alpha = 0.6, color = "blue") +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(
    title = "Relationship Between Steps Taken and Sedentary Minutes",
    x = "Total Steps Taken",
    y = "Sedentary Minutes"
  ) +
  theme_minimal()


# Weekday vs. Weekend Analysis
daily_activity_clean <- daily_activity_clean %>%
  mutate(weekday = ifelse(weekdays(date) %in% c("Saturday", "Sunday"), "Weekend", "Weekday"))

activity_weekday <- daily_activity_clean %>%
  group_by(weekday) %>%
  summarise(
    avg_steps = mean(totalsteps),
    avg_calories = mean(calories)
  )

# Plot comparison
ggplot(activity_weekday, aes(x = weekday, y = avg_steps, fill = weekday)) +
  geom_bar(stat = "identity") +
  labs(title = "Steps: Weekday vs. Weekend", x = "Day Type", y = "Average Steps") +
  theme_minimal()



# Scatter plot: Total Steps vs. Total Minutes Asleep
ggplot(merged_data, aes(x = totalsteps, y = totalminutesasleep)) +
  geom_point(alpha = 0.6, color = "blue") +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(
    title = "Correlation Between Total Steps and Total Minutes Asleep",
    x = "Total Steps",
    y = "Total Minutes Asleep"
  ) +
  theme_minimal()


# Scatter plot: Calories vs. Total Time in Bed
ggplot(merged_data, aes(x = calories, y = totaltimeinbed)) +
  geom_point(alpha = 0.6, color = "green") +
  geom_smooth(method = "lm", color = "orange", se = FALSE) +
  labs(
    title = "Correlation Between Calories Burned and Total Time in Bed",
    x = "Calories Burned",
    y = "Total Time in Bed"
  ) +
  theme_minimal()

# Calculate Sleep Recommendation
sleep_achieved <- sleep_data_clean %>%
  mutate(sleep_achieved = ifelse(totalminutesasleep >= 420, 1, 0)) %>%
  summarise(percent_achieved_sleep = mean(sleep_achieved) * 100)

# Calculate Activity Recommendation
activity_achieved <- daily_activity_clean %>%
  mutate(active_minutes = veryactiveminutes + fairlyactiveminutes) %>%
  summarise(percent_achieved_activity = mean(active_minutes >= 150) * 100)


# Combined Sleep and Activity 

combined_data <- tibble(
  Category = c("Sleep", "Activity"),
  Percent = c(
    sleep_achieved$percent_achieved_sleep,
    activity_achieved$percent_achieved_activity
  )
)

# Combined chart
ggplot(combined_data, aes(x = Category, y = Percent, fill = Category)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  labs(title = "Comparison of Sleep and Activity Recommendations Met",
       x = "Wellness Indicator",
       y = "Percentage") +
  theme_minimal()

