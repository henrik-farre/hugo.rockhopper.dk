---
title: Check video encoding script for MythTV
author: Henrik

date: 2008-06-28
url: /linux/software/mythtv/check-video-encoding-script-for-mythtv/
categories:
  - MythTV
tags:
  - mythfrontend

---
I&#8217;m using Xine as the preferred video player on my MythTV frontend, because it has a nice video output driver called &#8220;xxmc&#8221;. This driver enables hardware accelerated playback of mpeg1/2 streams (e.g. ivtv recordings or DVDs) on Geforce 7xxx and other Geforce chips.<!--more--> The driver should fall back to the xv driver if the stream is in another format than mpeg1/2, but somehow the xxmc drives screws up playback of videos encoded with Xvid as playback gets really jerky.

I order to work around this, I created a script to check which video encoding is used, and if it&#8217;s Xvid, Xine uses xv output. The script just requires MPlayer. Dump the script somewhere MythTV can find it, and set it as the preferred video player in MythTV.

You can of cause adapt it if you would like to use MPlayer instead of Xine, or want the script to check for something else than Xvid, or want the script to check for something entirely different then encoding (size maybe?), just check the output of: mplayer -identify &#8220;file&#8221;

<pre>
<code class="language-bash">#!/bin/bash

# Don't check encoding if MythTV is trying to playback a DVD
if [[ ${1} != 'dvd://' ]]; then
  VIDEO_FORMAT=`mplayer -really-quiet -identify -frames -vc null -vo null -ao null ${1} 2&lt;/dev/null | awk -F= '/^ID_VIDEO_FORMAT/ {print $2}'` # ID_VIDEO_FORMAT contains the encoding
else
  VIDEO_FORMAT='dvd'
fi

if [[ ${VIDEO_FORMAT} = 'XVID'  ]]; then
  VIDEO_DRIVER="-V xv" # Use xv output for Xvid, xxmc for everything else
else
  VIDEO_DRIVER="-V xxmc"
fi

# Xine options
AUDIO_DRIVER="-A alsa"
EXTRA_OPTIONS="-pfhq --no-splash"
DEBUG_OPTIONS="--verbose=5 &gt; /shared/mythtv/xine.log"

xine ${VIDEO_DRIVER} ${AUDIO_DRIVER} ${EXTRA_OPTIONS} ${1}
</code></pre>
