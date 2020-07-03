########################################
# Program Name : s_cmallmrg.R
# Study Name : J-TALC2
# Author : Kato Kiroku
# Date : 2020/06/05
# Output : cmallmrg_match.csv
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

idf$temp <- idf$MEDDRUGFULL
cm$temp <- cm$薬剤名
cm$No <- 1:nrow(cm)

combined <- merge(cm, idf, by = "temp", all = FALSE, sort = TRUE)
names(combined)[names(combined) == "temp"] <- "ComData"

combined$applicable <- ifelse(combined$投与経路 == "外用" & combined$USECAT2 == "外", 1,
                              ifelse(combined$投与経路 == "経口" & combined$USECAT2 == "内", 1,
                                     ifelse(combined$投与経路 == "静注" & combined$USECAT2 == "注", 1,
                                            ifelse(combined$投与経路 == "皮下注" & combined$USECAT2 == "注", 1,
                                                   ifelse(combined$投与経路 == "胸腔内", 1,
                                                          ifelse(combined$投与経路 == "その他", 1, 0))))))

combined <- combined %>%
  subset(applicable == 1) %>%
  select(No, everything(), -applicable, -ComData)

combined <- combined[with(combined, order(症例登録番号, 投与開始日, 薬剤名, DRUGCODE, No)), ]

write.csv(combined, paste0(outpath, "/cmallmrg_match.csv"), na = "", row.names = FALSE)
