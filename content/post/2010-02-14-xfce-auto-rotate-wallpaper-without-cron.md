---
title: 'Xfce: auto rotate wallpaper without cron'
author: Henrik
layout: post
date: 2010-02-14
url: /linux/software/xfce/xfce-auto-rotate-wallpaper-without-cron/
categories:
  - Xfce

---
Since Xfce 4.6 I&#8217;ve had the wallpaper autorotated on my Xfce desktop with the help of a small script and cron. But after an update of some component (probably libxfconf / xfconf) my script did not work anymore and I got this error if I tried to run the script from a console or via ssh:
<!--more-->

<pre>** (process:4150): CRITICAL **: Failed to init libxfconf: Failed to connect to socket /tmp/dbus-xrIvHB4Jas: Connection refused</pre>

So I made a workaround that did not require cron, and it runs in the current session. I created a .desktop file in ~/.config/autostart with this content:

{{< highlight ini >}}
[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=Rotate bg
Comment=
Exec=/home/enrique/bin/xfce-rotatebg.sh &
StartupNotify=false
Terminal=false
Hidden=false
{{< /highlight >}}

And the content of the xfce-rotatebg.sh is:

{{< highlight bash >}}
#!/bin/sh
while true; do
  PROPERTY="/backdrop/screen0/monitor0/image-path"
  IMAGE_PATH=`xfconf-query -c xfce4-desktop -p ${PROPERTY}`
  xfconf-query -c xfce4-desktop -p ${PROPERTY} -s ""
  xfconf-query -c xfce4-desktop -p ${PROPERTY} -s "${IMAGE_PATH}"
  sleep 600
done
{{< /highlight >}}

The sleep command controls the delay between wallpaper changes.

Remember this only works if you have created a list of wallpapers in the desktop settings of Xfce.
