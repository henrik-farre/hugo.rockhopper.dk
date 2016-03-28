---
title: Fast nagios exim mail queue plugin replacement
author: Henrik
layout: post
date: 2008-07-26
url: /linux/software/fast-nagios-exim-mail-queue-plugin-replacement/
categories:
  - Software
tags:
  - exim
  - nagios

---
We had a problem with the nagios check_mailq plugin at [work][1], it kept timing out. So I wrote a simple bash script (instead of 610 lines of perl) which is &#8220;compatible&#8221; with check\_mailq (supports the same arguments) which uses &#8220;exim4&#8221; and is very quick. Just drop it in /usr/local/bin/check\_mailq\_simple.sh and adjust your nagios conf to use that instead of check\_mailq

<pre class="bash codesnip" style="font-family:monospace;"><span class="co0">#!/bin/bash</span>
&nbsp;
<span class="re2">WARNING</span>=<span class="st0">""</span>
<span class="re2">CRITICAL</span>=<span class="st0">""</span>
<span class="re2">MAILER</span>=<span class="st0">""</span>
<span class="re2">TIMER</span>=<span class="st0">""</span>
&nbsp;
<span class="kw1">while</span> <span class="kw3">getopts</span> <span class="st0">"w:c:M:t"</span> optionName; <span class="kw1">do</span>
  <span class="kw1">case</span> <span class="st0">"<span class="es3">${optionName}</span>"</span> <span class="kw1">in</span>
    <span class="kw2">w</span><span class="br0">&#41;</span> <span class="re2">WARNING</span>=<span class="st0">"<span class="es3">${OPTARG}</span>"</span><span class="sy0">;;</span>
    c<span class="br0">&#41;</span> <span class="re2">CRITICAL</span>=<span class="st0">"<span class="es3">${OPTARG}</span>"</span><span class="sy0">;;</span>
    M<span class="br0">&#41;</span> <span class="re2">MAILER</span>=<span class="st0">"<span class="es3">${OPTARG}</span>"</span><span class="sy0">;;</span>
    t<span class="br0">&#41;</span> <span class="re2">TIMER</span>=<span class="st0">"<span class="es3">${OPTARG}</span>"</span><span class="sy0">;;</span>
  <span class="kw1">esac</span>
<span class="kw1">done</span>
&nbsp;
<span class="re2">MAILS_IN_QUEUE</span>=<span class="sy0">`</span><span class="kw2">sudo</span> <span class="sy0">/</span>usr<span class="sy0">/</span>sbin<span class="sy0">/</span>exim4 -bpc<span class="sy0">`</span>
&nbsp;
<span class="kw1">if</span> <span class="br0">&#91;</span><span class="br0">&#91;</span> <span class="co1">${MAILS_IN_QUEUE}</span> <span class="re5">-gt</span> <span class="co1">${CRITICAL}</span> <span class="br0">&#93;</span><span class="br0">&#93;</span>; <span class="kw1">then</span>
  <span class="kw3">echo</span> <span class="st0">"CRITICAL: mailq is <span class="es3">${MAILS_IN_QUEUE}</span> (threshold w = <span class="es3">${CRITICAL}</span>)|unsent=<span class="es3">${MAILS_IN_QUEUE}</span>;<span class="es3">${WARNING}</span>;<span class="es3">${CRITICAL}</span>;0"</span>
  <span class="kw3">exit</span> <span class="nu0">2</span>
<span class="kw1">elif</span> <span class="br0">&#91;</span><span class="br0">&#91;</span> <span class="co1">${MAILS_IN_QUEUE}</span> <span class="re5">-gt</span> <span class="co1">${WARNING}</span> <span class="br0">&#93;</span><span class="br0">&#93;</span>; <span class="kw1">then</span>
  <span class="kw3">echo</span> <span class="st0">"WARNING: mailq is <span class="es3">${MAILS_IN_QUEUE}</span> (threshold w = <span class="es3">${WARNING}</span>)|unsent=<span class="es3">${MAILS_IN_QUEUE}</span>;<span class="es3">${WARNING}</span>;<span class="es3">${CRITICAL}</span>;0"</span>
  <span class="kw3">exit</span> <span class="nu0">1</span>
<span class="kw1">elif</span> <span class="br0">&#91;</span><span class="br0">&#91;</span> <span class="co1">${MAILS_IN_QUEUE}</span> <span class="re5">-lt</span> <span class="co1">${WARNING}</span> <span class="br0">&#93;</span><span class="br0">&#93;</span>; <span class="kw1">then</span>
  <span class="kw3">echo</span> <span class="st0">"OK: mailq is <span class="es3">${MAILS_IN_QUEUE}</span> (threshold w = <span class="es3">${WARNING}</span>)|unsent=<span class="es3">${MAILS_IN_QUEUE}</span>;<span class="es3">${WARNING}</span>;<span class="es3">${CRITICAL}</span>;0"</span>
  <span class="kw3">exit</span> <span class="nu0"></span>
<span class="kw1">else</span>
  <span class="kw3">echo</span> <span class="st0">"ERROR: something did not go right"</span>
  <span class="kw3">exit</span> <span class="nu0">2</span>
<span class="kw1">fi</span></pre>

This has been tested on Debian sarge.

 [1]: http://www.bellcom.dk