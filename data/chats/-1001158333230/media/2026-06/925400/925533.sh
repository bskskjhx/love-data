#!/system/bin/sh
# ==================================================
# 【脚本说明】
# 脚本名称：异环解锁PC级画质帧率一键脚本
# 适用游戏：《异环》官服 / Bilibili渠道服
# 适用环境：安卓已ROOT设备（Magisk/KernelSU/APatch等ROOT环境通用）
# 核心功能：
#   1. 交互式菜单，自主选择抗锯齿模式（TAA/GSR/关闭）、帧生成开关
#   2. 一键解锁165Hz帧率上限，突破游戏原生帧率限制
#   3. 全画质档位拉满，解锁PC级渲染参数、100%原生渲染分辨率
#   4. 自动解除文件锁定、权限限制，彻底解决Operation not permitted报错
#   5. 写入完成后锁定555只读权限+不可变属性，彻底防止游戏回改配置
# 注意事项：
#   1. 建议骁龙8至尊版及以上芯片开启帧生成，低端机型建议关闭帧生成
#   2. GSR为高通骁龙专属抗锯齿技术，天玑/麒麟芯片推荐选择TAA
#   3. 165Hz高负载模式下，请全程搭配散热器使用，避免温控降频锁帧
#   4. 若游戏启动闪退，请手动执行以下命令解锁：
#      chattr -ia 配置文件路径 && chmod 644 配置文件路径
#      或直接删除配置文件，重启游戏会自动还原默认配置
# ==================================================
# 【更新日志】
# V2.0 2026-04-25
#   1. 补全脚本执行逻辑，无截断、无参数冲突
#   2. 新增交互式自选菜单，执行脚本后可自主选择抗锯齿模式、帧生成开关，无需修改脚本代码
#   3. 新增ROOT权限前置检测，无ROOT权限直接提示退出，避免无效执行报错
#   4. 新增配置确认环节，避免误操作，新手友好度拉满
#   5. 优化抗锯齿参数适配，TAA/GSR/关闭三模式全兼容，无参数冲突
# 颜色定义
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

# 游戏渠道配置
OFFICIAL_NAME="官服"
OFFICIAL_PKG="com.hottagames.yh.laohu"
OFFICIAL_DIR="/data/user/0/com.hottagames.yh.laohu/files/UnrealGame/HT/HT/Saved/Config/Android"
OFFICIAL_CFG="$OFFICIAL_DIR/GameUserSettings.ini"

BILI_NAME="哔哩哔哩服"
BILI_PKG="com.hottagames.yh.bilibili"
BILI_DIR="/data/user/0/com.hottagames.yh.bilibili/files/UnrealGame/HT/HT/Saved/Config/Android"
BILI_CFG="$BILI_DIR/GameUserSettings.ini"

# 临时文件配置
TMP_CFG="/data/local/tmp/.GameUserSettings_$$.tmp"
FOUND_COUNT=0
DONE_OFFICIAL=0
DONE_BILI=0
RUNNING_OFFICIAL=0
RUNNING_BILI=0

# 分割线函数
line() {
    echo -e "${GREEN}==================================================${NC}"
}

# 消息输出函数
msg() {
    echo -e "$1"
}

# 进程检测函数
is_running() {
    PKG="$1"
    pidof "$PKG" >/dev/null 2>&1 && return 0
    ps -A 2>/dev/null | grep -q "$PKG" && return 0
    return 1
}

# 应用/目录存在性检测函数
pkg_or_dir_exists() {
    PKG="$1"
    DIR="$2"
    pm path "$PKG" >/dev/null 2>&1 && return 0
    [ -d "$DIR" ] && return 0
    return 1
}

# 进程停止函数
stop_one() {
    PKG="$1"
    am force-stop "$PKG" 2>/dev/null
    pkill -f "$PKG" 2>/dev/null
}

# 应用启动函数
launch_one() {
    NAME="$1"
    PKG="$2"
    msg "${CYAN}[*] 正在启动 ${NAME}...${NC}"
    monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        msg "${GREEN}[✓] ${NAME} 启动完成${NC}"
        return 0
    else
        msg "${RED}[×] ${NAME} 启动失败，请手动打开${NC}"
        return 1
    fi
}

