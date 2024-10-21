library(viridis)
# library(cowplot)
library(tidyverse)
library(ggrepel)

plot_hmofires_space <- fires %>% 
  mutate(count = 1) %>% 
  group_by(borough, ward, hmo_yn) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = hmo_yn,
              values_from = count,
              values_fill = 0) %>% 
  pivot_longer(c("HMO", "Other dwelling"),
               names_to = "hmo_yn",
               values_to = "count") %>% 
  group_by(ward) %>% 
  mutate(pc = count / sum(count)) %>% 
  filter(hmo_yn != "Other dwelling") %>% 
  filter(count > 0) %>% 
  left_join(w22_shape %>% 
              select(WD22CD, geometry) %>% 
              rename(ward = WD22CD)) %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
  ggplot() +
  geom_sf(data = fires %>% 
            distinct(ward) %>% 
            mutate(count = 1) %>% 
            left_join(w22_shape %>% 
                        select(WD22CD, geometry) %>%
                        rename(ward = WD22CD)) %>% 
            st_as_sf() %>%
            st_transform(crs = 4326), aes(), colour="white", fill = "black") +
  geom_sf(aes(fill=count), colour="white") +
  scale_fill_viridis(option = "turbo",
                     begin = 0,
                     end = 1) +
  theme(# strip.text = element_blank(),
    # plot.margin = unit(c(1,9,0.7,0.8), "lines"),
    plot.background = element_rect(fill = "white"),
    panel.background = element_blank(),
    axis.line.x.bottom = element_line(colour = "black"),
    axis.line.y.left = element_line(colour = "black"),
    # panel.grid.major.x = element_line(color = "darkgrey", linewidth = 0.4),
    # panel.grid.major.y = element_line(color = "darkgrey", linewidth = 0.4),
    # panel.grid.minor.x = element_line(color = "darkgrey", linewidth = 0.1),
    # panel.grid.minor.y = element_line(color = "darkgrey", linewidth = 0.1),
    legend.title = element_blank(),
    legend.position = c(.9, 0.17)) +
  labs(title = "Total number of HMO fires in each London ward between 2009 and 2014", 
       subtitle = "Wards with no recorded HMO fires are filled black") 

plot_hmofires_space
# ggsave(filename = "plots/plot_hmofires_space.png", plot_hmofires_space) 


plot_pc_hmofires_space <- fires %>% 
  mutate(count = 1) %>% 
  group_by(borough, ward, hmo_yn) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = hmo_yn,
              values_from = count,
              values_fill = 0) %>% 
  pivot_longer(c("HMO", "Other dwelling"),
               names_to = "hmo_yn",
               values_to = "count") %>% 
  group_by(ward) %>% 
  mutate(pc = count / sum(count)) %>% 
  filter(hmo_yn != "Other dwelling") %>% 
  filter(pc > 0,
         pc != 1) %>% #removing one ward in the city of london that had only one fire & it was a HMO fire - otherwise colours are difficult to see on the graph
  left_join(w22_shape %>% 
              select(WD22CD, geometry) %>% 
              rename(ward = WD22CD))  %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
  ggplot() +
  geom_sf(data = fires %>% 
            distinct(ward) %>% 
            mutate(count = 1) %>% 
            left_join(w22_shape %>% 
                        select(WD22CD, geometry) %>%
                        rename(ward = WD22CD)) %>% 
            st_as_sf() %>%
            st_transform(crs = 4326), aes(), colour=NA, fill = "black") +
  geom_sf(aes(fill=pc), colour=NA) +
  scale_fill_viridis(option = "turbo",
                     begin = 0,
                     end = 1) +
  geom_sf(data = la21_shape %>% 
            filter(LAD21CD %in% ldn_borough_codes),
          aes(), 
          colour="white", #linewidth = 0.4,
          fill = NA) +
  theme(# strip.text = element_blank(),
    # plot.margin = unit(c(1,9,0.7,0.8), "lines"),
    plot.background = element_rect(fill = "white"),
    panel.background = element_blank(),
    axis.line.x.bottom = element_line(colour = "black"),
    axis.line.y.left = element_line(colour = "black"),
    # panel.grid.major.x = element_line(color = "darkgrey", linewidth = 0.4),
    # panel.grid.major.y = element_line(color = "darkgrey", linewidth = 0.4),
    # panel.grid.minor.x = element_line(color = "darkgrey", linewidth = 0.1),
    # panel.grid.minor.y = element_line(color = "darkgrey", linewidth = 0.1),
    legend.title = element_blank(),
    legend.position = c(.9, 0.17)) +
  labs(title = "HMO fires as a % of dwelling fires in each London ward between 2009 and 2014", 
       subtitle = "Wards with no recorded HMO fires are filled black") 

