---
title: CD/DVD burning, and working with .iso files
author: Henrik
layout: post
date: 2008-11-13
url: /linux/software/cddvd-burning-and-working-with-iso-files/
categories:
  - Software
tags:
  - cmd-line

---
Some handy command line tools to burn CDs/DVDs and work with .iso files:
<!--more-->

## Burning .iso files:

Basic usage of wodim (formally know as cdrecord):

<pre class="bash codesnip" style="font-family:monospace;">wodim <span class="re2">dev</span>=<span class="sy0">/</span>dev<span class="sy0">/</span>DEVICE image.iso</pre>

Replace DEVICE with the name of your drive, e.g. hda. You might need to be root/use sudo or have the appropriate permissions to access the device.

If your drive supports BurnFree add: -v driveropts=burnfree

## Generating .iso files

Add content of directory to an iso:

<pre class="bash codesnip" style="font-family:monospace;">genisoimage <span class="re5">-o</span> image.iso directory<span class="sy0">/</span></pre>

Some advanced options that might be useful:

  * -R : Enable Rock Ridge records (or use -r, read the genisoimage man page for info)
  * -joliet-long : Add support for filenames up to 103 chars (breaks joliet specification)
  * -graft-points : Maps a directory to another, e.g. specifying &#8220;-graft-points &#8216;/=/home/myusername'&#8221; the contents of /home/myusername is mapped to / on the iso

## To burn directly to CD/DVD

By combining genisoimage and wodim, you can burn files directly:

<pre class="bash codesnip" style="font-family:monospace;">genisoimage directory<span class="sy0">/</span> <span class="sy0">|</span> wodim <span class="re2">dev</span>=<span class="sy0">/</span>dev<span class="sy0">/</span>hda -</pre>

Note the missing -o for genisoimage, and the &#8220;-&#8221; argument for wodim

## Mounting .iso files

This requires root rights:

<pre class="bash codesnip" style="font-family:monospace;"><span class="kw2">mount</span> <span class="re5">-o</span> loop <span class="re5">-t</span> iso9660 image.iso <span class="sy0">/</span>mnt<span class="sy0">/</span>image<span class="sy0">/</span></pre>
