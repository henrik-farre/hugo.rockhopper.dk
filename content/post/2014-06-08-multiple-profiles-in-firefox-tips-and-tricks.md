---
title: 'Multiple profiles in Firefox: tips and tricks'
layout: post
date: 2014-06-08
url: /linux/multiple-profiles-in-firefox-tips-and-tricks/
categories:
  - Linux
  - Software
tags:
  - firefox

---
I have two different profiles for Firefox, one for work, and one for everything else.

To start Firefox with the correct profile, I have created two different application launchers (.desktop files) in ~/.local/share/applications, one called firefox-work.desktop and the other firefox-home.desktop
<!--more-->

The files contain:

{{< highlight ini >}}
[Desktop Entry]
Name=Firefox Home
GenericName=Web Browser
Comment=Browse the World Wide Web
Exec=/usr/lib/firefox/firefox -P Home -no-remote %u
Icon=firefox
Terminal=false
Type=Application
MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
Categories=Network;WebBrowser;
{{< /highlight >}}

Replace &#8220;Home&#8221; with the name of your profile.

In order to open links in the correct profile, I made a small shell script that used xdotool and zenity:

{{< highlight bash >}}#!/bin/sh

PROFILE=$(zenity --list --text "Open $1 in which profile?" --column "Profile" Work Home);

case $PROFILE in
  Home)
    PID=$(pgrep -f -- '-P Home')
    ;;
  Work)
    PID=$(pgrep -f -- '-P Work')
    ;;
  *)
    exit
    ;;
esac

# Avoid "Can't consume 1 args; are only 0 available. This is a bug." message: https://github.com/jordansissel/xdotool/issues/14
# Pick the last id, as it seems to be the one needed
WID=$(xdotool search --any --pid $PID --name "random_random_random" | tail -n1)

xdotool windowactivate --sync $WID
xdotool key --window $WID ctrl+t
xdotool key --window $WID ctrl+l
xdotool type --window $WID "$1"{{< /highlight >}}

The last thing to to is to open exo-preferred-applications and select the script as the preferred &#8220;web-browser&#8221; (remember &#8220;%s&#8221;).
