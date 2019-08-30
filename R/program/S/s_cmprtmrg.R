########################################
# Program Name : s_cmprtmrg.R
# Study Name : J-TALC2
# Author : Kato Kiroku
# Date : 2019/08/22
# Output : cmprtmrg.csv
########################################


library(sas7bdat)
library(dplyr)
library(data.table)

getwd()
prtpath <- "//ARONAS/Stat/Trials/Chiken/J-TALC2"

rawpath <- paste0(prtpath, "/input/rawdata")
extpath <- paste0(prtpath, "/input/ext")
outpath <- paste0(prtpath, "/output/QC")

idf <- read.sas7bdat(paste0(extpath, "/idf_20190422.sas7bdat"), debug = FALSE)
cm <- read.csv(paste0(rawpath, "/J-TALC2_cm_190725_1055.csv"), na.strings = c(""), as.is = TRUE)

idf$MEDDRUGFULL_h5 <- substr(idf$MEDDRUGFULL, 1, 5)
cm$薬剤名_h5 <- substr(cm$薬剤名, 1, 5)

names(idf)[names(idf) == "MEDDRUGFULL_h5"] <- "temp"
names(cm)[names(cm) == "薬剤名_h5"] <- "temp"

com <- merge(cm, idf, by = "temp", all = FALSE, sort = TRUE)
names(com)[names(com) == "temp"] <- "薬剤名_h5"
setDT(com)[, number := rleid(薬剤名_h5, 症例登録番号, 投与開始日)]
com_2 <- select(com, number, everything())

write.csv(com_2, paste0(outpath, "/cmprtmrg.csv"), na = "", row.names = TRUE)

# To identify duplicate column names
# tibble::enframe(names(com)) %>% count(value) %>% filter(n > 1)
