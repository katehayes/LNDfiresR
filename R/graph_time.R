library(zoo)
library(scales)



plot_hmo_pc_time <- fires %>% 
  mutate(month_yr = as.yearmon(date, "%Y %m")) %>% 
  select(month_yr, hmo_license) %>% 
  group_by(month_yr, hmo_license) %>% 
  mutate(count = 1) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  group_by(month_yr) %>% 
  mutate(pc = count / sum(count)) %>% 
  ungroup() %>%
  select(-count) %>% 
  filter(hmo_license != "Other dwelling") %>% 
  group_by(hmo_license) %>% 
  arrange(month_yr) %>% 
  mutate(pc = rollmean(pc, k = 3, fill = NA, align = "center")) %>%
  mutate(pc = rollmean(pc, k = 3, fill = NA, align = "center")) %>%
  pivot_wider(names_from = hmo_license,
              values_from = pc,
              values_fill = 0) %>% 
  mutate(month_yr = as.Date(month_yr)) %>% 
  ggplot() +
  geom_line(aes(x = month_yr, y=`HMO - unknown`), colour = "#1A9850FF", alpha=0.7, linewidth = 0.25) +
  geom_line(aes(x = month_yr, y=`HMO - unlicensed` + `HMO - unknown`), colour = "#ED3F39FF", alpha=0.7, linewidth = 0.25) +
  geom_line(aes(x = month_yr, y=`HMO - licensed`+ `HMO - unknown` + `HMO - unlicensed`), 
            colour = "black", alpha=0.8,
            linewidth = 0.6) +
  geom_ribbon(aes(x = month_yr, ymin=0, ymax=`HMO - unknown`), fill="#1A9850FF", alpha=0.77) +
  geom_ribbon(aes(x = month_yr, ymin=`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`), fill="#ED3F39FF", alpha=0.77) +
  geom_ribbon(aes(x = month_yr, ymin=`HMO - unlicensed`+`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`+`HMO - licensed`), fill="#0054FFFF", alpha=0.77) +
  theme(# strip.text = element_blank(),
        plot.background = element_rect(fill = "white"),
        panel.background = element_blank(),
        axis.line.x.bottom = element_line(colour = "black"),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color = "darkgrey", linewidth = 0.4),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        plot.margin = unit(c(1,9,0.7,0.8), "lines")) + # This widens the right margin
  scale_x_date(name = "",
                     date_breaks = "1 year",
                     date_minor_breaks = "3 months",
                     # limits = c(as.Date("2009-02-20"), as.Date("2024-06-30")),
                     date_labels = "%Y",
                     # expand = expansion(add = c(.6, 500)),
                     expand = c(0,0)) +
  scale_y_continuous(name = "",
                     labels = scales::percent,
                     limits = c(0, 0.052),
                     expand = c(0,0)) +
  labs(title = "Fires in HMOs (by license type) as a % of total monthly fires in London dwellings", 
       subtitle = "3-month rolling average") + # caption = "(based on data from ...)",
  geom_segment(aes(x = as.Date("2023-06-01"), y = 0.022,
                   xend = as.Date("2026-02-01"), yend = 0.022),
               color = "#0054FFFF",
               linewidth = 0.3) +
  geom_point(aes(x = as.Date("2023-06-01"), y = 0.022),
             color = "#0054FFFF",
             size = 0.6) +
  annotate(geom="text", x = as.Date("2026-02-01"), y = 0.0223, 
           label = "Licensed",
           color="black", size = 3.5,
           hjust = 1, vjust = 0) + # 0 is left/top aligned, 0.5 centered, 1 right/bottom
  geom_segment(aes(x = as.Date("2023-06-01"), y = 0.0133,
                   xend = as.Date("2026-02-01"), yend = 0.0133),
               color = "#ED3F39FF",
               linewidth = 0.35) +
  geom_point(aes(x = as.Date("2023-06-01"), y = 0.0133),
             color = "#ED3F39FF",
             size = 0.6) +
  annotate(geom="text", x = as.Date("2026-02-01"), y = 0.0136, 
           label = "Unlicensed",
           color="black", size = 3.5,
           hjust = 1, vjust = 0) + 
  geom_segment(aes(x = as.Date("2023-06-01"), y = 0.005,
                   xend = as.Date("2026-02-01"), yend = 0.005),
               color = "#1A9850FF",
               linewidth = 0.3) +
  geom_point(aes(x = as.Date("2023-06-01"), y = 0.005),
             color = "#1A9850FF",
             size = 0.6) +
  annotate(geom="text", x = as.Date("2026-02-01"), y = 0.0053, 
           label = "Unknown",
           color="black", size = 3.5,
           hjust = 1, vjust = 0) + 
  coord_cartesian(xlim = c(as.Date("2009-02-28"), as.Date("2024-06-10")), 
                  clip = "off") 

