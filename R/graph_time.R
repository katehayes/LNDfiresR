yearly




yearly <- fires %>% 
  mutate(date = dmy(DateOfCall),
         month_yr = as.yearmon(date, "%Y %m")) %>% 
  select(month_yr, my_cat) %>% 
  group_by(month_yr, my_cat) %>% 
  mutate(count = 1) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  group_by(month_yr) %>% 
  mutate(pc = count / sum(count)) %>% 
  ungroup() %>%
  select(-count) %>% 
  filter(my_cat != "Other dwelling") %>% 
  group_by(my_cat) %>% 
  arrange(month_yr) %>% 
  mutate(pc = rollmean(pc, k = 3, fill = NA, align = "center")) %>%
  mutate(pc = rollmean(pc, k = 3, fill = NA, align = "center")) %>%
  pivot_wider(names_from = my_cat,
              values_from = pc,
              values_fill = 0) %>% 
  ggplot() +
  geom_line(aes(x = month_yr, y=`HMO - unknown`), colour = "darkgrey") +
  geom_line(aes(x = month_yr, y=`HMO - unlicensed` + `HMO - unknown`), colour = "#A4661EFF") +
  geom_line(aes(x = month_yr, y=`HMO - licensed`+ `HMO - unknown` + `HMO - unlicensed`), colour = "#3A488AFF") +
  geom_ribbon(aes(x = month_yr, ymin=0, ymax=`HMO - unknown`), fill="darkgrey", alpha=0.5) +
  geom_ribbon(aes(x = month_yr, ymin=`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`), fill="#D9D6A6FF", alpha=0.5) +
  geom_ribbon(aes(x = month_yr, ymin=`HMO - unlicensed`+`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`+`HMO - licensed`), fill="#9BB0FEFF", alpha=0.5) 

yearly  




yearly <- fires %>% 
  mutate(date = dmy(DateOfCall),
         month_yr = as.yearmon(date, "%Y %m")) %>% 
  select(month_yr, my_cat) %>% 
  group_by(month_yr, my_cat) %>% 
  mutate(count = 1) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  filter(my_cat != "Other dwelling") %>% 
  group_by(my_cat) %>% 
  arrange(month_yr) %>% 
  mutate(count = rollmean(count, k = 3, fill = NA, align = "center")) %>%
  mutate(count = rollmean(count, k = 3, fill = NA, align = "center")) %>%
  pivot_wider(names_from = my_cat,
              values_from = count,
              values_fill = 0)  %>%
  ggplot() +
  geom_line(aes(x = month_yr, y=`HMO - unknown`), colour = "darkgrey") +
  geom_line(aes(x = month_yr, y=`HMO - unlicensed` + `HMO - unknown`), colour = "#A4661EFF") +
  geom_line(aes(x = month_yr, y=`HMO - licensed`+ `HMO - unknown` + `HMO - unlicensed`), colour = "#3A488AFF") +
  geom_ribbon(aes(x = month_yr, ymin=0, ymax=`HMO - unknown`), fill="darkgrey", alpha=0.5) +
  geom_ribbon(aes(x = month_yr, ymin=`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`), fill="#D9D6A6FF", alpha=0.5) +
  geom_ribbon(aes(x = month_yr, ymin=`HMO - unlicensed`+`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`+`HMO - licensed`), fill="#9BB0FEFF", alpha=0.5) 

yearly

as.Date()
library(scales)
# +
# theme(strip.text = element_blank()) +
# scale_x_continuous(name = "") +
# scale_y_continuous(name = "",
#                    limits = c(0, 50),
#                    expand = c(0,0))

yearly  


yearly <- fires %>% 
  filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
  mutate(date = dmy(DateOfCall),
         month_yr = as.yearmon(date, "%Y %m")) %>% 
  select(month_yr, my_cat) %>% 
  group_by(month_yr, my_cat) %>% 
  mutate(count = 1) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  group_by(my_cat) %>% 
  arrange(month_yr) %>% 
  mutate(count = rollmean(count, k = 6, fill = 0, align = "center")) %>%
  mutate(count = rollmean(count, k = 6, fill = 0, align = "center")) %>%
  pivot_wider(names_from = my_cat,
              values_from = count,
              values_fill = 0)  %>%
  ggplot() +
  geom_line(aes(x = month_yr, y=`HMO - unknown`), colour = "darkgrey") +
  geom_line(aes(x = month_yr, y=`HMO - unlicensed` + `HMO - unknown`), colour = "#A4661EFF") +
  geom_line(aes(x = month_yr, y=`HMO - licensed`+ `HMO - unknown` + `HMO - unlicensed`), colour = "#3A488AFF") +
  geom_line(aes(x = month_yr, y=`HMO - licensed`+ `HMO - unknown` + `HMO - unlicensed`+`Other dwelling`), colour = "#3A488AFF") +
  geom_ribbon(aes(x = month_yr, ymin=0, ymax=`HMO - unknown`), fill="darkgrey", alpha=0.5) +
  geom_ribbon(aes(x = month_yr, ymin=`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`), fill="#D9D6A6FF", alpha=0.5) +
  geom_ribbon(aes(x = month_yr, ymin=`HMO - unlicensed`+`HMO - unknown`, ymax=`HMO - unlicensed`+`HMO - unknown`+`HMO - licensed`), fill="#9BB0FEFF", alpha=0.5) + 
  geom_ribbon(aes(x = month_yr, ymin=`HMO - unlicensed`+`HMO - unknown`+`HMO - licensed`, ymax=`HMO - unlicensed`+`HMO - unknown`+`HMO - licensed`+`Other dwelling`), fill="#9BB0FEFF", alpha=0.5) 