# 生成画质配置临时文件（根据用户选择自动适配参数）
make_temp_config() {
    cat > "$TMP_CFG" <<EOF
;METADATA=(Diff=true, UseCommands=true)
[Internationalization]
Language=zh-CN
Locale=zh-CN
[Setting]
Graphics_Sharpen=0.8
[HTPSOComplie]
ShowPSOPreComplieVersion=1.0.0
[PSOGameVersion]
GameVersion=1003
[ScalabilityGroups]
sg.ResolutionQuality=100
sg.ViewDistanceQuality=4
sg.AntiAliasingQuality=4
sg.ShadowQuality=4
sg.GlobalIlluminationQuality=4
sg.ReflectionQuality=4
sg.PostProcessQuality=4
sg.TextureQuality=4
sg.EffectsQuality=4
sg.FoliageQuality=4
sg.ShadingQuality=4
sg.LandscapeQuality=3
[/Script/HTGame.HTGameUserSettings]
bCameraShake=True
bOpenHitPause=True
bOpenDamageFloatsWidget=True
bNpcCanDialogMarkShow=True
bOpenPlayerBufferList=False
bOpenMonsterBufferList=False
bIsBufferSimplifiedMode=False
bShowManualLockButton=False
bResetCameraWhenLockTarget=True
bAutoModifyCameraWhileRunning=True
bInFirstPersonView=False
bUseLockTargetAngle=False
fLockTargetAngleScale=0.250000
fFightDefaultArmLengthScale=0.250000
fFPCameraSmoothScale=0.500000
fFPCameraFOV=90.000000
fSteeringSensitivity=0.500000
MobileDrawIconsLimitOverride=()
DrawMiniMapNavigationPath=True
bNeedModifyDLSSMode=True
# ========== 用户自选抗锯齿模式 ==========
MobileAAMethod=${AA_METHOD}
DesktopAAMethod=DLSS
bDLSSRR=True
CloseOtherAAMethod=${AA_CLOSE}
# ========== 用户自选帧生成开关 ==========
bUseFSR=True
FSRQualityMode=0
bFSRFrameGeneration=${FG_FSR}
bUseDLSS=True
DLSSMode=4
RayTracingQuality=Disable
StreamlineMode=Off
GraphicQualityLevel=-1
ScreenPercentage=100
GIMethod=1
ReflectionMethod=2
CacheVsyncValue=1
bIsEnableMetalFX=-1
MobileAFME=${FG_AFME}
bMobileHWFG=${FG_HWFG}
bMobileMFRC=${FG_MFRC}
MobileRes=100.000000
NPCQuality=3
MotionBlur=0
VehicleBrakeChangeKey=1
VehicleDrive=0
SurroundSound=1
BrightnessSetting=2.200000
Language=zh-CN
AudioCulture=zh
PSCrossPlatform=1
RecordPlayerMusic=(MusicID="",RecordTime=0.000000,PlayMode=Sequential)
VehiclePlayerMusic=(MusicID="",RecordTime=0.000000,PlayMode=Sequential)
MovablePlayerMusic=(MusicID="",RecordTime=0.000000,PlayMode=Sequential)
bEnableNPCWalkIK=False
bEnablePlayerFootIK=False
DlgSkipNotShowTime=0
MapMessageBoxNotShowTime=()
bIsAutoVines=True
bSelfieShowSelf=True
bSelfieShowFriendNpc=True
bSelfieShowMonster=True
bSelfieShowWeapon=True
bSelfieOpenDof=True
bSelfieCameraVirtual=False
bSelfieShowWatermark=True
bSelfieFaceToCamera=True
bOpenAuxiliaryLine=False
bOpenFocal=False
bSelfieOptionSave=True
SelfieFocalLength=20.000000
ManualFocusDistance=50.000000
FocusOffset=1.200000
SelfiePlayerRotator=0.000000
SelfieCameraRotator=0.000000
SelfieBrightness=1.000000
SelfieSaturation=1.000000
SelfieContrast=1.000000
SelfieTemperature=6500.000000
SelfieTint=0.000000
SelfieBloomIntensity=0.680000
SelfieBloomThreshold=0.800000
SelfieVignette=0.400000
SelfieScreenGameSetting=(bOverride_ColorGamma=False,ColorGamma=(X=1.000000,Y=1.000000,Z=1.000000,W=1.000000),ColorSaturation=(X=1.000000,Y=1.000000,Z=1.000000,W=1.000000),bOverride_ColorContrast=False,ColorContrast=(X=1.000000,Y=1.000000,Z=1.000000,W=1.000000),WhiteTemp=6500.000000,bOverride_WhiteTint=False,WhiteTint=0.000000,bOverride_BloomIntensity=False,BloomIntensity=0.675000,bOverride_BloomThreshold=False,BloomThreshold=-1.000000,bOverride_VignetteIntensity=False,VignetteIntensity=0.000000)
SelfieCameraGameSetting=(NormalFocalLength=20.000000,UseStickFocalLength=20.000000,DroneFocalLength=20.000000,bFocusEnable=False,ManualFocusDistance=50.000000,FocusOffset=1.200000,PlayerRotator=0.000000,CameraRotator=0.000000,bFaceToCamera=False,bShowAuxiliaryLine=False,bHideSelf=False,bHideMonster=False,bHideFriend=False)
SelfieDroneGameSetting=(FocalLength=20.000000,DroneSpeed=50.000000,DroneAcceleration=1.200000,bDroneOpenVoice=False)
FocalSliderValue=0.000000
fAimmingTouchRate_X=4.000000
fDefaultAimmingTouchRateX_PC=4.000000
fAimmingTouchRate_Y=4.000000
fDefaultAimmingTouchRateY_PC=4.000000
CameraSlideYawSpeed=5.000000
fDefaultCameraSlideYawSpeed_PC=5.000000
CameraSlidePitchSpeed=5.000000
fDefaultCameraSlidePitchSpeed_PC=5.000000
FPCameraSlideYawSpeed=5.000000
fDefaultFPCameraSlideYawSpeed_PC=5.000000
FPCameraSlidePitchSpeed=5.000000
fDefaultFPCameraSlidePitchSpeed_PC=5.000000
LockDirectionCondition=LockType_None
bInverseMouseX=False
bInverseMouseY=False
bUseVSync=False
bUseDynamicResolution=False
ResolutionSizeX=3168
ResolutionSizeY=1440
LastUserConfirmedResolutionSizeX=3168
LastUserConfirmedResolutionSizeY=1440
FullscreenMode=1
LastConfirmedFullscreenMode=1
PreferredFullscreenMode=1
Version=5
AudioQualityLevel=0
LastConfirmedAudioQualityLevel=0
FrameRateLimit=165.000000
DesiredScreenWidth=3168
DesiredScreenHeight=1440
LastUserConfirmedDesiredScreenWidth=3168
LastUserConfirmedDesiredScreenHeight=1440
LastRecommendedScreenWidth=-1.000000
LastRecommendedScreenHeight=-1.000000
LastCPUBenchmarkResult=-1.000000
LastGPUBenchmarkResult=-1.000000
LastGPUBenchmarkMultiplier=1.000000
bUseHDRDisplayOutput=True
HDRDisplayOutputNits=1000
[/Script/Engine.GameUserSettings]
bUseDesiredScreenHeight=True
EOF
}