plot_hmo_pc_time 
# come back and make it so the formating of labels works for any size
# ggsave(filename = "plots/plot_hmo_pc_time.png", plot_hmo_pc_time) # Saving 13.9 x 8.96 in image





plot_hmo_count_time <- fires %>% 
  mutate(month_yr = as.yearmon(date, "%Y %m")) %>% 
  select(month_yr, hmo_license) %>% 
  group_by(month_yr, hmo_license) %>% 
  mutate(count = 1) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  filter(hmo_license != "Other dwelling") %>% 
  group_by(hmo_license) %>% 
  arrange(month_yr) %>% 
  mutate(count = rollmean(count, k = 3, fill = NA, align = "center")) %>%
  mutate(count = rollmean(count, k = 3, fill = NA, align = "center")) %>%
  pivot_wider(names_from = hmo_license,
              values_from = count,
              values_fill = 0)  %>%
  mutate(month_yr = as.Date(month_yr)) %>% 
  ggplot() +
  geom_line(aes(x = month_yr, y=`HMO - unknown`), colour = "#1A9850FF", alpha=0.7, linewidth = 0.25) +
  geom_line(aes(x = month_yr, y=`HMO - unlicensed` + `HMO - unknown`), colour = "#ED3F39FF", alpha=0.7, linewidth = 0.25) +
  geom_line(aes(x = month_yr, y=`HMO - licensed`+ `HMO - unknown` + `HMO - unlicensed`), 
            colour = "black", alpha=0.8,
            linewidth = 0.6) +
  geom_ribbon(aes(x = month_yr, ymin=0, ymax=`HMO - unknown`), fill="#1A9850FF", alpha=0.77) +
  geom_ribbon(aes(x = month_yr, ymin=`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`), fill="#ED3F39FF", alpha=0.77) +
  geom_ribbon(aes(x = month_yr, ymin=`HMO - unlicensed`+`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`+`HMO - licensed`), fill="#0054FFFF", alpha=0.77) +
  theme(# strip.text = element_blank(),
    plot.background = element_rect(fill = "white"),
    panel.background = element_blank(),
    axis.line.x.bottom = element_line(colour = "black"),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "darkgrey", linewidth = 0.4),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    plot.margin = unit(c(1,9,0.7,0.8), "lines")) + # This widens the right margin
  scale_x_date(name = "",
               date_breaks = "1 year",
               date_minor_breaks = "3 months",
               # limits = c(as.Date("2009-02-20"), as.Date("2024-06-30")),
               date_labels = "%Y",
               expand = c(0,0)) +
  coord_cartesian(xlim = c(as.Date("2009-02-28"), as.Date("2024-06-10")), 
                  clip = "off") +
  scale_y_continuous(name = "",
                    limits = c(0, 24),
                     expand = c(0,0)) +
  geom_segment(aes(x = as.Date("2023-06-01"), y = 8.5,
                   xend = as.Date("2026-02-01"), yend = 8.5),
               color = "#0054FFFF",
               linewidth = 0.35) +
  geom_point(aes(x = as.Date("2023-06-01"), y = 8.5),
             color = "#0054FFFF",
             size = 0.6) +
  annotate(geom="text", x = as.Date("2026-02-01"), y = 8.65, 
           label = "Licensed",
           color="black", size = 3.5,
           hjust = 1, vjust = 0) + # 0 is left/top aligned, 0.5 centered, 1 right/bottom
  geom_segment(aes(x = as.Date("2023-06-01"), y = 5.5,
                   xend = as.Date("2026-02-01"), yend = 5.5),
               color = "#ED3F39FF",
               linewidth = 0.35) +
  geom_point(aes(x = as.Date("2023-06-01"), y = 5.5),
             color = "#ED3F39FF",
             size = 0.6) +
  annotate(geom="text", x = as.Date("2026-02-01"), y = 5.65, 
           label = "Unlicensed",
           color="black", size = 3.5,
           hjust = 1, vjust = 0) + 
  geom_segment(aes(x = as.Date("2023-06-01"), y = 2.5,
                   xend = as.Date("2026-02-01"), yend = 2.5),
               color = "#1A9850FF",
               linewidth = 0.35) +
  geom_point(aes(x = as.Date("2023-06-01"), y = 2.5),
             color = "#1A9850FF",
             size = 0.6) +
  annotate(geom="text", x = as.Date("2026-02-01"), y = 2.65, 
           label = "Unknown",
           color="black", size = 3.5,
           hjust = 1, vjust = 0) + 
  labs(title = "Monthly fires in London HMOs (by license type)", 
       subtitle = "3-month rolling average") # caption = "(based on data from ...)",

plot_hmo_count_time
# ggsave(filename = "plots/plot_hmo_pc_time.png", plot_hmo_pc_time) # Saving 13.9 x 8.96 in image

