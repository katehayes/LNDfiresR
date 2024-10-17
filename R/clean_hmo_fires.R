load("data/raw/raw_fires_09to17.RData")
load("data/raw/raw_fires_18to24.RData")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

 # cat <- raw_fires_09to17 %>% 
 #  distinct(PropertyCategory, PropertyType)

# check <- raw_fires_09to17 %>% 
#   distinct(IncGeo_WardName, IncGeo_WardNameNew) %>% 
#   mutate(change = ifelse(IncGeo_WardName == IncGeo_WardNameNew, "fine", "change!"))

hmo_unlicensed <- c("Unlicensed House in Multiple Occupation - Up to 2 storeys",
                    "Unlicensed House in Multiple Occupation - 3 or more storeys")
hmo_licensed <- c("Licensed House in Multiple Occupation - Up to 2 storeys",
                  "Licensed House in Multiple Occupation - 3 or more storeys")
hmo_unknown <- c("House in Multiple Occupation - 3 or more storeys (not known if licensed)",
                 "House in Multiple Occupation - Up to 2 storeys (not known if licensed)")



# borough_list <- c("TOWER HAMLETS", "HACKNEY", "ISLINGTON", 
#                   "HARINGEY", "WALTHAM FOREST", "NEWHAM")
# 
# borough_list <- c("TOWER HAMLETS", "HACKNEY", "ISLINGTON", 
#                   "HARINGEY", "WALTHAM FOREST", "NEWHAM",
#                   "REDBRIDGE", "BARKING AND DAGENHAM",
#                   "CAMDEN", "WESTMINISTER", "GREENWICH",
#                   "SOUTHWARK", "LAMBETH", "LEWISHAM",
#                   "ENFIELD", "BARNET")

ldn_borough_codes <- raw_fires_09to17 %>% 
  distinct(IncGeo_BoroughCode) %>% 
  unlist()


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

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

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 


hmo <- raw_hmo %>% 
  filter(`Lower tier local authorities Code` %in% ldn_borough_codes) %>% 
  rename(hmo_size = `Households of multiple occupancy (HMO) (3 categories)`,
         property_type = `Accommodation type (5 categories)`,
         la = `Lower tier local authorities`,
         count = Observation)  %>% 
  select(c(la, hmo_size, property_type, count))

# 
# 
# 
# 
# fires_hmo <- fires %>% 
#   select(CalYear, IncGeo_BoroughCode, IncGeo_WardCode, my_cat_sum) %>% 
#   mutate(count = 1) %>% 
#   filter(CalYear %in% c(2020:2022)) %>% 
#   group_by(IncGeo_BoroughCode, IncGeo_WardCode, my_cat_sum) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   pivot_wider(names_from = my_cat_sum,
#               values_from = count,
#               values_fill = 0) %>% 
#   pivot_longer(c("HMO", "Other dwelling"),
#                names_to = "my_cat_sum",
#                values_to = "count") %>% 
#   group_by(IncGeo_WardCode) %>% 
#   mutate(pc_fires = count / sum(count)) %>% 
#   ungroup() %>%
#   rename(ward = IncGeo_WardCode,
#          borough = IncGeo_BoroughCode) %>% 
#   filter(my_cat_sum != "Other dwelling") %>% 
#   left_join(hmo %>% 
#               mutate(hmo_sum = ifelse(hmo == "Does not apply", "Not HMO", "HMO")) %>% 
#               group_by(la_code, hmo_sum) %>% 
#               summarise(pc_dwellings = sum(pc)) %>% 
#               filter(hmo_sum != "Not HMO") %>% 
#               rename(borough = la_code)) %>% 
#   left_join(w22_shape %>% 
#               select(WD22CD, geometry) %>% 
#               rename(ward = WD22CD)) %>% 
#   st_as_sf() %>% 
#   st_transform(crs = 4326)
