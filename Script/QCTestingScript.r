
#Load Packages
library(tidyverse)

#set working directory to find data
setwd("~/Work Material/USAID/ICPI/VL/QC/QCTestingScript")

# Read in  dataset. Make sure to change your the file name to yours
df<-read_tsv("Data/test_MER_Structured_Datasets_PSNU_IM_FY18-21_20201218_Mozambique.txt") %>% 
  mutate(pre_rgnlztn_hq_mech_code = as.character(pre_rgnlztn_hq_mech_code))
df1<-read_tsv("Data/test_MER_Structured_Datasets_PSNU_IM_FY18-21_20201218_Eswatini.txt")
glimpse(df)
glimpse(df1)

em<-bind_rows(df, df1)


#subset dataset
txcurr<-em %>% 
  filter(indicator == "TX_CURR") %>% 
  filter(standardizeddisaggregate %in% c("Age/Sex/HIVStatus","Age Aggregated/Sex/HIVStatus",
                                         "KeyPop/HIVStatus", "Total Numerator"))

txpvls<- em %>% 
  filter(indicator == "TX_PVLS")

pmtctart<- em %>%
  filter(indicator == "PMTCT_ART") %>% 
  filter(otherdisaggregate %in% "Life-long ART, Already")

unique(c(pmtctart$standardizeddisaggregate, pmtctart$fiscal_year, pmtctart$otherdisaggregate))


netnew<-em %>% 
  filter(indicator== "TX_NET_NEW")

lab<-em %>% 
  filter(indicator == "LAB_PTCQI")

#Checks
unique(txcurr$standardizeddisaggregate)
unique(txcurr$sex)
unique(txpvls$standardizeddisaggregate)
unique(txpvls$otherdisaggregate)
unique(pmtctart$standardizeddisaggregate)
unique(pmtctart$otherdisaggregate)
unique(netnew$standardizeddisaggregate)


# Combine all subset datasets
fdf<-bind_rows(txcurr, txpvls, pmtctart, netnew, lab)

write_tsv(fdf, "Data/EsMozPanoQC20201221", na = " ")
