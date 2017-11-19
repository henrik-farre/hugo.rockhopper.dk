---
title: 'HTPC/NAS for watching Netflix on Linux part 1: the hardware'
author: Henrik

date: 2013-11-13
url: /linux/hardware/htpcnas-for-watching-netflix-on-linux-part-1-the-hardware/
categories:
  - Hardware
tags:
  - HTPC
  - motherboard
  - XBMC

---
I decided to build a new HTPC/NAS in order to watch [Netflix](http://www.netflix.com) (using [pipelight](https://wiki.archlinux.org/index.php/Pipelight)) on Linux, and combine two older machines into one.
<!--more-->

My old HTPC was based on a 1.6GHz AMD Sempron from 2007 and a Nvidia GeForce N210. While it played Full HD content fine using [vdpau](https://wiki.archlinux.org/index.php/VDPAU), it was not able to handle Netflix using pipelight. A second machine with a Intel Atom CPU was used to store all the multimedia and host MythTV.

Specifications of the new machine are:

## Motherboard

[Gigabyte GA-Z87-D3HP](http://www.gigabyte.com/products/product-page.aspx?pid=4519)

Nice motherboard, ok PWM fan controls, only thing I dislike is the UEFI bios. Some options change when I navigate using the keyboard arrows&#8230; come on, do I _really_ need a mouse for changing bios options?

Everything I have tested works in Linux, also these things:

  * lm-sensors: supports the it8728 chip
  * Wake-on-lan
  * Audio over HDMI

I did not test:

  * USB 3.0
  * Changing the &#8220;Resume by Alarm&#8221; time from Linux.
  * Fancontrol in Linux

  * lspci reports:

<pre>00:00.0 Host bridge: Intel Corporation 4th Gen Core Processor DRAM Controller (rev 06)
00:02.0 VGA compatible controller: Intel Corporation Device 041e (rev 06)
00:03.0 Audio device: Intel Corporation Xeon E3-1200 v3/4th Gen Core Processor HD Audio Controller (rev 06)
00:14.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset Family USB xHCI (rev 04)
00:16.0 Communication controller: Intel Corporation 8 Series/C220 Series Chipset Family MEI Controller #1 (rev 04)
00:19.0 Ethernet controller: Intel Corporation Ethernet Connection I217-V (rev 04)
00:1a.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset Family USB EHCI #2 (rev 04)
00:1b.0 Audio device: Intel Corporation 8 Series/C220 Series Chipset High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port #1 (rev d4)
00:1c.3 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d4)
00:1d.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset Family USB EHCI #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation Z87 Express LPC Controller (rev 04)
00:1f.2 SATA controller: Intel Corporation 8 Series/C220 Series Chipset Family 6-port SATA Controller 1 [AHCI mode] (rev 04)
00:1f.3 SMBus: Intel Corporation 8 Series/C220 Series Chipset Family SMBus Controller (rev 04)
02:00.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 41)</pre>

### RAM

I went for some cheap [Kingston HyperX blu](http://www.kingston.com/us/memory/hyperx/blu) 2 x 2 GB memory. The motherboard supports faster memory which should boost graphics performance, but I&#8217;m content with how it performs now.

## CPU

I really like the [Intel i3-4130T](http://ark.intel.com/products/77481/) (Haswell) CPU. It runs @ 2.9GHz with a TDP of just 35W, and it comes with integrated Intel HD graphics 4400.

It is possible to view Full HD content using [va-api](https://wiki.archlinux.org/index.php/VA-API) without using more than <20% CPU.

### CPU cooler

The [Cooler Master Hyper 212 Evo](http://www.coolermaster.com/product/Detail/cooling/cpu-air-cooler/hyper-212-evo.html) is a direct heatpipe touch CPU cooler, and its fan can run at the lowest speed all the time thanks to the CPU&#8217;s low TDP. I use [Arctic Silver 5](http://www.arcticsilver.com/as5.htm) thermal compound.

## Control

I picked the [Chill KB-1BT Wireless Bluetooth Micro Keyboard](http://www.chill-innovation.com/en/bluetooth-keyboards/12-chill-kb-1bt-wireless-bluetooth-micro-keyboard-nordic-5711045075841.html) because I was tired of my old infrared connected keyboard&#8217;s poor range and it also had to be pointing directly at its receiver. And not only does the Chill KB-1BT have better range, it&#8217;s also much easier to type on because it&#8217;s much smaller so I can reach most keys with my thumbs.

While the keyboard is excellent for typing and controlling Netflix/Rdio, I also bought a [Pulse Eight USB &#8211; CEC Adapter](http://www.pulse-eight.com/store/products/104-usb-hdmi-cec-adapter.aspx) which allows me to control XBMC 100% using my TV&#8217;s (Sony KDL-40WE5) remote.

## Storage

I reused the 3 x 500Gb Seagate ST3500630AS discs from the Atom server running in a Raid 5 configuration.

## Case

First revision [Antec Sonata](http://techreport.com/review/6247/antec-sonata-atx-case) (does not even exist on Antec&#8217;s page any more)
