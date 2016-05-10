+++
date = "2016-04-24T11:44:30+02:00"
url = "/linux/hardware/htpcnas-for-watching-netflix-on-linux-part-3-the-hardware/"
title = "HTPC/NAS for watching Netflix on Linux part 3: Powermanagement"
categories = [
  "software"
]
tags = [
 "HTPC",
 "Kodi"
]

+++

My HTPC should be available when I need it, but not waste power when I'm not at home or sleeping.<!--more-->

See previous parts: [Part 1](/linux/hardware/htpcnas-for-watching-netflix-on-linux-part-1-the-hardware/), [Part 2](/linux/software/htpcnas-for-watching-netflix-on-linux-part-2-the-software/)

My setup consists of 3 scripts:

  1. <code>kodi-shutdown-inhibit-check.sh</code>: Main script that is run from cron, talks to Kodi to allow/inhibit shutdown
  2. <code>shutdown-check.sh</code>: Checks if anything should inhibit shutdown
  3. <code>set-next-wakeup.sh</code>: Sets when the computer should start next time

## Kodi idle shutdown timer

Kodi is set to shutdown after 5 mins of inactivity (See "Timer til lukning af funktion"):

{{< photo src="/uploads/kodi_powersave_settings.png" title="Kodi Powersave settings" thumb="/uploads/thumbnails/kodi_powersave_settings.png" >}}

Every 4 minutes cron runs the <code>kodi-shutdown-inhibit-check.sh</code> script. Note: it requires that <code>kodi-send</code> from the kodi-eventclients package is installed.

<pre><code class="language-bash">#!/bin/bash
# based on http://forum.xbmc.org/showthread.php?tid=172801&pid=1500080#pid1500080

LASTSTATEFILE="/tmp/xbmc-shutdown-inibit-laststate"

XBMCPIDFILE="/tmp/xbmc-shutdown-inibit-pid"

# Handle restart of xbmc
CURRENTPID=$(pgrep kodi.bin)

KODI_NOT_RUNNING=0
if [[ $? -gt 0 ]]; then
  KODI_NOT_RUNNING=1
fi

if [[ -f $XBMCPIDFILE ]]; then
  PID=`cat $XBMCPIDFILE`
else
  PID=$CURRENTPID
  echo $PID > $XBMCPIDFILE
fi

# if the old pid is not equal to the current, make sure that inhibit is send again
# by forcing it to be 0
if [[ $PID != $CURRENTPID ]]; then
  /usr/bin/logger "$0: XBMC changed PID: $PID != $CURRENTPID"
  if [[ -f $LASTSTATEFILE ]]; then
    rm $LASTSTATEFILE
  fi
  echo $CURRENTPID > $XBMCPIDFILE
fi

/usr/local/bin/set-next-wakeup.sh &>/dev/null

if [[ -f $LASTSTATEFILE ]]; then
  LASTSTATE=`cat $LASTSTATEFILE`
else
  LASTSTATE=0
fi

/usr/local/bin/shutdown-check.sh &>/dev/null
CHECK=$?

# Enable to debug
# /usr/bin/logger "$0: [DEBUG] CHECK: ${CHECK}"
# /usr/bin/logger "$0: [DEBUG] KODI_NOT_RUNNING: ${KODI_NOT_RUNNING}"
# /usr/bin/logger "$0: [DEBUG] PID: ${PID}"
# /usr/bin/logger "$0: [DEBUG] CURRENTPID: ${CURRENTPID}"

# 0: Shutdown allowed
if [[ $CHECK -eq 0 ]]; then
  if [[ $KODI_NOT_RUNNING -gt 0 ]]; then
    /usr/bin/logger "$0: Kodi not running, shutting down"
    /usr/bin/shutdown -h now
  fi
  if [[ $LASTSTATE -ne 0 ]]; then
    kodi-send --action="XBMC.InhibitIdleShutdown(false)" >/dev/null
    /usr/bin/logger "$0: Allow shutdown"
    echo "0" > $LASTSTATEFILE
#  else
#    /usr/bin/logger "$0: Shutdown allready allowed"
  fi
else
  if [[ $LASTSTATE -eq 0 ]]; then
    kodi-send --action="XBMC.InhibitIdleShutdown(true)" >/dev/null
    /usr/bin/logger "$0: Inhibit shutdown"
    echo "1" > $LASTSTATEFILE
#  else
#    /usr/bin/logger "$0: Shutdown allready inhibited"
  fi
fi</code></pre>

The above script calls <code>shutdown-check.sh</code> to see if it is OK to shutdown. The script checks for:

  1. Time of day, weekdays the computer should be on between 9 and 10:59, and again from 19 to 23:59. If the computer is running after midnight it will be shutdown between 2 and 6
  2. A couple of checks to see if anything is running that should be allowed to continue running
  3. Is there any users logged in other than the user that runs Kodi (in this case the "mythtv" user)

<pre><code class="language-bash">#!/bin/bash

# Check time
HOUR=`date '+%-k'`
MIN=`date +%M`
DAY=`date '+%u'`

case ${DAY} in
  1|2|3|4|5) # Work days
  ONHOURS="9 10 19 20 21 22 23"
  ;;
  6|7) # Weekends
  ONHOURS="0 1 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
  ;;
esac

# Hours where shutdown is forced
KILLHOURS="2 3 4 5 6"

for KILLHOUR in ${KILLHOURS}; do
  if [[ ${HOUR} == ${KILLHOUR} ]]; then
    /usr/bin/logger "$0: in killhour: ${HOUR} (day:${DAY})"
    exit 0
  fi
done

