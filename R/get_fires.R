library(tidyverse)
library(readxl)
library(lubridate)
# https://data.london.gov.uk/dataset/london-fire-brigade-incident-records?resource=f5066d66-c7a3-415f-9629-026fbda61822
# dataset updated 25 days ago as of 15th Oct 24

temp1 <- tempfile()
temp2 <- tempfile()

# options(timeout = 1000) 
download.file("https://data.london.gov.uk/download/london-fire-brigade-incident-records/73728cf4-b70e-48e2-9b97-4e4341a2110d/LFB%20Incident%20data%20from%202009%20-%202017.csv", temp1)
download.file("https://data.london.gov.uk/download/london-fire-brigade-incident-records/f5066d66-c7a3-415f-9629-026fbda61822/LFB%20Incident%20data%20from%202018%20onwards.csv.xlsx", temp2)

raw_fires_09to17 <- read_csv(temp1)
raw_fires_18to24 <- read_xlsx(temp2)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# f_data <- read.csv("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/THdata/LFB Incident data with notional cost and UPRN from January 2009.csv")
# 
# col_name <- read_xlsx("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/THdata/Metadata.xlsx") %>% 
#   select(Column) %>% 
#   unlist()
# 
# col_name <- c(col_name, "last_col")
# 
# names(f_data) <- col_name
# 
# cat <- f_data %>% 
#   filter(PropertyCategory %in% c("Other Residential")) %>% 
#   distinct(PropertyType)
# 
# 
# # maybe check attendance times & race
# 
# hmo_unlicensed <- c("Unlicensed House in Multiple Occupation - Up to 2 storeys ",
#                     "Unlicensed House in Multiple Occupation - 3 or more storeys ")
# hmo_licensed <- c("Licensed House in Multiple Occupation - Up to 2 storeys ",
#                   "Licensed House in Multiple Occupation - 3 or more storeys ")
# hmo_unknown <- c("House in Multiple Occupation - 3 or more storeys (not known if licensed) ",
#                  "House in Multiple Occupation - Up to 2 storeys (not known if licensed) ")
# 
# 
# borough_list <- c("TOWER HAMLETS", "HACKNEY", "ISLINGTON", 
#                   "HARINGEY", "WALTHAM FOREST", "NEWHAM")
# 
# borough_list <- c("TOWER HAMLETS", "HACKNEY", "ISLINGTON", 
#                   "HARINGEY", "WALTHAM FOREST", "NEWHAM",
#                   "REDBRIDGE", "BARKING AND DAGENHAM",
#                   "CAMDEN", "WESTMINISTER", "GREENWICH",
#                   "SOUTHWARK", "LAMBETH", "LEWISHAM",
#                   "ENFIELD", "BARNET")
# 
# # check <- fires %>% 
# #   distinct(AddressQualifier)
# # what do these address qualifiers mean... should i leave them out.
# # location_list <- c("On land associated with building", "Open land/water - nearest gazetteer location",
# #                    "In street outside gazetteer location", # ...and others)
# 
# fire_type - primary fire, secondary fire, chimney fire...
# 
# 
# check <- f_data %>% 
#   distinct(IncGeo_WardName, IncGeo_WardNameNew) %>% 
#   mutate(change = ifelse(IncGeo_WardName == IncGeo_WardNameNew, "fine", "change!"))
# 
# 
# w22_shape <- st_read("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/CL_drive_data/Wards_December_2022_Boundaries_UK_BFC_-3416072881830331872 (1)/WD_DEC_2022_UK_BFC.shp")
# lsoa2ward <- read_xlsx("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/THdata/LSOA11_WD21_LAD21_EW_LU_V2.xlsx")
# 
# w11_shape <- st_read("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/THdata/Wards_December_2011_FEB_EW_2022_3913596174602688209/Wards_December_2011_FEB_EW.shp")
# 
# hmo_data <- read.csv("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/THdata/RM193-2021-2.csv")
# 
# 
# 
# 
# 
# fires <- f_data %>% 
#   filter(IncidentGroup == "Fire",
#          PropertyCategory %in% c("Dwelling")) %>%  #,  "Other Residential"
#   mutate(my_cat = "Other dwelling",
#          my_cat = ifelse(PropertyType %in% hmo_unlicensed, "HMO - unlicensed", my_cat),
#          my_cat = ifelse(PropertyType %in% hmo_licensed, "HMO - licensed", my_cat),
#          my_cat = ifelse(PropertyType %in% hmo_unknown, "HMO - unknown", my_cat)) %>% 
#   mutate(my_cat_sum = ifelse(my_cat == "Other dwelling", my_cat, "HMO")) %>% 
#   filter(
#     # IncGeo_BoroughName %in% borough_list,
#     IncGeo_WardName != "")
# 
# 
# london_borough <- fires %>% 
#   distinct(IncGeo_BoroughCode) %>% 
#   unlist()
# 
# hmo <- hmo_data %>% 
#   filter(Lower.tier.local.authorities.Code %in% london_borough) %>% 
#   rename(hmo = `Households.of.multiple.occupancy..HMO...3.categories.`,
#          subtype = `Accommodation.type..5.categories.`,
#          la = Lower.tier.local.authorities,
#          la_code = Lower.tier.local.authorities.Code) %>% 
#   select(-c(`Households.of.multiple.occupancy..HMO...3.categories..Code`, `Accommodation.type..5.categories..Code`)) %>% 
#   group_by(la, la_code) %>% 
#   mutate(pc = Observation/sum(Observation))
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
# 
# fires_hmo %>% 
#   ggplot(aes(fill=pc_fires)) +
#   geom_sf(colour="white") +
#   scale_fill_viridis(option = "magma")
# 
# 
# fires_hmo %>% 
#   ggplot(aes(fill=pc_dwellings)) +
#   geom_sf(colour="white") +
#   scale_fill_viridis(option = "magma")


