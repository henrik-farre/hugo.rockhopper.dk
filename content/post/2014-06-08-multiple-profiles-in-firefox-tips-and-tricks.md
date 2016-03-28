---
title: 'Multiple profiles in Firefox: tips and tricks'
author: Henrik
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

The files contain:

<pre>[Desktop Entry]
Name=Firefox Home
GenericName=Web Browser
Comment=Browse the World Wide Web
Exec=/usr/lib/firefox/firefox -P Home -no-remote %u
Icon=firefox
Terminal=false
Type=Application
MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
Categories=Network;WebBrowser;</pre>

Replace &#8220;Home&#8221; with the name of your profile.

In order to open links in the correct profile, I made a small shell script that used xdotool and zenity:

<pre class="bash codesnip" style="font-family:monospace;"><span class="co0">#!/bin/sh</span>
&nbsp;
<span class="re2">PROFILE</span>=$<span class="br0">&#40;</span>zenity <span class="re5">--list</span> <span class="re5">--text</span> <span class="st0">"Open $1 in which profile?"</span> <span class="re5">--column</span> <span class="st0">"Profile"</span> Work Home<span class="br0">&#41;</span>;
&nbsp;
<span class="kw1">case</span> <span class="re1">$PROFILE</span> <span class="kw1">in</span>
  Home<span class="br0">&#41;</span>
    <span class="re2">PID</span>=$<span class="br0">&#40;</span>pgrep <span class="re5">-f</span> <span class="re5">--</span> <span class="st_h">'-P Home'</span><span class="br0">&#41;</span>
    <span class="sy0">;;</span>
  Work<span class="br0">&#41;</span>
    <span class="re2">PID</span>=$<span class="br0">&#40;</span>pgrep <span class="re5">-f</span> <span class="re5">--</span> <span class="st_h">'-P Work'</span><span class="br0">&#41;</span>
    <span class="sy0">;;</span>
  <span class="sy0">*</span><span class="br0">&#41;</span>
    <span class="kw3">exit</span>
    <span class="sy0">;;</span>
<span class="kw1">esac</span>
&nbsp;
<span class="co0"># Avoid "Can't consume 1 args; are only 0 available. This is a bug." message: https://github.com/jordansissel/xdotool/issues/14</span>
<span class="co0"># Pick the last id, as it seems to be the one needed</span>
<span class="re2">WID</span>=$<span class="br0">&#40;</span>xdotool search <span class="re5">--any</span> <span class="re5">--pid</span> <span class="re1">$PID</span> <span class="re5">--name</span> <span class="st0">"random_random_random"</span> <span class="sy0">|</span> <span class="kw2">tail</span> -n1<span class="br0">&#41;</span>
&nbsp;
xdotool windowactivate <span class="re5">--sync</span> <span class="re1">$WID</span>
xdotool key <span class="re5">--window</span> <span class="re1">$WID</span> ctrl+t
xdotool key <span class="re5">--window</span> <span class="re1">$WID</span> ctrl+l
xdotool <span class="kw3">type</span> <span class="re5">--window</span> <span class="re1">$WID</span> <span class="st0">"$1"</span></pre>

The last thing to to is to open exo-preferred-applications and select the script as the preferred &#8220;web-browser&#8221; (remember &#8220;%s&#8221;).