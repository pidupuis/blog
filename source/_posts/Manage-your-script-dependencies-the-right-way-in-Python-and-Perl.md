---
title: Manage your script dependencies the right way in Python and Perl
date: 2017-01-09T20:11:44.000Z
categories: Build
tags:
  - python
  - pyenv
  - perl
  - plenv
  - dependencies
---

In this tutorial, I am going to show you how to handle multiple versions of binaries and dependencies without having projects interfering with each other and how to easily share a project through different computers. After reading this post, you'll know how to use virtual environments and appropriate tools to manage your script dependencies in both Python and Perl. It only takes a few minutes to learn and it is a must-have for every development.

<!-- more -->

<style>
.addition {
  color: #B5C166;
}
.addition-bold {
  color: #859900;
}
.deletion {
  color: #E66F6D;
}
.deletion-bold {
  color: #DC322F;
}
.addition-bg {
  background-color: #a6f3a6;
}
.deletion-bg {
  background-color: #f8cbcb;
}
.custom-code {
  background: none 0% 0% / auto repeat scroll padding-box border-box rgb(247, 247, 247);
  color: rgb(131, 148, 150);
  font-size: 13px;
  line-height: 19px;
  overflow: auto;
  padding: 16px;
  border: none;
  display: block;
}
</style>

First, I think I owe you an explanation for mixing Python and Perl in the same tutorial, especially since it is not a "Python vs Perl" post. Among the bioinformatics community, these are two languages widely and legitimately used for scripting and I am not here to start a flame war. I was planning to write two separated tutorials but the fact is that virtual environments can be handled the exact same way in Python and Perl. There are so many similarities that I chose to stick to one tutorial and to show the differences along the way.

