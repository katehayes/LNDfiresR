library(tidyverse)
library(readxl)
library(lubridate)

# Getting the fires data from the online repository

# https://data.london.gov.uk/dataset/london-fire-brigade-incident-records?resource=f5066d66-c7a3-415f-9629-026fbda61822
# dataset updated 25 days ago as of 15th Oct 24

temp1 <- tempfile()
temp2 <- tempfile()

# options(timeout = 1000) 
download.file("https://data.london.gov.uk/download/london-fire-brigade-incident-records/73728cf4-b70e-48e2-9b97-4e4341a2110d/LFB%20Incident%20data%20from%202009%20-%202017.csv", temp1)
download.file("https://data.london.gov.uk/download/london-fire-brigade-incident-records/f5066d66-c7a3-415f-9629-026fbda61822/LFB%20Incident%20data%20from%202018%20onwards.csv.xlsx", temp2)

raw_fires_09to17 <- read_csv(temp1)
raw_fires_18to24 <- read_xlsx(temp2)

# save(raw_fires_09to17, file = "data/raw/raw_fires_09to17.RData")
# save(raw_fires_18to24, file = "data/raw/raw_fires_18to24.RData")


# Cleaning the data 

# cat <- raw_fires_09to17 %>% 
#  distinct(PropertyCategory, PropertyType)

hmo_unlicensed <- c("Unlicensed House in Multiple Occupation - Up to 2 storeys",
                    "Unlicensed House in Multiple Occupation - 3 or more storeys")
hmo_licensed <- c("Licensed House in Multiple Occupation - Up to 2 storeys",
                  "Licensed House in Multiple Occupation - 3 or more storeys")
hmo_unknown <- c("House in Multiple Occupation - 3 or more storeys (not known if licensed)",
                 "House in Multiple Occupation - Up to 2 storeys (not known if licensed)")

# check <- raw_fires_09to17 %>% 
#   distinct(IncGeo_WardName, IncGeo_WardNameNew) %>% 
#   mutate(change = ifelse(IncGeo_WardName == IncGeo_WardNameNew, "fine", "not fine!"))
# ward names have very small inconsistencies between years- will use codes

# borough_list <- c("TOWER HAMLETS", "HACKNEY", "ISLINGTON", 
#                   "HARINGEY", "WALTHAM FOREST", "NEWHAM")



fires <- raw_fires_09to17 %>% 
  mutate(DateOfCall = dmy(DateOfCall),
         TimeOfCall = format(as.POSIXct(TimeOfCall), format = "%H:%M:%S"),
         UPRN = as.double(UPRN),
         USRN = as.double(USRN),
         NumCalls = as.double(NumCalls)) %>%
  bind_rows(raw_fires_18to24 %>% 
              mutate(TimeOfCall = format(as.POSIXct(TimeOfCall), format = "%H:%M:%S"))) %>% 
  filter(IncidentGroup == "Fire",
         PropertyCategory %in% c("Dwelling")) %>%  #,  "Other Residential"
  # No longitude or latitude given for any dwellings
  # filter(AddressQualifier == "Correct incident location") %>%  # ?
  mutate(hmo_license = "Other dwelling",
         hmo_license = ifelse(PropertyType %in% hmo_unlicensed, "HMO - unlicensed", hmo_license),
         hmo_license = ifelse(PropertyType %in% hmo_licensed, "HMO - licensed", hmo_license),
         hmo_license = ifelse(PropertyType %in% hmo_unknown, "HMO - unknown", hmo_license)) %>% 
  mutate(hmo_yn = ifelse(hmo_license == "Other dwelling", hmo_license, "HMO")) %>% 
  rename(date = DateOfCall,
         property_type = PropertyType,
         borough = IncGeo_BoroughCode,
         ward = IncGeo_WardCode,
         easting_rounded = Easting_rounded,
         northing_rounded = Northing_rounded) %>% 
  select(date, borough, ward, easting_rounded, northing_rounded, hmo_yn, hmo_license, property_type)
# filter(borough %in% borough_list)

# save(fires, file = "data/fires.RData")


# Getting a list of the London borough codes here
# Going to use them to filter the HMO dataset

ldn_borough_codes <- raw_fires_09to17 %>%
  distinct(IncGeo_BoroughCode) %>%
  unlist()

# save(ldn_borough_codes, file = "data/ldn_borough_codes.RData")

