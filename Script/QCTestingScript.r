
#Load Packages
library(tidyverse)
library(readxl)

#set working directory to find data
setwd("C:/Users/jStephens/Documents/ICPI/QC/FY21Q2c")

# Read in  dataset. Make sure to change your the file name to yours
df<-read_tsv("test_MER_Structured_Datasets_PSNU_IM_FY19-21_20210618_Eswatini/test_MER_Structured_Datasets_PSNU_IM_FY19-21_20210618_Eswatini.txt") %>% 
  mutate(pre_rgnlztn_hq_mech_code = as.character(pre_rgnlztn_hq_mech_code))
df1<-read_tsv("test_MER_Structured_Datasets_PSNU_IM_FY19-21_20210618_Mozambique/test_MER_Structured_Datasets_PSNU_IM_FY19-21_20210618_Mozambique.txt")%>% 
  mutate(pre_rgnlztn_hq_mech_code = as.character(pre_rgnlztn_hq_mech_code))

# em<-read_csv("PCD FY21Q2_QC Round 1_PSNUxIM_Haiti.Kenya_20210419.csv")%>% 
#   mutate(pre_rgnlztn_hq_mech_code = as.character(pre_rgnlztn_hq_mech_code))


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

write_tsv(fdf, "MosEswatini_FY21Q2c", na = " ")

