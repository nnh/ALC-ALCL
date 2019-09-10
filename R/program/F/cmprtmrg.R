#*******************************************
# プログラム名：cmprtmrg.R  Ver1.0
# 概要　　　　：J-TALC2で入力した薬剤名（商品名）と一般名の対照表を作成
#             　薬剤名と一般名の部分一致を取った場合のプログラム
#               input　 J-TALC2_cm_190725_1055.csv、idf_20190422.sas7bdat
#　　　　　　　 output  cmprtmrg.csv
#
# 履歴
#　　Ver1.0　2019.09.02 Agata.K　作成途中 
#*******************************************　

# ライブラリインストール
install.packages("sas7bdat")
library(sas7bdat)


# 変数定義
# 変更箇所------------------------------------------------------------
#  パス定義
prtPath <- "//ARONAS/Stat/Trials/Chiken/J-TALC2"
#  ファイル名定義
rfname <- paste0(prtPath, "/input/rawdata/J-TALC2_cm_190725_1055.csv")
efname <- paste0(prtPath, "/input/ext/idf_20190422.sas7bdat")
outfname <- paste0(prtPath, "/output/F/cmprtmrg.csv")
#  一致文字数定義
matchNum <- 5
#---------------------------------------------------------------------


# ファイル読込(Ptosh/SAS)
rdata <- read.csv(rfname, as.is=T, na.strings="")
edata <- read.sas7bdat(efname, debug=FALSE)

#　比較文字を生成する（薬剤名・一般名の先頭5文字抽出,PtoshにNo）
for (i in 1:nrow(rdata)) {
  rdata$ComData[i] <- substr(rdata$薬剤名[i],1,matchNum)
  rdata$No[i] <- i
}
for (i in 1:nrow(edata)) {
  edata$ComData[i] <- substr(edata$MEDDRUGFULL[i],1,matchNum)
}


# マージ （一致した項目のみ表示）Key＝Ptosh：薬剤名、SAS：一般名
re.merge <- merge(rdata, edata,  by="ComData", is.na="")


# 列の順番入れ替え（No,Ptosh(マージで先頭に移動した薬剤名をもとの位置に戻す),SAS）
result <- re.merge[,c(37,1:36,38:61)]

# CSVファイル出力
write.csv(result, outfname, row.names=F, na="")
