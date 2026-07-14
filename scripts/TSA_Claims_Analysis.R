############################################################
# TSA Claims Analysis Project
# Statistical Computing - Project 3
# Name - Kumari Sita
# Purpose:
# Analyze TSA claim data, answer business questions,
# and visualize airport claim activity.
############################################################


#-----------------------------------------------------------
# Install and Load Required Packages
#-----------------------------------------------------------

# Run install.packages() only once if packages are missing
# install.packages(c("tidyverse", "janitor", "lubridate", "maps"))

library(tidyverse)
library(janitor)
library(lubridate)
library(maps)


#-----------------------------------------------------------
# Create Output Folder for Plots
#-----------------------------------------------------------

if (!dir.exists("plots")) {
  dir.create("plots")
}


#-----------------------------------------------------------
# Task 1 - Read Data
#-----------------------------------------------------------

# TSA Claims data
claims <- read_csv(
  "data/tsa_claims2.csv",
  show_col_types = FALSE,
  col_types = cols(.default = col_character()),
  na = c("", "NA", "-")
)

# Airport location data
airports <- read_csv(
  "data/GlobalAirportDatabase.csv",
  show_col_types = FALSE,
  na = c("", "NA"),
  name_repair = "minimal"
)

problems(airports)

nrow(claims)


#-----------------------------------------------------------
# Task 2 - Clean TSA Claims Data
#-----------------------------------------------------------

# Clean column names:
# Converts names to snake_case
# Example:
# "Claim Amount" -> "claim_amount"

claims <- claims %>%
  clean_names()


# Check column names after cleaning

names(claims)


#-----------------------------------------------------------
# Convert Date Columns
#-----------------------------------------------------------

# Incident Date examples:
# "12/12/2002 0:00"
#
# Date Received examples:
# "4-Jan-02"

claims <- claims %>%
  mutate(
    incident_date = parse_date_time(
      incident_date,
      orders = c(
        "mdy HM",
        "mdy",
        "m/d/Y H:M",
        "m/d/Y"
      ),
      quiet = TRUE
    ),
    
    date_received = parse_date_time(
      date_received,
      orders = c(
        "d-b-y",
        "d-b-Y",
        "m/d/Y"
      ),
      quiet = TRUE
    )
  )


# Remove only records where dates are missing

claims <- claims %>%
  filter(
    !is.na(incident_date),
    !is.na(date_received)
  )


#-----------------------------------------------------------
# Convert Monetary Columns
#-----------------------------------------------------------

# Replace "-" values with missing values
# Remove commas and dollar signs
# Convert to numeric


claims <- claims %>%
  mutate(
    claim_amount = na_if(claim_amount, "-"),
    close_amount = na_if(close_amount, "-"),
    
    claim_amount = parse_number(claim_amount),
    close_amount = parse_number(close_amount)
  )


# Remove invalid monetary records

claims <- claims %>%
  filter(
    !is.na(claim_amount),
    !is.na(close_amount),
    claim_amount > 0,
    close_amount >= 0,
    close_amount <= claim_amount
  )

summary(claims$claim_amount)
summary(claims$close_amount)

#-----------------------------------------------------------
# Cleaning Check
#-----------------------------------------------------------

cat("Rows remaining after cleaning:", nrow(claims), "\n")

cat("Missing incident dates:",
    sum(is.na(claims$incident_date)), "\n")

cat("Missing received dates:",
    sum(is.na(claims$date_received)), "\n")

cat("Missing claim amounts:",
    sum(is.na(claims$claim_amount)), "\n")


#-----------------------------------------------------------
# Question 1
#
# If a claim is approved, what percent of the claim amount
# did airports pay on average?
#
# If a claim is settled, what percent of the claim amount
# did airports pay on average?
#-----------------------------------------------------------


# Remove zero-dollar claims to avoid division by zero

approved <- claims %>%
  filter(
    status == "Approved",
    claim_amount > 0
  ) %>%
  mutate(
    percent_paid = (close_amount / claim_amount) * 100
  )


avg_approved <- mean(
  approved$percent_paid,
  na.rm = TRUE
)


settled <- claims %>%
  filter(
    status == "Settled",
    claim_amount > 0
  ) %>%
  mutate(
    percent_paid = (close_amount / claim_amount) * 100
  )


avg_settled <- mean(
  settled$percent_paid,
  na.rm = TRUE
)


print(avg_approved)
print(avg_settled)

# Answers:
#
# Approved claims:
# Airports paid approximately 99.63% of the claim amount.
#
# Settled claims:
# Airports paid approximately 52.47% of the claim amount.


print(avg_approved)
print(avg_settled)



