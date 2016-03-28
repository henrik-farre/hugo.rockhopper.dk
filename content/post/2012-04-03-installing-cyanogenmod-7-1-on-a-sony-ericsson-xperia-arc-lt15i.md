---
title: Installing CyanogenMod 7.1 on a Sony Ericsson Xperia Arc (LT15i)
author: Henrik
layout: post
date: 2012-04-03
url: /linux/hardware/phone-and-pda/installing-cyanogenmod-7-1-on-a-sony-ericsson-xperia-arc-lt15i/
categories:
  - Phone and PDA
tags:
  - android

---
Although the instructions for upgrading the Sony Ericsson Xperia Arc (not the new S version) are <a title="Sony Ericsson Xperia Arc: Full Update Guide" href="http://wiki.cyanogenmod.com/wiki/Sony_Ericsson_Xperia_Arc:_Full_Update_Guide" target="_blank">pretty detailed</a> there are some twists that are not documented:

  1. You need to upgrade to the latests official Sony Ericsson rom (currently &#8220;4.0.2.A.0.62 Generic Global World&#8221; ), you can find links in this <a title="ARC/ARC S (ROOT.FTF&.IMG)4.0.2.A.0.62 Generic Global World+Flashtool+Ringtones+Other" href="http://forum.xda-developers.com/showthread.php?t=1330314" target="_blank">xda developers thread</a>, else the phone will not be able to unlock the SIM card
  2. To flash the rom you will need <a title="Flashtool" href="http://androxyde.github.com/" target="_blank">FlashTool</a> (Java based app, works fine in Linux). And when it says that you have to connect the USB cable, and press a button, you don&#8217;t have to press the power button at the same time
  3. The 7.1.0.2 version of CyanogenMod is not usable on the phone I installed it on, it kept crashing on the first screen, apparently the fix is to <a title="The CyanogenMod7 droid animated screen loads in loop, can't setup phone " href="http://forum.cyanogenmod.com/topic/44435-the-cyanogenmod7-droid-animated-screen-loads-in-loop-cant-setup-phone/page__p__302315#entry302315" target="_blank">remove an app using adb</a>

I ended up using 7.1.0.1 which works fine, except vibrate.