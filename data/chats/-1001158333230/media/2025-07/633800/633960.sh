# 发送通知
function notification_simulation(){
  local title="${2}"      # 通知标题（第二个参数）
  local text="${1}"       # 通知内容（第一个参数）
  local author="${3}"     # 发送用户ID（第三个参数）

  # 特殊服务授权（仅限Google设备）
  if test "$(pm list package | grep -w 'com.google.android.ext.services' )" != "" ;then
    cmd notification allow_assistant 'com.google.android.ext.services/android.ext.services.notification.Assistant'
  fi

  # 用户ID兜底策略
  test "`echo "${author}" | grep -E '^[0-9].*[0-9]$'`" = "" && author="2000"
  
  # 两种su执行方式适配
  if [[ "$(su --help 2>/dev/null | sed '/--command/!d' )" = "" ]]; then
    su "${author}" -i -c "cmd notification post -S messaging --conversation '${title}' --message '${title}':'${text}' 'Tag' '$(echo $RANDOM)' " 
  else
    su -lp "${author}" -c "cmd notification post -S messaging --conversation '${title}' --message '${title}':'${text}' 'Tag' '$(echo $RANDOM)' " 
  fi
}

# 发送通知示例
notification_simulation "这是内容" "这是标题" "2000"