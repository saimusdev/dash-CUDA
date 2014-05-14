#!/bin/sh --
ruby -v >/dev/null 2>&1 || { echo "$(tput setaf 1)You need 'ruby' to install this docset!$(tput sgr0)"; exit 1; }
test `gem list -i bundle` != "true" && echo "$(tput setaf 1)You need the ruby gem 'bundle' to install this docset!\$(tput sgr0)"
bundle install
rake