#-----------------------------------------------------------
# Question 2
#
# What are the five airports with the most claims?
#-----------------------------------------------------------


top5_airports <- claims %>%
  filter(!is.na(airport_name),
         airport_name != "") %>%
  count(
    airport_name,
    sort = TRUE
  ) %>%
  slice_head(n = 5)


print(top5_airports)

# Answer:
#
# The five airports with the most TSA claims are:
#
# 1. Los Angeles International Airport - 6222 claims
# 2. John F. Kennedy International - 4831 claims
# 3. Chicago O'Hare International Airport - 4717 claims
# 4. Newark International Airport - 4554 claims
# 5. Miami International Airport - 4012 claims



# Visualization:
# Top five airports by claim count


top5_plot <- ggplot(
  top5_airports,
  aes(
    x = reorder(airport_name, n),
    y = n
  )
) +
  geom_col(
    fill = "steelblue"
  ) +
  coord_flip() +
  labs(
    title = "Top 5 Airports by TSA Claims",
    x = "Airport",
    y = "Number of Claims"
  ) +
  theme_minimal()


print(top5_plot)


ggsave(
  "plots/top5_airports.png",
  top5_plot,
  width = 8,
  height = 5
)



#-----------------------------------------------------------
# Question 3
#
# Has the average amount paid out by airports increased
# or decreased over time?
#-----------------------------------------------------------


# Limit data to realistic TSA claim years

claims_2000_2009 <- claims %>%
  filter(
    year(date_received) >= 2000,
    year(date_received) <= 2009
  )


payout_trend <- claims_2000_2009 %>%
  mutate(
    year = year(date_received)
  ) %>%
  group_by(year) %>%
  summarise(
    avg_payout = mean(close_amount, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  complete(
    year = 2000:2009,
    fill = list(avg_payout = 0)
  )


print(payout_trend)

# Answer:
#
# The average amount paid out by airports decreased over time.
# Payouts were highest in the early 2000s and generally declined
# through 2009.


payout_plot <- ggplot(
  payout_trend,
  aes(
    x = year,
    y = avg_payout
  )
) +
  geom_line(
    color = "blue",
    linewidth = 1
  ) +
  geom_point() +
  labs(
    title = "Average TSA Claim Payout Over Time",
    x = "Year",
    y = "Average Payout ($)"
  ) +
  theme_minimal()


print(payout_plot)


ggsave(
  "plots/payout_trend.png",
  payout_plot,
  width = 8,
  height = 5
)



#-----------------------------------------------------------
# Airport Map
#
# Show locations of airports in continental U.S.
# Dot size represents number of claims
#-----------------------------------------------------------


# Count claims by airport code

airport_claims <- claims %>%
  count(
    airport_code,
    name = "claim_count"
  )


# Match airport codes with locations

airport_locations <- airport_claims %>%
  left_join(
    airports,
    by = c(
      "airport_code" = "IATACode"
    )
  )


# Remove airports without coordinates

airport_locations_clean <- airport_locations %>%
  filter(
    !is.na(LatitudeDecimalDegrees),
    !is.na(LongitudeDecimalDegrees)
  )


# Remove duplicate airport matches

airport_locations_clean <- airport_locations_clean %>%
  group_by(airport_code) %>%
  slice(1) %>%
  ungroup()



# Keep only continental U.S. airports

us_airports <- airport_locations_clean %>%
  filter(
    Country == "USA",
    !is.na(LatitudeDecimalDegrees),
    !is.na(LongitudeDecimalDegrees),
    LatitudeDecimalDegrees >= 24,
    LatitudeDecimalDegrees <= 50,
    LongitudeDecimalDegrees >= -125,
    LongitudeDecimalDegrees <= -65
  )


# Create USA map

usa_map <- map_data("state")


airport_map <- ggplot() +
  
  geom_polygon(
    data = usa_map,
    aes(
      long,
      lat,
      group = group
    ),
    fill = "gray90",
    color = "white"
  ) +
  
  geom_point(
    data = us_airports,
    aes(
      x = LongitudeDecimalDegrees,
      y = LatitudeDecimalDegrees,
      size = claim_count
    ),
    color = "red",
    alpha = 0.6
  ) +
  
  coord_fixed(1.3) +
  
  labs(
    title = "TSA Claims by Airport in Continental U.S.",
    x = "Longitude",
    y = "Latitude",
    size = "Number of Claims"
  ) +
  
  theme_minimal()


print(airport_map)


ggsave(
  "plots/airport_map.png",
  airport_map,
  width = 10,
  height = 6
)


#-----------------------------------------------------------
# End of TSA Claims Analysis Project
#-----------------------------------------------------------