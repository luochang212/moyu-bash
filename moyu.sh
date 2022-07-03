# Author: github@luochang212

work_start="10:00:00"    # 上班时间
lunch_start="12:00:00"    # 午饭开始
lunch_end="13:00:00"    # 午饭结束
dinner_start="18:00:00"    # 晚饭开始
dinner_end="19:00:00"    # 晚饭结束
work_end="20:00:00"    # 下班时间
salary=40000    # 月薪
day=22    # 每月工作天数


CURRENT_TIME=$(date +"%T")
EMOJI_ARRAY=("(・▽ < )★" "─=≡Σ((( つ•̀ 3 •́)つ" "┗|｀O′|┛" "_(┐「ε:)_" "ヽ( ˘ω˘ )ゝ")

get_second() {
    read -r h m s <<< $(echo $1 | tr ':' ' ')
    echo $(((h*60*60)+(m*60)+s))
}

calc_duration() {
    local start=$(get_second $1)
    local end=$(get_second $2)
    echo $((end-start))
}

calc_work_time() {
    local lunch_time=$(calc_duration $lunch_start $lunch_end)
    local dinner_time=$(calc_duration $dinner_start $dinner_end)
    if [ $(calc_duration $CURRENT_TIME $work_start) -gt 0 ]; then
        echo 0
    elif [ $(calc_duration $CURRENT_TIME $lunch_start) -gt 0 ]; then
        echo $(calc_duration $work_start $CURRENT_TIME)
    elif [ $(calc_duration $CURRENT_TIME $lunch_end) -gt 0 ]; then
        echo $(calc_duration $work_start $lunch_start)
    elif [ $(calc_duration $CURRENT_TIME $dinner_start) -gt 0 ]; then
        echo $(($(calc_duration $work_start $CURRENT_TIME) - lunch_time))
    elif [ $(calc_duration $CURRENT_TIME $dinner_end) -gt 0 ]; then
        echo $(($(calc_duration $work_start $dinner_start) - lunch_time))
    elif [ $(calc_duration $CURRENT_TIME $work_end) -gt 0 ]; then
        echo $(($(calc_duration $work_start $CURRENT_TIME) - lunch_time - dinner_time))
    else
        echo $(($(calc_duration $work_start $work_end) - lunch_time - dinner_time))
    fi
}

show_work_time() {
    local work_sec=$(calc_work_time)
    echo "$(($work_sec / 3600)) hours and $(($work_sec % 3600 / 60)) minutes and $(($work_sec % 60)) seconds"
}

calc_money() {
    local lunch_time=$(calc_duration $lunch_start $lunch_end)
    local dinner_time=$(calc_duration $dinner_start $dinner_end)
    local mnt=$((($(calc_duration $work_start $work_end) - lunch_time - dinner_time) / 60))
    local salary_per_mnt=$(($salary * 100000000 / $day / $mnt))
    local work_sec=$(calc_work_time)
    local money=$((salary_per_mnt * (work_sec / 60) / 1000000))
    echo $money
}

show_money() {
    local money=$(calc_money)
    echo "已挣到：$(($money / 100)).$(($money % 100)) 元"
}

calc_work_end() {
    if [ $(calc_duration $CURRENT_TIME $work_start) -gt 0 ]; then
        echo "距离下班还有：[还没开始上班]"
    elif [ $(calc_duration $CURRENT_TIME $work_end) -gt 0 ]; then
        local time_left=$(calc_duration $CURRENT_TIME $work_end)
        echo "距离下班还有：$(($time_left / 3600)) 小时 $(($time_left % 3600 / 60)) 分钟 $(($time_left % 60)) 秒"
    else
        echo "距离下班还有：[下班啦]"
    fi
}

random_emoji() {
    local len=${#EMOJI_ARRAY[*]}
    echo ${EMOJI_ARRAY[RANDOM % $len]}
}


random_emoji
show_money
calc_work_end
