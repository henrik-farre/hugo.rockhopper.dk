---
title: zsh, bash, screen and urxvt title
author: Henrik

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
<!--more-->

I have a pretty consistence terminal title in both shells. I use hostname[last part of current path]:

{{< photo src="/uploads/zsh_screen_urxvt.jpg" title="Zsh in screen in urxvt" thumb="/uploads/thumbnails/zsh_screen_urxvt-300x178.jpg" no_responsive="true" >}}

I have the following in my ~/.zsh:


<pre>
<code class="language-bash">if [[ ${TERM} == "screen-bce" || ${TERM} == "screen" ]]; then
  precmd () { print -Pn "\033k\033\134\033k%m[%1d]\033\134" }
  preexec () { print -Pn "\033k\033\134\033k%m[$1]\033\134" }
else
  precmd () { print -Pn "\e]0;%n@%m: %~\a" }
  preexec () { print -Pn "\e]0;%n@%m: $1\a" }
fi
PS1=$'%{\e[0;32m%}%m%{\e[0m%}:%~&gt; '
export PS1
</code></pre>

My ~/.bashrc:

<pre>
<code class="language-bash">PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
PS1='\[\033[0;32m\]\h\[\033[00m\]:\w&gt; '
export PS1 PROMPT_COMMAND
</code></pre>

And finally my ~/.screenrc

<pre>
<code class="language-bash">hardstatus string "%h"
caption always "%{= kw} %-w%{= wk}%n*%t%{-}%+w%{= kw} %=%d %M %0c %{g}%H%{-}"
</code></pre>
