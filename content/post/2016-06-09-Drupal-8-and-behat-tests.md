+++
date = "2016-06-09T10:52:40+02:00"
draft = true
title = "Drupal 8 and Behat tests"

+++

hest<!--more-->

First create a behat directory outside the drupal installation so that you have the following directory layout:

<pre>.
├── behat
├── logs
│   ├── access.log
│   └── error.log
├── public_html
│   ├── autoload.php
│   ├── ...
│   └── web.config
├── sessions
├── tmp
└── upload</pre>

Inside the behat directory create a composer.json file, with the following content:

{{< code javascript >}}{
  "require": {
    "drupal/drupal-extension": "~3.0",
    "guzzlehttp/guzzle": "^6.0@dev",
    "symfony/dependency-injection": "2.8.2",
    "symfony/event-dispatcher": "2.8.2"
  },
  "config": {
    "bin-dir": "bin/"
  }
}
{{< /code >}}

It is needed to pin the version of the Symfony dependencies, else you will get this error:

{{< code php >}}PHP Fatal error:  Undefined class constant 'Symfony\Component\DependencyInjection\ContainerInterface::SCOPE_CONTAINER' in /var/www/drupal8.dev/public_html/core/lib/Drupal/Core/DependencyInjection/Container.php on line 16{{< /code >}}

See [Drupal bug report](https://www.drupal.org/node/2704943) for more info. The file is based on the [Stand-alone installation](https://behat-drupal-extension.readthedocs.io/en/3.1/localinstall.html) documentation for the Drupal Extension to Behat and Mink.

Next the dependencies has to be installed, I use my [Docker based dev environment "pilotboat"](https://github.com/henrik-farre/docker), so I can execute {{< cmd >}}pilotboat shell{{< /cmd >}} to get a shell inside the container, else just follow the next instructions.

Enter the behat directory, {{< cmd >}}cd drupal8.dev/behat{{< /cmd >}} and run: {{< cmd >}}composer install{{< /cmd >}} and wait until everything is installed.

Finally create behat.yml:

{{< code yaml >}}default:
  suites:
    default:
      contexts:
        - FeatureContext
        - Drupal\DrupalExtension\Context\DrupalContext
        - Drupal\DrupalExtension\Context\MinkContext
        - Drupal\DrupalExtension\Context\MessageContext
        - Drupal\DrupalExtension\Context\DrushContext
  extensions:
    Behat\MinkExtension:
      selenium2:
        wd_host: 'http://phantomjs:8910/wd/hub'
      base_url: http://drupal8.dev
    Drupal\DrupalExtension:
      blackbox: ~
      api_driver: 'drupal'
      drush:
        root: '/var/www/drupal8.dev/public_html'
      drupal:
        drupal_root: '/var/www/drupal8.dev/public_html'{{< /code >}}

Now everything should be ready to run {{< cmd >}}bin/behat --init{{< /cmd >}} and create a feature:

{{< code cucumber >}}

{{< /code >}}
