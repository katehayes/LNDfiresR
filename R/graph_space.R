fires_hmo %>% 
  ggplot(aes(fill=pc_fires)) +
  geom_sf(colour="white") +
  scale_fill_viridis(option = "magma")


fires_hmo %>% 
  ggplot(aes(fill=pc_dwellings)) +
  geom_sf(colour="white") +
  scale_fill_viridis(option = "magma")


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





yearly <- fires %>% 
  select(CalYear, IncGeo_WardCode, IncGeo_BoroughName, my_cat_sum) %>% 
  mutate(count = 1
         # ,
         # IncGeo_WardName = toupper(IncGeo_WardName)
  ) %>% 
  group_by(IncGeo_WardCode, IncGeo_BoroughName, my_cat_sum) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = my_cat_sum,
              values_from = count,
              values_fill = 0) %>% 
  pivot_longer(c("HMO", "Other dwelling"),
               names_to = "my_cat_sum",
               values_to = "count") %>% 
  group_by(IncGeo_WardCode, IncGeo_BoroughName) %>% 
  mutate(pc = count / sum(count)) %>% 
  ungroup() %>%
  rename(ward = IncGeo_WardCode) %>% 
  filter(my_cat_sum != "Other dwelling") %>% 
  filter(
    # IncGeo_BoroughName %in% borough_list,
    pc < 0.3)  %>%
  left_join(w22_shape %>% 
              select(WD22CD, geometry) %>% 
              rename(ward = WD22CD)) %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
  ggplot(aes(fill=pc)) +
  geom_sf(colour="white") +
  scale_fill_viridis(option = "magma",
                     begin = 0.1,
                     end = 0.9) 

# +
# facet_wrap(~CalYear)
# so actually the total pc is higher outside TH

yearly


yearly <- fires %>% 
  select(CalYear, IncGeo_WardCode, IncGeo_BoroughName, my_cat_sum) %>% 
  mutate(count = 1
         # ,
         # IncGeo_WardName = toupper(IncGeo_WardName)
  ) %>% 
  group_by(IncGeo_WardCode, IncGeo_BoroughName, my_cat_sum) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = my_cat_sum,
              values_from = count,
              values_fill = 0) %>% 
  pivot_longer(c("HMO", "Other dwelling"),
               names_to = "my_cat_sum",
               values_to = "count") %>% 
  group_by(IncGeo_WardCode, IncGeo_BoroughName) %>% 
  mutate(pc = count / sum(count)) %>% 
  ungroup() %>%
  rename(ward = IncGeo_WardCode) %>% 
  filter(my_cat_sum != "Other dwelling") %>% 
  # filter(
  # IncGeo_BoroughName %in% borough_list,
  #   pc < 0.3)  %>% 
  left_join(w22_shape %>% 
              select(WD22CD, geometry) %>% 
              rename(ward = WD22CD)) %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
  ggplot(aes(fill=count)) +
  geom_sf(colour="white") +
  scale_fill_viridis(option = "mako") 

# +
# facet_wrap(~CalYear)
# so actually the total pc is higher outside TH



yearly <- fires %>% 
  select(CalYear, IncGeo_WardCode, IncGeo_BoroughName, my_cat_sum) %>% 
  mutate(count = 1
         # ,
         # IncGeo_WardName = toupper(IncGeo_WardName)
  ) %>% 
  group_by(IncGeo_WardCode, IncGeo_BoroughName, my_cat_sum) %>% 
  # filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = my_cat_sum,
              values_from = count,
              values_fill = 0) %>% 
  pivot_longer(c("HMO", "Other dwelling"),
               names_to = "my_cat_sum",
               values_to = "count") %>% 
  group_by(IncGeo_WardCode, IncGeo_BoroughName) %>% 
  mutate(pc = count / sum(count)) %>% 
  ungroup() %>%
  rename(ward = IncGeo_WardCode) %>% 
  filter(my_cat_sum != "Other dwelling") %>% 
  # filter(
  # IncGeo_BoroughName %in% borough_list,
  #   pc < 0.3)  %>% 
  left_join(w22_shape %>% 
              select(WD22CD, geometry) %>% 
              rename(ward = WD22CD)) %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
  ggplot(aes(fill=count)) +
  geom_sf(colour="white") +
  scale_fill_viridis(option = "mako",
                     begin = 0.1,
                     end = 0.9)




yearly <- fires %>% 
  select(CalYear, IncGeo_WardCode, IncGeo_BoroughName, FirstPumpArriving_AttendanceTime, my_cat_sum) %>% 
  # mutate(count = 1
  #        # ,
  #        # IncGeo_WardName = toupper(IncGeo_WardName)
  # ) %>% 
  filter(FirstPumpArriving_AttendanceTime != "NULL")  %>% 
  group_by(IncGeo_WardCode, my_cat_sum) %>% 
  summarise(count = mean(as.numeric(FirstPumpArriving_AttendanceTime), na.rm = T)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = my_cat_sum,
              values_from = count,
              values_fill = 0) %>% 
  pivot_longer(c("HMO", "Other dwelling"),
               names_to = "my_cat_sum",
               values_to = "count") %>% 
  rename(ward = IncGeo_WardCode) %>% 
  filter(my_cat_sum != "Other dwelling") %>% 
  # filter(
  # IncGeo_BoroughName %in% borough_list,
  #   pc < 0.3)  %>% 
  left_join(w22_shape %>% 
              select(WD22CD, geometry) %>% 
              rename(ward = WD22CD)) %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
  ggplot(aes(fill=count)) +
  geom_sf(colour="white") +
  scale_fill_viridis(option = "mako",
                     begin = 0.1,
                     end = 0.9)


yearly

