########################################
# Program Name : s_cmprtmrg.R
# Study Name : J-TALC2
# Author : Kato Kiroku
# Date : 2019/09/13
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

idf$temp <- substr(idf$MEDDRUGFULL, 1, 5)
cm$temp <- substr(cm$薬剤名, 1, 5)
cm$No <- 1:nrow(cm)

combined <- merge(cm, idf, by = "temp", all = FALSE, sort = TRUE)
names(combined)[names(combined) == "temp"] <- "ComData"
combined_2 <- select(combined, No, everything())

write.csv(combined_2, paste0(outpath, "/cmprtmrg.csv"), na = "", row.names = FALSE)

# To identify duplicate column names
# tibble::enframe(names(com)) %>% count(value) %>% filter(n > 1)
