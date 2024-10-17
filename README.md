# LDNfiresR
**Context:** after a fire in an overcrowded, unlicensed HMO in Shadwell, a local residents' group are preparing to speak to Tower Hamlets council about fire safety in rental properties. They would like to get a sense of patterns in the occurrence of fires in London w.r.t. time, place (borough or ward etc.), dwelling type (e.g. HMO vs. single occupancy), HMO license type (licensed vs. unlicensed). This is a v quick look at the data for them. 
<br><br>
## Data sources
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
**Boundaries etc**
<br>
The ONS Open Geography Portal (https://geoportal.statistics.gov.uk/)
<br><br>
## Plots
Fires in licensed HMOs look like they're becoming more frequent over time, while fires in unlicensed HMOs (& HMOs with unknown license status) happen less. Dwelling fires in London are, overall, becoming less frequent and so fires in licensed HMOs are making up a growing proportion of total fires. Not sure what is happening to the number of HMOs in London over the same time period.<br>
![plot_hmo_count_time](https://github.com/katehayes/LNDfiresR/blob/main/plots/plot_hmo_count_time.png)
<br>
![plot_hmo_pc_time](https://github.com/katehayes/LNDfiresR/blob/main/plots/plot_hmo_pc_time.png)
<br>
Dwelling fires in Tower Hamlets are (unsurprisingly) only a fraction of London's dwelling fires - though the fraction is growing, as fire frequency in the rest of London falls faster than in TH.<br>
![plot_fires_th_time](https://github.com/katehayes/LNDfiresR/blob/main/plots/plot_fires_th_time.png)
<br>
![plot_fires_space](https://github.com/katehayes/LNDfiresR/blob/main/plots/plot_fires_space.png)
<br>
![plot_hmos_space](https://github.com/katehayes/LNDfiresR/blob/main/plots/plot_hmos_space.png) 
<br>
![plot_pc_hmofires_space](https://github.com/katehayes/LNDfiresR/blob/main/plots/plot_pc_hmofires_space.png)
<br>
![plot_hmofires_space](https://github.com/katehayes/LNDfiresR/blob/main/plots/plot_hmofires_space.png)
<br>


<!---
<p>
 <img src="https://github.com/katehayes/LNDfiresR/blob/main/plots/plot_hmos_space.png" hspace="10" width="47%"/><img src="https://github.com/katehayes/LNDfiresR/blob/main/plots/plot_pc_hmofires_space.png" hspace="10" width="47%"/>  
</p>
<br>
-->


<!---
Every fire in a HMO in Tower Hamlets (years 2009-2023) by ward, HMO license, HMO size.<br>
![plot_fires_th_time](https://github.com/katehayes/LNDfiresR/blob/main/plots/plot_hmofires_THwards.png)
-->