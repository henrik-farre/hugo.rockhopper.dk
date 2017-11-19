---
title: Upgrading an Android Developer Phone 1 to Cyanogenmod 5.0.7 (Android 2.1)
author: Henrik

date: 2010-06-19
url: /linux/hardware/phone-and-pda/upgrading-an-android-developer-phone-1-to-cyanogenmod-5-0-7-android-2-1/
categories:
  - Phone and PDA
tags:
  - android

---
My ADP1 has been running Android 1.6 (Cyanogenmod 4.2.x) for quite a while now, and I was exited to see that it would be possible to run Android 2.1 on it thanks to Cyanogen :). This guide is a digest of information found on Cyanogen&#8217;s wiki, like: [ADP1 Firmware to CyanogenMod](http://wiki.cyanogenmod.com/index.php/Full_Update_Guide_-_ADP1_Firmware_to_CyanogenMod), please consult the wiki for up todate information and warnings :)
<!--more-->

## Prerequisite

Download the following files:

  * [RA recovery for dream](http://forum.xda-developers.com/showpost.php?p=4647751&postcount=1) I use version 1.7.0
  * [DangerSPL](http://wiki.cyanogenmod.com/index.php/DangerSPL_and_CM_5_for_Dream)
  * [Google apps for Cyanogen](http://wiki.cyanogenmod.com/index.php/Latest_version#ERE36B_Google_addon_for_G1.2FDream.2FSapphire)
  * [Lateste Cyanogen 5.0.x for dream](http://wiki.cyanogenmod.com/index.php/Latest_version#Current_Stable_Version_2)

## Install recovery image

Based on [Full Update Guide &#8211; ADP1 Firmware to CyanogenMod](http://wiki.cyanogenmod.com/index.php/Full_Update_Guide_-_ADP1_Firmware_to_CyanogenMod)

  1. Boot the phone into fastboot mode by holding the BACK button while pressing the power button
  2. On your computer run the following commands:

<pre>./fastboot device #check if the phone is available
./fastboot flash recovery recovery-RA-dream-v1.7.0.img
./fastboot reboot</pre>

<a href="http://android-dls.com/wiki/index.php?title=Fastboot">More information about fastboot</a>

## Install bootloader

In order to run Android 2.1 you need to replace the bootloader with one called &#8220;DangerSPL&#8221;, and there is a reason it is called &#8220;Danger&#8221; :) please read [DangerSPL and CM 5 for Dream](http://wiki.cyanogenmod.com/index.php/DangerSPL_and_CM_5_for_Dream) and read the warnings and prerequisites.

Copy the files to the root of your SD card:

  1. DangerSPL: spl-signed.zip
  2. CyanogenMod: update-cm-5.0.7-DS-signed.zip
  3. Google Apps: gapps-ds-ERE36B-signed.zip

Reboot the phone into recovery mode by holding hold the home button while booting.

I did the following steps:

  1. Run a Nandroid Backup
  2. Wipe Data/Factory Reset
  3. Flash DangerSPL by selecting &#8220;Apply any zip from SD&#8221; and then select spl-signed.zip

After the bootloader has been flashed, reboot the phone when asked for it. The phone should boot into recovery mode again to complete the upgrade.

## Install Cyanogenmod 5.0.7 and Google apps

After the bootloader has been installed it is time to flash Android 2.1 and Google apps

  1. Select &#8220;Apply any zip from SD&#8221; and then update-cm-5.0.7-DS-signed.zip
  2. Do the same with gapps-ds-ERE36B-signed.zip after CM 5.0.x
  3. Reboot (takes awhile to boot)

If all went well, you should be able to enter your PIN number and enjoy Android 2.1 :)

<div id="_mcePaste" style="position: absolute; left: -10000px; top: 202px; width: 1px; height: 1px; overflow: hidden;">
  <h1 id="firstHeading" class="firstHeading">
    DangerSPL and CM 5 for Dream
  </h1>
</div>