plot_pc_hmofires_space
ggsave(filename = "plots/plot_pc_hmofires_space.png", plot_pc_hmofires_space) 




plot_pc_unlfires_space <- fires %>% 
  mutate(count = 1) %>% 
  group_by(borough, ward, hmo_license) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  # pivot_wider(names_from = hmo_license,
  #             values_from = count,
  #             values_fill = 0) %>% 
  # pivot_longer(c("HMO", "Other dwelling"),
  #              names_to = "hmo_yn",
  #              values_to = "count") %>% 
  group_by(ward) %>% 
  mutate(pc = count / sum(count)) %>% 
  filter(hmo_license == "HMO - unlicensed") %>% 
  filter(pc > 0,
         pc != 1) %>% 
  left_join(w22_shape %>% 
              select(WD22CD, geometry) %>% 
              rename(ward = WD22CD))  %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
  ggplot() +
  geom_sf(data = fires %>% 
            distinct(ward) %>% 
            mutate(count = 1) %>% 
            left_join(w22_shape %>% 
                        select(WD22CD, geometry) %>%
                        rename(ward = WD22CD)) %>% 
            st_as_sf() %>%
            st_transform(crs = 4326), aes(), colour="white", fill = "black") +
  geom_sf(aes(fill=pc), colour="white") +
  scale_fill_viridis(option = "turbo",
                     begin = 0,
                     end = 1) +
  theme(# strip.text = element_blank(),
    # plot.margin = unit(c(1,9,0.7,0.8), "lines"),
    plot.background = element_rect(fill = "white"),
    panel.background = element_blank(),
    axis.line.x.bottom = element_line(colour = "black"),
    axis.line.y.left = element_line(colour = "black"),
    # panel.grid.major.x = element_line(color = "darkgrey", linewidth = 0.4),
    # panel.grid.major.y = element_line(color = "darkgrey", linewidth = 0.4),
    # panel.grid.minor.x = element_line(color = "darkgrey", linewidth = 0.1),
    # panel.grid.minor.y = element_line(color = "darkgrey", linewidth = 0.1),
    legend.title = element_blank(),
    legend.position = c(.9, 0.17)) +
  labs(title = "Unlicensed HMO fires as a % of dwelling fires in each London ward between 2009 and 2014", 
       subtitle = "Wards with no recorded unlicensed HMO fires are filled black") 

plot_pc_unlfires_space
ggsave(filename = "plots/plot_pc_unlfires_space.png", plot_pc_unlfires_space) 






plot_fires_space <- fires %>% 
  mutate(count = 1) %>% 
  group_by(ward) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  filter(count > 0) %>% 
  left_join(w22_shape %>% 
              select(WD22CD, geometry) %>% 
              rename(ward = WD22CD)) %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
  ggplot() +
  geom_sf(data = fires %>% 
            distinct(ward) %>% 
            mutate(count = 1) %>% 
            left_join(w22_shape %>% 
                        select(WD22CD, geometry) %>%
                        rename(ward = WD22CD)) %>% 
            st_as_sf() %>%
            st_transform(crs = 4326), aes(), colour="white", fill = "black") +
  geom_sf(aes(fill=count), colour="white") +
  scale_fill_viridis(option = "turbo",
                     begin = 0,
                     end = 1) +
  theme(# strip.text = element_blank(),
    # plot.margin = unit(c(1,9,0.7,0.8), "lines"),
    plot.background = element_rect(fill = "white"),
    panel.background = element_blank(),
    axis.line.x.bottom = element_line(colour = "black"),
    axis.line.y.left = element_line(colour = "black"),
    # panel.grid.major.x = element_line(color = "darkgrey", linewidth = 0.4),
    # panel.grid.major.y = element_line(color = "darkgrey", linewidth = 0.4),
    # panel.grid.minor.x = element_line(color = "darkgrey", linewidth = 0.1),
    # panel.grid.minor.y = element_line(color = "darkgrey", linewidth = 0.1),
    legend.title = element_blank(),
    legend.position = c(.9, 0.17)) +
  labs(title = "Total number of dwelling fires in each London ward between 2009 and 2014", 
       subtitle = "There are no dwelling fires recorded for wards in the City of London - they are filled black") 

