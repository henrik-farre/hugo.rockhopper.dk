+++
date = "2016-06-15T09:42:24+02:00"
draft = true
title = "Linux on Lenovo ThinkPad L460"

+++

Finding a laptop that is well supported by Linux, has nice features and is not to expensive can be quite a task. Lucky the Lenovo ThinkPad L460 fits my requirements.<!--more-->

## OS

I decided to do a fresh install of Arch Linux instead of just cloning one of my other systems as I normally do. At the time of this post the laptop is running with Linux kernel version 4.6.2-1.

Relevant info from [dmesg](/uploads/files/dmesg.lenovo-thinkpad-l460.txt), [dmidecode](/uploads/files/dmidecode.lenovo-thinkpad-l460.txt), [lscpi](/uploads/files/lspci.lenovo-thinkpad-l460.txt) and [lsusb](/uploads/files/lsusb.lenovo-thinkpad-l460.txt)

## Specs

<table class="table table-striped">
  <tr>
    <td>CPU</td>
    <td>Intel i5-6200U (3MB Cache, up to 2.80GHz)</td>
  </tr>
  <tr>
    <td>RAM</td>
    <td>16 GB PC3-12800 DDR3L 1600MHz (2 &times; 8GB 1.35V 204-pin SODIMM, Samsung M471B1G73DB0-YK0)</td>
  </tr>
  <tr>
    <td>Storage</td>
    <td>256 GB Solid State Drive, SATA3</td>
  </tr>
  <tr>
    <td>Screen</td>
    <td>14" FHD (1920 x 1080), IPS, AntiGlare</td>
  </tr>
  <tr>
    <td>WIFI / Bluetooth</td>
    <td>Intel Dual Band Wireless-AC (2x2) 8260, Bluetooth-version 4.1 vPro</td>
  </tr>
  <tr>
    <td>Ethernet</td>
    <td>Intel PRO/1000 (I219-V)</td>
  </tr>
  <tr>
    <td>UEFI</td>
    <td>Version R08ET41W (1.15), Option to disable secure boot: yes</td>
  </tr>
  <tr>
    <td>Battery</td>
    <td>6 cell Li-Ion (47Whr, Sanyo LNV-45N1)</td>
  </tr>
  <tr>
    <td>Webcam</td>
    <td>720p HD Camera, uses uvcvideo driver</td>
  </tr>
</table>

## Touchpad / Clickpad

The xf86-input-libinput driver was not very responsive and I had to move my finger alot to get it to move, which made resizing windows and hitting small targets very hard.
I replaced it with the xf86-input-synaptics and it works much better.

The next problem was that the cursor jumped down and to the left each time I tried to use the clickpad's left "button".

I ended up with the following options in {{< path >}}/etc/X11/xorg.conf.d/55-synaptics.conf{{< /path >}} to fix that:

{{< pre >}}Section "InputClass"
    Identifier      "touchpad"
    Driver          "synaptics"
    MatchIsTouchpad "on"
    Option          "SoftButtonAreas"  "60% 0 82% 0 40% 59% 82% 0"
    Option          "AreaBottomEdge"       "90%"
EndSection{{< /pre >}}

## Graphics card / driver

I experienced a lot off screen flickering, so I tried the mode setting driver by uninstalling xf86-video-intel and xf86-video-vesa which fixes the problem, but introduces screen tearing. I update UEFI to version 1.15 (which includes new VBIOS), Linux kernel to 4.6.x and the xf86-video-intel driver to version 2.99.917+662 and now the problem seems to have disappeared.

Two minor problems still persists, LightDM/Light-locker still flickers once after starting and after resume, but I just have to wait a second before entering my password.

Finally the cursor disappears after resume, this can be fixed by running {{< cmd >}}xset dpms force off{{< /cmd >}}.

I have only set "TearFree" as an extra option in {{< path >}}/etc/X11/xorg.conf.d/20-intel.conf{{< /path >}}:

<pre>Section "Device"
  Identifier  "Intel Graphics"
  Driver      "intel"
  Option      "TearFree" "true"
EndSection</pre>

## Overall

Okay build quality, a little to much flex when I lift it

Battery life is okay, I have installed and configured tlp
