#*******************************************
# プログラム名：cmprtmrg.R  Ver1.0
# 概要　　　　：J-TALC2で入力した薬剤名（商品名）と一般名の対照表を作成
#             　【薬剤名】と【投薬方法】をKEYととしてマージを取った場合のプログラム
#               　薬剤名　：薬剤名・MEDDRUGFULL(部分一致)
#                 投薬方法：投薬経路・USECAT2
#               マージ前に通し番号をつけておいて、同じ症例/投薬については分かるようにする

#               input　 J-TALC2_cm_190725_1055.csv、idf_20190422.sas7bdat
#　　　　　　　 output  cmprtmrg.csv
#
# 履歴
#　　2019.09.10　Agata.K　初版作成
#    2019.10.15  Agata.K  マージ条件に投与経路を追加 
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

# 2019.10.10 Agata.K マージの条件に投与経路が追加となったため、処理を追加--------------------------------------------------------------
# 投薬経路により不要なデータは削除する（投薬経路とUSECAT２）
cnt <- 1
for (i in 1:nrow(re.merge)) {
  
  if((re.merge$投与経路[cnt] == "外用") & (re.merge$USECAT2[cnt] != "外")){         # 投薬経路が【外用】、USECAT2が【外】以外 ：　行削除
    re.merge <- re.merge[-cnt, ]
  }
  else if((re.merge$投与経路[cnt] == "経口") & (re.merge$USECAT2[cnt] != "内")){    # 投薬経路が【経口】、USECAT2が【内】以外 ：　行削除
    re.merge <- re.merge[-cnt,]
  }
  else if((re.merge$投与経路[cnt] == "静注") & (re.merge$USECAT2[cnt] != "注")){    # 投薬経路が【静注】、USECAT2が【注】以外 ：　行削除
    re.merge <- re.merge[-cnt,]
  }
  else if((re.merge$投与経路[cnt] == "皮下注") & (re.merge$USECAT2[cnt] != "注")){  # 投薬経路が【皮下注】、USECAT2が【注】以外 ：　行削除
    re.merge <- re.merge[-cnt,]
  }
  else{                                                                             # 投薬経路が上記条件以外なら残す
    cnt <- cnt + 1
  }

  }
# 2019.10.10 Agata.K--------------------------------------------------------------------------------------------------------------------

# 列の順番入れ替え（No,Ptosh(マージで先頭に移動した薬剤名をもとの位置に戻す),SAS）
result <- re.merge[,c(37,1:36,38:61)]

# CSVファイル出力
write.csv(result, outfname, row.names=F, na="")
