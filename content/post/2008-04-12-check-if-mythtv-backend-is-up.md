---
title: Check if MythTV backend is up
author: Henrik
layout: post
date: 2008-04-12
url: /linux/software/mythtv/check-if-mythtv-backend-is-up/
categories:
  - MythTV
tags:
  - mythbackend
  - mythfrontend
  - wol

---
My MythTV frontend depends on the masterbackend to be up and running, mainly because some partitions are nfs mounted. So I created a simple script to check if the backend is responding to ping:

<pre class="bash codesnip" style="font-family:monospace;"><span class="co0">#!/bin/bash</span>
&nbsp;
<span class="kw1">function</span> isup<span class="br0">&#40;</span><span class="br0">&#41;</span> <span class="br0">&#123;</span>
 <span class="kw2">ping</span> <span class="re5">-q</span> <span class="re5">-n</span> <span class="re5">-c1</span> <span class="re5">-w2</span> BACKEND_IP <span class="sy0">&gt;</span> <span class="sy0">/</span>dev<span class="sy0">/</span>null
 <span class="kw1">if</span> <span class="br0">&#91;</span><span class="br0">&#91;</span> <span class="re4">$?</span> <span class="sy0">!</span>= <span class="nu0"></span> <span class="br0">&#93;</span><span class="br0">&#93;</span>; <span class="kw1">then</span>
   <span class="kw2">sleep</span> <span class="nu0">5</span>
   isup
 <span class="kw1">else</span>
   <span class="kw3">echo</span> <span class="st0">"is up"</span>
 <span class="kw1">fi</span>
<span class="br0">&#125;</span>
&nbsp;
isup</pre>

But there is a small problem with this approach: the backend starts replying to ping long before nfsd and mythbackend are ready.

So instead of using ping, I created a script that checks if mythbackend&#8217;s status page (port 6544) is ready, using wget:

<pre class="bash codesnip" style="font-family:monospace;"><span class="co0">#!/bin/bash</span>
&nbsp;
<span class="kw1">function</span> isbackendup <span class="br0">&#123;</span>
  <span class="kw2">wget</span> <span class="re5">-q</span> http:<span class="sy0">//</span>BACKEND_IP:<span class="nu0">6544</span> <span class="re5">-O</span> <span class="sy0">/</span>dev<span class="sy0">/</span>null
  <span class="kw1">if</span> <span class="br0">&#91;</span><span class="br0">&#91;</span> <span class="re4">$?</span> <span class="sy0">!</span>= <span class="nu0"></span> <span class="br0">&#93;</span><span class="br0">&#93;</span>; <span class="kw1">then</span>
    <span class="kw2">sleep</span> <span class="nu0">5</span>
    isbackendup
  <span class="kw1">else</span>
    stat_done
  <span class="kw1">fi</span>
<span class="br0">&#125;</span>
&nbsp;
isbackendup</pre>

Finally I wrapped it all up in an ArchLinux rc script, and use WOL to wake the backend:

<pre class="bash codesnip" style="font-family:monospace;"><span class="co0">#!/bin/bash</span>
&nbsp;
. <span class="sy0">/</span>etc<span class="sy0">/</span>rc.conf
. <span class="sy0">/</span>etc<span class="sy0">/</span>rc.d<span class="sy0">/</span>functions
&nbsp;
<span class="kw1">function</span> isbackendup <span class="br0">&#123;</span>
  <span class="kw2">wget</span> <span class="re5">-q</span> http:<span class="sy0">//</span>BACKEND_IP:<span class="nu0">6544</span> <span class="re5">-O</span> <span class="sy0">/</span>dev<span class="sy0">/</span>null
  <span class="kw1">if</span> <span class="br0">&#91;</span><span class="br0">&#91;</span> <span class="re4">$?</span> <span class="sy0">!</span>= <span class="nu0"></span> <span class="br0">&#93;</span><span class="br0">&#93;</span>; <span class="kw1">then</span>
    <span class="kw2">sleep</span> <span class="nu0">5</span>
    isbackendup
  <span class="kw1">else</span>
    stat_done
  <span class="kw1">fi</span>
<span class="br0">&#125;</span>
&nbsp;
<span class="kw1">case</span> <span class="st0">"$1"</span> <span class="kw1">in</span>
  start<span class="br0">&#41;</span>
    stat_busy <span class="st0">"Checking if backend is up..."</span>
    wol BACKEND_MACADDR <span class="sy0">&gt;</span> <span class="sy0">/</span>dev<span class="sy0">/</span>null
    isbackendup
    <span class="sy0">;;</span>
  stop<span class="br0">&#41;</span>
    <span class="sy0">/</span>bin<span class="sy0">/</span><span class="kw2">true</span>
    <span class="sy0">;;</span>
  restart<span class="br0">&#41;</span>
    $<span class="nu0"></span> stop
    <span class="kw2">sleep</span> <span class="nu0">1</span>
    $<span class="nu0"></span> start
    <span class="sy0">;;</span>
  <span class="sy0">*</span><span class="br0">&#41;</span>
    <span class="kw3">echo</span> <span class="st0">"usage: $0 {start|stop|restart}"</span>  
<span class="kw1">esac</span></pre>

If you run ArchLinux just added it to /etc/rc.conf in the DAEMONS array.

Remember to replace **BACKEND_IP** and **BACKEND_MACADDR** with your own values.