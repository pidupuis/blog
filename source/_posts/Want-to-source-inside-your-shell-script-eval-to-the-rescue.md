---
title: Want to source inside your shell script? eval to the rescue!
date: 2016-12-22 10:30:33
tags:
    - tutorial
    - shell
---

For the very first post of this site, I wanted something very digest so I chose a really basic shell problem which is common and yet, not enough documented. Let's say you want to add your `npm/bin` folder to the path to use `bower`. Basically, you need to update your profile file, so you'd do:
<!-- more -->
```bash
$ echo "export PATH=\"$HOME/npm/bin:$PATH\"" >> ~/.bash_profile
$ source ~/.bash_profile
$ bower --help # It works!
```

Then every binary in that folder will be available. Plain and simple.

But what happens if you put this code inside a script? The answer is: it does not work.

```bash
echo "export PATH=\"$HOME/npm/bin:$PATH\"" >> ~/.bash_profile
source ~/.bash_profile
bower --help # bower: command undefined :(
```

It doesn't work because the script is already running from an outdated environment. It is only after the end of the script that the new `PATH` will be available.

Like I said, that's a basic problem. Inside your script, you'll have to use `eval` like this:

```bash
EXPORT_PATH="export PATH=\"$HOME/npm/bin:$PATH\""

echo $EXPORT_PATH >> ~/.bash_profile
source ~/.bash_profile

eval $EXPORT_PATH
bower --help # It works!
```

And that's all!