# 修复文件所有者、SELinux上下文，最终锁定555只读权限
fix_and_lock_config() {
    TARGET="$1"
    PARENT="$(dirname "$TARGET")"
    # 修复所有者，与父目录保持一致，确保游戏能正常读取
    if [ -d "$PARENT" ]; then
        UG="$(stat -c '%u:%g' "$PARENT" 2>/dev/null)"
        [ -n "$UG" ] && chown "$UG" "$TARGET" 2>/dev/null
    fi
    # 修复SELinux上下文，解决高版本安卓读取拦截
    if command -v restorecon >/dev/null 2>&1; then
        restorecon "$TARGET" >/dev/null 2>&1
    fi
    # 核心：锁定555只读权限（所有者/组/其他用户均只有读+执行权限，无写入权限）
    chmod 0555 "$TARGET" 2>/dev/null
    # 双重锁定：添加不可变属性，彻底禁止任何修改/删除操作（包括root和游戏）
    chattr +ia "$TARGET" 2>/dev/null
}

# 写入单渠道配置文件
write_one() {
    NAME="$1"
    PKG="$2"
    DIR="$3"
    CFG="$4"
    if ! pkg_or_dir_exists "$PKG" "$DIR"; then
        msg "${YELLOW}[跳过] ${NAME} 不存在：$PKG${NC}"
        return 1
    fi
    FOUND_COUNT=$((FOUND_COUNT + 1))
    msg "${CYAN}[*] 正在写入 ${NAME} 配置...${NC}"
    mkdir -p "$DIR" 2>/dev/null || true
    
    # 写入配置文件
    cat "$TMP_CFG" > "$CFG" 2>/dev/null
    if [ ! -f "$CFG" ]; then
        msg "${RED}[×] ${NAME} 配置写入失败${NC}"
        return 1
    fi
    
    # 写入完成后，修复属性并锁定555只读权限
    fix_and_lock_config "$CFG"
    sync
    
    # 验证锁定结果
    if [ -f "$CFG" ]; then
        msg "${GREEN}[✓] ${NAME} 写入成功，已锁定555只读权限防回改${NC}"
        ls -l "$CFG" 2>/dev/null
        lsattr "$CFG" 2>/dev/null
        return 0
    else
        msg "${RED}[×] ${NAME} 配置写入失败${NC}"
        return 1
    fi
}