yearly <- fires %>% 
  select(CalYear, IncGeo_WardCode, my_cat) %>% 
  filter(my_cat != "Other dwelling") %>% 
  mutate(count = 1
         # ,
         # IncGeo_WardName = toupper(IncGeo_WardName)
  ) %>% 
  group_by(IncGeo_WardCode, my_cat) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = my_cat,
              values_from = count,
              values_fill = 0) %>% 
  pivot_longer(c("HMO - unlicensed", "HMO - unknown", "HMO - licensed"),
               names_to = "my_cat",
               values_to = "count") %>% 
  group_by(IncGeo_WardCode) %>% 
  mutate(pc = count / sum(count)) %>% 
  ungroup() %>%
  rename(ward = IncGeo_WardCode) %>% 
  filter(my_cat %in% c("HMO - unlicensed", "HMO - unknown")) %>% 
  group_by(ward) %>% 
  summarise(pc = sum(pc)) %>% 
  # filter(
  #   # IncGeo_BoroughName %in% borough_list,
  #   pc < 0.3)  %>% 
  left_join(w22_shape %>% 
              select(WD22CD, geometry) %>% 
              rename(ward = WD22CD)) %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
  ggplot() +
  geom_sf(data = fires %>% 
            distinct(IncGeo_WardCode) %>% 
            rename(ward = IncGeo_WardCode) %>% 
            mutate(count = 1) %>% 
            left_join(w22_shape %>% 
                        select(WD22CD, geometry) %>%
                        rename(ward = WD22CD)) %>% 
            st_as_sf() %>%
            st_transform(crs = 4326), aes(), colour="white", fill = "grey") +
  geom_sf(aes(fill=pc), colour="white") +
  scale_fill_viridis(option = "rocket",
                     begin = 0.2,
                     end = 0.8)
# +
# facet_wrap(~CalYear)
# so actually the total pc is higher outside TH

yearly



yearly <- fires %>% 
  select(CalYear, IncGeo_WardCode, my_cat) %>% 
  filter(my_cat != "Other dwelling") %>% 
  mutate(count = 1) %>% 
  filter(my_cat %in% c("HMO - unlicensed", "HMO - unknown")) %>% 
  group_by(IncGeo_WardCode) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  rename(ward = IncGeo_WardCode) %>% 
  # filter(
  #   # IncGeo_BoroughName %in% borough_list,
  #   pc < 0.3)  %>% 
  left_join(w22_shape %>% 
              select(WD22CD, geometry) %>% 
              rename(ward = WD22CD)) %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
  ggplot() +
  geom_sf(data = fires %>% 
            distinct(IncGeo_WardCode) %>% 
            rename(ward = IncGeo_WardCode) %>% 
            mutate(count = 1) %>% 
            left_join(w22_shape %>% 
                        select(WD22CD, geometry) %>%
                        rename(ward = WD22CD)) %>% 
            st_as_sf() %>%
            st_transform(crs = 4326), aes(), colour="white", fill = "grey") +
  geom_sf(aes(fill=count), colour="white") +
  scale_fill_viridis(option = "magma",
                     begin = 0.2,
                     end = 0.8)
# +
# facet_wrap(~CalYear)
# so actually the total pc is higher outside TH

yearly





yearly <- fires %>% 
  filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
  select(CalYear, IncGeo_WardCode, my_cat_sum) %>% 
  mutate(count = 1
         # ,
         # IncGeo_WardName = toupper(IncGeo_WardName)
  ) %>% 
  group_by(CalYear, IncGeo_WardCode, my_cat_sum) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = my_cat_sum,
              values_from = count,
              values_fill = 0) %>% 
  pivot_longer(c("HMO", "Other dwelling"),
               names_to = "my_cat_sum",
               values_to = "count") %>% 
  group_by(CalYear, IncGeo_WardCode) %>% 
  mutate(pc = count / sum(count)) %>% 
  ungroup() %>%
  rename(ward = IncGeo_WardCode) %>% 
  filter(my_cat_sum != "Other dwelling") %>% 
  # filter(
  #   # IncGeo_BoroughName %in% borough_list,
  #   pc < 0.3)  %>% 
  left_join(w22_shape %>% 
              select(WD22CD, geometry) %>% 
              rename(ward = WD22CD)) %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
  ggplot(aes(fill=count)) +
  geom_sf(colour="white") +
  scale_fill_viridis(option = "magma") +
  facet_wrap(~CalYear)
# so actually the total pc is higher outside TH

yearly



yearly <- fires %>% 
  filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
  select(CalYear, IncGeo_WardCode, my_cat) %>% 
  mutate(count = 1
         # ,
         # IncGeo_WardName = toupper(IncGeo_WardName)
  ) %>% 
  group_by(IncGeo_WardCode, my_cat) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = my_cat,
              values_from = count,
              values_fill = 0) %>% 
  pivot_longer(c("HMO - licensed", "Other dwelling", "HMO - unlicensed", "HMO - unknown"),
               names_to = "my_cat",
               values_to = "count") %>% 
  group_by(IncGeo_WardCode) %>% 
  mutate(pc = count / sum(count)) %>% 
  filter(my_cat != "Other dwelling") %>% 
  ungroup() %>%
  rename(ward = IncGeo_WardCode) %>% 
  # filter(
  #   # IncGeo_BoroughName %in% borough_list,
  #   pc < 0.3)  %>% 
  left_join(w22_shape %>% 
              select(WD22CD, geometry) %>% 
              rename(ward = WD22CD)) %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
  ggplot(aes(fill=pc)) +
  geom_sf(colour="white") +
  scale_fill_viridis(option = "magma") +
  facet_wrap(~my_cat)
# so actually the total pc is higher outside TH


  