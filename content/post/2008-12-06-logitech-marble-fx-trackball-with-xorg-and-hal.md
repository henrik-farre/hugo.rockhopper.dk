---
title: Logitech Marble FX trackball with Xorg and Hal
author: Henrik
layout: post
date: 2008-12-06
url: /linux/hardware/logitech-marble-fx-trackball-with-xorg-and-hal/
categories:
  - Hardware
  - Xorg
tags:
  - archlinux

---
After the recent upgrade in ArchLinux of xorg-server from 1.4.x to 1.5.x my thrusty Logitech Marble FX trackball did not work entirely. The trackball does not have a dedicated scroll wheel, but by pressing a button, and using the trackball, you can scroll both vertical and horizontal.
<!--more-->

In order to get the emulated scroll working again you first have to update the evdev driver (the xf86-input-evdev package), as version 2.0.7 doesn&#8217;t support the needed options.

I use the [xf86-input-evdev-git PKGBUILD from aur][1] (which depends on [xkeyboard-config-git][2]) which works fine.

Once you have build the packages and installed them (remove the conflicting packages by using pacman -Rd packagename) you will have to create a Hal fdi file, I created &#8220;/etc/hal/fdi/policy/11-x11-mouse.fdi&#8221; containing:

<pre>
<code class="language-xml">&lt;?xml version="1.0" encoding="ISO-8859-1"?&gt;
&lt;deviceinfo version="0.2"&gt;
  &lt;device&gt;
    &lt;match key="info.capabilities" contains="input.mouse"&gt;
      &lt;match key="info.product" contains="PS2++ Logitech Mouse"&gt;
        &lt;merge key="input.x11.Protocol" type="string"&gt;ExplorerPS/2&lt;/merge&gt;
        &lt;merge key="input.x11_options.Buttons" type="string"&gt;7&lt;/merge&gt;
        &lt;merge key="input.x11_options.XAxisMapping" type="string"&gt;6 7&lt;/merge&gt;
        &lt;merge key="input.x11_options.YAxisMapping" type="string"&gt;4 5&lt;/merge&gt;
        &lt;merge key="input.x11_options.EmulateWheel" type="string"&gt;True&lt;/merge&gt;
        &lt;merge key="input.x11_options.EmulateWheelButton" type="string"&gt;8&lt;/merge&gt;
        &lt;merge key="input.x11_options.EmulateWheelInertia" type="string"&gt;30&lt;/merge&gt;
        &lt;merge key="input.x11_options.Emulate3Buttons" type="string"&gt;False&lt;/merge&gt;
      &lt;/match&gt;
    &lt;/match&gt;
  &lt;/device&gt;
&lt;/deviceinfo&gt;
</code></pre>

Now shutdown X, restart hal and X and the emulated scroll whell should work just fine. I have the following output in my &#8220;/var/log/Xorg.0.log&#8221;:

<pre>(II) config/hal: Adding input device PS2++ Logitech Mouse
(**) PS2++ Logitech Mouse: always reports core events
(**) PS2++ Logitech Mouse: Device: "/dev/input/event3"
(II) PS2++ Logitech Mouse: Found 4 mouse buttons
(II) PS2++ Logitech Mouse: Found x and y relative axes
(II) PS2++ Logitech Mouse: Configuring as mouse
(**) Option "Emulate3Buttons" "False"
(II) PS2++ Logitech Mouse: Forcing middle mouse button emulation off.
(**) Option "EmulateWheel" "True"
(**) Option "EmulateWheelButton" "8"
(**) Option "EmulateWheelInertia" "30"
(**) Option "YAxisMapping" "4 5"
(**) PS2++ Logitech Mouse: YAxisMapping: buttons 4 and 5
(**) Option "XAxisMapping" "6 7"
(**) PS2++ Logitech Mouse: XAxisMapping: buttons 6 and 7
(**) PS2++ Logitech Mouse: EmulateWheelButton: 8, EmulateWheelInertia: 30, EmulateWheelTimeout: 200
(II) XINPUT: Adding extended input device "PS2++ Logitech Mouse" (type: MOUSE)</pre>

 [1]: http://aur.archlinux.org/packages.php?do_Details=1&ID=19593&O=&L=&C=&K=&SB=&SO=&PP=&do_Orphans=&SeB=
 [2]: http://aur.archlinux.org/packages.php?do_Details=1&ID=19592&O=&L=&C=&K=&SB=&SO=&PP=&do_Orphans=&SeB=