plot_fires_space
ggsave(filename = "plots/plot_fires_space.png", plot_fires_space) 

check <- hmo %>% 
  distinct(la)

plot_hmos_space <- hmo %>% 
  mutate(hmo_yn = ifelse(hmo_size == "Does not apply", "Other dwelling", "HMO")) %>% 
  group_by(la_code, la, hmo_yn) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  group_by(la) %>% 
  mutate(pc = count / sum(count)) %>% 
  filter(hmo_yn != "Other dwelling") %>% 
  left_join(la21_shape %>% 
              select(LAD21CD, LONG, LAT, geometry) %>% 
              rename(la_code = LAD21CD,
                     lng = LONG,
                     lat = LAT)) %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  ggplot() +
  geom_sf(aes(fill=pc), colour="white") +
  # geom_sf_text(aes(label = la)) +

  scale_fill_viridis(option = "turbo",
                     begin = 0,
                     end = 1) +
  theme(# strip.text = element_blank(),
    # plot.margin = unit(c(1,9,0.7,0.8), "lines"),
    plot.background = element_rect(fill = "white"),
    panel.background = element_blank(),
    axis.line.x.bottom = element_line(colour = "black"),
    axis.line.y.left = element_line(colour = "black"),
    # panel.grid.major.x = element_line(color = "darkgrey", linewidth = 0.4),
    # panel.grid.major.y = element_line(color = "darkgrey", linewidth = 0.4),
    # panel.grid.minor.x = element_line(color = "darkgrey", linewidth = 0.1),
    # panel.grid.minor.y = element_line(color = "darkgrey", linewidth = 0.1),
    legend.title = element_blank(),
    legend.position = c(.9, 0.2)) +
  labs(title = "% of households living in HMOs in each London borough in 2021", 
       subtitle = "")

plot_hmos_space
ggsave(filename = "plots/plot_hmos_space.png", plot_hmos_space) 


# TO-DO: function - for each borough, take name, centre point, make line and label
# geom_segment(aes(x = as.Date("2023-06-01"), y = 0.022,
#                  xend = as.Date("2026-02-01"), yend = 0.022),
#              color = "#0054FFFF",
#              linewidth = 0.3) +
#   geom_point(aes(x = as.Date("2023-06-01"), y = 0.022),
#              color = "#0054FFFF",
#              size = 0.6) +
#   annotate(geom="text", x = as.Date("2026-02-01"), y = 0.0223, 
#            label = "Licensed",
#            color="black", size = 3.5,
#            hjust = 1, vjust = 0) + # 0 is left/top aligned, 0.5 centered, 1 right/bottom



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# check <- plot_grid(plot_hmos_space, plot_pc_hmofires_space, nrow = 1, align = "h")
# check

