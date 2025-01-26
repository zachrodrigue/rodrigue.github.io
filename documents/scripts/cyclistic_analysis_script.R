# Load `data.table`
library(data.table)

# Load cleaned data csv file

cleaned_data <- fread("cleaned_bike_data_2024.csv")

# METRICS
## 1. Ride duration average between user types
avg_ride_duration <- cleaned_data[, .(avg_ride_duration = mean(ride_duration)), by = member_casual]
print(avg_ride_duration)

## 2. Ride frequency per user type
ride_frequency <- cleaned_data[, .N, by = .(member_casual, day_of_week)]
print(ride_frequency[order(member_casual, -N)])


## 3. Time of usage - Peak usage time for user types
peak_usage <- cleaned_data[, .N, by = .(member_casual, hour_of_day)]
print(peak_usage[order(member_casual, hour_of_day)])


## 4. Seasonality Patterns - Usage changes over the months in the year

# Load `lubridate` package
library(lubridate)

# Extract month from started_at for additional column
cleaned_data[, month := month(started_at, label = TRUE, abbr = TRUE)]

# Count rides by month and member type
monthly_usage <- cleaned_data[, .N, by = .(member_casual, month)]
print(monthly_usage[order(member_casual, month)])


## 5. Geographical patterns - Most popular start & end stations 

# Filter rows with complete station data
station_data <- cleaned_data[!is.na(start_station_name) & 
                               !is.na(start_station_id) & 
                               !is.na(end_station_name) & 
                               !is.na(end_station_id)]

# 5.1 Count rides by start station and member type
popular_start_stations <- station_data[, .N, by = .(member_casual, start_station_name)]
print(popular_start_stations[order(member_casual, -N)])

# The output included blank station names,
# likely due to the fact those cells are not empty but rather contain spaces as input

# Filter out rows with empty or missing station names
popular_start_stations <- popular_start_stations[start_station_name != "" & !is.na(start_station_name)]
# Reorder the data
popular_start_stations <- popular_start_stations[order(member_casual, -N)]
print(popular_start_stations)


# 5.2 Count rides by end station and member type
popular_end_stations <- station_data[, .N, by = .(member_casual, end_station_name)]
print(popular_end_stations[order(member_casual, -N)])

# The output included blank station names,
# likely due to the fact those cells are not empty but rather contain spaces as input

# Filter out rows with empty or missing station names
popular_end_stations <- popular_end_stations[end_station_name != "" & !is.na(end_station_name)]
# Reorder the data
popular_end_stations <- popular_end_stations[order(member_casual, -N)]
print(popular_end_stations)


# Top 10 stations by user types

# Casual Members
## Start Stations
top_casual_start_stations <- popular_start_stations[member_casual == "casual"][1:10]
print(top_casual_start_stations)

## End Stations
top_casual_end_stations <- popular_end_stations[member_casual == "casual"][1:10]
print(top_casual_end_stations)

# Annual Members
## Start Stations
top_member_start_stations <- popular_start_stations[member_casual == "member"][1:10]
print(top_member_start_stations)

## End Stations
top_member_end_stations <- popular_end_stations[member_casual == "member"][1:10]
print(top_member_end_stations)

## 6. 
### Count rides by bike type and member type
bike_type_usage <- cleaned_data[, .N, by = .(member_casual, rideable_type)]
print(bike_type_usage[order(member_casual, -N)])

# count total riders by membership
membership_ride <- cleaned_data[, .N, by = .(member_casual)]
print(membership_ride)

# EXPORT TABLES TO CSV FOR VISUALIZATION 

# Export ride duration average
fwrite(avg_ride_duration, "avg_ride_duration.csv")

# Export ride frequency by day of week
fwrite(ride_frequency, "ride_frequency.csv")

# Export peak usage times by hour of day
fwrite(peak_usage, "peak_usage.csv")

# Export monthly usage patterns
fwrite(monthly_usage, "monthly_usage.csv")

# Export popular start stations
fwrite(popular_start_stations, "popular_start_stations.csv")

# Export popular end stations
fwrite(popular_end_stations, "popular_end_stations.csv")

# Export top 10 start stations for casual members
fwrite(top_casual_start_stations, "top_casual_start_stations.csv")

# Export top 10 end stations for casual members
fwrite(top_casual_end_stations, "top_casual_end_stations.csv")

# Export top 10 start stations for annual members
fwrite(top_member_start_stations, "top_member_start_stations.csv")

# Export top 10 end stations for annual members
fwrite(top_member_end_stations, "top_member_end_stations.csv")

# Export bike usage type 
fwrite(bike_type_usage, "bike_type_usage.csv")






























