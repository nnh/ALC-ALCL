########################################
# Program Name : s_cmallmrg.R
# Study Name : J-TALC2
# Author : Kato Kiroku
# Date : 2019/08/22
# Output : cmallmrg.csv
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

names(idf)[names(idf) == "MEDDRUGFULL"] <- "薬剤名"

com <- merge(cm, idf, by = "薬剤名", all = FALSE, sort = TRUE)
setDT(com)[, number := rleid(薬剤名, 症例登録番号, 投与開始日)]
com_2 <- select(com, number, everything())

write.csv(com_2, paste0(outpath, "/cmallmrg.csv"), na = "", row.names = TRUE)
