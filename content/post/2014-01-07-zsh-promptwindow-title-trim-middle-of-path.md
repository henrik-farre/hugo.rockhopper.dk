---
title: 'zsh prompt/window title: trim middle of path'
author: Henrik
layout: post
date: 2014-01-07
url: /linux/zsh-promptwindow-title-trim-middle-of-path/
categories:
  - Linux
tags:
  - tmux
  - zsh

---
I run zsh in tmux, and sometimes I end up in a deep directory where the path matches that of another window in tmux (for example in my local docker development environment and on the testing/production server). When this happens just seeing the last part of the path as the window title is not enough, like this: &#8230;/sites/all/modules/somemodule.
<!--more-->

So I changed my ~/.zshrc to contain this:

<pre>
<code class="language-bash">####################################################
# Set title function
# Used in precmd
function title() {
  # escape '%' chars in $1, make nonprintables visible
  local cmd=${(V)1//\%/\%\%}

  # See "Conditional Substrings in Prompts"
  # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  # %X&gt;...&gt;                     : truncate to 40 chars followed by ...
  # %X(c:true-text:false-text)  : if c &gt; %X show true text, else false text

  # Truncate cmd to 40
  cmd=$(print -Pn "%40&gt;...&gt;$cmd" | tr -d "\n")

  case $TERM in
    screen|screen-bce|screen-256color|screen-256color-bce)
      if [[ -z $SSH_TTY ]]; then
        #print -Pn "\ek%40&lt;...&lt;%~&gt; $cmd\e\\"
        # if c (current path with prefix replace, aka ~) is larger than 7,
        # show first 3 parts, then ... and then last 3 parts, else just %~
        print -Pn "\ek%7(c:%-3~/.../%3~:%~) $cmd\e\\"
      else
        # With user/hostname
        print -Pn "\ek%m:%40&lt;...&lt;%~&gt; $cmd\e\\"
      fi
      ;;
    xterm*|rxvt*)
      # plain xterm title
      if [[ -z $SSH_TTY ]]; then
        print -Pn "\e]2;%40&lt;...&lt;%~&gt; $cmd\a"
      else
        # With user/hostname
        print -Pn "\e]2;%n@%m:%40&lt;...&lt;%~&gt; $cmd\a"
      fi
      ;;
  esac
}

####################################################
# Window title
# precmd is called just before the prompt is printed
function precmd() {
  title ""
  # Don't run vcs_info if remote shell
  if [[ -z $SSH_TTY ]]; then
    vcs_info
  fi
}
# preexec is called just before any command line is executed
function preexec() {
  title "$1"
}
</code>
</pre>

This creates the following window title: ~/Work/docker/&#8230;/all/modules/somemodule. The magic happens by saying %7(c:%-3~/&#8230;/%3~:%~) which means: if &#8220;c&#8221;, which contains the entire path after prefix has been replaced -> /home/username to ~, is larger than 7, show the 3 first directories, then &#8230; and finally the last 3 directories.

The same can be done in the shell prompt.
