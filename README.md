# LDNfiresR
**Context:** after a fire in an overcrowded, unlicensed HMO in Shadwell, a local residents' group are preparing to speak to Tower Hamlets council about fire safety in rental properties. They want to look at trends in fire data w.r.t. time, location (borough or ward etc.), dwelling type (HMO vs. single occupancy), HMO license type (licensed vs. unlicensed).
<br><br>
**Fire data**
<br>
London Fire Brigade Incident Records (https://data.london.gov.uk/dataset/london-fire-brigade-incident-records). Data available in two chunks, 2009-2017 and 2018-onwards (minor inconsistencies between them; see the cleaning script). Data is incident-level - information available re whether the property is a HMO and so on. 
<br><br>
**HMO data**
<br>
The ONS released this dataset, derived from 2021 Census data - contains LA-level counts of the number of households living in HMOs (https://www.ons.gov.uk/datasets/RM193/editions/2021/versions/2). No equivalent dataset available for earlier census years. 
<br>
Doesn't seem like there are many (any?) consistent time-series available that track HMO numbers/ number of households in HMOs? To-do: explore LA housing statistics - some HMO data maybe present in the 2020/2021 returns (https://www.gov.uk/government/statistical-data-sets/local-authority-housing-statistics-data-returns-for-2020-to-2021) - here also is LA housing open data (https://www.gov.uk/government/statistical-data-sets/local-authority-housing-statistics-open-data).
<br><br>
**Plots**<br>
Fires in licensed HMOs look like they're becoming more frequent over time, while fires in unlicensed HMOs (& HMOs with unknown license status) happen less. Dwelling fires in London are, overall, becoming less frequent and so fires in licensed HMOs are making up a growing proportion of total fires. <br>
![plot_hmo_count_time](https://github.com/katehayes/LNDfiresR/blob/main/plots/plot_hmo_count_time.png)
<br>
![plot_hmo_pc_time](https://github.com/katehayes/LNDfiresR/blob/main/plots/plot_hmo_pc_time.png)
<br>
Dwelling fires in Tower Hamlets are (unsurprisingly) only a fraction of London's dwelling fires - though the fraction is growing, as fire frequency in the rest of London falls faster than in TH.<br>
![plot_fires_th_time](https://github.com/katehayes/LNDfiresR/blob/main/plots/plot_fires_th_time.png)