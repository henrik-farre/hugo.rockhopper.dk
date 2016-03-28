---
title: zsh, bash, screen and urxvt title
author: Henrik
layout: post
date: 2008-11-05
url: /linux/software/zsh-bash-screen-and-urxvt-title/
categories:
  - Software
tags:
  - bash
  - screen
  - urxvt
  - zsh

---
I use both the zsh and bash shell, and most of the time I run them in screen. This happens in my favourite terminal: urxvt (aka rxvt-unicode). 

I have a pretty consistence terminal title in both shells. I use hostname[last part of current path]:

[<img src="https://rockhopper.dk/wp-content/uploads/2008/11/zsh_screen_urxvt-300x178.jpg" alt="" title="Zsh in screen in urxvt" width="300" height="178" class="alignnone size-medium wp-image-100" srcset="http://rockhopper.hf/wp-content/uploads/2008/11/zsh_screen_urxvt-300x178.jpg 300w, http://rockhopper.hf/wp-content/uploads/2008/11/zsh_screen_urxvt.jpg 654w" sizes="(max-width: 300px) 100vw, 300px" />][1] 

I have the following in my ~/.zsh:

<pre class="bash codesnip" style="font-family:monospace;"><span class="kw1">if</span> <span class="br0">&#91;</span><span class="br0">&#91;</span> <span class="co1">${TERM}</span> == <span class="st0">"screen-bce"</span> <span class="sy0">||</span> <span class="co1">${TERM}</span> == <span class="st0">"screen"</span> <span class="br0">&#93;</span><span class="br0">&#93;</span>; <span class="kw1">then</span>
  precmd <span class="br0">&#40;</span><span class="br0">&#41;</span> <span class="br0">&#123;</span> print <span class="re5">-Pn</span> <span class="st0">"\033k\033\134\033k%m[%1d]\033\134"</span> <span class="br0">&#125;</span>
  preexec <span class="br0">&#40;</span><span class="br0">&#41;</span> <span class="br0">&#123;</span> print <span class="re5">-Pn</span> <span class="st0">"\033k\033\134\033k%m[$1]\033\134"</span> <span class="br0">&#125;</span>
<span class="kw1">else</span>
  precmd <span class="br0">&#40;</span><span class="br0">&#41;</span> <span class="br0">&#123;</span> print <span class="re5">-Pn</span> <span class="st0">"\e]0;%n@%m: %~\a"</span> <span class="br0">&#125;</span>
  preexec <span class="br0">&#40;</span><span class="br0">&#41;</span> <span class="br0">&#123;</span> print <span class="re5">-Pn</span> <span class="st0">"\e]0;%n@%m: $1\a"</span> <span class="br0">&#125;</span>
<span class="kw1">fi</span>
<span class="re2">PS1</span>=$<span class="st_h">'%{\e[0;32m%}%m%{\e[0m%}:%~&gt; '</span>
<span class="kw3">export</span> PS1</pre>

My ~/.bashrc:

<pre class="bash codesnip" style="font-family:monospace;"><span class="re2">PROMPT_COMMAND</span>=<span class="st_h">'echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'</span>
<span class="re2">PS1</span>=<span class="st_h">'\[\033[0;32m\]\h\[\033[00m\]:\w&gt; '</span>
<span class="kw3">export</span> PS1 PROMPT_COMMAND</pre>

And finally my ~/.screenrc

<pre class="bash codesnip" style="font-family:monospace;">hardstatus string <span class="st0">"%h"</span>
caption always <span class="st0">"%{= kw} %-w%{= wk}%n*%t%{-}%+w%{= kw} %=%d %M %0c %{g}%H%{-}"</span></pre>

 [1]: https://rockhopper.dk/wp-content/uploads/2008/11/zsh_screen_urxvt.jpg