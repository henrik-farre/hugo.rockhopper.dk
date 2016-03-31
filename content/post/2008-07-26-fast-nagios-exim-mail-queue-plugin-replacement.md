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
<!--more-->

<pre>
<code class="language-bash">#!/bin/bash

WARNING=""
CRITICAL=""
MAILER=""
TIMER=""

while getopts "w:c:M:t" optionName; do
  case "${optionName}" in
    w) WARNING="${OPTARG}";;
    c) CRITICAL="${OPTARG}";;
    M) MAILER="${OPTARG}";;
    t) TIMER="${OPTARG}";;
  esac
done

MAILS_IN_QUEUE=`sudo /usr/sbin/exim4 -bpc`

if [[ ${MAILS_IN_QUEUE} -gt ${CRITICAL} ]]; then
  echo "CRITICAL: mailq is ${MAILS_IN_QUEUE} (threshold w = ${CRITICAL})|unsent=${MAILS_IN_QUEUE};${WARNING};${CRITICAL};0"
  exit 2
elif [[ ${MAILS_IN_QUEUE} -gt ${WARNING} ]]; then
  echo "WARNING: mailq is ${MAILS_IN_QUEUE} (threshold w = ${WARNING})|unsent=${MAILS_IN_QUEUE};${WARNING};${CRITICAL};0"
  exit 1
elif [[ ${MAILS_IN_QUEUE} -lt ${WARNING} ]]; then
  echo "OK: mailq is ${MAILS_IN_QUEUE} (threshold w = ${WARNING})|unsent=${MAILS_IN_QUEUE};${WARNING};${CRITICAL};0"
  exit
else
  echo "ERROR: something did not go right"
  exit 2
fi
</code>
</pre>

This has been tested on Debian sarge.

 [1]: http://www.bellcom.dk
