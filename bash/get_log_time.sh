#!/bin/sh

file="last_log_point"

sto_unixtime()
{
  date -d "$(echo "$1" | sed -e 's,/,-,g' -e 's,:, ,')" +"%s"
}

get_time_from_log()
{
  # 23/Feb/2024:10:54:27
  now=$(tail -1 /var/log/nginx/access.log | grep -ioE "[0-9]{2}\/[a-z]{3}\/[0-9]{4}:[0-9]{2}:[0-9]{2}:[0-9]{2}")
  now_ts=$(sto_unixtime "$now")
  now_nf=$(date -d @"$now_ts" "+%Y-%m-%d %H:%M:%S")
  #23/Feb/2024:10:51:38
     #1708656698
     #2024-02-23 10:51:38
     #2024-02-23 10:51:38
  echo "$now"
  echo "$now_ts"
  echo "$now_nf"
  date -d "$(echo "$now" | sed -e 's,/,-,g' -e 's,:, ,')" +"%Y-%m-%d %H:%M:%S"
}

get_time_from_log
exit 0


get_log_time()
{
  file=$1
  if [ ! -f "$file" ]; then
    touch "$file"
  fi

  cat "$file"
}

set_log_time()
{
  file=$1
  time=$2
  echo "$time" > "$file"
}

#get_last_time()
#{
#  tail -1 "$1" |
#}

# shellcheck disable=SC2046
last=$(get_log_time "$file")

# shellcheck disable=SC2046
#echo $(set_log_time "$file" $(get_time))


time_5=`date -d "5 minutes ago" "+%d/%b/%Y:%H:%M:%S"`
time=`date "+%d/%b/%Y:%H:%M:%S"`

set_log_time "$file" "$time"
#
#if [ $(sto_unixtime "$last") -ge $(sto_unixtime "$time_5") ]; then
#  start=$last
#else
#  start=$time_5
#fi


echo "$last"
echo "$time_5"
#echo "$start"
echo "$time"

sto_unixtime "$last"
sto_unixtime "$time_5"
sto_unixtime "$time"

# 取日志规则 5分钟内最多不超过10万条日志，正常取上次到当前的日志，一言不合就取10万条
# 1、取最新日志时间戳
# 2、取上次日志时间戳，如果没有，取10万条，保存最后一条日志时间戳
# 3、如果上次日志时间戳超过了5分钟，取10万条，保存最后一条日志时间戳
# 4、取上次时间戳到本次时间戳之间的记录，如果为0（日志每日结转了），取10万条，保存最后一条日志时间戳
# 5、不为0，保存最后一条日志时间戳