########################################
# Program Name : s_cmallmrg.R
# Study Name : J-TALC2
# Author : Kato Kiroku
# Date : 2019/08/15
# Output : cmallmrg.csv
########################################


# How to handle duplicate values?

install.packages("sas7bdat")
library(sas7bdat)
library(dplyr)

getwd()
prtpath <- "//ARONAS/Stat/Trials/Chiken/J-TALC2"

rawpath <- paste0(prtpath, "/input/rawdata")
extpath <- paste0(prtpath, "/input/ext")
outpath <- paste0(prtpath, "/output/QC")

idf <- read.sas7bdat(paste0(extpath, "/idf_20190422.sas7bdat"), debug = FALSE)
cm <- read.csv(paste0(rawpath, "/J-TALC2_cm_190725_1055.csv"), na.strings = c(""), as.is = TRUE)

names(idf)[names(idf) == "MEDDRUGFULL"] <- "薬剤名"

com <- merge(cm, idf, by = "薬剤名", all = FALSE, sort = TRUE)
com_2 <- distinct(com, 薬剤名, .keep_all = TRUE)

write.csv(com, paste0(outpath, "/cmallmrg.csv"), na = "", row.names = TRUE)
