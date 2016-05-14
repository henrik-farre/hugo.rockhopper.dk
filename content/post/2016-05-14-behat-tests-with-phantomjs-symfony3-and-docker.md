+++
date = "2016-05-14T14:56:22+02:00"
title = "Behat tests with Symfony 3, PhantomJS and Docker"
url = "/linux/software/behat-tests-with-symfony3-phantomjs-and-docker"
tags = ["Behat", "Docker"]
categories = [
  "software",
  "php",
  "pilotboat"
]

+++

Writing tests should be easy, but installing and maintaining every single piece needed is nontrivial. Thankfully Docker can provide each piece of the jigsaw: Symfony 3, Behat and PhantomJS.<!--more-->

I have created [pilotboat](https://github.com/henrik-farre/docker) to make it easy for me to develop and test PHP based applications, and I will use it in this how-to. If you prefer to use another setup, feel free to look through my [github repository for pilotboat](https://github.com/henrik-farre/docker) for inspiration.

## Prerequisite

1. Working Docker installation
2. A top level domain that points to your local machine, e.g. .dev

## Pilotboat setup

The following steps are required to setup pilotboat:

1. Clone https://github.com/henrik-farre/docker to your preferred location
2. Add the bin directory to your $PATH.
3. (Optional) Create an [Blackfire.io](https://blackfire.io) account
4. Copy containers/docker.env.skel to containers/docker.env and fill out the values for your Blackfire.io account, or leave them blank
5. Run: {{< cmd >}}pilotboat start php-dev-debian-jessie{{< /cmd >}} (starts the default image based on Debian Jessie with Apache 2.4.x and PHP 5.6.x)

Docker-compose will download and build the needed images and start the containers.

## Site setup

To create a site based on Symfony 3 run {{< cmd >}}pilotboat site-create symfony.dev symfony{{< /cmd >}} (symfony.dev is your domain name, you may choose anything you like). The latest stable version of the Symfony 3 framework will be downloaded and installed. Note that pilotboat will create a database, but you will have to manually configure {{< path >}}app/config/parameters.yml{{< /path >}} to access it.

## Behat configuration

Enter the container with {{< cmd >}}pilotboat shell{{< /cmd >}} and change to your site: {{< cmd >}}cd symfony.dev{{< /cmd >}}.

Next you will have to install the needed bundles for Behat, using composer: {{< cmd >}}composer require --dev behat/behat behat/mink behat/mink-extension behat/mink-selenium2-driver{{< /cmd >}}

When composer is done installing, initialize Behat with {{< cmd >}}vendor/bin/behat --init{{< /cmd >}}, this will create the {{< path >}}features{{< /path >}} directory and {{< path >}}features/bootstrap/FeatureContext.php{{< /path >}}.

Now we have to tie everything together using a {{< path >}}behat.yml{{< /path >}} file, that you create in the root directory of your site, e.g. /var/www/symfony.dev:

{{< code yml >}}default:
  suites:
    default:
      contexts:
        - FeatureContext
        - Behat\MinkExtension\Context\MinkContext
  extensions:
    Behat\MinkExtension:
      base_url: 'http://symfony.dev/'
      sessions:
        default:
          selenium2:
            wd_host: 'http://phantomjs:8910/wd/hub'{{< /code >}}

## Writing and running tests

I will not go into detail on how to write tests, so the following is just a small example. Create {{< path >}}features/homepage.feature{{< /path >}} and put the following in the file:

{{< code cucumber >}}Feature: Homepage
  In order to see if the home page works
  As a website user
  I need to be able to see the home page

  Scenario: See the home page
    Given I am on "/"
    Then I should see "Welcome to Symfony 3"{{< /code >}}

Run {{< cmd >}}vendor/bin/behat{{< /cmd >}} to execute the test, and you should see something like:

<pre>Feature: Homepage
  In order to see if the home page works
  As a website user
  I need to be able to see the home page

  Scenario: See the home page                # features/homepage.feature:6
    Given I am on "/"                        # Behat\MinkExtension\Context\MinkContext::visit()
    Then I should see "Welcome to Symfony 3" # Behat\MinkExtension\Context\MinkContext::assertPageContainsText()

1 scenario (1 passed)
2 steps (2 passed)
0m0.21s (13.43Mb)</pre>

And you're ready to write tests :)
