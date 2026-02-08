#!/bin/zsh

gphoto2 --set-config /main/actions/viewfinder=1
gphoto2 --set-config /main/capturesettings/liveviewafmode="Face-priority AF"
gphoto2 --set-config /main/imgsettings/iso=200
gphoto2 --set-config /main/imgsettings/whitebalance=0
gphoto2 --set-config /main/capturesettings/exposurecompensation=0
gphoto2 --set-config /main/actions/autofocusdrive=1
sleep 2
gphoto2 --stdout --capture-movie | ffmpeg -i - -vf "hflip,crop=iw:iw*9/16" -fflags nobuffer -flags low_delay -preset ultrafast -tune zerolatency -vcodec rawvideo -pix_fmt yuv420p -threads 0 -s 1920x1080 -f v4l2 /dev/video2
