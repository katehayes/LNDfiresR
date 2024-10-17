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

# save(raw_fires_09to17, file = "data/raw/raw_fires_09to17.RData")
# save(raw_fires_18to24, file = "data/raw/raw_fires_18to24.RData")
