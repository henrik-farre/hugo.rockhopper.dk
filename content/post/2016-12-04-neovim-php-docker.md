+++
date = "2016-04-12T10:47:36+02:00"
title = "Local PHP development with Vim/Neovim and Docker"
url = "/linux/software/local-php-development-with-vimneovim-and-docker"
tags = ["Docker"]
categories = [
  "software",
  "php",
  "vim"
]

+++
I use Neovim for all my text editing, and as I'm a web developer I edit a lot of HTML, PHP, CSS and JavaScript. And not only do I have to switch between different programming/markup languages I also have to switch between different environments, ranging from old Drupal 6 sites on Debian squeeze to a Symfony setup on Debian Jessie to ensure that my code works in production.<!--more-->

## Enter Docker
Switching between different versions of Apache/PHP/MySQL and other components is nearly impossible if they are locally installed. In the old dark days I would work on a site directly on the server, then later Vagrant came along and gave a virtual server that could be provisioned like the production server and now Docker gives lightweight containers that allows to quickly switch between different setups.

I use a Docker image that contains all the needed components for the development environment. My docker setup is here http://github.com/henrik-farre/docker. I use a simple script to make interaction easier, it's called "pilotboat".

My Docker image contains Apache, MariaDB, PHP5 with Xdebug, Mailhog and Webgrind. Database data is kept separately in a volume and sites/virtual hosts are kept on the host.

### Workflow
I can either drop an existing virtual host file in the vhosts directory, or run <code>pilotboat site-create mydomain.dev</code> which will create a virtual host and directory structure. I use dnsmasq to point the top level domain (.dev) to localhost. If you use NetworkManager just create the following file: <code>/etc/NetworkManager/dnsmasq.d/dev.conf</code> containing:

<pre><code>address=/dev/127.0.0.1</code></pre>

Then I can checkout the site from git and import a database, which can be done by <code>pilotboat db-import database_name</code>. The command will try to import a file in the databases directory called database_name.sql.gz and the file should have been created by running <code>mysqldump -f --opt -u root -p -c [database_name] | gzip > [database_name.sql.gz]</code>, or alternative I use phpMyAdmin which is running in the container on http://localhost/phpmyadmin/

## Vim / Neovim
The only special setup for Vim is connecting Xdebug in the container to Vdebug, and map paths from inside the container to the local file system:
<pre><code class="language-vim">let g:vdebug_options = {"path_maps": {"/var/www": "/path/to/pilotboat/sites"}, "break_on_open": 0, "watch_window_style": "compact", "server" : "172.17.0.1", "port": 9000}
</code></pre>

I try to make Neovim do as much work for me as possible, and I use the following plugins to help me with that:

  * [Vdebug](https://github.com/joonty/vdebug): Debug PHP code step by step
  * [Emmet](https://github.com/mattn/emmet-vim): Expands div#header &gt; ul.menu &gt; li*5 to real HTML
  * [UltiSnips](https://github.com/SirVer/ultisnips): Advanced snippet expanding, useful for quickly typing PHP functions complete with PHP doc comments
  * [YouCompleteMe](https://github.com/Valloric/YouCompleteMe): Great for completing the current programming languages native functions and vars
  * [delimitMate](https://github.com/Raimondi/delimitMate): Automatically insert matching brackets, parentheses and more
  * [Surround](https://github.com/tpope/vim-surround): Wraps words in ' or * or other characters
  * [NERD Commenter](https://github.com/scrooloose/nerdcommenter): Comment/Uncomment single lines or blocks
  * [Neomake](https://github.com/benekastah/neomake): Automatically asynchronous syntax checking, works with PHP lint, [PHP Mess Detector](https://phpmd.org/) and [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)

You can find my Neovim setup here: http://github.com/henrik-farre/vimrc