# geom_text_repel(aes(x = lng, y = lat, label = la),
  # nudge_x = c(0.1,0,0,0,0,0,0,0,0,0,0,0,
  #             0,0,0,0,0,0,0,0,0,0,0,0,
  #             0,0,0,0,0,0,0,0,0), 
  # nudge_y = c(0.1,0,0,0,0,0,0,0,0,0,0,0,
  #             0,0,0,0,0,0,0,0,0,0,0,0,
  #             0,0,0,0,0,0,0,0,0)) +  



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
# 
# 
# 
# 
# fires_shape %>% 
#   ggplot(aes(fill=count)) +
#   geom_sf(colour="white") +
#   scale_fill_viridis(option = "magma")
# 
# 
# fires_hmo %>% 
#   ggplot(aes(fill=pc_dwellings)) +
#   geom_sf(colour="white") +
#   scale_fill_viridis(option = "magma")
# 
# 
# # check <- fires %>% 
# #   filter(IncGeo_BoroughName %in% borough_list) %>% 
# #   distinct(IncGeo_WardCode, IncGeo_WardName) %>% 
# #   rename(ward = IncGeo_WardCode) %>% 
# #   left_join(w_shape %>% 
# #               select(wd11cd, wd11nm, geometry) %>% 
# #               rename(ward = wd11cd)) %>% 
# #   st_drop_geometry() %>% 
# #   filter(!is.na(wd11nm)) %>% 
# #   distinct(ward, geometry) 
# 
# 
# # st_as_sf() %>% 
# # st_transform(crs = 4326)
# # 
# # 
# # check <- fires %>% 
# #   filter(IncGeo_BoroughName %in% borough_list) %>% 
# #   distinct(IncGeo_BoroughCode, IncGeo_BoroughName) %>% 
# #   rename(borough = IncGeo_BoroughCode) %>% 
# #   left_join(w22_shape %>% 
# #               select(LAD22CD, LAD22NM, geometry) %>% 
# #               rename(borough = LAD22CD)) 
# # 
# # 
# # check <- w22_shape %>% 
# #   select(LAD22NM, WD22NM, WD22CD, geometry) %>% 
# #   rename(borough = LAD22NM,
# #          ward = WD22CD) %>% 
# #   mutate(borough = toupper(borough)) %>% 
# #   filter(borough %in% borough_list) %>% 
# #   left_join(fires %>% 
# #               filter(IncGeo_BoroughName %in% borough_list) %>% 
# #               filter(my_cat_sum != "Other dwelling")  %>% 
# #               distinct(IncGeo_WardCode, IncGeo_WardName) %>% 
# #               rename(ward= IncGeo_WardCode))
# # 
# # 
# # 
# # check <- w22_shape %>% 
# #   select(LAD22NM, WD22NM, WD22CD, geometry) %>% 
# #   rename(borough = LAD22NM,
# #          ward = WD22CD) %>% 
# #   mutate(borough = toupper(borough)) %>% 
# #   filter(borough %in% borough_list) %>% 
# #   st_as_sf() %>% 
# #   st_transform(crs = 4326) %>% 
# #   # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
# #   ggplot(aes(), fill="lightgrey") +
# #   geom_sf(colour="white") 
# # 
# # 
# # # +
# #   scale_fill_viridis(option = "magma") 
# # 
# # check
# # 
# # # %>% 
# #   st_drop_geometry() %>% 
# #   filter(!is.na(wd11nm)) %>% 
# #   distinct(ward, geometry) 
# 
# 
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
# # 
# # yearly <- fires %>% 
# #   select(CalYear, IncGeo_WardCode, IncGeo_BoroughName, FirstPumpArriving_AttendanceTime, my_cat_sum) %>% 
# #   # mutate(count = 1
# #   #        # ,
# #   #        # IncGeo_WardName = toupper(IncGeo_WardName)
# #   # ) %>% 
# #   filter(FirstPumpArriving_AttendanceTime != "NULL")  %>% 
# #   group_by(IncGeo_WardCode, my_cat_sum) %>% 
# #   summarise(count = mean(as.numeric(FirstPumpArriving_AttendanceTime), na.rm = T)) %>% 
# #   ungroup() %>% 
# #   pivot_wider(names_from = my_cat_sum,
# #               values_from = count,
# #               values_fill = 0) %>% 
# #   pivot_longer(c("HMO", "Other dwelling"),
# #                names_to = "my_cat_sum",
# #                values_to = "count") %>% 
# #   rename(ward = IncGeo_WardCode) %>% 
# #   filter(my_cat_sum != "Other dwelling") %>% 
# #   # filter(
# #   # IncGeo_BoroughName %in% borough_list,
# #   #   pc < 0.3)  %>% 
# #   left_join(w22_shape %>% 
# #               select(WD22CD, geometry) %>% 
# #               rename(ward = WD22CD)) %>% 
# #   st_as_sf() %>% 
# #   st_transform(crs = 4326) %>% 
# #   # st_crop(ont, xmin=-1, xmax=1, ymin=51, ymax=52) %>% 
# #   ggplot(aes(fill=count)) +
# #   geom_sf(colour="white") +
# #   scale_fill_viridis(option = "mako",
# #                      begin = 0.1,
# #                      end = 0.9)
# # 
# # 
# # yearly
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
# 
#   