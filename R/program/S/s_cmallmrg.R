########################################
# Program Name : s_cmallmrg.R
# Study Name : J-TALC2
# Author : Kato Kiroku
# Date : 2019/10/08
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
combined_2 <- select(combined, No, everything())

combined_2$applicable <- ifelse(combined_2$投与経路 == "外用" & combined_2$USECAT2 == "外", 1,
                       ifelse(combined_2$投与経路 == "経口" & combined_2$USECAT2 == "内", 1,
                              ifelse(combined_2$投与経路 == "静注" & combined_2$USECAT2 == "注", 1,
                                     ifelse(combined_2$投与経路 == "皮下注" & combined_2$USECAT2 == "注", 1,
                                            ifelse(combined_2$投与経路 == "胸腔内", 1,
                                                   ifelse(combined_2$投与経路 == "その他", 1, 0))))))

combined_2 <- combined_2 %>%
  subset(applicable == 1) %>%
  select(No, 投与経路, USECAT2, applicable, everything(), -applicable)

write.csv(combined_2, paste0(outpath, "/cmallmrg.csv"), na = "", row.names = FALSE)
