library(sf)
# https://www.data.gov.uk/dataset/b6b33be9-01ab-4720-a43e-8992ce2a84e6/wards-december-2022-boundaries-uk-bfc
# w22_shape <- st_read("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/CL_drive_data/Wards_December_2022_Boundaries_UK_BFC_-3416072881830331872 (1)/WD_DEC_2022_UK_BFC.shp")
download.file("https://open-geography-portalx-ons.hub.arcgis.com/api/download/v1/items/a2c204fedefe4120ac93f062c647bdcb/csv?layers=0", temp1)
w22_shape <- read_csv(temp1)

# lsoa2ward <- read_xlsx("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/THdata/LSOA11_WD21_LAD21_EW_LU_V2.xlsx")
download.file("https://www.arcgis.com/sharing/rest/content/items/ff21f0cfbdcc4206906920b3a8858867/data", temp1)
lsoa2ward <- read_xlsx(temp1)

download.file("https://www.arcgis.com/home/item.html?id=3ca4d8430072442bb3dc1d673a670b40&sublayer=0#data", temp1)
w11_shape <- st_read(temp1)


# w11_shape <- st_read("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/THdata/Wards_December_2011_FEB_EW_2022_3913596174602688209/Wards_December_2011_FEB_EW.shp")

temp1 <- jsonlite::fromJSON('https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_December_2011_FEB_EW_2022/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json',
                   simplifyDataFrame=T) %>%
  .$features %>%
  unnest(cols = c(attributes))

# AssetPlusSYVChartsv2 <- jsonlite::fromJSON('https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_December_2011_FEB_EW_2022/FeatureServer/0/query?where=0%3D0&outFields=*&f=json',
#                                            simplifyDataFrame=T) %>%
#   .$features %>%
#   unnest(cols = c(attributes))
# 







# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 


# download.file("https://open-geography-portalx-ons.hub.arcgis.com/api/download/v1/items/a2c204fedefe4120ac93f062c647bdcb/shapefile?layers=0", temp1)
# files_list <- unzip(temp1, list = TRUE)
# hape <- unz(temp1, filename = "WD_DEC_2022_UK_BFC.shp")
# WD_DEC_2022_UK_BFC.shp
# 
# files_list <- unzip(temp1, list = TRUE)$Name
# files_list <- grep(".shp$", files_list, value = TRUE)
# hape <- unzip(temp1, files = files_list)
# hape <- bind_rows(lapply(files_list, function(fn) st_read(unz(temp1, fn))))