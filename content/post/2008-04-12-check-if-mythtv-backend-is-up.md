---
title: Check if MythTV backend is up
author: Henrik

date: 2008-04-12
url: /linux/software/mythtv/check-if-mythtv-backend-is-up/
categories:
  - MythTV
tags:
  - mythbackend
  - mythfrontend
  - wol

---
My MythTV frontend depends on the masterbackend to be up and running, mainly because some partitions are nfs mounted. So I created a simple script to check if the backend is responding to ping:<!--more-->

<pre>
<code class="language-bash">#!/bin/bash

function isup() {
 ping -q -n -c1 -w2 BACKEND_IP &gt; /dev/null
 if [[ $? !=  ]]; then
   sleep 5
   isup
 else
   echo "is up"
 fi
}

isup</code></pre>

But there is a small problem with this approach: the backend starts replying to ping long before nfsd and mythbackend are ready.

So instead of using ping, I created a script that checks if mythbackend&#8217;s status page (port 6544) is ready, using wget:

<pre>
<code class="language-bash">#!/bin/bash

function isbackendup {
  wget -q http://BACKEND_IP:6544 -O /dev/null
  if [[ $? !=  ]]; then
    sleep 5
    isbackendup
  else
    stat_done
  fi
}
</code></pre>

Finally I wrapped it all up in an ArchLinux rc script, and use WOL to wake the backend:

<pre>
<code class="language-bash">#!/bin/bash

. /etc/rc.conf
. /etc/rc.d/functions

function isbackendup {
  wget -q http://BACKEND_IP:6544 -O /dev/null
  if [[ $? !=  ]]; then
    sleep 5
    isbackendup
  else
    stat_done
  fi
}

case "$1" in
  start)
    stat_busy "Checking if backend is up..."
    wol BACKEND_MACADDR &gt; /dev/null
    isbackendup
    ;;
  stop)
    /bin/true
    ;;
  restart)
    $ stop
    sleep 1
    $ start
    ;;
  *)
    echo "usage: $0 {start|stop|restart}"
esac
</code></pre>

If you run ArchLinux just added it to /etc/rc.conf in the DAEMONS array.

Remember to replace **BACKEND_IP** and **BACKEND_MACADDR** with your own values.
