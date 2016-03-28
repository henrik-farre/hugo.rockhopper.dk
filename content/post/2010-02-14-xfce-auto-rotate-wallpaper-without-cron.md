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

<pre>** (process:4150): CRITICAL **: Failed to init libxfconf: Failed to connect to socket /tmp/dbus-xrIvHB4Jas: Connection refused</pre>

So I made a workaround that did not require cron, and it runs in the current session. I created a .desktop file in ~/.config/autostart with this content:

<pre>[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=Rotate bg
Comment=
Exec=/home/enrique/bin/xfce-rotatebg.sh &
StartupNotify=false
Terminal=false
Hidden=false</pre>

And the content of the xfce-rotatebg.sh is:

<pre class="bash codesnip" style="font-family:monospace;"><span class="co0">#!/bin/sh</span>
<span class="kw1">while</span> <span class="kw2">true</span>; <span class="kw1">do</span>
<span class="re2">PROPERTY</span>=<span class="st0">"/backdrop/screen0/monitor0/image-path"</span>
<span class="re2">IMAGE_PATH</span>=<span class="sy0">`</span>xfconf-query <span class="re5">-c</span> xfce4-desktop <span class="re5">-p</span> <span class="co1">${PROPERTY}</span><span class="sy0">`</span>
xfconf-query <span class="re5">-c</span> xfce4-desktop <span class="re5">-p</span> <span class="co1">${PROPERTY}</span> <span class="re5">-s</span> <span class="st0">""</span>
xfconf-query <span class="re5">-c</span> xfce4-desktop <span class="re5">-p</span> <span class="co1">${PROPERTY}</span> <span class="re5">-s</span> <span class="st0">"<span class="es3">${IMAGE_PATH}</span>"</span>
<span class="kw2">sleep</span> <span class="nu0">600</span>
<span class="kw1">done</span></pre>

The sleep command controls the delay between wallpaper changes.

Remember this only works if you have created a list of wallpapers in the desktop settings of Xfce.