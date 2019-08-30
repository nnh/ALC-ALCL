#*******************************************
#
# プログラム名：cmallmrg.R  Ver1.0
# 概要　　　　：J-TALC2で入力した薬剤名（商品名）と一般名の対照表を作成
#             　薬剤名と一般名の完全一致を取った場合のプログラム
#               input　 J-TALC2_cm_190725_1055.csv、idf_20190422.sas7bdat
#　　　　　　　 output  cmallmrg.csv
# 履歴
#　　Ver1.0　2019.08.30　Agata.K　初版作成
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
outfname <- paste0(prtPath, "/output/F/cmallmrg.csv")


# ファイル読込(Ptosh/SAS)
rdata <- read.csv(rfname, as.is=T, na.strings="")
edata <- read.sas7bdat(efname, debug=FALSE)

# マージ （一致した項目のみ表示）Key＝Ptosh：薬剤名、SAS：一般名
re.merge <- merge(rdata, edata,  by.x="薬剤名", by.y="MEDDRUGFULL", is.na="")

# 比較時に比較済みかどうかの区別をつけるために、Noに全て0を代入しておく
re.merge$No <- 0

# 症例登録番号・薬剤名・投与経路？が一致の場合、通番（cnt)を同じにする。（処理は以下）
# １つ目のforで比較対象を抽出して、その中でもう一回forを回して比較していく
# 比較した結果一致すれば、cntをNoへ入れていく
cnt <- 1
for (i in 1:nrow(re.merge)) {
  if(re.merge$No[i] == 0){

    # 比較対象のNoは０なら入れる
    re.merge$No[i] <- cnt
    # 比較対象を退避
    ComNo <- re.merge$症例登録番号[i]
    ComMed <- re.merge$薬剤名[i]
    ComRt <- re.merge$投与経路[i]
    
    # forで回して比較対象と比較していく、一致ならcntを入れる
    for (j in 1:nrow(re.merge)) {
      if(re.merge$No[j] == 0){
        if((re.merge$症例登録番号[j] == ComNo) && (re.merge$薬剤名[j] == ComMed) && (re.merge$投与経路[j] == ComRt)){
          re.merge$No[j] <- cnt
        }
      }
    }
    
    # cnt値をcntアップ
    cnt <- cnt + 1
  }
}

# 列の順番入れ替え（Noを先頭に持ってくる）
result <- re.merge[,c(59,1:58)]

# CSVファイル出力
write.csv(result, outfname, row.names=T, na="")
