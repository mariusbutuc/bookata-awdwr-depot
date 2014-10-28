#!/bin/bash
# Install ruby/rails via RVM

## Command Line Tools for Xcode required

## install RVM: latest stable
curl -sSL https://get.rvm.io | bash -s stable​

## install Ruby
rvm install 2.1.3 --autolibs=enable
rvm --default use 2.1.3
rvm --create --ruby-version ruby-2.1.3@bookata-rails4-agile-web-dev

## install Rails
echo gem: --no-document > ~/.gemrc
gem install rails --version 4.1.6
