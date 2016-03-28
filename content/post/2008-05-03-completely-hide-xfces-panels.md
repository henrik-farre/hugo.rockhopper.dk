---
title: Completely hide Xfce’s panels
author: Henrik
layout: post
date: 2008-05-03
url: /linux/software/xfce/completely-hide-xfces-panels/
categories:
  - Xfce

---
Even though a Xfce panel is &#8220;hidden&#8221; (i.e. &#8220;Autohide&#8221; is enabled) 3 pixels of it is still visible. But there is an easy way to hide it completely (Requires Xfwm4&#8217;s compositor to be enabled):

  * Right click on the panel you want to hide, select &#8220;Customize panel&#8221;
  * Set &#8220;Transparency&#8221; to 100%
  * Click &#8220;Make active panel opaque&#8221;

The 3 pixels are now 100% transparent, but when the mouse cursor moves over the panel, the panel becomes opaque.

<img src="https://rockhopper.dk/wp-content/uploads/2008/05/xfce-panel-manager.png" alt="Xfce\&#039;s panel set to hide completely" title="xfce-panel-manager" width="281" height="182" class="alignright size-full wp-image-50" />