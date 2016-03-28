---
title: Check video encoding script for MythTV
author: Henrik
layout: post
date: 2008-06-28
url: /linux/software/mythtv/check-video-encoding-script-for-mythtv/
categories:
  - MythTV
tags:
  - mythfrontend

---
I&#8217;m using Xine as the preferred video player on my MythTV frontend, because it has a nice video output driver called &#8220;xxmc&#8221;. This driver enables hardware accelerated playback of mpeg1/2 streams (e.g. ivtv recordings or DVDs) on Geforce 7xxx and other Geforce chips. The driver should fall back to the xv driver if the stream is in another format than mpeg1/2, but somehow the xxmc drives screws up playback of videos encoded with Xvid as playback gets really jerky.

I order to work around this, I created a script to check which video encoding is used, and if it&#8217;s Xvid, Xine uses xv output. The script just requires MPlayer. Dump the script somewhere MythTV can find it, and set it as the preferred video player in MythTV.

You can of cause adapt it if you would like to use MPlayer instead of Xine, or want the script to check for something else than Xvid, or want the script to check for something entirely different then encoding (size maybe?), just check the output of: mplayer -identify &#8220;file&#8221;

<pre class="bash codesnip" style="font-family:monospace;"><span class="co0">#!/bin/bash</span>
&nbsp;
<span class="co0"># Don't check encoding if MythTV is trying to playback a DVD</span>
<span class="kw1">if</span> <span class="br0">&#91;</span><span class="br0">&#91;</span> <span class="co1">${1}</span> <span class="sy0">!</span>= <span class="st_h">'dvd://'</span> <span class="br0">&#93;</span><span class="br0">&#93;</span>; <span class="kw1">then</span>
  <span class="re2">VIDEO_FORMAT</span>=<span class="sy0">`</span><span class="kw2">mplayer</span> <span class="re5">-really-quiet</span> <span class="re5">-identify</span> <span class="re5">-frames</span> <span class="nu0"></span> <span class="re5">-vc</span> null <span class="re5">-vo</span> null <span class="re5">-ao</span> null <span class="co1">${1}</span> <span class="nu0">2</span><span class="sy0">&</span>lt;<span class="sy0">/</span>dev<span class="sy0">/</span>null <span class="sy0">|</span> <span class="kw2">awk</span> <span class="re5">-F</span>= <span class="st_h">'/^ID_VIDEO_FORMAT/ {print $2}'</span><span class="sy0">`</span> <span class="co0"># ID_VIDEO_FORMAT contains the encoding</span>
<span class="kw1">else</span>
  <span class="re2">VIDEO_FORMAT</span>=<span class="st_h">'dvd'</span>
<span class="kw1">fi</span>
&nbsp;
<span class="kw1">if</span> <span class="br0">&#91;</span><span class="br0">&#91;</span> <span class="co1">${VIDEO_FORMAT}</span> = <span class="st_h">'XVID'</span>  <span class="br0">&#93;</span><span class="br0">&#93;</span>; <span class="kw1">then</span>
  <span class="re2">VIDEO_DRIVER</span>=<span class="st0">"-V xv"</span> <span class="co0"># Use xv output for Xvid, xxmc for everything else</span>
<span class="kw1">else</span>
  <span class="re2">VIDEO_DRIVER</span>=<span class="st0">"-V xxmc"</span>
<span class="kw1">fi</span>
&nbsp;
<span class="co0"># Xine options</span>
<span class="re2">AUDIO_DRIVER</span>=<span class="st0">"-A alsa"</span>
<span class="re2">EXTRA_OPTIONS</span>=<span class="st0">"-pfhq --no-splash"</span>
<span class="re2">DEBUG_OPTIONS</span>=<span class="st0">"--verbose=5 &lt; /shared/mythtv/xine.log"</span>
&nbsp;
xine <span class="co1">${VIDEO_DRIVER}</span> <span class="co1">${AUDIO_DRIVER}</span> <span class="co1">${EXTRA_OPTIONS}</span> <span class="co1">${1}</span></pre>