---
title: How not to restore a Linux software raid
author: Henrik
layout: post
date: 2009-04-19
url: /linux/software/how-not-to-restore-a-linux-software-raid/
categories:
  - Software
tags:
  - raid

---
We had a disk failure on one of our Xen servers at [work][1] last week, and what we thought would be a quick disk replace, turned into a small nightmare.

Our setup is fairly &#8220;simple&#8221;: 2 x raid1&#8217;s consisting of sda1/sdb1 (/dev/md0 mounted at /) and sda3/sdb3 (/dev/md1 with LVM on top of it).

mdadm reported that sdb1 and sdb3 had failed, so we just had to identify which disk was sdb in the server and replace it. Well it wasn&#8217;t easy to see which disk has which after we had opened the server, so we decided to boot the server again to look up the drives&#8217; serial number (using hdparm -I /dev/sda, and the small barcode on the front of the disk).

Now the fun part starts. The contents of /proc/mdstat showed something like this after the reboot:

<pre>Personalities : [raid1]
md1 : active raid1 sdb3[0] sda3[1] (F)
      235400320 blocks [2/1] [U_]

md0 : active raid1 sdb1[0] (F) sda1[1]
      7815488 blocks [1/2] [_U]

unused devices: &lt;none&gt;</pre>

On md0 sdb1 is failed, and on md1 it&#8217;s sda3, so one partition is marked failed on each drive. Here we made the **big mistake**: we decided to readd sdb1 to md0 and sdb3 to md1.

While the raid was syncing there was a lot of disk errors on sda1 and sda3, so we identified sda using its serial number, shutdown the server, replaced the disk, booted and everything looked fine.

Fast forward to the next day: we started receiving e-mails from customers saying data was missing from their sites, and they where missing data from the day the drive failed&#8230; then it dawned on us: when we readded sda3 it was overridden with the old data from sdb3  <img src="http://rockhopper.hf/wp-includes/images/smilies/frownie.png" alt=":(" class="wp-smiley" style="height: 1em; max-height: 1em;" />. Only one thing to do: restore from backup.

Now the question is: why the hell was sda3 marked as failed after the reboot? It was on the good drive&#8230;

 [1]: http://www.bellcom.dk "Bellcom Open Source ApS"