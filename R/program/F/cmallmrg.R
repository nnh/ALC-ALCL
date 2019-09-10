#*******************************************
# プログラム名：cmallmrg.R  Ver1.0
# 概要　　　　：J-TALC2で入力した薬剤名（商品名）と一般名の対照表を作成
#             　薬剤名と一般名の完全一致を取った場合のプログラム
#               症例登録番号、薬剤名、投与開始日（懸案）の一致で通し番号をつける
#               input　 J-TALC2_cm_190725_1055.csv、idf_20190422.sas7bdat
#　　　　　　　 output  cmallmrg.csv
#
# 履歴
#　　Ver1.0　2019.09.10　Agata.K　初版作成
#*******************************************　

# ライブラリインストール
install.packages("sas7bdat")
library(sas7bdat)

# 変数定義
# 変更箇所------------------------------------------------------------
# パス定義
prtPath <- "//ARONAS/Stat/Trials/Chiken/J-TALC2"
# ファイル名定義
rfname <- paste0(prtPath, "/input/rawdata/J-TALC2_cm_190725_1055.csv")
efname <- paste0(prtPath, "/input/ext/idf_20190422.sas7bdat")
outfname <- paste0(prtPath, "/output/F/cmallmrg.csv")
#---------------------------------------------------------------------

# ファイル読込(Ptosh/SAS)
rdata <- read.csv(rfname, as.is=T, na.strings="")
edata <- read.sas7bdat(efname, debug=FALSE)

# PtoshのデータにNoを追加する
for (i in 1:nrow(rdata)) {
  rdata$No[i] <- i
}

# マージ （一致した項目のみ表示）Key＝Ptosh：薬剤名、SAS：一般名
re.merge <- merge(rdata, edata,  by.x="薬剤名", by.y="MEDDRUGFULL", is.na="")

# 列の順番入れ替え（No,Ptosh(マージで先頭に移動した薬剤名をもとの位置に戻す),SAS）
result <- re.merge[,c(36,1:35,37:59)]

# CSVファイル出力
write.csv(result, outfname, row.names=F, na="")