# ====================== 前置检测与交互式选择 ======================
clear
line
msg "${CYAN}           一键解锁异环 165Hz 稳帧高画质脚本${NC}"
msg "${BLUE}                By Ktwo 酷安Ktwo2${NC}"
line

# 1. ROOT权限检测（核心前置，无ROOT直接退出）
msg "${CYAN}[*] 正在检测ROOT权限...${NC}"
if [ "$(id -u)" -ne 0 ]; then
    msg "${RED}[×] 未获取到ROOT权限，请授予终端ROOT权限后再执行脚本${NC}"
    line
    exit 1
else
    msg "${GREEN}[✓] ROOT权限获取成功${NC}"
fi

# 2. 交互式选择抗锯齿模式
echo ""
line
msg "=====  第一步：请选择抗锯齿模式  ====="
msg "${GREEN}1. TAA 时域抗锯齿${NC}（画面柔和无闪烁，全芯片通用，推荐）"
msg "${GREEN}2. GSR 骁龙超分抗锯齿${NC}（画面锐利，高通骁龙芯片专属）"
msg "${GREEN}3. 关闭抗锯齿${NC}（极致性能，降低GPU负载）"
line
while true; do
    echo -n "请输入选项（1/2/3，直接回车默认选1）："
    read aa_choice
    # 空输入默认选1
    [ -z "$aa_choice" ] && aa_choice=1
    # 校验输入是否合法
    case $aa_choice in
        1)
            AA_METHOD="TAA"
            AA_CLOSE="None"
            AA_NAME="TAA时域抗锯齿"
            break
            ;;
        2)
            AA_METHOD="GSR"
            AA_CLOSE="GSR"
            AA_NAME="GSR骁龙超分抗锯齿"
            break
            ;;
        3)
            AA_METHOD="None"
            AA_CLOSE="None"
            AA_NAME="关闭抗锯齿"
            break
            ;;
        *)
            msg "${RED}[!] 输入错误，请输入1、2、3中的一个选项${NC}"
            ;;
    esac
done

# 3. 交互式选择帧生成开关
echo ""
line
msg "=====  第二步：请选择帧生成功能  ====="
msg "${GREEN}1. 开启帧生成${NC}（大幅提升帧率，骁龙8至尊版及以上推荐）"
msg "${GREEN}2. 关闭帧生成${NC}（降低GPU负载，避免兼容性问题）"
line
while true; do
    echo -n "请输入选项（1/2，直接回车默认选1）："
    read fg_choice
    # 空输入默认选1
    [ -z "$fg_choice" ] && fg_choice=1
    # 校验输入是否合法
    case $fg_choice in
        1)
            FG_AFME="True"
            FG_HWFG="True"
            FG_MFRC="True"
            FG_FSR="True"
            FG_NAME="开启"
            break
            ;;
        2)
            FG_AFME="False"
            FG_HWFG="False"
            FG_MFRC="False"
            FG_FSR="False"
            FG_NAME="关闭"
            break
            ;;
        *)
            msg "${RED}[!] 输入错误，请输入1或2${NC}"
            ;;
    esac
done

# 4. 最终配置确认
echo ""
line
msg "=====  最终配置确认  ====="
msg "抗锯齿模式：${AA_NAME}"
msg "帧生成功能：${FG_NAME}"
msg "防回改锁定：555只读权限+不可变属性（已开启）"
msg "适配渠道：官服+Bilibili服（自动检测）"
line
echo -n "是否确认执行？（y/n，直接回车默认执行）："
read confirm
if [ "$confirm" = "n" ] || [ "$confirm" = "N" ]; then
    msg "${YELLOW}[!] 用户取消执行，脚本已退出${NC}"
    line
    exit 0
fi

# ====================== 主执行流程 ======================
echo ""
line
msg "${CYAN}[*] 开始执行配置修改...${NC}"
line

# 1. 检测游戏运行状态
msg "${CYAN}[*] 正在检测游戏运行状态...${NC}"
if is_running "$OFFICIAL_PKG"; then
    RUNNING_OFFICIAL=1
    msg "${YELLOW}[!] 检测到官服正在运行，将自动停止进程${NC}"
