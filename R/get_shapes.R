library(sf)

# w22_shape <- st_read("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/CL_drive_data/Wards_December_2022_Boundaries_UK_BFC_-3416072881830331872 (1)/WD_DEC_2022_UK_BFC.shp")
# https://www.data.gov.uk/dataset/b6b33be9-01ab-4720-a43e-8992ce2a84e6/wards-december-2022-boundaries-uk-bfc
temp1 <- tempfile()
download.file("https://open-geography-portalx-ons.hub.arcgis.com/api/download/v1/items/a2c204fedefe4120ac93f062c647bdcb/csv?layers=0", temp1)
w22_shape <- read_csv(temp1)




# lsoa2ward <- read_xlsx("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/THdata/LSOA11_WD21_LAD21_EW_LU_V2.xlsx")
temp1 <- tempfile()
download.file("https://www.arcgis.com/sharing/rest/content/items/ff21f0cfbdcc4206906920b3a8858867/data", temp1)
lsoa2ward <- read_xlsx(temp1)

# w11_shape <- st_read("/Users/katehayes/Library/CloudStorage/GoogleDrive-khayes2@sheffield.ac.uk/My Drive/THdata/Wards_December_2011_FEB_EW_2022_3913596174602688209/Wards_December_2011_FEB_EW.shp")
temp1 <- tempfile()
download.file("https://open-geography-portalx-ons.hub.arcgis.com/api/download/v1/items/f5e07097d2db46e0b33ce92e09b8981a/csv?layers=0", temp1)
w11_shape <- read_csv(temp1)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
