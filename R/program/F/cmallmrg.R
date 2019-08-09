#*******************************************
#
# プログラム名：cmallmrg.R  Ver1.0
# 概要　　　　：J-TALC2で入力した薬剤名（商品名）と一般名の対照表を作成
#               input　 J-TALC2_cm_190725_1055.csv、idf_20190422.sas7bdat
#　　　　　　　 output  cmallmrg.csv
#
# 履歴
#　　Ver1.0　2019.08.08　Agata.K　作成
#
#*******************************************　

# library
install.packages("sas7bdat")
library(sas7bdat)


# 変数
prtPath <- "//ARONAS/Stat/Trials/Chiken/J-TALC2"

rfname <- paste0(prtPath, "/input/rawdata/J-TALC2_cm_190725_1055.csv")
efname <- paste0(prtPath, "/input/ext/idf_20190422.sas7bdat")
outfname <- paste0(prtPath, "/output/F/cmallmrg.csv")

# ファイル読込(Ptosh/SAS)
rdata <- read.csv(rfname, as.is=T, na.strings="")
edata <- read.sas7bdat(efname, debug=FALSE)


# マージ （一致した項目のみ）
re.merge <- merge(rdata, edata,  by.x="薬剤名", by.y="MEDDRUGFULL", is.na="")
# CSVファイル出力
write.csv(re.merge, outfname, row.names=T, na="")


# マージ (Ptoshの情報は全て表示)
#re.merge <- merge(rdata, edata,  by.x="薬剤名", by.y="MEDDRUGFULL", all.x=T, is.na="")
# CSVファイル出力
#write.csv(re.merge, outfname, row.names=T, na="")
