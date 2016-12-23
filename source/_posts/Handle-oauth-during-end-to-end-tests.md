---
title: Handle OAuth during end-to-end tests
date: 2016-12-23 08:50:14
tags:
    - test
    - e2e
    - angularjs
    - protractor
    - selenium
    - OAuth
---


In this tutorial, I am going to walk through writing a simple Protractor configuration file to handle Google authentication during end-to-end tests of an AngularJS app. I will also explain why we are doing it like this with a little state-of-the-art.

<!-- more -->

If you'd rather skip to the end, you can jump to the final configuration through the following [link (**#TL;DR**)](#put-it-together).

I'll assume that you are familiar with [AngularJS](https://angularjs.org/) ecosystem. Ideally, you should have at least heard about [Jasmine](http://jasmine.github.io/), a behavior driven development framework for JavaScript, and [Protractor](https://angular.github.io/protractor/#/), an end-to-end test runner. But it doesn't matter if you haven't. The strategy used here can be applied in every end-to-end environment. Moreover, since Protractor used [Selenium Webdriver](https://code.google.com/p/selenium/wiki/GettingStarted), it will be quite easy to translate the following method for your own purpose.

## User-oriented, as it always should be

Let's say you have an application which requires a Google authentication. Basically, when a user visits your site, he will be automatically redirected to the Google login page and then redirected to your site.

When the time comes to write end-to-end tests, one can see this authentication as a constraint.

> When I test my app manually, I don't need to register at all. I saved my password inside my browser, so why should I act differently inside my tests?

<!-- -->

> I simply want to test my app. I don't want to check if Google know how to develop a login page...

<!-- -->

> I don't want to depend on Google at all. Why if they change their page?

<!-- -->

> There is a lot of things I can test without being connected to Google. I don't want to depend on my Internet connection...

The fact is, you're already in bed with the OAuth system since you've began your app. That's a not a bad thing, the authentication system is a part of your app and you have to deal with it.

First, the only way to do not depend on this authentication system is if your app implements its own alternative. If not, you need to log in to your Google account.
After a quick search on Internet, you'll see that there is a lot of ways to be automatically connected. You can use your private OAuth token for Google to recognize your account. You can even indicate to Protractor the path of your Google Chrome browser in which you are autologged. Yeah, that's cheating, but you can.

My point is, don't do this. That's not how your users will use your app. I agree that is not your job to test Google login page, but your job is to test that this page is well plugged to your application. **You should always test your entire app from the user's point of view.** This implies that you will have to program your test runner to find and fill the input of Google login page.

Off course, Google can modify their page. This could or could not impact your tests but if it helps, be aware that currently, their email input identifier is `Email`, which is pretty straight forward. So if they decide to change this identifier, I can assure you will not be the only one impacted...


## Let's beat the odds

Now that we agree to test as a user, let's see how to tell Protractor to log in to Google.

### Configuration

Protractor offers a configuration variable called `onPrepare` which allows you to write code which will be run before any test suite. The basic configuration would be as following:

```js
'use strict';

exports.config = {
    seleniumAddress: 'http://localhost:4444/wd/hub',
    baseUrl: 'http://localhost:8888/',
    framework: 'jasmine2',
    capabilities: {
        'browserName': 'chrome'
    },
    onPrepare: function() {
        // Maximise the browser window
        browser.driver.manage().window().maximize();

        // Jump to your app page (the one where the redirection to Google happens)
        browser.driver.get(browser.baseUrl);
    },
    specs: ['./e2e/**/*.js']
};
```

That's where you will write the authentication logic.

### Login form

Google pages are not different that any of yours. Therefore, to enter your email, you could simply do:

```js
browser.driver.findElement(by.id('Email')).sendKeys('mygoogle@account.com');
```

However, you will see soon that the redirection could take a while depending on your Internet connection. The time can even change between two runs. So to anticipate this, we will wait for the element to be present:

```js
// We wait for the element to appear during 5 seconds maximum
// This time is absolutely arbitrary. Since we leave the loop as soon as necessary, you can put 60 seconds if you want
browser.driver.wait(function() {
    return browser.driver.isElementPresent(by.id('Email')).then(function(bool) {
        return bool;
    });
}, 5000);
// Here it is different, we force the browser to wait 500ms, no matter what. That prevents the test runner to execute the next line before running the previous waiting timer
browser.sleep(500);
// Then we fill the input
browser.driver.findElement(by.id('Email')).sendKeys('mygoogle@account.com');
```

