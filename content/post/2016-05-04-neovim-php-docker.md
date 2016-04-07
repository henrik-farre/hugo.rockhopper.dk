+++
date = "2016-04-05T10:47:36+02:00"
draft = true
title = "Local PHP development with Vim/Neovim and Docker"

+++
I use Neovim for all my text editing, and as I'm a web developer I edit a lot of HTML, PHP, CSS and JavaScript. And not only do I have to switch between different programming/markup languages I also have to switch between different environments, ranging from old Drupal 6 sites on Debian squeeze to a Symfony setup on Debian Jessie to ensure that my code works.

And switching between different versions of Apache/PHP/Mysql and other components is nearly impossible if they are locally installed. In the old dark days I would work on a site directly on the server, then later came vagrant and now docker.

I prefer to use one single docker container that can be easily distributed and that containing all the needed components for the development environment. My docker setup is here http://github.com/henrik-farre/docker. I use a simple script to make interaction easier, it's called "pilotboat".

My Docker image contains Apache,MariaDB,PHP5 with Xdebug, Mailhog and webgrind. Database data is kept separately in a volume and sites/virtual hosts are kept on the host.

The only special setup for Vim is connecting Vdebug to Xdebug in the container

I try to make Neovim do as much work for me as possible, and I use the following plugins to help me with that:

  * [Emmet](https://github.com/mattn/emmet-vim): Expands div#header &gt; ul.menu &gt; li*5 to real HTML
  * [UltiSnips](https://github.com/SirVer/ultisnips): Advanced expanding, useful for stuff like fast typing PHP functions with PHP doc comments and everything
  * [YouCompleteMe](https://github.com/Valloric/YouCompleteMe): Great for completing the current programming languages native functions and vars
  * [delimitMate](https://github.com/Raimondi/delimitMate): Automatically insert matching brackets, parentheses and more
  * [Surround](https://github.com/tpope/vim-surround): Wraps words in ' or * or whatever is needed
  * [NERD Commenter](https://github.com/scrooloose/nerdcommenter)
  * [Neomake](https://github.com/benekastah/neomake): Automatically asynchronous syntax checking, works with PHP lint, [PHP Mess Detector](https://phpmd.org/) and [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)

You can find my Neovim setup here: http://github.com/henrik-farre/vimrc
