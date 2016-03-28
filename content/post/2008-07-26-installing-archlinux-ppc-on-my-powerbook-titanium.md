---
title: Installing ArchLinux PPC on my Powerbook Titanium
author: Henrik
layout: post
date: 2008-07-26
url: /linux/hardware/installing-archlinux-ppc-on-my-powerbook-titanium/
categories:
  - Hardware
tags:
  - archlinux
  - powerbook

---
I decided to bring my [Powerbook Titanium][1] back into service as a server/torrent fetcher. So I downloaded [ArchLinux PPC][2] and installed it.

I just followed the [instructions available][3] in the ArchLinux wiki, and here are my notes on the installation.

## Install issues

I experienced 2 issues with the /arch/quickinstall script. First it failed because wget was missing from the cd. So I used &#8220;vi&#8221; to replace wget with [snarf][4] (which is on the cd) in the script. Secondly the quickinstall ftp URL was wrong in the wiki, it should be core instead of current (I have updated the wiki with the correct link)

When I entered the chroot the last command &#8220;makedevs&#8221; was not found, I just proceeded as /dev/null and other devices existed within the chroot. I don&#8217;t know if that is the source of my 2 small outstanding problems.

I ran into a small problem as I was creating users, probably not related to ArchLinux PPC. If I tried, as root, to run: &#8220;adduser username&#8221; I would get the following error:

<pre class="bash codesnip" style="font-family:monospace;">You are required to change your password immediately <span class="br0">&#40;</span>root enforced<span class="br0">&#41;</span>
useradd: PAM authentication failed</pre>

I then changed my password, remember I was logged in as root, but I keep getting the same error. So I manually created the user by editing /etc/passwd and /etc/shadow (by copying the lines from another ArchLinux box)

But if I tried, still as root, to: &#8220;su &#8211; username&#8221;, I got this error:

<pre class="bash codesnip" style="font-family:monospace;"><span class="kw2">su</span>: incorrect password</pre>

I finally track the problem down to a mismatch between /etc/shadow and /etc/shadow- in the line with the root user.

## Post install

When everything was installed and the system running, I started to add applications and tweak settings:

First I installed pbbuttonsd so that machine would switch of the display when it was booted

Next I tried to set CPU frequency scaling up, using the &#8220;conservative&#8221; governor. But I got this error:

<pre class="bash codesnip" style="font-family:monospace;">conservative governor failed, too long transition latency of HW, fallback to performance governor</pre>

Instead of wasting to much time on that, I just decided to use the &#8220;powersave&#8221; governor.

Finally I installed [transmission bittorrent client][5], and the [clutch web interface for transmission][6], and a couple of other apps.

## Unresolved issuses

I have 2 small problems left that are minor annoyances:

udev gives an error on every boot:

<pre class="bash codesnip" style="font-family:monospace;">:: Loading udev...<span class="sy0">/</span>etc<span class="sy0">/</span>start_udev: <span class="nu0">110</span>: <span class="sy0">/</span>sbin<span class="sy0">/</span>udevtrigger: not found
<span class="sy0">/</span>etc<span class="sy0">/</span>start_udev: <span class="nu0">110</span>: <span class="sy0">/</span>sbin<span class="sy0">/</span>udevsettle: not found done.</pre>

I tried a [couple of solutions][7] I found in ArchLinux&#8217;s forum but they did not help, so I&#8217;m just ignoring it <img src="http://rockhopper.hf/wp-includes/images/smilies/simple-smile.png" alt=":)" class="wp-smiley" style="height: 1em; max-height: 1em;" />

Another error that comes at each boot is this clock error:

<pre class="bash codesnip" style="font-family:monospace;">Cannot access the Hardware Clock via any know method. Use the <span class="re5">-debug</span> option to see the details of our search <span class="kw1">for</span> an access method</pre>

I also ignore this, because the machine uses ntpdate to set its time.

## Status

The machine has been running stable in a couple of weeks, and ArchLinux PPC feels as stable as the x86 edition.

 [1]: https://rockhopper.dk/old/linux/hardware/powerbook-titanium.html
 [2]: http://www.archlinuxppc.org/
 [3]: http://wiki.archlinux.org/index.php/Install_Arch_Linux_PPC
 [4]: http://www.xach.com/snarf/
 [5]: http://www.transmissionbt.com/
 [6]: http://clutchbt.com/
 [7]: http://bbs.archlinux.org/viewtopic.php?id=49285