# not enough fires in TH to break down over monthly by HMO license type

# yearly <- fires %>% 
#   filter(borough == "TOWER HAMLETS") %>% 
#   mutate(month_yr = as.yearmon(date, "%Y %m")) %>% 
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


plot_fires_th_time <- fires %>% 
  filter(borough == "TOWER HAMLETS") %>% 
  mutate(month_yr = as.yearmon(date, "%Y %m")) %>% 
  select(month_yr) %>% 
  group_by(month_yr) %>% 
  mutate(th_count = 1) %>% 
  summarise(th_count = sum(th_count)) %>% 
  ungroup() %>% 
  arrange(month_yr) %>% 
  mutate(th_count = rollmean(th_count, k = 3, fill = NA, align = "center")) %>%
  left_join(fires %>% 
              filter(borough != "TOWER HAMLETS") %>% 
              mutate(month_yr = as.yearmon(date, "%Y %m")) %>% 
              select(month_yr) %>% 
              group_by(month_yr) %>% 
              mutate(rest_count = 1) %>% 
              summarise(rest_count = sum(rest_count)) %>% 
              ungroup() %>% 
              arrange(month_yr) %>% 
              mutate(rest_count = rollmean(rest_count, k = 3, fill = NA, align = "center"))) %>% 
  mutate(month_yr = as.Date(month_yr)) %>% 
  arrange(month_yr) %>% 
  ggplot() +
  geom_line(aes(x = month_yr, y=th_count), colour = "#ED3F39FF") +
  geom_line(aes(x = month_yr, y=th_count+rest_count),
            colour = "black", alpha=0.8,
            linewidth = 0.6) +
  geom_ribbon(aes(x = month_yr, ymin=0, ymax=th_count), fill="#ED3F39FF", alpha=0.77) +
  geom_ribbon(aes(x = month_yr, ymin=th_count, ymax=th_count+rest_count), fill="#0054FFFF", alpha=0.77) +
  theme(# strip.text = element_blank(),
    plot.background = element_rect(fill = "white"),
    panel.background = element_blank(),
    axis.line.x.bottom = element_line(colour = "black"),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "darkgrey", linewidth = 0.4),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    plot.margin = unit(c(1,1,0.7,0.7), "lines")) +
  scale_x_date(name = "",
               date_breaks = "1 year",
               date_minor_breaks = "3 months",
               limits = c(as.Date("2009-02-20"), as.Date("2024-06-30")),
               date_labels = "%Y",
               expand = c(0,0)) +
  # coord_cartesian(xlim = c(as.Date("2009-02-28"), as.Date("2024-06-10")), 
  #                 clip = "off") +
  scale_y_continuous(name = "",
                     breaks = seq(0, 600, by = 100),
                     limits = c(0, 649),
                     expand = c(0,0)) +
  geom_segment(aes(x = as.Date("2020-01-01"), y = 585,
                   xend = as.Date("2020-01-01"), yend = 10),
               color = "#ED3F39FF",
               linewidth = 0.35) +
  geom_point(aes(x = as.Date("2020-01-01"), y = 10),
             color = "#ED3F39FF",
             size = 0.6) +
  annotate(geom="text", x = as.Date("2020-03-10"), y = 585, 
           label = "Tower Hamlets",
           color="black", size = 3.5,
           hjust = 0, vjust = 1) + 
  geom_segment(aes(x = as.Date("2021-04-01"), y = 550,
                   xend = as.Date("2021-04-01"), yend = 150),
               color = "#0054FFFF",
               linewidth = 0.35) +
  geom_point(aes(x = as.Date("2021-04-01"), y = 150),
             color = "#0054FFFF",
             size = 0.6) +
  annotate(geom="text", x = as.Date("2021-06-10"), y = 550, 
           label = "The rest of\nLondon",
           color="black", size = 3.5,
           hjust = 0, vjust = 1) + # 0 is left/top aligned, 0.5 centered, 1 right/bottom
  labs(title = "Monthly dwelling fires in Tower Hamlets vs. the rest of London", 
       subtitle = "3-month rolling average")


plot_fires_th_time
# ggsave(filename = "plots/plot_fires_th_time.png", plot_fires_th_time) 

# geom_segment(aes(x = as.Date("2022-04-20"), y = 550,
#                  xend = as.Date("2022-04-20"), yend = 150),
#              color = "#0054FFFF",
#              linewidth = 0.35) +
#   geom_point(aes(x = as.Date("2022-04-20"), y = 150),
#              color = "#0054FFFF",
#              size = 0.6) +
#   annotate(geom="text", x = as.Date("2022-07-01"), y = 550, 
#            label = "The rest of\nLondon",
#            color="black", size = 3.5,
#            


  