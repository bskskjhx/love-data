#!/system/bin/sh
# Pure Script Mount 1.1.2
# by NekoYuzu (MlgmXyysd)

# You can add your device specific partitions here
LIST="
odm
odm_dlkm
oem
product
system
system_dlkm
system_ext
vendor
vendor_dlkm
"
SKIP="
"

SCRIPTDIR=${0%/*}
SKIP_FLAG="$SCRIPTDIR/skip_mount"
MOUNT_DIST="$SCRIPTDIR/overlay"
OVERLAY_IMG="$SCRIPTDIR/overlay.img"
TEMP_DIST="$MOUNT_DIST/workdir"
IS_OVERLAY_SUPPORTED=$(gzip -c -d /proc/config.gz | grep CONFIG_OVERLAY_FS=y)

if [ ! -f $OVERLAY_IMG ]; then
  # 10 GiB of overlayfs image
  /system/bin/mkfs.ext4 -b 4096 $OVERLAY_IMG 2621440
fi

mkdir -p $MOUNT_DIST
umount -l $MOUNT_DIST
mount -v -t ext4 -o rw $OVERLAY_IMG $MOUNT_DIST

if [ -f $SKIP_FLAG ]; then
  # Skip partition mount, keep mount overlay.img for troubleshooting
  exit
fi

if [ "$(getprop persist.sys.safemode)" == "1" ] || [ "$(getprop ro.sys.safemode)" == "1" ]; then
  # Safe mode, create skip mount flag for next boot
  touch $SKIP_FLAG
fi

for partition in $LIST; do
  if [ $partition != "workdir" ]; then
    if [ -d /$partition ] && [ -z "$(ls -l / | grep "$partition ->")" ]; then
      # Partition found in root (not link)
      if [ -n $IS_OVERLAY_SUPPORTED ]; then
        if [ -d $MOUNT_DIST/$partition ]; then
          chmod -R 755 $MOUNT_DIST/$partition
          if [ "$(getprop sys.boot_completed)" == "1" ]; then
            # Boot completed, remount rw
            mkdir -p $TEMP_DIST
            umount -l /$partition
            mount -v -t overlay -o lowerdir=/$partition,upperdir=$MOUNT_DIST/$partition,workdir=$TEMP_DIST overlay_$partition /$partition
            rm -rf $TEMP_DIST
          else
            # Early boot, mount ro
            mount -v -t overlay -o lowerdir=$MOUNT_DIST/$partition:/$partition overlay_$partition /$partition
          fi
        fi
      else
        echo Fallback to bind mount is not implemented yet!
        exit
        # TODO: Fallback to bind mount
        # chmod -R 755 $partition
        # FILE=$(find $partition)
        # for f in $FILE; do
          # if [ -d $f ]; then
            # chmod 644 $f
            # if [ ! -d /$f ]; then
              # SKIP="$SKIP
              # $f
              # "
              # mount -o bind $f /$f
            # fi
          # elif [ -f $f ]; then
            # if [ $(echo "${SKIP[@]}" | grep "${f%/*}") == "" ]; then
              # mount -o bind $f /$f
            # fi
          # fi
        # done
      fi
    fi
  fi
done