# check <- fires %>% 
#   filter(IncGeo_BoroughName %in% borough_list) %>% 
#   distinct(IncGeo_WardCode, IncGeo_WardName) %>% 
#   rename(ward = IncGeo_WardCode) %>% 
#   left_join(w_shape %>% 
#               select(wd11cd, wd11nm, geometry) %>% 
#               rename(ward = wd11cd)) %>% 
#   st_drop_geometry() %>% 
#   filter(!is.na(wd11nm)) %>% 
#   distinct(ward, geometry) 


# st_as_sf() %>% 
# st_transform(crs = 4326)
# 
# 
# check <- fires %>% 
#   filter(IncGeo_BoroughName %in% borough_list) %>% 
#   distinct(IncGeo_BoroughCode, IncGeo_BoroughName) %>% 
#   rename(borough = IncGeo_BoroughCode) %>% 
#   left_join(w22_shape %>% 
#               select(LAD22CD, LAD22NM, geometry) %>% 
#               rename(borough = LAD22CD)) 
# 
# 
# check <- w22_shape %>% 
#   select(LAD22NM, WD22NM, WD22CD, geometry) %>% 
#   rename(borough = LAD22NM,
#          ward = WD22CD) %>% 
#   mutate(borough = toupper(borough)) %>% 
#   filter(borough %in% borough_list) %>% 
#   left_join(fires %>% 
#               filter(IncGeo_BoroughName %in% borough_list) %>% 
#               filter(my_cat_sum != "Other dwelling")  %>% 
#               distinct(IncGeo_WardCode, IncGeo_WardName) %>% 
#               rename(ward= IncGeo_WardCode))
# 
# 
# 
# check <- w22_shape %>% 
#   select(LAD22NM, WD22NM, WD22CD, geometry) %>% 
#   rename(borough = LAD22NM,
#          ward = WD22CD) %>% 
#   mutate(borough = toupper(borough)) %>% 
#   filter(borough %in% borough_list) %>% 
#   st_as_sf() %>% 
#   st_transform(crs = 4326) %>% 
#   # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
#   ggplot(aes(), fill="lightgrey") +
#   geom_sf(colour="white") 
# 
# 
# # +
#   scale_fill_viridis(option = "magma") 
# 
# check
# 
# # %>% 
#   st_drop_geometry() %>% 
#   filter(!is.na(wd11nm)) %>% 
#   distinct(ward, geometry) 





