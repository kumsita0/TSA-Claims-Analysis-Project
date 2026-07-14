# TSA-Claims-Analysis-Project
Statistical analysis and visualization of TSA claims data using R. This project examines claim payouts, identifies airports with the highest number of claims, analyzes payout trends over time, and visualizes airport claim activity across the U.S.

---
# TSA Claims Analysis Project

## Project Overview

This project analyzes TSA claims data to explore patterns in airport claim activity and payment outcomes. The analysis focuses on answering business questions related to claim payouts, identifying airports with the highest number of claims, and examining how average payouts changed over time.

The project includes data cleaning, statistical summaries, and visualizations created using R. The final outputs include:
- Average percentage paid for approved and settled claims
- Top five airports with the highest number of TSA claims
- Trend analysis of average payouts from 2000–2009
- A map showing TSA claim activity by airport location in the continental United States

---

## Dataset

This project uses two datasets:

### 1. TSA Claims Dataset
**File:** `tsa_claims2.csv`

This dataset contains TSA customer claim records, including information such as:
- Claim number
- Incident date
- Date received
- Airport code and airport name
- Claim amount
- Settlement amount
- Claim status
- Claim type and location

The dataset was cleaned by:
- Standardizing column names
- Converting date fields into proper date formats
- Converting monetary values into numeric format
- Removing invalid or incomplete records

### 2. Airport Location Dataset
**File:** `GlobalAirportDatabase.csv`

This dataset provides airport geographic information used for mapping, including:
- Airport codes
- Airport names
- Country
- Latitude
- Longitude

---

## Software and Packages Used

### Software
- **R Programming Language**
- **RStudio**

### R Packages

| Package | Purpose |
|---|---|
| `tidyverse` | Data manipulation, cleaning, and visualization |
| `janitor` | Cleaning and standardizing column names |
| `lubridate` | Date conversion and time-based analysis |
| `maps` | Creating geographic maps |
| `ggplot2` | Creating plots and visualizations |

---

## Repository Structure

```
TSA-Claims-Analysis-Project/
├── scripts/
│  └──TSA_Claims_Analysis.R      # Main R analysis script
│ 
├── docs/
│  └──Assignment 3 TSA.pdf      # Supporting document for the questions that lead to the goal of the project
│ 
├── README.md                    # Project documentation
│
├── data/
│   ├── tsa_claims2.csv          # TSA claims dataset
│   └── GlobalAirportDatabase.csv # Airport location dataset
│
└── plots/
    ├── top5_airports.png        # Top airports visualization
    ├── payout_trend.png         # Payout trend visualization
    └── airport_map.png          # Airport claim activity map
```

---

## How to Run

1. Install R and RStudio.

2. Download or clone this repository:

```bash
git clone https://github.com/yourusername/TSA-Claims-Analysis-Project.git
```

3. Open the project folder in RStudio.

4. Install the required packages if they are not already installed:

```r
install.packages(c(
  "tidyverse",
  "janitor",
  "lubridate",
  "maps"
))
```

5. Make sure the datasets are located inside the `data` folder.

6. Open and run:

```r
TSA_Claims_Analysis.R
```

The script will:
- Clean the TSA claims data
- Calculate claim payment statistics
- Identify airports with the highest number of claims
- Generate payout trend analysis
- Create visualization files in the `plots` folder

---

## Results Summary

### Average Claim Payment

- Approved claims: Airports paid approximately **99.63%** of the claimed amount on average.
- Settled claims: Airports paid approximately **52.47%** of the claimed amount on average.

### Top Five Airports by Number of Claims

1. Los Angeles International Airport — 6,222 claims  
2. John F. Kennedy International — 4,831 claims  
3. Chicago O'Hare International Airport — 4,717 claims  
4. Newark International Airport — 4,554 claims  
5. Miami International Airport — 4,012 claims  

### Payout Trend

The analysis shows that average TSA claim payouts generally decreased from 2000 to 2009, with the highest average payouts occurring in the early 2000s.

---

## Author

**Kumari Sita**

Statistical Computing Project 3  
TSA Claims Analysis using R
