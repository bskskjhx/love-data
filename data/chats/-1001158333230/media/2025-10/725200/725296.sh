
# 解除cpu频率限制
echo 1 > /proc/game_opt/disable_cpufreq_limit
chmod 444 /proc/game_opt/disable_cpufreq_limit

# 伪装温度
echo "0 37000" > /proc/shell-temp
echo "1 37000" > /proc/shell-temp
echo "2 37000" > /proc/shell-temp

# 关闭温控解除限制
while :
do
    setprop init.svc.thermal-engine stopped
    setprop init.svc.android.thermal-hal stopped
    if pgrep -f "com.x1y9.probe|com.bilibili.fatego|com.hypergryph.arknights" >/dev/null; then
touchHidlTest -c wo 0 26 258
else
touchHidlTest -c wo 0 26 0
fi
    sleep 5
done