for ONHOUR in ${ONHOURS}; do
  if [[ ${HOUR} == ${ONHOUR} ]]; then
    #/usr/bin/logger "$0: in onhour: ${HOUR} (day:${DAY})"
    exit 1
  else
    # Considered true if clock 18:16
    if [[ $(( ${HOUR} + 1 )) == ${ONHOUR} && ${MIN} -gt 15 ]]; then
      /usr/bin/logger "$0: less than 45min to onhour: ${HOUR} ${MIN} ${ONHOUR} (day:${DAY})"
      exit 1
    fi
  fi
done

if [[ `transmission-remote -l | wc -l` > 2 ]]; then
  /usr/bin/logger "$0: transmission downloading"
  exit 1
fi

if [[ `grep -c "check" /proc/mdstat` = 1 ]]; then
  /usr/bin/logger "$0: raid resync is running"
  exit 1
fi

if [ -e /tmp/noshutdown-*.lock ]; then
  /usr/bin/logger "$0: a job is running"
  exit 1
fi

declare -a CHECK_PROGRAMS
CHECK_PROGRAMS=('chrome' 'chromium' 'fs-uae' 'popcorntime' 'dolphin')

for PROGRAM in "${CHECK_PROGRAMS[@]}"; do
  if pgrep "$PROGRAM" &>/dev/null; then
    /usr/bin/logger "$0: $PROGRAM is running"
    exit 1
  fi
done

# if last | head | grep -q ".*still logged in"; then
USERS=`w -h | grep -v mythtv | wc -l`
if [[ $USERS > 0 ]]; then
  # A user is logged in
  /usr/bin/logger "$0: user logged in"
  exit 1
fi

/usr/bin/logger "$0: shutdown ok"
exit 0</code></pre>

## Wakeup

The last 2 pieces is to set up the computer so that it will automatically start the next day, and enable Wake-On-LAN.

### Wakeup via ACPI / RTC

I have made a simple script that ensures that the computer is turned on at 9:00 and again at 19:00 on weekdays, and at 7:00 in the weekend. The script is called <code>set-next-shutdown.sh</code>.

Note: this requires that the BIOS/UEFI is configured correctly, in the case of the Gigabyte GA-Z87-D3HP the "Wake from Alarm" should be disabled.

<pre><code class="language-bash">#!/bin/bash

# Defaults to tomorrow @ 09:00:00 in weekdays, and 07:00:00 in the weekend
LASTWAKETIMEFILE="/tmp/set_next_wakeup_laststate"

HOUR=`date '+%-k'`
DAY=`date '+%u'`

ONTIME=`date '+%s' -d 'tomorrow 09:00:00'`

case ${DAY} in
  1|2|3|4) # Work days
    case ${HOUR} in
      0|1|2|3|4|5|6|7)
        ONTIME=`date '+%s' -d '09:00:00'`
        ;;
      8|9|10|11|12|13|14|15)
        ONTIME=`date '+%s' -d '19:00:00'`
        ;;
    esac
    ;;
  5) # Friday
    case ${HOUR} in
      0|1|2|3|4|5|6|7)
        ONTIME=`date '+%s' -d '9:00:00'`
        ;;
      8|9|10|11|12|13|14|15)
        ONTIME=`date '+%s' -d '19:00:00'`
        ;;
      16|17|18|19|20|21|22|23)
        ONTIME=`date '+%s' -d 'tomorrow 07:00:00'`
        ;;
    esac
    ;;
  6) # Saturday
    case ${HOUR} in
      0|1|2|3|4|5|6)
        ONTIME=`date '+%s' -d '7:00:00'`
        ;;
      *)
        ONTIME=`date '+%s' -d 'tomorrow 07:00:00'`
        ;;
    esac
    ;;
  7) # Sunday
    case ${HOUR} in
      0|1|2|3|4|5|6)
        ONTIME=`date '+%s' -d '7:00:00'`
        ;;
    esac
    ;;
esac

if [[ -f $LASTWAKETIMEFILE ]]; then
  LASTWAKETIME=`cat $LASTWAKETIMEFILE`
  if [[ $LASTWAKETIME != $ONTIME ]]; then
    /usr/bin/logger "$0: Setting wakeup to $ONTIME (`date -d @${ONTIME}`)"
    echo 0 > /sys/class/rtc/rtc0/wakealarm
    echo $ONTIME > /sys/class/rtc/rtc0/wakealarm
    echo $ONTIME > $LASTWAKETIMEFILE
#  else
#    /usr/bin/logger "$0: Wakeup allready set to $LASTWAKETIME (`date -d @${LASTWAKETIME}`)"
  fi
else
  /usr/bin/logger "$0: Setting wakeup to $ONTIME (`date -d @${ONTIME}`)"
  echo 0 > /sys/class/rtc/rtc0/wakealarm
  echo $ONTIME > /sys/class/rtc/rtc0/wakealarm
  echo $ONTIME > $LASTWAKETIMEFILE
fi</code></pre>


### Wake On LAN (WOL)

In case I need the computer at a time where it is not runnin, I can wake it from my desktop computer or from my phone using the [Wake On LAN](https://play.google.com/store/apps/details?id=de.ralischer.wakeonlan) app.

Activate WOL support using ethtool with a systemd unit (based on [Arch Linux Wiki:Wake-on-LAN](https://wiki.archlinux.org/index.php/Wake-on-LAN#systemd_service)):

<pre><code class="language-ini">[Unit]
Description=Wake-on-LAN for %i
After=network.target

[Service]
ExecStart=/usr/bin/ethtool -s %i wol g
Type=oneshot

[Install]
WantedBy=multi-user.target</code></pre>

Now I can use the wol tool to wake the HTPC: <code>wol -v ${MAC}</code> where ${MAC} is the MAC address of NIC
