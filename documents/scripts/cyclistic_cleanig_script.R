# Set up R environment

# Install and Load `data.table` package

install.packages("data.table")
library(data.table)

#Load combined data - set working directory to data location
combined_data <- fread("combined_bike_data_2024.csv")

# View data table structure
head(combined_data)
glimpse(combined_data)


# Data Cleaning & Manipulation

## 1. Fix datetime columns if applicable
### combined_data[, started_at := as.POSIXct(started_at, format="%Y-%m-%dT%H:%M:%SZ")]
### combined_data[, ended_at := as.POSIXct(ended_at, format="%Y-%m-%dT%H:%M:%SZ")]

## 2. Checking and handling Missing values

### Check for missing values
colSums(is.na(combined_data))

### Maintained rows with missing start & end station names and ID for separate analysis

### Remove rows with missing critical columns
combined_data <- combined_data[!is.na(ride_id) & !is.na(started_at) & !is.na(ended_at) & !is.na(member_casual)]

## 3. Remove Duplicates

combined_data <- unique(combined_data, by = "ride_id")


## 4. Data consistency 

combined_data <- combined_data[ended_at > started_at]

nrow(combined_data)  # Number of rows after filtering - Number dropped from 5,860,568 to 5,859,634

## 5. New columns for Analysis

### Add ride_duration (in minutes)

combined_data[, ride_duration := as.numeric(difftime(ended_at, started_at, units = "mins"))]

### Add day_of_week
combined_data[, day_of_week := weekdays(started_at)]

### Add hour_of_day
combined_data[, hour_of_day := hour(started_at)]

## 6. Handle outliers

combined_data <- combined_data[ride_duration >= 1 & ride_duration <= 1440]

nrow(combined_data)

colnames(combined_data)

# Save the cleaned data to directory
fwrite(combined_data, "cleaned_bike_data_2024.csv")

















