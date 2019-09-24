########################################
# Program Name : compare.R
# Study Name : J-TALC2
# Author : Kato Kiroku
# Date : 2019/09/13
# Output :
########################################


getwd()
prtpath <- "//ARONAS/Stat/Trials/Chiken/J-TALC2"

outpath <- paste0(prtpath, "/output")

first_all <- read.csv(paste0(outpath, "/F/cmallmrg.csv"), na.strings = c(""), as.is = TRUE)
second_all <- read.csv(paste0(outpath, "/QC/cmallmrg.csv"), na.strings = c(""), as.is = TRUE)

identical(first_all, second_all)

first_prt <- read.csv(paste0(outpath, "/F/cmprtmrg.csv"), na.strings = c(""), as.is = TRUE)
second_prt <- read.csv(paste0(outpath, "/QC/cmprtmrg.csv"), na.strings = c(""), as.is = TRUE)

identical(first_prt, second_prt)


# all.equal(first_prt, second_prt)
#
#
# library(dplyr)
# library(magrittr)
#
# dir.create(paste0(prtpath, "/validation"), showWarnings = FALSE)
# valpath <- paste0(prtpath, "/validation")
#
# read.csv(paste0(outpath, "/F/cmallmrg.csv"), na.strings = c(""), as.is = TRUE) %>%
  # inner_join(read.csv(paste0(outpath, "/QC/cmallmrg.csv"), na.strings = c(""), as.is = TRUE)) %>%
  # write.csv(paste0(valpath, "/compare_cmallmrg.csv"), na = "", row.names = FALSE)
