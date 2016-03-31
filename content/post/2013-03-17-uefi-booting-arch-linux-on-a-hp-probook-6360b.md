---
title: UEFI booting Arch Linux on a HP ProBook 6360b
author: Henrik
layout: post
date: 2013-03-17
url: /linux/hardware/uefi-booting-arch-linux-on-a-hp-probook-6360b/
categories:
  - Hardware
tags:
  - Archlinux
  - BIOS
  - booting
  - ProBook 6360b
  - UEFI

---
As I&#8217;ve just got a new Samsung 840 Pro Series 256GB SSD for my work laptop (HP ProBook 6360b), I wanted to try switching from BIOS booting to UEFI.
<!--more-->

# SSD setup

Using gdisk I created two partitions:

<pre>Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          206847   100.0 MiB   EF00  EFI System
   2          206848       500118158   238.4 GiB   8300  Linux filesystem</pre>

I left the default align to 2048-sector boundaries.

In gdisk I entered &#8220;extra functionality (experts only)&#8221; by pressing &#8220;x&#8221;, and then &#8220;a&#8221; ( &#8220;set attributes&#8221;), and selected &#8220;0&#8221; for &#8220;system partition&#8221; and &#8220;2&#8221; for &#8220;legacy BIOS bootable&#8221;

Next I formatted the two partitions using:

  * mkfs.vfat -F32 /dev/sda1
  * mkfs.ext4 -m0 /dev/sda2

Finally I mounted the old disk (connected using the eSATA connector on the laptop) and the new disk, and used rsync to copy everything to the new disk.

# Bootloader setup

This was the tricky part. First I updated the firmware on the laptop to the newest version (F.29 from [HPs support site](http://h20000.www2.hp.com/bizsupport/TechSupport/SoftwareIndex.jsp?lang=en&cc=dk&prodNameId=5045588&prodTypeId=321957&prodSeriesId=5045581&swLang=13&taskId=135&swEnvOID=4060)). I tried all the .exe files on a computer running Windows 7 until I found the one that could create an USB stick.

## Booting in UEFI mode

Very importen bit: you can&#8217;t install a UEFI bootloader unless you&#8217;ve booted in UEFI mode.

I used the instructions in the Arch Linux wiki on how to [Create UEFI bootable USB from ISO](https://wiki.archlinux.org/index.php/UEFI#Create_UEFI_bootable_USB_from_ISO). Sometimes UEFI refused to boot from the USB, but it worked each time I selected the EFI file on the USB stick. To do that press F9 while the computer is booting and select &#8220;Boot from EFI file&#8221;, then select the USB device and EFI/boot/bootx64.efi

## Installing the bootloader

I tried rEFInd, gummiboot, grub2 and just using the kernel EFI stub support. Nothing worked. After reading [UEFI Booting 64-bit Redhat Enterprise Linux 6](http://blog.fpmurphy.com/2010/09/uefi-booting-64-bit-redhat-enterprise-linux-6.html) I figured out that HPs firmware only allows you to boot from &#8220;OS bootloader&#8221;, which means that it will only boot from \EFI\BOOT\BOOTX64.EFI. So I installed grub2 using these commands (/dev/sda1 is mounted at /boot/efi):

  * grub-install &#8211;target=x86\_64-efi &#8211;efi-directory=/boot/efi &#8211;bootloader-id=arch\_grub &#8211;recheck
  * grub-mkconfig -o /boot/grub/grub.cfg

This will put the EFI application in /boot/efi/EFI/arch\_grub/grubx64.efi which does not work. So I just copied /boot/efi/EFI/arch\_grub/grubx64.efi /boot/efi/EFI/BOOT/BOOTX64.EFI and everything works.

# Conclusion

I can&#8217;t say that that the time I used to get UEFI booting working was time well spend, nothing magic happens when booting using UEFI compared to legacy BIOS, but at least I&#8217;m not using anything that is labelled &#8220;legacy&#8221; :)
