#!/bin/bash

mount_dir="/home/chao/fds_data"

path_prefix="car/eng/bhx/0003"

dst_path="/media/chao/Data/bag/data-input/car/eng/bhx/0003"

echo $#
if [ $# -lt 2 ]; then
  echo "Usage: ./download_record.sh dir record.1 [record.2 ...]"
  exit 1
fi

if [ ! -d $mount_dir/$path_prefix ]; then
  echo "make sure fds is mounted"
  exit 1
fi

if [ ! -d $dst_path ]; then
  echo "$dst_path is not exit"
  exit 1
fi

record_dir=$1

shift 1

for record in $@
do
  record_path=$record_dir/$record
  if [ ! -f $mount_dir/$path_prefix/$record_path ]; then
    echo "can not find record: $mount_dir/$path_prefix/$record_path"
    continue
  fi
  
  if [ ! -d $dst_path/$record_dir ]; then
    echo "mkdir $dst_path/$record_dir"
    mkdir -p $dst_path/$record_dir
  fi

  echo "cp $mount_dir/$path_prefix/$record_dir/$record $dst_path/$record_dir/$record"
  rsync -avPh $mount_dir/$path_prefix/$record_dir/$record $dst_path/$record_dir/ 
  chmod 664 $dst_path/$record_dir/$record 
done
notify-send "Download Finished!"
