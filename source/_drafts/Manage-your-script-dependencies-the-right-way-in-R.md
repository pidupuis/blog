---
title: Manage your script dependencies the right way in R
tags:
  - r
  - packrat
---




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
