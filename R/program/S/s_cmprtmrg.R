########################################
# Program Name : s_cmprtmrg.R
# Study Name : J-TALC2
# Author : Kato Kiroku
# Date : 2019/08/02
# Output : cmprtmrg.csv
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

idf$MEDDRUGFULL_h5 <- substr(idf$MEDDRUGFULL, 1, 5)
cm$薬剤名_h5 <- substr(cm$薬剤名, 1, 5)

names(idf)[names(idf) == "MEDDRUGFULL_h5"] <- "Med.Gen.merge"
names(cm)[names(cm) == "薬剤名_h5"] <- "Med.Gen.merge"

com <- merge(cm, idf, by = "Med.Gen.merge", all = FALSE, sort = TRUE)
# Duplicates Values Deleted
com_2 <- distinct(com, Med.Gen.merge, .keep_all = TRUE)

write.csv(com, paste0(outpath, "/cmprtmrg.csv"), na = "", row.names = FALSE)
