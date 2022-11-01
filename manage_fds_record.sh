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

function parse_arguments() {
	
	while [ $# -gt 0 ] ; do
    local opt="$1"; shift
    case "${opt}" in
      -h|--help)
        show_usage
        exit 1
        ;;
      -s|--search)
        search_record "$@"
        exit 1
        ;;
      -d|--download)
        download_record "$@"
        exit 1
        ;;
      *)
        warning "Unknow option: ${opt}"
        show_usage
        exit 2
        ;;
    esac
  done
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
  echo "date --date='$@' "+%Y %m %d %H %M %S""
  read -r y m d H M S <<< "$(date "+%Y %m %d %H %M %S" --date="$*")"
  for var in y m d H M S; do echo "$var=${!var}"; done

  search_seconds=$(($H*3600+$M*60+$S))
  echo $search_seconds
  dirs=($(ls "$mount_dir/$path_prefix/$y-$m-$d"))
  echo "dir: ${dirs[1]}"
  dir=""
  for temp_dir in ${dirs[@]}; do
    seconds=$(parse_dir_name2time $temp_dir)
    echo "$temp_dir seconds: $seconds"
    if [[ $search_seconds -lt $seconds ]];then
      break 
    else
      dir=$temp_dir
    fi
  done
  if [[ $dir == "" ]];then 
    error "no dir contain time: $*"
    exit -1
  fi
  echo $dir
  exit 1
}

parse_arguments $@
