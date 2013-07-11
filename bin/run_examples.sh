#!/bin/sh
# This is just a handy shortcut to run the jruby game.
ruby -J-Djava.library.path=./native -rubygems bin/main.rb
