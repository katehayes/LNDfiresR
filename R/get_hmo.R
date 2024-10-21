library(httr)
library(jsonlite)

# Getting the HMO data from the repository

# https://ons.gov.uk/datasets/RM193/editions/2021/versions/2
temp1 <- tempfile()
download.file("https://s3.eu-west-1.amazonaws.com/statistics.digitalresources.jisc.ac.uk/dkan/files/2021/ONS/number-of-households-that-are-in-HMO/by-accomodation-type/RM193-Number-Of-Households-In-Houses-In-Multiple-Occupation-(Hmo)-By-Accommodation-Type-2021-ltla-ONS.xlsx", temp1)
raw_hmo <- read_xlsx(temp1)

# save(raw_hmo, file = "data/raw/raw_hmo.RData")

# Cleaning the HMO data:
# keeping London data only, throwing out unnecessary columns
# re-naming some variables to make them easier to work with

# load("data/ldn_borough_codes.RData")

hmo <- raw_hmo %>% 
filter(`Lower tier local authorities Code` %in% ldn_borough_codes) %>% 
  rename(hmo_size = `Households of multiple occupancy (HMO) (3 categories)`,
         property_type = `Accommodation type (5 categories)`,
         la_code = `Lower tier local authorities Code`,
         la = `Lower tier local authorities`,
         count = Observation)  %>% 
  select(c(la_code, la, hmo_size, property_type, count))

# save(hmo, file = "data/hmo.RData")
