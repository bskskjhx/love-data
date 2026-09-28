check_file() {
    if [ ! -f "$1" ]; then
        echo "$2"
        return 1
    fi
    return 0
}

capacity=$(check_file /sys/class/power_supply/battery/capacity "可能机型不支持查看剩余电量" && cat /sys/class/power_supply/battery/capacity)
temp=$(check_file /sys/class/power_supply/battery/temp "可能机型不支持查看电池温度" && cat /sys/class/power_supply/battery/temp)
cycle_count=$(check_file /sys/class/power_supply/battery/cycle_count "可能机型不支持查看充电周期次数" && cat /sys/class/power_supply/battery/cycle_count)
voltage_now=$(check_file /sys/class/power_supply/battery/voltage_now "可能机型不支持查看当前电压" && cat /sys/class/power_supply/battery/voltage_now)
voltage_max=$(check_file /sys/class/power_supply/battery/voltage_max "可能机型不支持查看最大电压" && cat /sys/class/power_supply/battery/voltage_max)
full_design=$(check_file /sys/class/power_supply/battery/charge_full_design "可能机型不支持查看设计满充容量" && cat /sys/class/power_supply/battery/charge_full_design)
full=$(check_file /sys/class/power_supply/battery/charge_full "可能机型不支持查看当前满充容量" && cat /sys/class/power_supply/battery/charge_full)
charge_counter=$(check_file /sys/class/power_supply/battery/charge_counter "可能机型不支持查看充电计数器" && cat /sys/class/power_supply/battery/charge_counter)
soh=$(check_file /sys/class/qcom-battery/soh "可能机型不支持查看电池芯片容量 (SOH)" && cat /sys/class/qcom-battery/soh)

if [[ -z "$capacity" || -z "$temp" || -z "$cycle_count" || -z "$voltage_now" || -z "$voltage_max" || -z "$full_design" || -z "$full" || -z "$charge_counter" || -z "$soh" ]]; then
    echo "部分信息未能获取，可能机型不支持查看。"
    exit 1
fi

temp_celsius=$(echo "scale=1; $temp / 10" | bc)
voltage_now_v=$(echo "scale=2; $voltage_now / 1000000" | bc)
voltage_max_v=$(echo "scale=2; $voltage_max / 1000000" | bc)
full_design_mah=$(echo "scale=0; $full_design / 1000" | bc)
charge_counter=$(echo "scale=0; $charge_counter / 1000" | bc)
full_mah=$(echo "scale=0; $full / 1000" | bc)
remaining_percentage=$(awk "BEGIN {printf \"%.2f\", ($full_mah / $full_design_mah) * 100}")

if [ -n "$soh" ] && [ "$soh" -ge 80 ]; then
    soh_message="当前容量为($soh%)，不建议去售后检测。"
else
    soh_message="当前容量为($soh%)，可以去售后检查电池了。"
fi

current_time=$(date +"%Y-%m-%d %H:%M:%S")

echo ""
echo "-当前获取时间：$current_time"
echo ""
echo "-剩余电量：$capacity%"
echo "-电池温度：${temp_celsius}°C"
echo "-充电循环次数：$cycle_count次"
echo "-初始化电池容量：${full_design_mah} 毫安"
echo "-当前电池满充容量：${full_mah} 毫安"
echo "-当前电池芯片容量 (SOH)：$soh%"
echo "-当前电池电量的容量：$charge_counter 毫安"  
echo "-当前估计剩余电池容量:${remaining_percentage}%"
echo "-当前电池电压：${voltage_now_v} V（当前） / ${voltage_max_v} V（最大）"
echo ""
echo "-$soh_message"
echo ""
echo "-注意:这些数字都是，根据你的使用习惯和使用环境温度这些来计算的，并且这些都是随机应变的数字。"