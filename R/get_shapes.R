library(sf)
# https://geoportal.statistics.gov.uk/
  
w22_shape <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_December_2022_Boundaries_UK_BFC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson")

la21_shape <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_May_2021_UK_BGC_2022/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# lsoa2ward <- read_xlsx("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/THdata/LSOA11_WD21_LAD21_EW_LU_V2.xlsx")
# temp1 <- tempfile()
# download.file("https://www.arcgis.com/sharing/rest/content/items/ff21f0cfbdcc4206906920b3a8858867/data", temp1)
# lsoa2ward <- read_xlsx(temp1)
# 
# # w11_shape <- st_read("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/THdata/Wards_December_2011_FEB_EW_2022_3913596174602688209/Wards_December_2011_FEB_EW.shp")
# temp1 <- tempfile()
# download.file("https://open-geography-portalx-ons.hub.arcgis.com/api/download/v1/items/f5e07097d2db46e0b33ce92e09b8981a/csv?layers=0", temp1)
# w11_shape <- read_csv(temp1)
# 

