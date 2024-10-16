library(httr)
library(jsonlite)

# https://ons.gov.uk/datasets/RM193/editions/2021/versions/2?f=get-data
# datasets/RM193/editions/2021/versions/2
# hmo_data <- read.csv("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/THdata/RM193-2021-2.csv")

download.file("https://s3.eu-west-1.amazonaws.com/statistics.digitalresources.jisc.ac.uk/dkan/files/2021/ONS/number-of-households-that-are-in-HMO/by-accomodation-type/RM193-Number-Of-Households-In-Houses-In-Multiple-Occupation-(Hmo)-By-Accommodation-Type-2021-ltla-ONS.xlsx", temp1)

raw_hmo <- read_xlsx(temp1)