I hope you'll enjoy this <span class="deletion-bg">Python</span><span class="addition-bg">Perl</span> post. If the git-diff style doesn't suit you or if you want to stick to the part relevant for your case, you can jump to the final recap using this [link for Python](#python) or this [link for Perl](#perl) (**#TL;DR**).

# Virtual environment

Basically, a virtual environment is a folder in which a specific version of <span class="deletion-bg">Python</span><span class="addition-bg">Perl</span> can run. This allows you to have multiple versions installed on the same computer.

Before getting started, be sure to have <span class="deletion-bg">[Python](https://www.python.org/downloads/)</span><span class="addition-bg">[Perl](https://www.perl.org/get.html)</span> and [Git](https://git-scm.com/downloads) installed.

## Install

There are multiple ways to create virtual environments but a common and efficient one is by using <span class="deletion-bg">[pyenv](https://github.com/yyuu/pyenv)</span><span class="addition-bg">[plenv](https://github.com/tokuhirom/plenv)</span>. The easiest way to install this utility is by cloning the git repository. In the following lines, I chose to put the binaries inside my home folder but you can put it elsewhere as you wish.

<pre class="custom-code">
<span class="deletion">git clone https://github.com/<span class="deletion-bold">yyuu/pyenv</span>.git ~/.p<span class="deletion-bold">y</span>env</span>
<span class="addition">git clone https://github.com/<span class="addition-bold">tokuhirom/plenv</span>.git ~/.p<span class="addition-bold">l</span>env</span>
<span class="deletion">git clone https://github.com/<span class="deletion-bold">yyuu/pyenv-virtualenv</span>.git ~/.p<span class="deletion-bold">y</span>env/plugins/<span class="deletion-bold">pyenv-virtualenv</span></span>
<span class="addition">git clone https://github.com/<span class="addition-bold">tokuhirom/Perl-Build</span>.git ~/.p<span class="addition-bold">l</span>env/plugins/<span class="addition-bold">perl-build</span></span>
</pre>

Then, since it is not a system-level installation, you have to add the repository path into your environment variables. The following commands write the adequate lines at the end of your profile file. In my case, the profile file is `.bash_profile`, but change it according to your own configuration (it could be `.bashrc`, `.zshrc`, `.profile`, etc). Then `source` your profile file to benefit from these modifications right now.

<pre class="custom-code">
<span class="deletion">echo 'export PATH="$HOME/.p<span class="deletion-bold">y</span>env/bin:$PATH"' >> ~/.bash_profile</span>
<span class="addition">echo 'export PATH="$HOME/.p<span class="addition-bold">l</span>env/bin:$PATH"' >> ~/.bash_profile</span>
<span class="deletion">echo 'export PATH="$HOME/.pyenv/shims:$PATH"' >> ~/.bash_profile</span>

<span class="deletion">echo 'eval "$(p<span class="deletion-bold">y</span>env init -)"' >> ~/.bash_profile</span>
<span class="addition">echo 'eval "$(p<span class="addition-bold">l</span>env init -)"' >> ~/.bash_profile</span>
<span class="deletion">echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile</span>

source ~/.bash_profile
</pre>

Now that you have <span class="deletion-bg">pyenv</span><span class="addition-bg">plenv</span> installed, you can easily use it to install every <span class="deletion-bg">Python</span><span class="addition-bg">Perl</span> version you want. For example, you can do:

<pre class="custom-code">
<span class="deletion">p<span class="deletion-bold">y</span>env install <span class="deletion-bold">3.5.1</span></span>
<span class="addition">p<span class="addition-bold">l</span>env install <span class="addition-bold">5.25.8</span></span>
</pre>

If you want to see the versions available for installation, you can do:

<pre class="custom-code">
<span class="deletion">p<span class="deletion-bold">y</span>env install --list</span>
<span class="addition">p<span class="addition-bold">l</span>env install --list</span>
</pre>

## Usage

The previous step was the installation part. This was the kind of things you have to do only once. Now we enter the part in which we set up a project. This is what you'll have to do each time you create a new project. But don't worry, as you will see, this is really quick and easy.

You have a virtual environment utility and a <span class="deletion-bg">Python</span><span class="addition-bg">Perl</span> version. The only thing you have to do is to indicate to your project folder which version to use:

<pre class="custom-code">
mkdir my_project
cd my_project
<span class="deletion">p<span class="deletion-bold">y</span>env local <span class="deletion-bold">3.5.1</span></span>
<span class="addition">p<span class="addition-bold">l</span>env local <span class="addition-bold">5.25.8</span></span>
</pre>

The previous command generates a <span class="deletion-bg">`.python-version`</span><span class="addition-bg">`.perl-version`</span> file inside your folder. This file contains the version used. Therefore, the virtual environment will be activated automatically as you enter the folder. When you'll share the folder with someone else, he'll know which version to use and he would only have to install the corresponding version the same way you did it in the installation part.

# Package management

Virtual environments are as simple as that. You could stop here but we can do so much more with only a few more steps. Let's introduce a package manager! A package manager allows you to install every dependency existing out there with a simple command. This is really useful and it becomes really awesome once combined with a virtual environment.

<span class="deletion-bg">Install [pip](https://pip.pypa.io/en/stable/installing/) by following the instructions on the official site.</span>

<span class="deletion-bg">Then update pip</span><span class="addition-bg">Install cpanm</span> by running the following command:

<pre class="custom-code">
<span class="deletion">pip install --upgrade pip</span>
<span class="addition">plenv install-cpanm</span>
</pre>

When you are inside a virtual environment, every dependency you'll install will be installed only for this environment. This means you will be able to use different dependency versions for different projects. Moreover, you can list your dependencies in a dedicated file called <span class="deletion-bg">`requirements.txt`</span><span class="addition-bg">`cpanfile`</span> and install everything from this file using a simple command. This is a must-have if you want to share your code.

The following commands show you how to add a dependency to manipulate dates in your project:

<pre class="custom-code">
<span class="deletion">echo "python-dateutil==2.6.0" >> requirements.txt</span>
<span class="addition">echo "requires 'DateTime', '== 1.42';" >> cpanfile</span>
<span class="deletion">pip install -r requirements.txt</span>
<span class="addition">cpanm --installdeps .</span>
</pre>

# Conclusion

Your project now includes two simple human-readable files allowing anyone to use your code. One file to set the <span class="deletion-bg">Python</span><span class="addition-bg">Perl</span> version and another one to install the dependencies.

Therefore, **it will take only two commands to set up an environment where your script will be able to run**, and this without explanation or additional documentation. Not only using this is beneficial in no time but it is a good practice shared by the entire community.

Moreover, you don't need any additional learning to do it in two major languages.

I hope you liked this tutorial.

# More informations

If you want to learn more about virtual environments and package management, go check the following links:
- <span class="deletion-bg">[yyuu/pyenv](https://github.com/yyuu/pyenv)</span>
- <span class="addition-bg">[tokuhirom/plenv](https://github.com/tokuhirom/plenv)</span>
- <span class="deletion-bg">[pip](https://pypi.python.org/pypi/pip)</span>
- <span class="addition-bg">[cpanm](http://search.cpan.org/~miyagawa/Menlo-1.9003/script/cpanm-menlo)</span>

_____

# Appendices

## <a id="python"></a>Python

Here is the concatenation of the commands used to set up the Python virtual environment in the tutorial:

```bash
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

echo "export PATH=\"$HOME/.pyenv/bin:$PATH\"" >> ~/.bash_profile
echo "export PATH=\"$HOME/.pyenv/shims:$PATH\"" >> ~/.bash_profile
echo "eval \"$(pyenv init -)\"" >> ~/.bash_profile
echo "eval \"$(pyenv virtualenv-init -)\"" >> ~/.bash_profile
source ~/.bash_profile

pyenv install 3.5.1

mkdir my_project
cd my_project
pyenv local 3.5.1

pip install --upgrade pip

echo "python-dateutil" >> requirements.txt

pip install -r requirements.txt
```

## <a id="perl"></a>Perl

Here is the concatenation of the commands used to set up the Perl virtual environment in the tutorial:

```bash
git clone https://github.com/tokuhirom/plenv.git ~/.plenv
git clone https://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build

echo "export PATH=\"$HOME/.plenv/bin:$PATH\"" >> ~/.bash_profile
echo "eval \"$(plenv init -)\"" >> ~/.bash_profile
source ~/.bash_profile

plenv install 5.25.8
plenv rehash

mkdir my_project
cd my_project
plenv local 5.25.8

plenv install-cpanm

echo "requires 'DateTime';" >> cpanfile

cpanm --installdeps .
```
