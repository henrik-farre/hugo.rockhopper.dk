---
title: Updating the Android Developer Phone1 to v1.1
author: Henrik
layout: post
date: 2009-02-10
url: /linux/hardware/phone-and-pda/updating-the-android-developer-phone1-to-v11/
categories:
  - Phone and PDA
tags:
  - android

---
I&#8217;ve been putting off upgrading my ADP1 in fear of that I would brick it, but after reading that there now are official update images available I decided to give it a try.
<!--more-->

Here is a short walk through:

First download the following (you can skip download of the JesusFreke images if you don&#8217;t want a backup):

  * <a href="http://andblogs.net/2009/01/jesusfrekes-14-images-are-out/" target="_blank"><span class="downloadlink">JesusFreke ADP1</span></a> (bottom of the page, before the comments)
  * <a href="http://android-dls.com/wiki/index.php?title=Fastboot" target="_blank">Fastboot</a> (either compile it your self or download &#8220;DarkriftX&#8217;s precompiled&#8221; version)
  * <a href="http://andblogs.net/2009/02/new-adp1-update-official-with-google-voice-and-more/" target="_blank">ADP1.1 update</a> (get the &#8220;No Device Checks!&#8221; version)

# Backup the ADP1

(This is based on this <a title=" ADP1 ONLY instructions for backup, installing from git, then back to backup " href="http://groups.google.com/group/android-discuss/browse_thread/thread/e9eb4604357ff117?hide_quotes=no&pli=1" target="_blank">google groups thread</a> and the <a href="http://antonmelser.org/open-source/backup-install-restore-adp1.html" target="_blank">cleaned up version</a>)

This is a non destructive backup procedure, you will not have to install anything on your phone!

You will need about 110mb free on the SD card installed in your phone.

Extract JFv1.41_ADP1.1.zip and then boot the ADP1 into &#8220;fastboot&#8221; mode:

  1. Power the phone off
  2. Hold the camera button down
  3. Press the power button (still holding the camera button down)

A white screen with small androids on skateboards will apper on the screen, and in the middle of the screen it will say &#8220;serial0&#8221;. Connect the USB cable to your computer and the ADP1, wait a bit, then press the &#8220;back&#8221; button. The text should change to &#8220;fastboot&#8221;. If not, check the dmesg on your computer, it should say something like:

<pre>usb 1-2: new high speed USB device using ehci_hcd and address 11
usb 1-2: configuration #1 chosen from 1 choice</pre>

Now the phone should be ready to boot the recovery image from JF (if you don&#8217;t have sudo, log in as root):

  * sudo ./fastboot boot JFv1.41_ADP1.1/data/recovery.img

The phone will now boot using the image, and you should see some Linux kernel messages scrolling by, and then an image with yellow text.

  * Press &#8220;Alt+b&#8221; (without the quotes)

Backup is now running and you should see the following messages:

<pre>Performing backup...
Backup complete!</pre>

Now reboot the phone

## Flashing new firmware

Connect the USB cable to the phone and mount the SD card, I have mine mounted at /media/android_sd

Copy the update image to the SD card:

<pre>cp signed-holiday_nochecks_devphone-ota-130444-debug.55489994.zip /media/android_sd/update.img</pre>

Now perform the following steps:

  1. Power off
  2. Press and hold the &#8220;home&#8221; button
  3. Press the power button
  4. When a image of a phone and a exclamation sign appears press &#8220;Alt+l&#8221; and then &#8220;Alt+s&#8221;

The phone should start the updating process and show these messages:

<pre>Installing from sdcard...
Finding update package...
Opening update package...
Verifying update package...
Installing update
Formatting Boot:...
Extraction radio image
Formatting System
Copying files
Writing boot
Installation complete
Press home+back to reboot</pre>

After pressing home+backup a final message will appear:

<pre>Writing radio image</pre>

Then the phone rebooted twice (the process took about 3-4 mins), and it displayed two images, one where there is an arrow pointing onto a chip, and an arrow comming out of a box and pointing to a phone.

The update should be complete after that.

## New things after the update

2 new applications are installed; &#8220;Voice Dialer&#8221; and &#8220;Voice Search&#8221;. I have not played with them yet so I can&#8217;t really say anything about them :)

There are a couple of new settings here and there, but I have not noticed anything fancy, so I guess we still have to wait the the mysterious &#8220;cupcake&#8221; update, if such a thing even exists.

Before the update the phone had the following information:

  * Build date: Mon Now 3 12:54:32 PST 2008
  * Linux kernel version: 2.6.25-01843-gfea26b0
  * Baseband version: 62.33.20.08H_1.22.12.29

Now it has:

  * Build date: Mon Feb 9 10:28:32 PST 2009
  * Linux kernel version: 2.6.25-01845-g85d4f0d
  * Baseband version: 62.33.20.08H_1.22.14.11
