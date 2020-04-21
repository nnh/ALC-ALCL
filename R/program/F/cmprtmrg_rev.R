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
#    2020.04.20  Agata.K  不一致リストも別で出力する(cmprtmrg_rev.Rとして新規作成)
#                         一致リスト、不一致リストについてソートを追加
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
outfname <- paste0(prtPath, "/output/F/cmprtmrg_match.csv")
nmatch_outfname <- paste0(prtPath, "/output/F/cmprtmrg_notmatch.csv")
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
# 2020.04.20 不一致リストも必要なため,Ptoshデータは全て残す（all.x=T）
re.merge <- merge(rdata, edata,  by="ComData", is.na="", all.x=T)
match <- re.merge     #一致データを格納
not.match <-re.merge　#不一致データを格納

# 2019.10.10 Agata.K マージの条件に投与経路が追加となったため、処理を追加--------------------------------------------------------------
# 2020.04.20 Agata.K 不一致データの処理追加
# 投薬経路により不要なデータは削除する（投薬経路とUSECAT２）
cnt <- 1
ncnt <- 1

for (i in 1:nrow(re.merge)) {
  
  if(is.na(re.merge$DRUGCODE[i]) == FALSE){ # SASの情報入っていれば一致（以下条件満たせば一致データとする）
    
    if((re.merge$投与経路[i] == "外用") & (re.merge$USECAT2[i] != "外")){         # 投薬経路が【外用】、USECAT2が【外】以外 ：　行削除
      match <- match[-cnt, ]
      ncnt <- ncnt + 1
    }
    else if((re.merge$投与経路[i] == "経口") & (re.merge$USECAT2[i] != "内")){    # 投薬経路が【経口】、USECAT2が【内】以外 ：　行削除
      match <- match[-cnt, ]
      ncnt <- ncnt + 1
    }
    else if((re.merge$投与経路[i] == "静注") & (re.merge$USECAT2[i] != "注")){    # 投薬経路が【静注】、USECAT2が【注】以外 ：　行削除
      match <- match[-cnt, ]
      ncnt <- ncnt + 1
    }
    else if((re.merge$投与経路[i] == "皮下注") & (re.merge$USECAT2[i] != "注")){  # 投薬経路が【皮下注】、USECAT2が【注】以外 ：　行削除
      match <- match[-cnt, ]
      ncnt <- ncnt + 1
    }
    else{   # 投薬経路が上記条件以外なら残す
      not.match <- not.match[-ncnt,]
      cnt <- cnt + 1
    }
    
  }else{    # SAS情報が入っていなければ不一致データ
    match <- match[-cnt, ]
    ncnt <- ncnt + 1
  }

}
# 2019.10.10 Agata.K--------------------------------------------------------------------------------------------------------------------

# 列の順番入れ替え（No,Ptosh(マージで先頭に移動した薬剤名をもとの位置に戻す),SAS）
ret <- match[,c(37,1:36,38:61)]
nret <- not.match[,c(37,1:36,38:61)]

# 一致データをソート（1症例番号、2開始日）2020.04.20 Agata.K
ret_sort <- order(ret$症例登録番号)
ret <- ret[ret_sort,]
ret_sort <- order(ret$投与開始日)
ret <- ret[ret_sort,]

# 不一致データをソート（1症例番号、2開始日）2020.04.20 Agata.K
ret_sort <- order(nret$症例登録番号)
nret <- nret[ret_sort,]
ret_sort <- order(nret$投与開始日)
nret <- nret[ret_sort,]

# CSVファイル出力
write.csv(ret, outfname, row.names=F, na="")
write.csv(nret, nmatch_outfname, row.names=F, na="")
