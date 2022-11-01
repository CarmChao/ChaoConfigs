#!/bin/bash

export XIAOMI_FDS_ENDPOINT=cnbj1-fds.api.xiaomi.net

fdsfuse data-input ~/fds_data -o passwd_file=~/Configs/.fds_key -o use_cache=~/.fds_cache -o endpoint=cnbj1.fds.api.xiaomi.com