We'll use the same logic to click on the `Next` button, to enter the password and to click on the `signIn` button.

### Approval requirements

The login form is not the only thing to handle. When you use a Google app, some intermediary pages can appear to ask you to approve the app and/or some access requirements. It is only ask once during the installation so we often forget this pages. In the context of our tests, this will be ask every time you'll run your test since nothing is registered locally.

You have two pages to considered, one for apps market account and one for approve access.

```js
browser.driver.findElement(by.id('apps_market_account')).click();
browser.driver.findElement(by.id('submit_approve_access')).click();
```

As previously, you can use the `wait`, `sleep` and `isElementPresent` functions. However, these pages are not present for every Google app. They can appear as your app grows (if you add authorization requirements) so I strongly recommend you to handle them even if this is not necessary for now.

How can we wait for a button which could never appear? Since you have been connected to Google at this point, you will normally be redirected to your app, so the idea is to wait for the url to be the one of your app and click on the intermediary buttons if they appear.

```js
return browser.driver.wait(function() { // We wait during 20 seconds maximum
    // If the button apps_market_account is present, we click on it
    browser.driver.isElementPresent(by.id('apps_market_account')).then(function(bool) {
        if (bool)
        {
            browser.sleep(500);
            browser.driver.findElement(by.id('apps_market_account')).click();
        }
    });

    // We leave the loop as soon as the current url is our app url
    return browser.driver.getCurrentUrl().then(function(url) {
        return url === browser.baseUrl;
    });
}, 20000);
```

Once again, 20 seconds is an arbitrary duration. If you think you need more, put more.


## Put it together

Here is the final configuration file:

```js
'use strict';

exports.config = {
    seleniumAddress: 'http://localhost:4444/wd/hub',
    baseUrl: 'http://localhost:8888/',
    framework: 'jasmine2',
    capabilities: {
        'browserName': 'chrome'
    },
    onPrepare: function() {
        // Maximise the browser window
        browser.driver.manage().window().maximize();

        // Jump to your app page (the one where the redirection to Google happens)
        browser.driver.get(browser.baseUrl);

        // Google account email
        browser.driver.wait(function() {
            return browser.driver.isElementPresent(by.id('Email')).then(function(bool) {
                return bool;
            });
        }, 5000);
        browser.sleep(500);
        browser.driver.findElement(by.id('Email')).sendKeys('mygoogle@account.com');

        // Next
        browser.driver.wait(function() {
            return browser.driver.isElementPresent(by.id('next')).then(function(bool) {
                return bool;
            });
        }, 5000);
        browser.sleep(500);
        browser.driver.findElement(by.id('next')).click();

        // Google account password
        browser.driver.wait(function() {
            return browser.driver.isElementPresent(by.id('Passwd')).then(function(bool) {
                return bool;
            });
        }, 5000);
        browser.sleep(500);
        browser.driver.findElement(by.id('Passwd')).sendKeys('myPa');

        // Sign in
        browser.driver.wait(function() {
            return browser.driver.isElementPresent(by.id('signIn')).then(function(bool) {
                return bool;
            });
        }, 5000);
        browser.sleep(500);
        browser.driver.findElement(by.id('signIn')).click();

        // Wait for redirection
        return browser.driver.wait(function() {
            // Market account approval eventually needed
            browser.driver.isElementPresent(by.id('apps_market_account')).then(function(bool) {
                if (bool)
                {
                    browser.sleep(500);
                    browser.driver.findElement(by.id('apps_market_account')).click();
                }
            });
            // Access approval eventually needed
            browser.driver.isElementPresent(by.id('submit_approve_access')).then(function(bool) {
                if (bool) {
                    browser.sleep(500);
                    browser.driver.findElement(by.id('submit_approve_access')).click();
                }
            });

            return browser.driver.getCurrentUrl().then(function(url) {
                return url === browser.baseUrl;
            });
        }, 20000);
    },
    specs: ['./e2e/**/*.js']
};
```

Hope you liked this tutorial!