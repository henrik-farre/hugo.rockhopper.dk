---
title: Terratec Cinergy C PCI HD + MythTV
author: Henrik
layout: post
date: 2010-02-09
url: /linux/software/mythtv/terratec-cinergy-c-pci-hd-mythtv/
categories:
  - MythTV
tags:
  - dvb-c
  - mythbackend

---
In the middle of December 2009 danish cable TV providor [Stofa](http://stofa.dk) made most of the channels in its DVB-C network [available unencoded](http://www.stofa.dk/showpage.php?mid=368). This prompted me to replace my analogue [Hauppauge WinTV-PVR-500 TV tuner card](https://rockhopper.dk/old/linux/hardware/pvr_cards.html) (yes the links goes to my old PVR-150 page) with something that could record the digital signal from DVB-C. I looked for a card that had the following characteristic:
<!--more-->

  * Have stable Open Source Linux drivers
  * It should work with [MythTV](/category/linux/software/mythtv/)
  * Fit in a PCI slot (My Asus AT3N7A-I motherboard only has one PCI slot)
  * Be able to record HD TV
  * Not be to expensive

I spend a lot of time looking for information on different sites like [LinuxTV wiki](http://www.linuxtv.org/wiki/index.php) (direct link to [TerraTec Cinergy C DVB-C](http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C)) and [MythTV wiki](http://www.mythtv.org/wiki/Video_capture_card), and ended up with the TerraTec card.

## Installing the card

On the physical installation I don&#8217;t have any interesting to say, it fits into the PCI slot on the motherboard without covering/blocking anything.

The &#8220;mantis&#8221; driver that the card uses is currently not in the mainline kernel, but it will be of version 2.6.33 (I&#8217;m currently on 2.6.32). So you have to download the source and build the driver yourself.

I found the &#8220;ArchVDR&#8221; project quite useful, I just followed the instructions in their wiki on [how to build the s2-liplianin-hg package](http://sourceforge.net/apps/trac/archvdr/wiki/ArchVDR) (scroll down to the section about s2-liplianin-hg). After building (it takes a while as there are a lot of drives in the [s2-liplianin mercurial repository](http://mercurial.intuxication.org/hg/s2-liplianin)). When the build is complete and the package is installed, you only have to run &#8220;modprobe mantis&#8221; as root.

You can check if the driver loaded correctly by looking at the output of &#8220;dmesg&#8221;, I get the following:

<pre>Mantis 0000:01:05.0: PCI INT A -&gt; Link[LNKA] -&gt; GSI 18 (level, low) -&gt; IRQ 18
irq: 18, latency: 64
 memory: 0xdffff000, mmio: 0xffffc90003f72000
found a VP-2040 PCI DVB-C device on (01:05.0),
 Mantis Rev 1 [153b:1178], irq: 18, latency: 64
 memory: 0xdffff000, mmio: 0xffffc90003f72000
 MAC Address=[00:08:ca:1e:b5:a7]
mantis_alloc_buffers (0): DMA=0x77a40000 cpu=0xffff880077a40000 size=65536
mantis_alloc_buffers (0): RISC=0x7b588000 cpu=0xffff88007b588000 size=1000
DVB: registering new adapter (Mantis dvb adapter)
mantis_frontend_init (0): Probing for CU1216 (DVB-C)
TDA10023: i2c-addr = 0x0c, id = 0x7d
mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c
mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success
DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
mantis_ca_init (0): Registering EN50221 device
mantis_ca_init (0): Registered EN50221 device
mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
input: Mantis VP-2040 IR Receiver as /devices/virtual/input/input4
Creating IR device irrcv0
Mantis VP-2040 IR Receiver: unknown key for scancode 0x0000
Mantis VP-2040 IR Receiver: unknown key: key=0x00 down=1
Mantis VP-2040 IR Receiver: unknown key: key=0x00 down=0
</pre>

## Adding the card to MythTV

I started by scanning for channels using the &#8220;scan&#8221; tool from the linuxtv-dvb-apps package in ArchLinux. None of the provided data files (in &#8220;/usr/share/dvb/dvb-c/&#8221;) contained the correct information, so I created one using information about frequency and other bits provided by [Stofa](http://www.stofa.dk/showpage.php?shortcut=kanalsoeg):

<pre>Frekvens: 346 MHz
Netværsks-ID: 0
Modulation: 64 QAM
Symbol rate: 6900 KS
</pre>

From which I created a file called &#8220;stofa&#8221;:

<pre># Stofa
# http://www.stofa.dk/
# freq sr fec mod
C 346000000 6900000 NONE QAM64</pre>

To scan for channels using this file run: &#8220;scan stofa > channels.conf&#8221; (You can run &#8220;scan stofa&#8221; to test it without creating the channels.conf file).  ****

**Note:** Later I have learned that importing a channels file into MythTV does not provide MythTV with enough information to get EIT (TV guide) working, but more on that later. Running the &#8220;scan&#8221; tool showed that the driver/card could find the DVB stream.

So instead of importing the channels.conf file, I made MythTV itself scan for the channels.

## Mythtv setup

I started by shutting down the mythbackend, and starting &#8220;mythtv-setup&#8221;. I deleted all references to my old analogue TV card, and proceeded to setup the new Terratec Cinergy C PCI HD card. **Note:** I only mention the settings that I changed, the rest are left on their default setting.

### Adding a new capture card

In mythtv-setup enter &#8220;Capture cards&#8221; and select &#8220;New capture card&#8221;.

{{< photo src="/uploads/mythtv_capture_card_add_new.png" title="MythTV setup: adding new capture card" thumb="/uploads/mythtv_capture_card_add_new-150x150.png" no_responsive="true" >}}

  * Card type: &#8220;DVB DTV capture card (v3.x)&#8221; (DVB Device Number should change to &#8220;/dev/dvb/adapter0/frontend0&#8221; and Frontend ID should change to Philips TDA10023 DVB-C)

In &#8220;Recording options&#8221; I entered:

  * Max recordings: 2 (allows you to record 2 streams simultaneously if the channels are in the same [mux](http://en.wikipedia.org/wiki/DVB-C#Technical_description_of_the_DVB-C_transmitter))
  * Use DVB Card for active EIT scan: checked (should allow MythTV to get data for its TV guide from the DVB stream)

When I pressed finish, the card is listed on the capture cards page.

### Adding a new video source

In mythtv-setup enter &#8220;Video sources&#8221; and select &#8220;New video source&#8221;.

{{< photo src="/uploads/mythtv_video_source_add_new.png" title="MythTV setup: adding new video source" thumb="/uploads/mythtv_video_source_add_new-150x150.png" no_responsive="true" >}}

  * Video source name: &#8220;TV Guide&#8221; (whatever you want)
  * Listings grabber: &#8220;Transmitted guide only (EIT)&#8221;

Press finish and the source should be listed on the sources page.

### Connection capture card to video source

In mythtv-setup enter &#8220;Input connections&#8221; and select the one that matches the DVB device number you got from capture cards.

{{< photo src="/uploads/mythtv_input_connections.png" title="MythTV setup: input connections" thumb="/uploads/mythtv_input_connections-150x150.png" no_responsive="true" >}}

  * Display Name: TV
  * Video source: &#8220;TV Guide&#8221; (the one that was added previously)

Now press &#8220;Scan for channels&#8221;

### Scanning for channels

{{< photo src="/uploads/mythtv_scanning_for_channels.png" title="MythTV setup: scanning for channels" thumb="/uploads/mythtv_scanning_for_channels-150x150.png" no_responsive="true" >}}

  * Desired Services: TV
  * Scan Type: &#8220;Full Scan (Tuned)&#8221;
  * Frequency: 346000000 (based on the information from [Stofa](http://www.stofa.dk/showpage.php?shortcut=kanalsoeg), **Note:** the frequency is in Hz)
  * Symbol Rate: 6900000
  * Modulation: &#8220;QAM 64&#8221;

When you press next MythTV should start scanning:

{{< photo src="/uploads/mythtv_scanning_for_channels2.png" title="MythTV setup: performing the scan" thumb="/uploads/mythtv_scanning_for_channels2-150x150.png" no_responsive="true" >}}

This takes a while, and then you should get:

{{< photo src="/uploads/mythtv_scanning_for_channels_done.png" title="MythTV setup: channel scanning completed" thumb="/uploads/mythtv_scanning_for_channels_done-150x150.png" no_responsive="true" >}}

Select &#8220;Insert all&#8221; which brings you back to the input connection screen.

### Channel editor

In mythtv-setup enter &#8220;Channel Editor&#8221;

Here you can see all the found channels and change their names, channel number, and so on. I did not change anything using the channel editor, but went to phpMyAdmin and changed settings like &#8220;Use on air guide&#8221; in one SQL.

This should be it, you should be able to record now :)

## EIT (TV guide)

MythTV should be able to get the data for the TV guide from the DVB-C stream, but I can&#8217;t get it working. When googling the problem I learned that importing the channels.conf generated by the &#8220;scan&#8221; tool does not provide enough data for MythTV to pickup the EIT data from the stream.

To further debug the problem I set mythbackend to log messages about EIT, in ArchLinux you can edit &#8220;/etc/conf.d/mythbackend&#8221; and change LOG_OPTS to:

<pre>LOG_OPTS='--verbose important,general,eit'
</pre>

So I shut the myhtbackend down, went to phpMyAdmin and truncated all tables related to channels/capture card and started over, and then let MythTV do the scan.

But I still get messages like this in &#8220;/var/log/mythbackend.log&#8221;:

<pre>2010-01-31 21:22:19.366 Program #1148 not found in PAT!
Program Association Table
 PSIP tableID(0x0) length(33) extension(0xb)
 version(27) current(1) section(0) last_section(0)
 tsid: 11
 programCount: 6
 program number     0 has PID 0x  10   data  0x 0 0x 0 0xe0 0x10
 program number  1090 has PID 0x  5a   data  0x 4 0x42 0xe0 0x5a
 program number  1098 has PID 0x  62   data  0x 4 0x4a 0xe0 0x62
 program number  1099 has PID 0x  63   data  0x 4 0x4b 0xe0 0x63
 program number  1165 has PID 0x  a5   data  0x 4 0x8d 0xe0 0xa5
 program number  1251 has PID 0x  fb   data  0x 4 0xe3 0xe0 0xfb

2010-01-31 21:22:20.120 ProcessPAT: Program not found in PAT.
 Rescan your transports.
2010-01-31 21:22:20.156 Desired program #1148 not found in PAT.
 Can Not create single program PAT.
</pre>

So for the time being I have given up, but luckily I found another way to get data from the stream.

## TV grab dvb plus

[tv\_grab\_dvb_plus](http://sourceforge.net/projects/tvgrabeit/) is a small tool that produces a xmltv file that can be imported into MythTV, just download and compile it. It worked the first time I tried it, although there are two minor issues:

  1. The mapping of xmltv ids to channels in MythTV
  2. The encoding of special characters like Danish letters (æøå)

The first issue I fixed with a small PHP script:

<pre>
<code class="language-php">&lt;?php $mysqli = new mysqli("localhost", "YOUR DB USER", "YOUR DB PASSWORD", "mythconverg"); if ($mysqli-&gt;connect_error)
{
printf("Connect failed: %s\n", mysqli_connect_error());
exit();
}

$result = $mysqli-&gt;query("SELECT chanid, serviceid FROM channel");

while ( $row = $result-&gt;fetch_assoc() )
{
$sql = sprintf("UPDATE channel SET xmltvid = '%s' WHERE chanid = %d", $row['serviceid'].'.dvb.guide', (int) $row['chanid']);

$mysqli-&gt;query($sql);
}

$mysqli-&gt;close();

?&gt;
</code>
</pre>

Remember to replace &#8220;YOUR DB USER&#8221; and &#8220;YOUR DB PASSWORD&#8221; with real values.

This script uses the serviceid from the channel table to set the xmltvid to the correct value.

The encoding issue was fixed by editing the source of tv\_grab\_dvb\_plus. In the file &#8220;src/dvb\_text.cpp&#8221; on line 133, I changed the encoding to &#8220;ISO-8859-1&#8221;:

<pre>
cd = iconv_open("ISO-8859-1", cs_new);
</pre>

And now it works.

All that is left is to import the produced xml file into MythTV with this command: &#8220;mythfilldatabase &#8211;file 1 dvbplus.xml&#8221; (or whatever you called the file).

## Final thoughts

So far I&#8217;m pleased with the combination of the TerraTec Cinergy C DVB-C card and MythTV, although it&#8217;s not super stable, and sometimes MythTV fails to record a program, and the following messages appear in dmesg:

<pre>mantis_ack_wait (0): Slave RACK Fail !
mantis_ack_wait (0): Slave RACK Fail !
mantis_ack_wait (0): Slave RACK Fail !
mantis_ack_wait (0): Slave RACK Fail !
mantis_ack_wait (0): Slave RACK Fail !
mantis_ack_wait (0): Slave RACK Fail !
mantis_ack_wait (0): Slave RACK Fail !</pre>

I hope this problem is fixed when the 2.6.33 Linux kernel hits my machine.

To view the recorded shows I strongly recommend a [Nvidia graphics card that support VDPAU](http://en.wikipedia.org/wiki/VDPAU).