yearly




yearly <- fires %>% 
  filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
  mutate(date = dmy(DateOfCall),
         month_yr = as.yearmon(date, "%Y %m")) %>% 
  select(month_yr) %>% 
  group_by(month_yr) %>% 
  mutate(count = 1) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  arrange(month_yr) %>% 
  mutate(count = rollmean(count, k = 3, fill = NA, align = "center")) %>%
  # mutate(count = rollmean(count, k = 3, fill = 0, align = "center")) %>%
  ggplot() +
  geom_line(aes(x = month_yr, y=count), colour = "#3A488AFF") +
  geom_ribbon(aes(x = month_yr, ymin=0, ymax=count), fill="#9BB0FEFF", alpha=0.5) 
yearly


yearly <- fires %>% 
  filter(IncGeo_BoroughName == "TOWER HAMLETS",
         my_cat != "Other dwelling") %>% 
  select(CalYear, my_cat) %>% 
  group_by(CalYear, my_cat) %>% 
  mutate(count = 1) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  # arrange(month_yr) %>% 
  # mutate(count = rollmean(count, k = 3, fill = NA, align = "center")) %>%
  # mutate(count = rollmean(count, k = 3, fill = 0, align = "center")) %>%
  ggplot() +
  geom_bar(aes(x = CalYear, y=count, fill = my_cat), stat = "identity", position = "stack")
# geom_ribbon(aes(x = month_yr, ymin=0, ymax=count), fill="#9BB0FEFF", alpha=0.5) 
yearly





yearly <- fires %>% 
  filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
  mutate(date = dmy(DateOfCall),
         month_yr = as.yearmon(date, "%Y %m")) %>% 
  select(month_yr) %>% 
  group_by(month_yr) %>% 
  mutate(count = 1) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  arrange(month_yr) %>% 
  mutate(count = rollmean(count, k = 3, fill = NA, align = "center")) %>%
  left_join(fires %>% 
              filter(IncGeo_BoroughName != "TOWER HAMLETS") %>% 
              mutate(date = dmy(DateOfCall),
                     month_yr = as.yearmon(date, "%Y %m")) %>% 
              select(month_yr) %>% 
              group_by(month_yr) %>% 
              mutate(count = 1) %>% 
              summarise(count = sum(count)) %>% 
              ungroup() %>% 
              arrange(month_yr) %>% 
              mutate(tot_count = rollmean(count, k = 3, fill = NA, align = "center")) %>% 
              select(-count)) %>% 
  ggplot() +
  geom_line(aes(x = month_yr, y=count), colour = "#881C00FF") +
  geom_line(aes(x = month_yr, y=count+tot_count), colour = "#172869FF") +
  geom_ribbon(aes(x = month_yr, ymin=0, ymax=count), fill="#AF6125FF", alpha=0.5) +
  geom_ribbon(aes(x = month_yr, ymin=count, ymax=count+tot_count), fill="#0076BBFF", alpha=0.5) 
yearly



yearly <- fires %>% 
  select(CalYear, IncGeo_WardName, IncGeo_BoroughName, my_cat) %>% 
  mutate(IncGeo_WardName = toupper(IncGeo_WardName)) %>% 
  mutate(count = 1) %>% 
  group_by(CalYear, IncGeo_WardName, IncGeo_BoroughName, my_cat) %>% 
  summarise(count = sum(count)) %>% 
  ungroup() %>% 
  group_by(CalYear, IncGeo_WardName, IncGeo_BoroughName) %>% 
  mutate(pc = count / sum(count)) %>% 
  ungroup() %>%
  select(-count) %>% 
  filter(my_cat != "Other dwelling") %>% 
  pivot_wider(names_from = my_cat,
              values_from = pc,
              values_fill = 0) %>% 
  filter(IncGeo_BoroughName == "TOWER HAMLETS") %>% 
  ggplot() +
  geom_line(aes(x = CalYear, y=`HMO - unlicensed`, colour = IncGeo_WardName))

yearly  


# +
geom_line(aes(x = end_period_year, y=`AP-Free`+`BSS-CBS`), colour="#B48A2CFF") +
  geom_ribbon(aes(x = end_period_year, ymin=0,ymax=`BSS-CBS`), fill="#9BB0FEFF", alpha=0.5) +
  geom_ribbon(aes(x = end_period_year, ymin=`BSS-CBS`,ymax=`AP-Free`+`BSS-CBS`), fill="#DCD66EFF", alpha=0.5) +
  facet_grid(cols = vars(fsm)) +
  