########################################
# Program Name : s_cmallmrg.R
# Study Name : J-TALC2
# Author : Kato Kiroku
# Date : 2019/10/16
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

cm$No <- 1:nrow(cm)
names(idf)[names(idf) == "MEDDRUGFULL"] <- "薬剤名"

combined <- merge(cm, idf, by = "薬剤名", all = FALSE, sort = TRUE)

combined$applicable <- ifelse(combined$投与経路 == "外用" & combined$USECAT2 == "外", 1,
                              ifelse(combined$投与経路 == "経口" & combined$USECAT2 == "内", 1,
                                     ifelse(combined$投与経路 == "静注" & combined$USECAT2 == "注", 1,
                                            ifelse(combined$投与経路 == "皮下注" & combined$USECAT2 == "注", 1,
                                                   ifelse(combined$投与経路 == "胸腔内", 1,
                                                          ifelse(combined$投与経路 == "その他", 1, 0))))))

combined <- combined %>%
  subset(applicable == 1) %>%
  select(No, everything(), -applicable)

write.csv(combined, paste0(outpath, "/cmallmrg.csv"), na = "", row.names = FALSE)
