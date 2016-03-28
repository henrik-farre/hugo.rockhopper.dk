---
title: AnySee E30 C Plus + MythTV
author: Henrik
layout: post
date: 2010-05-29
url: /linux/software/mythtv/anysee-e30-c-plus-mythtv/
categories:
  - MythTV
tags:
  - dvb-c
  - mythbackend

---
I had the chance to test [AnySee&#8217;s USB based DVB-C tuner][1] with MythTV, and I can confirm it &#8220;just works&#8221;.

To setup the AnySee E30 C Plus just follow my [Terratec Cinergy C PCI HD + MythTV guide][2], the setup is exactly the same. The only thing I noticed is that the signal strength is not as high as it is with the Terratec card, it hovers around 40-50% vs 90-95%.

Dmesg output:

<pre>usb 2-6: USB disconnect, address 4
dvb-usb: Anysee DVB USB2.0 successfully deinitialized and disconnected.
usb 2-6: new high speed USB device using ehci_hcd and address 5
usb 2-6: device not accepting address 5, error -71
usb 2-6: new high speed USB device using ehci_hcd and address 6
usb 2-6: config 1 interface 0 altsetting 0 bulk endpoint 0x1 has invalid maxpacket 64
usb 2-6: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 64
usb 2-6: config 1 interface 0 altsetting 1 bulk endpoint 0x1 has invalid maxpacket 64
usb 2-6: config 1 interface 0 altsetting 1 bulk endpoint 0x81 has invalid maxpacket 64
usb 2-6: configuration #1 chosen from 1 choice
dvb-usb: found a 'Anysee DVB USB2.0' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Anysee DVB USB2.0)
anysee: firmware version:0.1.2 hardware id:15
DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-6/input/input10
dvb-usb: schedule remote query interval to 200 msecs.
dvb-usb: Anysee DVB USB2.0 successfully initialized and connected.</pre>

 [1]: http://www.anysee.dk/products.html
 [2]: https://rockhopper.dk/linux/software/mythtv/terratec-cinergy-c-pci-hd-mythtv/