fi
if is_running "$BILI_PKG"; then
    RUNNING_BILI=1
    msg "${YELLOW}[!] 检测到B站服正在运行，将自动停止进程${NC}"
fi

# 2. 先停止游戏进程，彻底解除文件占用（核心，解决文件锁定报错）
echo
msg "${YELLOW}[*] 正在结束游戏进程，解除文件占用...${NC}"
[ "$RUNNING_OFFICIAL" -eq 1 ] && stop_one "$OFFICIAL_PKG"
[ "$RUNNING_BILI" -eq 1 ] && stop_one "$BILI_PKG"
sleep 1
msg "${GREEN}[✓] 游戏进程已停止${NC}"

# 3. 前置解锁：解除双渠道配置文件的锁定与权限限制
echo
# 官服前置解锁
if [ -d "$OFFICIAL_DIR" ]; then
    cd "$OFFICIAL_DIR"
    if [ -f "$OFFICIAL_CFG" ]; then
        msg "${CYAN}[*] 正在解锁官服配置文件锁定...${NC}"
        # 先解除不可变属性，临时放开写入权限，确保脚本可以写入配置
        chattr -ia GameUserSettings.ini 2>/dev/null
        chmod 0777 GameUserSettings.ini 2>/dev/null
        lsattr GameUserSettings.ini
        msg "${GREEN}[✓] 官服配置文件解锁完成，临时权限已放开${NC}"
    fi
    cd /
fi

# B站服前置解锁
if [ -d "$BILI_DIR" ]; then
    cd "$BILI_DIR"
    if [ -f "$BILI_CFG" ]; then
        msg "${CYAN}[*] 正在解锁B站服配置文件锁定...${NC}"
        # 先解除不可变属性，临时放开写入权限，确保脚本可以写入配置
        chattr -ia GameUserSettings.ini 2>/dev/null
        chmod 0777 GameUserSettings.ini 2>/dev/null
        lsattr GameUserSettings.ini
        msg "${GREEN}[✓] B站服配置文件解锁完成，临时权限已放开${NC}"
    fi
    cd /
fi

# 4. 生成临时配置文件（根据用户选择自动适配）
echo
make_temp_config

# 5. 写入双渠道配置，写入完成后自动锁定555权限
write_one "$OFFICIAL_NAME" "$OFFICIAL_PKG" "$OFFICIAL_DIR" "$OFFICIAL_CFG" && DONE_OFFICIAL=1
echo
write_one "$BILI_NAME" "$BILI_PKG" "$BILI_DIR" "$BILI_CFG" && DONE_BILI=1

# 6. 清理临时文件
rm -f "$TMP_CFG" 2>/dev/null

# 7. 异常处理：未检测到游戏
if [ "$FOUND_COUNT" -eq 0 ]; then
    echo
    line
    msg "${RED}[×] 无法找到文件夹或游戏未安装${NC}"
    msg "${YELLOW}    官服和哔哩哔哩服都没有检测到，已退出${NC}"
    line
    exit 1
fi

# 8. 执行完成提示
echo
line
msg "${GREEN}处理完成！165Hz 模式已就绪，配置已锁定防回改${NC}"
[ "$DONE_OFFICIAL" -eq 1 ] && msg "${GREEN}[✓] 官服已修改为 165Hz 稳帧配置，抗锯齿=${AA_NAME}，帧生成=${FG_NAME}${NC}"
[ "$DONE_BILI" -eq 1 ] && msg "${GREEN}[✓] 哔哩哔哩服已修改为 165Hz 稳帧配置，抗锯齿=${AA_NAME}，帧生成=${FG_NAME}${NC}"
line
echo

# 9. 自动重启游戏（仅对执行前正在运行的游戏生效）
if [ "$RUNNING_OFFICIAL" -eq 1 ] && [ "$DONE_OFFICIAL" -eq 1 ]; then
    launch_one "$OFFICIAL_NAME" "$OFFICIAL_PKG"
elif [ "$RUNNING_BILI" -eq 1 ] && [ "$DONE_BILI" -eq 1 ]; then
    launch_one "$BILI_NAME" "$BILI_PKG"
elif [ "$DONE_OFFICIAL" -eq 1 ]; then
    launch_one "$OFFICIAL_NAME" "$OFFICIAL_PKG"
elif [ "$DONE_BILI" -eq 1 ]; then
    launch_one "$BILI_NAME" "$BILI_PKG"
fi

echo
msg "${CYAN}配置已通过555只读权限+不可变属性双重锁定，游戏无法自动回改，尽情享受丝滑画质吧！${NC}"
