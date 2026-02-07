#!/bin/bash

#動画サイズ
SIZE=1920x1080 #1080p
#SIZE=1280x760  #720p

#タイムラプススピード（5〜30）
FPS=30

echo "-----------------------------------------------------------------"
echo "タイムラプス写真の動画化と冒頭にテキストを入れるシェルスクリプト"
echo ""
echo "                  mozi-Lapse（モジラプス）"
echo ""
echo "連続写真のファイルは PHOTOディレクトリ内へ"
echo "冒頭に入れたいテキストファイルは mozi.txt　に記述してください"
echo ""
echo "動画サイズとタイムラプススピードの調整は　mozi-lapse.sh　に"
echo "記述してください。"
echo "-----------------------------------------------------------------"
echo ""
echo "何かキーを押してスタートします..."
read input


#PHOTOディレクトリの確認
if [ ! -d PHOTO/ ]; then
  echo "PHOTOディレクトリが見つかりませんでした。"
  echo "PHOTOディレクトリに写真を入れてください。"
  exit 1
fi


#OUTディレクトリの確認と作成
if [ ! -d OUT/ ]; then
  echo "OUTディレクトリがありません"
  echo "作成しますか？ Y or N "
  read input

  if [ $input = 'yes' ] || [ $input = 'YES' ] || [ $input = 'y' ] ; then
    mkdir OUT
    echo "OUTディレクトリを作成しました。"
  elif [ $input = 'no' ] || [ $input = 'NO' ] || [ $input = 'n' ] ; then
    echo "処理を中止します。"
    exit 1
  fi
fi


#OUTディレクトリ内の一時ファイルの削除
rm OUT/01.mp4
rm OUT/02.mp4
rm OUT/output.mp4


#テキスト動画、30fps
ffmpeg -f lavfi -i color=c=white:s=$SIZE:r=30:d=5 -vf "drawtext=textfile='mozi.txt':fontfile='doc/NotoSansCJK-Bold.ttc':fontsize=64:fontcolor=black:x=(w-text_w)/2:y=(h-text_h)/2" -pix_fmt yuv420p OUT/01.mp4 -y

#タイムラプス
ffmpeg -r $FPS -pattern_type glob -i 'PHOTO/*.JPG' -s $SIZE -c:v libx264 -pix_fmt yuv420p -r 30 OUT/02.mp4 -y

#動画結合
ffmpeg -f concat -safe 0 -i list.txt -c copy OUT/output.mp4


#OUTディレクトリ内の一時ファイルの削除
rm OUT/01.mp4
rm OUT/02.mp4


echo ""
echo "動画がOUTディレクトリに作成されました。"
echo ""