# yearly <- fires %>% 
#   select(CalYear, IncGeo_WardCode, IncGeo_BoroughName, my_cat_sum) %>% 
#   mutate(count = 1
#          # ,
#          # IncGeo_WardName = toupper(IncGeo_WardName)
#   ) %>% 
#   group_by(IncGeo_WardCode, IncGeo_BoroughName, my_cat_sum) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   pivot_wider(names_from = my_cat_sum,
#               values_from = count,
#               values_fill = 0) %>% 
#   pivot_longer(c("HMO", "Other dwelling"),
#                names_to = "my_cat_sum",
#                values_to = "count") %>% 
#   group_by(IncGeo_WardCode, IncGeo_BoroughName) %>% 
#   mutate(pc = count / sum(count)) %>% 
#   ungroup() %>%
#   rename(ward = IncGeo_WardCode) %>% 
#   filter(my_cat_sum != "Other dwelling") %>% 
#   filter(
#     # IncGeo_BoroughName %in% borough_list,
#     pc < 0.3)  %>%
#   left_join(w22_shape %>% 
#               select(WD22CD, geometry) %>% 
#               rename(ward = WD22CD)) %>% 
#   st_as_sf() %>% 
#   st_transform(crs = 4326) %>% 
#   # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
#   ggplot(aes(fill=pc)) +
#   geom_sf(colour="white") +
#   scale_fill_viridis(option = "magma",
#                      begin = 0.1,
#                      end = 0.9) 
# 
# # +
# # facet_wrap(~CalYear)
# # so actually the total pc is higher outside TH
# 
# yearly
# 
# 
# yearly <- fires %>% 
#   select(CalYear, IncGeo_WardCode, IncGeo_BoroughName, my_cat_sum) %>% 
#   mutate(count = 1
#          # ,
#          # IncGeo_WardName = toupper(IncGeo_WardName)
#   ) %>% 
#   group_by(IncGeo_WardCode, IncGeo_BoroughName, my_cat_sum) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   pivot_wider(names_from = my_cat_sum,
#               values_from = count,
#               values_fill = 0) %>% 
#   pivot_longer(c("HMO", "Other dwelling"),
#                names_to = "my_cat_sum",
#                values_to = "count") %>% 
#   group_by(IncGeo_WardCode, IncGeo_BoroughName) %>% 
#   mutate(pc = count / sum(count)) %>% 
#   ungroup() %>%
#   rename(ward = IncGeo_WardCode) %>% 
#   filter(my_cat_sum != "Other dwelling") %>% 
#   # filter(
#   # IncGeo_BoroughName %in% borough_list,
#   #   pc < 0.3)  %>% 
#   left_join(w22_shape %>% 
#               select(WD22CD, geometry) %>% 
#               rename(ward = WD22CD)) %>% 
#   st_as_sf() %>% 
#   st_transform(crs = 4326) %>% 
#   # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
#   ggplot(aes(fill=count)) +
#   geom_sf(colour="white") +
#   scale_fill_viridis(option = "mako") 
# 
# # +
# # facet_wrap(~CalYear)
# # so actually the total pc is higher outside TH
# 
# 
# 
# yearly <- fires %>% 
#   select(CalYear, IncGeo_WardCode, IncGeo_BoroughName, my_cat_sum) %>% 
#   mutate(count = 1
#          # ,
#          # IncGeo_WardName = toupper(IncGeo_WardName)
#   ) %>% 
#   group_by(IncGeo_WardCode, IncGeo_BoroughName, my_cat_sum) %>% 
#   # filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   pivot_wider(names_from = my_cat_sum,
#               values_from = count,
#               values_fill = 0) %>% 
#   pivot_longer(c("HMO", "Other dwelling"),
#                names_to = "my_cat_sum",
#                values_to = "count") %>% 
#   group_by(IncGeo_WardCode, IncGeo_BoroughName) %>% 
#   mutate(pc = count / sum(count)) %>% 
#   ungroup() %>%
#   rename(ward = IncGeo_WardCode) %>% 
#   filter(my_cat_sum != "Other dwelling") %>% 
#   # filter(
#   # IncGeo_BoroughName %in% borough_list,
#   #   pc < 0.3)  %>% 
#   left_join(w22_shape %>% 
#               select(WD22CD, geometry) %>% 
#               rename(ward = WD22CD)) %>% 
#   st_as_sf() %>% 
#   st_transform(crs = 4326) %>% 
#   # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
#   ggplot(aes(fill=count)) +
#   geom_sf(colour="white") +
#   scale_fill_viridis(option = "mako",
#                      begin = 0.1,
#                      end = 0.9)
# 
# 
# 
# 
# yearly <- fires %>% 
#   select(CalYear, IncGeo_WardCode, IncGeo_BoroughName, FirstPumpArriving_AttendanceTime, my_cat_sum) %>% 
#   # mutate(count = 1
#   #        # ,
#   #        # IncGeo_WardName = toupper(IncGeo_WardName)
#   # ) %>% 
#   filter(FirstPumpArriving_AttendanceTime != "NULL")  %>% 
#   group_by(IncGeo_WardCode, my_cat_sum) %>% 
#   summarise(count = mean(as.numeric(FirstPumpArriving_AttendanceTime), na.rm = T)) %>% 
#   ungroup() %>% 
#   pivot_wider(names_from = my_cat_sum,
#               values_from = count,
#               values_fill = 0) %>% 
#   pivot_longer(c("HMO", "Other dwelling"),
#                names_to = "my_cat_sum",
#                values_to = "count") %>% 
#   rename(ward = IncGeo_WardCode) %>% 
#   filter(my_cat_sum != "Other dwelling") %>% 
#   # filter(
#   # IncGeo_BoroughName %in% borough_list,
#   #   pc < 0.3)  %>% 
#   left_join(w22_shape %>% 
#               select(WD22CD, geometry) %>% 
#               rename(ward = WD22CD)) %>% 
#   st_as_sf() %>% 
#   st_transform(crs = 4326) %>% 
#   # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
#   ggplot(aes(fill=count)) +
#   geom_sf(colour="white") +
#   scale_fill_viridis(option = "mako",
#                      begin = 0.1,
#                      end = 0.9)
# 
# 
# yearly
# 
# yearly <- fires %>% 
#   select(CalYear, IncGeo_WardCode, my_cat) %>% 
#   filter(my_cat != "Other dwelling") %>% 
#   mutate(count = 1
#          # ,
#          # IncGeo_WardName = toupper(IncGeo_WardName)
#   ) %>% 
#   group_by(IncGeo_WardCode, my_cat) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   pivot_wider(names_from = my_cat,
#               values_from = count,
#               values_fill = 0) %>% 
#   pivot_longer(c("HMO - unlicensed", "HMO - unknown", "HMO - licensed"),
#                names_to = "my_cat",
#                values_to = "count") %>% 
#   group_by(IncGeo_WardCode) %>% 
#   mutate(pc = count / sum(count)) %>% 
#   ungroup() %>%
#   rename(ward = IncGeo_WardCode) %>% 
#   filter(my_cat %in% c("HMO - unlicensed", "HMO - unknown")) %>% 
#   group_by(ward) %>% 
#   summarise(pc = sum(pc)) %>% 
#   # filter(
#   #   # IncGeo_BoroughName %in% borough_list,
#   #   pc < 0.3)  %>% 
#   left_join(w22_shape %>% 
#               select(WD22CD, geometry) %>% 
#               rename(ward = WD22CD)) %>% 
#   st_as_sf() %>% 
#   st_transform(crs = 4326) %>% 
#   # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
#   ggplot() +
#   geom_sf(data = fires %>% 
#             distinct(IncGeo_WardCode) %>% 
#             rename(ward = IncGeo_WardCode) %>% 
#             mutate(count = 1) %>% 
#             left_join(w22_shape %>% 
#                         select(WD22CD, geometry) %>%
#                         rename(ward = WD22CD)) %>% 
#             st_as_sf() %>%
#             st_transform(crs = 4326), aes(), colour="white", fill = "grey") +
#   geom_sf(aes(fill=pc), colour="white") +
#   scale_fill_viridis(option = "rocket",
#                      begin = 0.2,
#                      end = 0.8)
# # +
# # facet_wrap(~CalYear)
# # so actually the total pc is higher outside TH
# 
# yearly
# 
# 
# 
# yearly <- fires %>% 
#   select(CalYear, IncGeo_WardCode, my_cat) %>% 
#   filter(my_cat != "Other dwelling") %>% 
#   mutate(count = 1) %>% 
#   filter(my_cat %in% c("HMO - unlicensed", "HMO - unknown")) %>% 
#   group_by(IncGeo_WardCode) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   rename(ward = IncGeo_WardCode) %>% 
#   # filter(
#   #   # IncGeo_BoroughName %in% borough_list,
#   #   pc < 0.3)  %>% 
#   left_join(w22_shape %>% 
#               select(WD22CD, geometry) %>% 
#               rename(ward = WD22CD)) %>% 
#   st_as_sf() %>% 
#   st_transform(crs = 4326) %>% 
#   # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
#   ggplot() +
#   geom_sf(data = fires %>% 
#             distinct(IncGeo_WardCode) %>% 
#             rename(ward = IncGeo_WardCode) %>% 
#             mutate(count = 1) %>% 
#             left_join(w22_shape %>% 
#                         select(WD22CD, geometry) %>%
#                         rename(ward = WD22CD)) %>% 
#             st_as_sf() %>%
#             st_transform(crs = 4326), aes(), colour="white", fill = "grey") +
#   geom_sf(aes(fill=count), colour="white") +
#   scale_fill_viridis(option = "magma",
#                      begin = 0.2,
#                      end = 0.8)
# # +
# # facet_wrap(~CalYear)
# # so actually the total pc is higher outside TH
# 
# yearly
# 
# 
# 
# 
# 
# yearly <- fires %>% 
#   filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
#   select(CalYear, IncGeo_WardCode, my_cat_sum) %>% 
#   mutate(count = 1
#          # ,
#          # IncGeo_WardName = toupper(IncGeo_WardName)
#   ) %>% 
#   group_by(CalYear, IncGeo_WardCode, my_cat_sum) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   pivot_wider(names_from = my_cat_sum,
#               values_from = count,
#               values_fill = 0) %>% 
#   pivot_longer(c("HMO", "Other dwelling"),
#                names_to = "my_cat_sum",
#                values_to = "count") %>% 
#   group_by(CalYear, IncGeo_WardCode) %>% 
#   mutate(pc = count / sum(count)) %>% 
#   ungroup() %>%
#   rename(ward = IncGeo_WardCode) %>% 
#   filter(my_cat_sum != "Other dwelling") %>% 
#   # filter(
#   #   # IncGeo_BoroughName %in% borough_list,
#   #   pc < 0.3)  %>% 
#   left_join(w22_shape %>% 
#               select(WD22CD, geometry) %>% 
#               rename(ward = WD22CD)) %>% 
#   st_as_sf() %>% 
#   st_transform(crs = 4326) %>% 
#   # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
#   ggplot(aes(fill=count)) +
#   geom_sf(colour="white") +
#   scale_fill_viridis(option = "magma") +
#   facet_wrap(~CalYear)
# # so actually the total pc is higher outside TH
# 
# yearly
# 
# 
# 
# yearly <- fires %>% 
#   filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
#   select(CalYear, IncGeo_WardCode, my_cat) %>% 
#   mutate(count = 1
#          # ,
#          # IncGeo_WardName = toupper(IncGeo_WardName)
#   ) %>% 
#   group_by(IncGeo_WardCode, my_cat) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   pivot_wider(names_from = my_cat,
#               values_from = count,
#               values_fill = 0) %>% 
#   pivot_longer(c("HMO - licensed", "Other dwelling", "HMO - unlicensed", "HMO - unknown"),
#                names_to = "my_cat",
#                values_to = "count") %>% 
#   group_by(IncGeo_WardCode) %>% 
#   mutate(pc = count / sum(count)) %>% 
#   filter(my_cat != "Other dwelling") %>% 
#   ungroup() %>%
#   rename(ward = IncGeo_WardCode) %>% 
#   # filter(
#   #   # IncGeo_BoroughName %in% borough_list,
#   #   pc < 0.3)  %>% 
#   left_join(w22_shape %>% 
#               select(WD22CD, geometry) %>% 
#               rename(ward = WD22CD)) %>% 
#   st_as_sf() %>% 
#   st_transform(crs = 4326) %>% 
#   # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
#   ggplot(aes(fill=pc)) +
#   geom_sf(colour="white") +
#   scale_fill_viridis(option = "magma") +
#   facet_wrap(~my_cat)
# # so actually the total pc is higher outside TH
# 
# yearly
# 
# 
# 
# 
# yearly <- fires %>% 
#   mutate(date = dmy(DateOfCall),
#          month_yr = as.yearmon(date, "%Y %m")) %>% 
#   select(month_yr, my_cat) %>% 
#   group_by(month_yr, my_cat) %>% 
#   mutate(count = 1) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   group_by(month_yr) %>% 
#   mutate(pc = count / sum(count)) %>% 
#   ungroup() %>%
#   select(-count) %>% 
#   filter(my_cat != "Other dwelling") %>% 
#   group_by(my_cat) %>% 
#   arrange(month_yr) %>% 
#   mutate(pc = rollmean(pc, k = 3, fill = NA, align = "center")) %>%
#   mutate(pc = rollmean(pc, k = 3, fill = NA, align = "center")) %>%
#   pivot_wider(names_from = my_cat,
#               values_from = pc,
#               values_fill = 0) %>% 
#   ggplot() +
#   geom_line(aes(x = month_yr, y=`HMO - unknown`), colour = "darkgrey") +
#   geom_line(aes(x = month_yr, y=`HMO - unlicensed` + `HMO - unknown`), colour = "#A4661EFF") +
#   geom_line(aes(x = month_yr, y=`HMO - licensed`+ `HMO - unknown` + `HMO - unlicensed`), colour = "#3A488AFF") +
#   geom_ribbon(aes(x = month_yr, ymin=0, ymax=`HMO - unknown`), fill="darkgrey", alpha=0.5) +
#   geom_ribbon(aes(x = month_yr, ymin=`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`), fill="#D9D6A6FF", alpha=0.5) +
#   geom_ribbon(aes(x = month_yr, ymin=`HMO - unlicensed`+`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`+`HMO - licensed`), fill="#9BB0FEFF", alpha=0.5) 
# 
# yearly  
# 
# 
# 
# 
# yearly <- fires %>% 
#   mutate(date = dmy(DateOfCall),
#          month_yr = as.yearmon(date, "%Y %m")) %>% 
#   select(month_yr, my_cat) %>% 
#   group_by(month_yr, my_cat) %>% 
#   mutate(count = 1) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   filter(my_cat != "Other dwelling") %>% 
#   group_by(my_cat) %>% 
#   arrange(month_yr) %>% 
#   mutate(count = rollmean(count, k = 3, fill = NA, align = "center")) %>%
#   mutate(count = rollmean(count, k = 3, fill = NA, align = "center")) %>%
#   pivot_wider(names_from = my_cat,
#               values_from = count,
#               values_fill = 0)  %>%
#   ggplot() +
#   geom_line(aes(x = month_yr, y=`HMO - unknown`), colour = "darkgrey") +
#   geom_line(aes(x = month_yr, y=`HMO - unlicensed` + `HMO - unknown`), colour = "#A4661EFF") +
#   geom_line(aes(x = month_yr, y=`HMO - licensed`+ `HMO - unknown` + `HMO - unlicensed`), colour = "#3A488AFF") +
#   geom_ribbon(aes(x = month_yr, ymin=0, ymax=`HMO - unknown`), fill="darkgrey", alpha=0.5) +
#   geom_ribbon(aes(x = month_yr, ymin=`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`), fill="#D9D6A6FF", alpha=0.5) +
#   geom_ribbon(aes(x = month_yr, ymin=`HMO - unlicensed`+`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`+`HMO - licensed`), fill="#9BB0FEFF", alpha=0.5) 
# 
# yearly
# 
# as.Date()
# library(scales)
# # +
# # theme(strip.text = element_blank()) +
# # scale_x_continuous(name = "") +
# # scale_y_continuous(name = "",
# #                    limits = c(0, 50),
# #                    expand = c(0,0))
# 
# yearly  
# 
# 
# yearly <- fires %>% 
#   filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
#   mutate(date = dmy(DateOfCall),
#          month_yr = as.yearmon(date, "%Y %m")) %>% 
#   select(month_yr, my_cat) %>% 
#   group_by(month_yr, my_cat) %>% 
#   mutate(count = 1) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   group_by(my_cat) %>% 
#   arrange(month_yr) %>% 
#   mutate(count = rollmean(count, k = 6, fill = 0, align = "center")) %>%
#   mutate(count = rollmean(count, k = 6, fill = 0, align = "center")) %>%
#   pivot_wider(names_from = my_cat,
#               values_from = count,
#               values_fill = 0)  %>%
#   ggplot() +
#   geom_line(aes(x = month_yr, y=`HMO - unknown`), colour = "darkgrey") +
#   geom_line(aes(x = month_yr, y=`HMO - unlicensed` + `HMO - unknown`), colour = "#A4661EFF") +
#   geom_line(aes(x = month_yr, y=`HMO - licensed`+ `HMO - unknown` + `HMO - unlicensed`), colour = "#3A488AFF") +
#   geom_line(aes(x = month_yr, y=`HMO - licensed`+ `HMO - unknown` + `HMO - unlicensed`+`Other dwelling`), colour = "#3A488AFF") +
#   geom_ribbon(aes(x = month_yr, ymin=0, ymax=`HMO - unknown`), fill="darkgrey", alpha=0.5) +
#   geom_ribbon(aes(x = month_yr, ymin=`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`), fill="#D9D6A6FF", alpha=0.5) +
#   geom_ribbon(aes(x = month_yr, ymin=`HMO - unlicensed`+`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`+`HMO - licensed`), fill="#9BB0FEFF", alpha=0.5) + 
#   geom_ribbon(aes(x = month_yr, ymin=`HMO - unlicensed`+`HMO - unknown`+`HMO - licensed`, ymax=`HMO - unlicensed`+`HMO - unknown`+`HMO - licensed`+`Other dwelling`), fill="#9BB0FEFF", alpha=0.5) 
# yearly
# 
# 
# 
# 
# yearly <- fires %>% 
#   filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
#   mutate(date = dmy(DateOfCall),
#          month_yr = as.yearmon(date, "%Y %m")) %>% 
#   select(month_yr) %>% 
#   group_by(month_yr) %>% 
#   mutate(count = 1) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   arrange(month_yr) %>% 
#   mutate(count = rollmean(count, k = 3, fill = NA, align = "center")) %>%
#   # mutate(count = rollmean(count, k = 3, fill = 0, align = "center")) %>%
#   ggplot() +
#   geom_line(aes(x = month_yr, y=count), colour = "#3A488AFF") +
#   geom_ribbon(aes(x = month_yr, ymin=0, ymax=count), fill="#9BB0FEFF", alpha=0.5) 
# yearly
# 
# 
# yearly <- fires %>% 
#   filter(IncGeo_BoroughName == "TOWER HAMLETS",
#          my_cat != "Other dwelling") %>% 
#   select(CalYear, my_cat) %>% 
#   group_by(CalYear, my_cat) %>% 
#   mutate(count = 1) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   # arrange(month_yr) %>% 
#   # mutate(count = rollmean(count, k = 3, fill = NA, align = "center")) %>%
#   # mutate(count = rollmean(count, k = 3, fill = 0, align = "center")) %>%
#   ggplot() +
#   geom_bar(aes(x = CalYear, y=count, fill = my_cat), stat = "identity", position = "stack")
# # geom_ribbon(aes(x = month_yr, ymin=0, ymax=count), fill="#9BB0FEFF", alpha=0.5) 
# yearly
# 
# 
# 
# 
# 
# yearly <- fires %>% 
#   filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
#   mutate(date = dmy(DateOfCall),
#          month_yr = as.yearmon(date, "%Y %m")) %>% 
#   select(month_yr) %>% 
#   group_by(month_yr) %>% 
#   mutate(count = 1) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   arrange(month_yr) %>% 
#   mutate(count = rollmean(count, k = 3, fill = NA, align = "center")) %>%
#   left_join(fires %>% 
#               filter(IncGeo_BoroughName != "TOWER HAMLETS") %>% 
#               mutate(date = dmy(DateOfCall),
#                      month_yr = as.yearmon(date, "%Y %m")) %>% 
#               select(month_yr) %>% 
#               group_by(month_yr) %>% 
#               mutate(count = 1) %>% 
#               summarise(count = sum(count)) %>% 
#               ungroup() %>% 
#               arrange(month_yr) %>% 
#               mutate(tot_count = rollmean(count, k = 3, fill = NA, align = "center")) %>% 
#               select(-count)) %>% 
#   ggplot() +
#   geom_line(aes(x = month_yr, y=count), colour = "#881C00FF") +
#   geom_line(aes(x = month_yr, y=count+tot_count), colour = "#172869FF") +
#   geom_ribbon(aes(x = month_yr, ymin=0, ymax=count), fill="#AF6125FF", alpha=0.5) +
#   geom_ribbon(aes(x = month_yr, ymin=count, ymax=count+tot_count), fill="#0076BBFF", alpha=0.5) 
# yearly
# 
# 
# 
# yearly <- fires %>% 
#   select(CalYear, IncGeo_WardName, IncGeo_BoroughName, my_cat) %>% 
#   mutate(IncGeo_WardName = toupper(IncGeo_WardName)) %>% 
#   mutate(count = 1) %>% 
#   group_by(CalYear, IncGeo_WardName, IncGeo_BoroughName, my_cat) %>% 
#   summarise(count = sum(count)) %>% 
#   ungroup() %>% 
#   group_by(CalYear, IncGeo_WardName, IncGeo_BoroughName) %>% 
#   mutate(pc = count / sum(count)) %>% 
#   ungroup() %>%
#   select(-count) %>% 
#   filter(my_cat != "Other dwelling") %>% 
#   pivot_wider(names_from = my_cat,
#               values_from = pc,
#               values_fill = 0) %>% 
#   filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
#   ggplot() +
#   geom_line(aes(x = CalYear, y=`HMO - unlicensed`, colour = IncGeo_WardName))
# 
# yearly  
# 
# 
# # +
# geom_line(aes(x = end_period_year, y=`AP-Free`+`BSS-CBS`), colour="#B48A2CFF") +
#   geom_ribbon(aes(x = end_period_year, ymin=0,ymax=`BSS-CBS`), fill="#9BB0FEFF", alpha=0.5) +
#   geom_ribbon(aes(x = end_period_year, ymin=`BSS-CBS`,ymax=`AP-Free`+`BSS-CBS`), fill="#DCD66EFF", alpha=0.5) +
#   facet_grid(cols = vars(fsm)) +
#   
#   