#*******************************************
#
# プログラム名：cmprtmrg.R  Ver1.0
# 概要　　　　：J-TALC2で入力した薬剤名（商品名）と一般名の対照表を作成
#             　薬剤名と一般名の部分一致を取った場合のプログラム
#               input　 J-TALC2_cm_190725_1055.csv、idf_20190422.sas7bdat
#　　　　　　　 output  cmprtmrg.csv
#
# 履歴
#　　Ver1.0　2019.08.21　Agata.K　作成途中 
#
#*******************************************　

# ライブラリインストール
install.packages("sas7bdat")
library(sas7bdat)


# 変数定義(以下フォルダ・ファイル名により適宜変更)
#  パス定義
prtPath <- "//ARONAS/Stat/Trials/Chiken/J-TALC2"
#  ファイル名定義
rfname <- paste0(prtPath, "/input/rawdata/J-TALC2_cm_190725_1055.csv")
efname <- paste0(prtPath, "/input/ext/idf_20190422.sas7bdat")
outfname <- paste0(prtPath, "/output/F/cmprtmrg.csv")
#  一致文字数定義
match <- 5


# ファイル読込(Ptosh/SAS)
rdata <- read.csv(rfname, as.is=T, na.strings="")
edata <- read.sas7bdat(efname, debug=FALSE)


# 一致確認
#  Ptoshデータ数分回す（for)

#  先頭からmatch分の比較文字抽出(Ptoshデータ)

#  SASデータ数分回す（for）

#  先頭からmatch分の比較文字抽出(SASデータ)

#  一致確認

#  一致なら

#  不一致なら


# CSVファイル出力（Ptoshデータ,一致一般名①,一致一般名②,・・・）
write.csv(re.merge, outfname, row.names=T, na="")
