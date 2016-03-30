---
title: 'Android Developer Phone: Mini review'
author: Henrik
layout: post
date: 2009-01-24
url: /linux/hardware/phone-and-pda/android-developer-phone-mini-review/
categories:
  - Phone and PDA
tags:
  - android
  - review

---
I have been playing around with my Android Developer Phone (ADP) for about 2 weeks now, and this are my thoughts on it so far.
<!--more-->

## Wireless connection (Wi-Fi/3G)

The Wi-Fi range is a bit limited, with my laptop I get about 80% signal quality in my living room, but the ADP only gets &#8220;fair&#8221; or no connection.

Another issue is that some times the phone will not connect to a remembered network (it might be a problem with hidden SSIDs), and the only way to fix it is to delete the saved network and add it again, which is highly annoying if you have a 64 char WPA2 passphrase :).

I can&#8217;t really say anything about the quality of the 3G, because coverage is rather bad where I live and where I work.

## Screen

Even though I run the screen at lowest brightness setting it is still bright enough to see it in sunlight (well it is winter right now, so the sun isn&#8217;t that bright). Sometimes it takes 2-3 tries to select something on the screen, probably because I tap on it to quickly/lightly.

I have found some nice [wallpapers on InterfaceLIFT][1]. I download the images in 800&#215;480 and crop the image to fit the screen.

## Audio

The audio player that comes with Android works well, and the sound quality is better than my old iPod mini 4Gb. I have upgrade the 1Gb MicroSD to a 16Gb MicroSDHC class 2 card and stuffed it full with music, and it works great. It&#8217;s nice that file formats other than mp3 are support (e.g. ogg vorbis).

It took me a while to get album covers to show up in the player, but after I tried [Banshee][2] (which supports the G1 out of the box), I discovered that I should just rename my cover.jpg files to AlbumArt.jpg :). Bash one liner to do this:

<pre class="bash codesnip" style="font-family:monospace;"><span class="kw2">find</span> . <span class="re5">-name</span> <span class="st0">"cover.jpg"</span> <span class="re5">-print0</span> <span class="sy0">|</span> <span class="kw1">while</span> <span class="kw2">read</span> <span class="re5">-d</span> $<span class="st_h">'\0'</span> i; <span class="kw1">do</span> <span class="re2">j</span>=<span class="sy0">`</span><span class="kw2">dirname</span> <span class="st0">"<span class="es2">$i</span>"</span><span class="sy0">`</span>; <span class="kw2">mv</span> <span class="st0">"<span class="es2">$i</span>"</span> <span class="st0">"<span class="es2">$j</span>/AlbumArt.jpg"</span>; <span class="kw1">done</span></pre>

A nice features is the ability to control the music player using the button on the headphones&#8217; cable.

## Applications / Android OS

The applications that come with the G1, like Gmail, browser and messaging, are easy to use and just work. Please note that I had a PalmOne Treo 600 before the ADP, so everything is super compared to it ;).

I have installed a couple of extra applications (either from the market place or directly from webpages) that you might find useful:

  * [Connectbot][3]: establish ssh connections to servers, supports ssh keys
  * [AndFTP](http://www.lysesoft.com/products/andftp/): upload/download files via ftp/sftp
  * Terminal: gives access to the ADP&#8217;s Linux shell
  * Anycut: create shortcuts to applications or activities like text a specific contact

The Android OS feels stable and relative mature, and I have only experienced one major crash. It happened just after adding 14Gb of music to the sd card, and I was playing around with the headphones while the player was busy creating thumbnails of the Album art. Suddenly the player forced quit, and then the sd card could not be accessed, neither by the player nor could I mount the card on my computer. I could only make it work again by reformatting the card, and copying all the music on to the card again.

## Camera

Light years ahead of the crappy camera in the Treo 600, takes good pictures, but I don&#8217;t see me using it much.

When I took the phone out of the box, the small plastic cover above the camera lens was lose and still does not sit flush with the rest of the back cover, but I&#8217;m sure it can be fixed.

## Keyboard

I like the keyboard, the keys are not to small and provide excellent tactile feedback. My only issues are:

  * I often hit enter when I want to hit del, and the other way around, but that&#8217;s probably me having to get use to the placement of the keys
  * Danish characters (æøå) are slow to type, first you have to long press a (for æå) or o (for ø) and then either use the trackball or touch screen to select the character (you can also use enter to type the selected character, and space to select the last character)

I&#8217;m used to my phone no having auto completion, but it would speed up typing words with Danish characters.

## Overall

Although I have limited experience with smart phones, I really prefer the ADP when I compare it to my friends iPhones or HTC phones running Windows Mobile. My girlfriend also really likes it and is defently going to buy the regular HTC G1 when it hits Denmark.

 [1]: http://interfacelift.com
 [2]: http://banshee-project.org/
 [3]: http://code.google.com/p/connectbot/
