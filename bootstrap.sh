#!/bin/bash
# Install ruby/rails via RVM

## Command Line Tools for Xcode required

## install RVM: latest stable
curl -sSL https://get.rvm.io | bash -s stable​

## install Ruby
rvm install 2.1.5 --autolibs=enable
rvm --default use 2.1.5
rvm --create --ruby-version ruby-2.1.5@bookata-awdwr-depot

## install Rails
echo gem: --no-document > ~/.gemrc
gem install rails --version 4.1.8
