#!/usr/bin/env sh
#### ACTUALLY CANCEL THAT http://magazine.redhat.com/2008/02/07/python-for-bash-scripters-a-well-kept-secret/
#
# This script is solely for Bourne Shell enabled command line interfaces
# such as provided by the /bin/sh, /bin/bash or /bin/zsh executables.
#
# This is a raw and naive write-up of any shell scripting you'd want to do
# if you automate some of the setup tasks to become up-and-running with a
# best-practices (optionally opinionated) config for DocPad development.

# Another option is to write this in python, as it's a requirement for node.js
# This means a core prerequisite for any DocPad development would be
# the pre-existing presence of python (2 explicitly) on the system.


# Variables
npm_not_found_in_path=0

##
# Sanity checks
##

# Node.js existing installation
hash npm 2>/dev/null || { printf "\n%s\n%s\n" >&2 \
"Node Package Manager (npm) executable not found down the \$PATH hash array." \
"Node.js might not be installed yet.";
npm_not_found_in_path=1; } \
  && { echo "";
  }

# If we do have a npm found, tell us where




#### ACTUALLY CANCEL THAT http://magazine.redhat.com/2008/02/07/python-for-bash-scripters-a-well-kept-secret/
