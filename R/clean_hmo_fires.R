# cat <- f_data %>% 
#   distinct(PropertyCategory, PropertyType)


hmo_unlicensed <- c("Unlicensed House in Multiple Occupation - Up to 2 storeys ",
                    "Unlicensed House in Multiple Occupation - 3 or more storeys ")
hmo_licensed <- c("Licensed House in Multiple Occupation - Up to 2 storeys ",
                  "Licensed House in Multiple Occupation - 3 or more storeys ")
hmo_unknown <- c("House in Multiple Occupation - 3 or more storeys (not known if licensed) ",
                 "House in Multiple Occupation - Up to 2 storeys (not known if licensed) ")


borough_list <- c("TOWER HAMLETS", "HACKNEY", "ISLINGTON", 
                  "HARINGEY", "WALTHAM FOREST", "NEWHAM")

borough_list <- c("TOWER HAMLETS", "HACKNEY", "ISLINGTON", 
                  "HARINGEY", "WALTHAM FOREST", "NEWHAM",
                  "REDBRIDGE", "BARKING AND DAGENHAM",
                  "CAMDEN", "WESTMINISTER", "GREENWICH",
                  "SOUTHWARK", "LAMBETH", "LEWISHAM",
                  "ENFIELD", "BARNET")

check <- f_data %>% 
  distinct(IncGeo_WardName, IncGeo_WardNameNew) %>% 
  mutate(change = ifelse(IncGeo_WardName == IncGeo_WardNameNew, "fine", "change!"))


fires <- f_data %>% 
  filter(IncidentGroup == "Fire",
         PropertyCategory %in% c("Dwelling")) %>%  #,  "Other Residential"
  mutate(my_cat = "Other dwelling",
         my_cat = ifelse(PropertyType %in% hmo_unlicensed, "HMO - unlicensed", my_cat),
         my_cat = ifelse(PropertyType %in% hmo_licensed, "HMO - licensed", my_cat),
         my_cat = ifelse(PropertyType %in% hmo_unknown, "HMO - unknown", my_cat)) %>% 
  mutate(my_cat_sum = ifelse(my_cat == "Other dwelling", my_cat, "HMO")) %>% 
  filter(
    # IncGeo_BoroughName %in% borough_list,
    IncGeo_WardName != "")


london_borough <- fires %>% 
  distinct(IncGeo_BoroughCode) %>% 
  unlist()

hmo <- hmo_data %>% 
  filter(Lower.tier.local.authorities.Code %in% london_borough) %>% 
  rename(hmo = `Households.of.multiple.occupancy..HMO...3.categories.`,
         subtype = `Accommodation.type..5.categories.`,
         la = Lower.tier.local.authorities,
         la_code = Lower.tier.local.authorities.Code) %>% 
  select(-c(`Households.of.multiple.occupancy..HMO...3.categories..Code`, `Accommodation.type..5.categories..Code`)) %>% 
  group_by(la, la_code) %>% 
  mutate(pc = Observation/sum(Observation))


fires_hmo <- fires %>% 
  select(CalYear, IncGeo_BoroughCode, IncGeo_WardCode, my_cat_sum) %>% 
  mutate(count = 1) %>% 
  filter(CalYear %in% c(2020:2022)) %>% 
  group_by(IncGeo_BoroughCode, IncGeo_WardCode, my_cat_sum) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = my_cat_sum,
              values_from = count,
              values_fill = 0) %>% 
  pivot_longer(c("HMO", "Other dwelling"),
               names_to = "my_cat_sum",
               values_to = "count") %>% 
  group_by(IncGeo_WardCode) %>% 
  mutate(pc_fires = count / sum(count)) %>% 
  ungroup() %>%
  rename(ward = IncGeo_WardCode,
         borough = IncGeo_BoroughCode) %>% 
  filter(my_cat_sum != "Other dwelling") %>% 
  left_join(hmo %>% 
              mutate(hmo_sum = ifelse(hmo == "Does not apply", "Not HMO", "HMO")) %>% 
              group_by(la_code, hmo_sum) %>% 
              summarise(pc_dwellings = sum(pc)) %>% 
              filter(hmo_sum != "Not HMO") %>% 
              rename(borough = la_code)) %>% 
  left_join(w22_shape %>% 
              select(WD22CD, geometry) %>% 
              rename(ward = WD22CD)) %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326)
