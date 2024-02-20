#!/usr/bin/env sh

get_http_status()
{
  log_file=${1:-"/var/log/nginx/access.log"}
  lines=${2:-"100000"}
  tail -"$lines" "$log_file" | grep -ioE "HTTP\/[1|2]\.[1|0]\"[[:blank:]][0-9]{3}" | awk '{print $2}' | sort | uniq -c | awk '{print $2,$1}'
#  tail -"$lines" "$log_file" | grep -ioE "HTTP\/[1|2]\.[1|0]\"[[:blank:]][0-9]{3}" | awk '{print $2}' | sort | uniq -c | awk '{
#    if($2 >= 100 && $2 < 200){
#      i=$1
#    }else if($2 >= 200 && $2 < 300){
#      j=$1
#    }else if($2 >= 300 && $2 < 400){
#      k=$1
#    }else if($2 >= 400 && $2 < 500){
#      l=$1
#    }else if($2 >= 500){
#      m=$1
#  }} END{ t=i+j+k+l+m;print i?i:0, j?j:0, k?k:0, l?l:0, m?m:0, t, j / t}'
}

get_http_status "$@" | awk '{print $1,$2}'
