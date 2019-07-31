########################################
# Program Name : s_cmallmrg.R
# Study Name : J-TALC2
# Author : Kato Kiroku
# Date : 2019/07/30
# Output : cmallmrg.csv
########################################


install.packages("sas7bdat")
library(sas7bdat)

getwd()
prtpath <- "//ARONAS/Stat/Trials/Chiken/J-TALC2"

rawpath <- paste0(prtpath, "/input/rawdata")
extpath <- paste0(prtpath, "/input/ext")
outpath <- paste0(prtpath, "/output")

idf <- read.sas7bdat(paste0(extpath, "/idf_20190422.sas7bdat"), debug=FALSE)
