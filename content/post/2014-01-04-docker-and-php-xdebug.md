---
title: Docker and PHP xdebug
author: Henrik
layout: post
date: 2014-01-04
url: /linux/docker-and-php-xdebug/
categories:
  - Development
  - Linux
  - php
  - vim
tags:
  - Docker

---
I have switched from using Vagrant to Docker as my local development environment, and I&#8217;m still mentally trying to switch :)
<!--more-->

To use the [vdebug plugin](https://github.com/joonty/vdebug) in Vim I have set xdebug up inside the container as follows:

/etc/php5/conf.d/20-xdebug.ini (Debian wheezy)

<pre>
<code class="language-ini">zend_extension=/usr/lib/php5/20100525/xdebug.so
xdebug.remote_enable=1
xdebug.remote_autostart=0
xdebug.remote_connect_back=1
xdebug.remote_port=9000</code>
</pre>

And in my ~/.vimrc I have these vdebug settings:

<pre>
<code class="language-vim">let g:vdebug_options = {"path_maps": {"/var/www": "/home/username/Localdev"}, \
"break_on_open": 0, "watch_window_style": "compact", \
"server" : "172.17.42.1"}</code>
</pre>

172.17.42.1 is the ip of the bridge created by docker, it can be found by using ip addr and looking for the &#8220;docker0&#8221; interface.

I create the xdebug ini file in my Dockerfile, see my [Docker repository](https://github.com/henrik-farre/docker)
