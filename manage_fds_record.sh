#!/bin/bash

BOLD='\033[1m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[32m'
WHITE='\033[34m'
YELLOW='\033[33m'
NO_COLOR='\033[0m'

function info() {
  (echo >&2 -e "[${WHITE}${BOLD}INFO${NO_COLOR}] $*")
}

function error() {
  (echo >&2 -e "[${RED}ERROR${NO_COLOR}] $*")
}

function warning() {
  (echo >&2 -e "${YELLOW}[WARNING] $*${NO_COLOR}")
}

function ok() {
  (echo >&2 -e "[${GREEN}${BOLD} OK ${NO_COLOR}] $*")
}

mount_dir="/home/chao/fds_data"

path_prefix="car/eng/bhx/0003"
#path_prefix="car/eng/bmk/0005"

dst_path="/media/chao/Data/bag/data-input/car/eng/bhx/0003"
#dst_path="/media/chao/Data/bag/data-input/car/eng/bmk/0005"
record_prefix="record"
traget_dir=""
target_record=""

function parse_arguments() {
	while [ $# -gt 0 ] ; do
    local opt="$1"; shift
    case "${opt}" in
      -h|--help)
        show_usage
        exit 0
        ;;
      -s|--search)
        search_record "$@"
        exit 0
        ;;
      -d|--download)
        download_record "$@"
        exit 0
        ;;
      *)
        warning "Unknow option: ${opt}"
        show_usage
        exit 2
        ;;
    esac
  done
}

function show_usage() {
  echo "Usage:"
  echo "  -h|--help: show usage"
  echo "  -s|--search search_date: search record/dir in specify date"
  echo "  -d|--download dir [record.1 record.2 ...]: download specify record"
}

function parse_dir_name2time(){
  let builtin
  IFS='-'
  read -a t_arr <<< "$*"
  second=0
  for t in ${t_arr[@]}; do
    second=$((second*60+10#$t))
  done
  echo "$second"
}

function search_record() {
  #echo "date --date='$@' "+%Y %m %d %H %M %S""
  read -r y m d H M S <<< "$(date "+%Y %m %d %H %M %S" --date="$*")"

  dirs=($(ls "$mount_dir/$path_prefix/$y-$m-$d"))
  echo "dirs in $y-$m-$d:"
  for dir in ${dirs[@]}; do echo "$dir"; done

  search_seconds=$(($H*3600+$M*60+$S))
  #echo $search_seconds
  if [[ $search_seconds == "0" ]];then
    exit 0
  fi

  dir=""
  start_seconds=""
  for temp_dir in ${dirs[@]}; do
    seconds=$(parse_dir_name2time $temp_dir)
    #echo "$temp_dir seconds: $seconds"
    if [[ $search_seconds -lt $seconds ]];then
      break 
    else
      dir=$temp_dir
      start_seconds=$seconds
    fi
  done
  if [[ $dir == "" ]];then 
    error "no dir contain time: $*"
    exit -1
  fi
  record_idx=$(((search_seconds-start_seconds)/30))
  printf -v record_idx "%05g" $record_idx
  record_name="$record_prefix.$record_idx"
  echo "$y-$m-$d/$dir ${record_name}"
  exit 1
}

function download_record() {
  if [ $# -lt 1 ]; then
    warning "Usage: ./download_record.sh dir [record.1 record.2 ...]"
    exit -1
  fi

  if [ ! -d $mount_dir/$path_prefix ]; then
    error "make sure fds is mounted"
    exit -1
  fi

  if [ ! -d $dst_path ]; then
    error "$dst_path is not exit"
    exit -1
  fi

  record_dir=$1

  shift 1

  if [ $# == 0 ]
  then
    if [ ! -d $dst_path/$record_dir ]; then
      info "mkdir $dst_path/$record_dir"
      mkdir -p $dst_path/$record_dir
    fi
    info "download whole dir: $mount_dir/$path_prefix/$record_dir to $dst_path/$record_dir"
    rsync -ravPh $mount_dir/$path_prefix/$record_dir $dst_path
    chmod -R 774 $dst_path/$record_dir
    chmod 664 $dst_path/$record_dir/*
    notify-send -a record_downloader "Download $record_dir finished"
  else
    for record in $@
    do
      record_path=$record_dir/$record
      if [ ! -f $mount_dir/$path_prefix/$record_path ]; then
        warning "can not find record: $mount_dir/$path_prefix/$record_path"
        continue
      fi

      if [ ! -d $dst_path/$record_dir ]; then
        info "mkdir $dst_path/$record_dir"
        mkdir -p $dst_path/$record_dir
      fi

      info "cp $mount_dir/$path_prefix/$record_dir/$record $dst_path/$record_dir/$record"
      rsync -avPh $mount_dir/$path_prefix/$record_dir/$record $dst_path/$record_dir/
      chmod 664 $dst_path/$record_dir/$record
      notify-send -a record_downloader "Download $record_dir/$record finished"
    done
  fi
}

if [[ $# -eq 0 ]];then
  show_usage
  exit 1
fi
parse_arguments $@

