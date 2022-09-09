#!/bin/sh

if [ "$(uname)" == 'Darwin' ]; then
  #MacOSの場合
  echo "Please enter the EFI partition to mount by number"
  #接続されているデバイスからEFIパーティションを検出
  disklist=$(for L in `diskutil list | grep EFI`;do i=`expr $i + 1`;echo $L | grep disk ;done 2>/dev/null)
  i=0;for L in $disklist;do i=`expr $i + 1`;echo $i : $L ;done 2>/dev/null
  count=$(i=0;for L in $disklist;do i=`expr $i + 1`;echo $i : $L ;done 2>/dev/null | wc -l)
  #数値の入力をさせる
  echo -n Number:
  read str
  #入力された数値が検出したEFIパーティションの数以下なのか確認する
  if [ $str -le $count ]; then
    #以下であるとき
    sudo diskutil mount /dev/$(i=0;for L in $disklist;do i=`expr $i + 1`;echo $L ;done 2>/dev/null | sed -n `echo $str`P) > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      #マウント成功したとき
      echo "successfully mounted"
    else
      #マウント失敗したとき
      echo "mount failed"
      exit 1
    fi
  else
    #以上であるとき
    echo "The number you entered is too large. please try again"
    exit 1
  fi
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  #Linuxの場合
  echo "LinuxOS"
  echo "This OS is not supported"
  exit 1
else
  #Linux以外のOSの場合
  echo "このOSは非対応です"
  exit 1
fi