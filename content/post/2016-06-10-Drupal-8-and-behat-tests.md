+++
date = "2016-06-10T10:23:40+02:00"
draft = true
title = "Drupal 8 and Behat tests"
url = "linux/software/drupal-8-and-behat-tests"
tags = ["Behat", "Drupal 8"]
categories = [
  "software",
  "php"
]

+++

The ["Drupal Extension to Behat and Mink"](https://www.drupal.org/project/drupalextension) provides some nice Drupal specific step definitions and ways of setting test data up. This post runs through the setup process.<!--more-->

First create a behat directory outside your Drupal installation ({{< path >}}public_html{{< /path >}} in my case) so that you have the following directory layout:

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

I always keep the entire layout show above in git (with git ignores on the contents of {{< path >}}logs{{< /path >}}, {{< path >}}session{{< /path >}}, {{< path >}}tmp{{< /path >}} and {{< path >}}upload{{< /path >}}).

Inside the {{< path >}}behat{{< /path >}} directory create a {{< path >}}composer.json{{< /path >}} file, with the following content:

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

See this [bug report](https://www.drupal.org/node/2704943) for more info. The file is based on the [Stand-alone installation](https://behat-drupal-extension.readthedocs.io/en/3.1/localinstall.html) documentation for the Drupal Extension to Behat and Mink.

Next the dependencies has to be installed. I use my [Docker based dev environment "pilotboat"](https://github.com/henrik-farre/docker), so I execute {{< cmd >}}pilotboat shell{{< /cmd >}} to get a shell inside the container, if you use something else, just follow the next instructions.

Enter the {{< path >}}behat{{< /path >}} directory, {{< cmd >}}cd drupal8.dev/behat{{< /cmd >}} and run: {{< cmd >}}composer install{{< /cmd >}} and wait until everything is installed.

Now we can create {{< path >}}behat.yml{{< /path >}}. Adapt the url for PhantomJS (wd_host), and the paths to the Drupal installation so it matches your setup.

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

Now everything should be ready so that you can run {{< cmd >}}bin/behat --init{{< /cmd >}} and then create the first feature: {{< path >}}features/homepage.feature{{< /path >}}.

{{< code cucumber >}}Feature: Homepage
  In order to see if the home page works
  As a website user
  I need to be able to see the home page

  Scenario: See the home page
    Given I am on "/"
    Then I should see "Welcome to drupal8.dev"{{< /code >}}

If you want to create nodes, you can tag the feature or the scenario with "@api":

{{< code cucumber >}}@api
  Scenario: Create a node
    Given I am logged in as a user with the "administrator" role
    When I am viewing an "article" content with the title "My article"
    Then I should see the heading "My article"{{< /code >}}

For more information about the api driver see the [Drupal API Driver documentation](https://behat-drupal-extension.readthedocs.io/en/3.1/drupalapi.html).
