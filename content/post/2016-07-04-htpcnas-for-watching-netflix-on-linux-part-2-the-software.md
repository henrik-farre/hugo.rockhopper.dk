---
title: "HTPC/NAS for watching Netflix on Linux part 2: the software"
author: Henrik
date: 2016-04-07
url: /linux/software/htpcnas-for-watching-netflix-on-linux-part-2-the-software/
categories:
  - Software
tags:
  - HTPC
  - KODI

---

The system runs Arch Linux with Kodi and Chrome to view Netflix. The post will not go into detail on how to configure Kodi, but rather getting the other pieces of the puzzle setup.<!--more--> Read part 1 here: [HTPC/NAS for watching Netflix on Linux part 1: the hardware](/linux/hardware/htpcnas-for-watching-netflix-on-linux-part-1-the-hardware/)

Originally the setup used [Pipelight](https://wiki.archlinux.org/index.php/Pipelight) to watch Netflix, but I have moved away from that, because Chrome for Linux has native support for Netflix playback since version 42.

## Xorg setup

The system uses integrated Intel HD 4400 Graphics, and works without any configuration, but to tweak driver settings I created the file ```/etc/X11/xorg.conf.d/40-device.conf``` and added:

<pre>
Section "Device"
  Identifier  "Card0"
  Driver      "intel"
  Option      "TearFree" "on"
  Option      "TripleBuffer" "on"
  Option      "Tiling" "on"
  Option      "monitor-HDMI1" "HDMI1"
EndSection
</pre>

Refer to the Arch Linux [wiki entry on Xorg](https://wiki.archlinux.org/index.php/Xorg) for more information
## Auto login

As Arch Linux uses systemd I just followed the instructions for [setting up auto login to console](https://wiki.archlinux.org/index.php/Automatic_login_to_virtual_console).

Create the directory ```/etc/systemd/system/getty@tty1.service.d``` and add the following content to the file: ```/etc/systemd/system/getty@tty1.service.d/autologin.conf```

<pre>
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin YOUR_USERNAME --noclear %I 38400 linux
</pre>

Remember to change YOUR_USERNAME

## Auto start Xorg

I have this in ```~/.bash_profile``` which gets sourced when auto login runs.

<pre>
<code class="language-bash">source /etc/profile

umask 007
setterm -blank 0

export PATH=$HOME/bin:$PATH:/usr/local/bin

if [[ x$DISPLAY == 'x' ]]; then
  # Do not redirect output if you want to run xorg as rootless
  exec startx
fi
</code></pre>

## Openbox

The startx command executes ```~/.xinitrc``` which contains:

<pre>
<code class="language-bash">#!/bin/sh
exec openbox-session
</code></pre>

Then Openbox executes: ```~/.config/openbox/autostart```

<pre><code class="language-bash">#!/bin/bash

xrdb -load ~/.Xresources

# If colors looks "off", try to enable the following, my problem has disappeared in newer versions of the Intel driver
# xrandr --output HDMI2 --set "Broadcast RGB" "Full"
# Hide cursor
unclutter &
xset -dpms s off
setxkbmap dk

/usr/bin/kodi --standalone -fs &</code></pre>

## Kodi tweaks

### Hardware accelerated playback on Intel

I have installed libva-intel-driver, libva-vdpau-driver, libvdpau and libva and enabled hardware accelerated playback in Kodi's settings. The Intel HD Graphics can handle 1080p without problems.

### Idle CPU usage
Depending on the Intel driver version, Kodi might use about 15% CPU when idle, but by editing ```~/.kodi/userdata/advancedsettings.xml``` I was able to reduce it to 3%

<pre>
<code class="language-xml">&lt;advancedsettings&gt;
  &lt;gui&gt;
    &lt;algorithmdirtyregions&gt;3&lt;/algorithmdirtyregions&gt;
    &lt;nofliptimeout&gt;1000&lt;/nofliptimeout&gt;
  &lt;/gui&gt;
&lt;/advancedsettings&gt;
</code></pre>

### Mouse pointer

To get a decent size cursor in Chrome I have these settings in ```~/.Xresources``` (Requires the DMZ mouse cursor theme installed)

<pre>
Xcursor.theme: DMZ
Xcursor.size: 32
</pre>

## Plugins

I created two simple addons that launches Chromium in fullscreen mode and opens a website like Rdio or Netflix. You can find them in my [XBMC addons repository](https://github.com/henrik-farre/xbmc-addons)

## CEC (Consumer Electronics Control) over HDMI
I also added a USB - CEC Adapter from [PulseEight](https://www.pulse-eight.com/) so it is possible to control Kodi using the TVs remote control.

If you wish to remap some of the buttons on your remote here is an excellent guide: [How To remap CEC buttons on a Sony TV Remote for XBMC under Xbian 1.0.5a](http://xbmcnut.blogspot.dk/2013/07/how-to-remap-cec-buttons-on-sony-tv.html)

