---
title: venv
tags:
---



## Python

### Install environment

```bash
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv


echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$HOME/.pyenv/shims:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile

source ~/.bash_profile

pyenv install 3.5.1
```

### Set up environment

```bash
mkdir python_project
cd python_project
pyenv virtualenv 3.5.1 python_project
pyenv local python_project

pip install --upgrade pip
```

### Manage packages

```bash
echo "python-dateutil" >> requirements.txt
pip install -r requirements.txt
```


## Perl

### Install environment


```bash
git clone https://github.com/tokuhirom/plenv.git ~/.plenv
git clone https://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build

echo 'export PATH="$HOME/.plenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(plenv init -)"' >> ~/.bash_profile

source ~/.bash_profile

plenv install 5.25.8
plenv rehash

```


### Set up environment


```bash
mkdir perl_project
cd perl_project
plenv local 5.25.8

plenv install-cpanm
```


### Manage packages

```bash
echo "requires 'JSON';" >> cpanfile
echo "requires 'DateTime';" >> cpanfile
cpanm --installdeps .
```


## R

### Install environment


```bash
sudo R
```

```R
install.packages("packrat")
```


### Set up environment


```bash
mkdir r_project
cd r_project
R
```

```R
packrat::init()
```


### Manage packages

```R
install.packages("reshape2")
packrat::snapshot()
```


### Share project

```R
packrat::bundle()
packrat::unbundle("./r_project-2017-01-03.tar.gz", getwd())
```
