#!/bin/bash
n_row=$1;
n_col=$2;
num=$(($n_row*$n_col));
count=0;
for row in `seq -$((($n_row-1)/2)) $(($n_row/2))`;
do
for col in `seq -$((($n_col-1)/2)) $(($n_col/2))`;
do
  let count+=1;
  sed -i "s/var\ hshift\ =\ \-\{0,1\}[0-9]\{1,\}/var\ hshift\ =\ $col/" fuzhou_system_map.html;
  sed -i "s/var\ vshift\ =\ \-\{0,1\}[0-9]\{1,\}/var\ vshift\ =\ $row/" fuzhou_system_map.html;
  echo Generating piece $count/$num ...
  google-chrome --headless --disable-gpu --screenshot --window-size=1920,1080 fuzhou_system_map.html > /dev/null 2>&1;
  mkdir -p pieces
  mv screenshot.png pieces/piece-$count.png
done
done
# Reset values
sed -i "s/var\ hshift\ =\ \-\{0,1\}[0-9]\{1,\}/var\ hshift\ =\ 0/" fuzhou_system_map.html;
sed -i "s/var\ vshift\ =\ \-\{0,1\}[0-9]\{1,\}/var\ vshift\ =\ 0/" fuzhou_system_map.html;
# Tile
echo Generating tiled image ...
montage "pieces/piece-%d.png[1-$num]" -tile "$n_colx$n_row" -geometry +0+0 map.png
