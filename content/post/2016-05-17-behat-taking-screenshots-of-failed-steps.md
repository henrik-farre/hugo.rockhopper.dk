+++
date = "2016-05-17T10:51:24+02:00"
title = "Behat: taking screenshots of failed steps"
url = "/linux/software/behat-taking-screenshots-of-failed-steps"
tags = ["Behat"]
categories = [
  "software",
  "php",
]
+++

Getting a screenshot and a dump of the HTML of a failed step is invaluable when running tests on a headless "browser" like PhantomJS, and this post will show you how<!--more-->

You will of cause need a working Behat/PhantomJS setup to run this code, you can see my post about <a href="/linux/software/behat-tests-with-symfony3-phantomjs-and-docker/">Behat tests with Symfony 3, PhantomJS and Docker</a> on how to configure everything like {{< path >}}behat.yml{{< /path >}}.

The following code is compiled from this Github bug report: <a href="https://github.com/Behat/Behat/issues/649">Behat 3: Taking screenshots after failed steps #649</a> and <a href="https://www.google.dk/#q=takeScreenshotAfterFailedStep">several other people using "takeScreenshotAfterFailedStep" as the function name</a>

Edit your {{< path >}}features/bootstrap/FeatureContext.php{{< /path >}} and create the takeScreenshotAfterFailedStep function:

{{< code php >}}&lt;?php

use Behat\Behat\Context\Context;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;

use Behat\Testwork\Tester\Result\TestResult;
use Behat\Behat\Hook\Scope\AfterStepScope;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;

class FeatureContext implements Context, SnippetAcceptingContext
{
    /** @var \Behat\MinkExtension\Context\MinkContext */
    private $minkContext;

    public function __construct() {}

    /**
     * @BeforeScenario
     * http://behat.readthedocs.org/en/v3.0/cookbooks/context_communication.html
     */
    public function gatherContexts(BeforeScenarioScope $scope)
    {
        $environment = $scope-&gt;getEnvironment();
        $this-&gt;minkContext = $environment-&gt;getContext('Behat\MinkExtension\Context\MinkContext');
    }

    /**
     * @AfterStep
     */
    public function takeScreenshotAfterFailedStep(AfterStepScope $scope)
    {
        if (TestResult::FAILED === $scope-&gt;getTestResult()-&gt;getResultCode()) {
            $driver = $this-&gt;minkContext-&gt;getSession()-&gt;getDriver();

            if (!$driver instanceof Behat\Mink\Driver\Selenium2Driver) {
                return;
            }

            $page               = $this-&gt;minkContext-&gt;getSession()-&gt;getPage()-&gt;getContent();
            $screenshot         = $driver-&gt;getScreenshot();
            $screenshotFileName = date('d-m-y').'-'.uniqid().'.png';
            $pageFileName       = date('d-m-y').'-'.uniqid().'.html';
            // NOTE: hardcoded path:
            $filePath           = "/var/www/symfony.dev/";

            file_put_contents($filePath.$screenshotFileName, $screenshot);
            file_put_contents($filePath.$pageFileName, $page);
            print 'Screenshot at: '.$filePath.$screenshotFileName."\n";
            print 'HTML dump at: '.$filePath.$pageFileName."\n";
        }
    }
}{{< /code >}}

When a step failes you should see something like:

<pre>Feature: Homepage
  In order to see if the home page works
  As a website user
  I need to be able to see the home page

  Scenario: See the home page                # features/homepage.feature:6
    Given I am on "/"                        # Behat\MinkExtension\Context\MinkContext::visit()
    Then I should see "Welcome to Symfony 4" # Behat\MinkExtension\Context\MinkContext::assertPageContainsText()
      The text "Welcome to Symfony 4" was not found anywhere in the text of the current page. (Behat\Mink\Exception\ResponseTextException)
    │
    │  Screenshot at: /var/www/symfony.dev/17-05-16-573ae8a1e9f9a.png
    │  HTML dump at: /var/www/symfony.dev/17-05-16-573ae8a1e9fd3.html
    │
    │
    └─ @AfterStep # FeatureContext::takeScreenshotAfterFailedStep()

--- Failed scenarios:

    features/homepage.feature:6

1 scenario (1 failed)
2 steps (1 passed, 1 failed)
0m0.31s (13.49Mb)</pre>

Happy testing :)
