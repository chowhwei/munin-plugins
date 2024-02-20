#!/usr/bin/env sh

get_memory_usage()
{
  keyword=$1
  ps aux | grep -i "$keyword" | grep -v grep | awk '{sum+=$6} END {print(sum * 1024)}'
  return
}

get_memory_usage2()
{
  keyword=$1
  sum=0
  for pid in $(pgrep -i "$keyword")
  do
    sum=$((sum+$(ps -o rss= -p "$pid")*1024))
  done
  echo $sum;
  return
}
echo "mem.value $(get_memory_usage "WeChat")"
echo "mem.value $(get_memory_usage2 "WeChat")"