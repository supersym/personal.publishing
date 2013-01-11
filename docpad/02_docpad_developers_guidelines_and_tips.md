DocPad Developer Tips and Guidelines
====================================

Introduction
------------

The following is a short draft for the outline of a more elaborate, somewhat
biased or opinionated, guide for developers. It's assumed development
(initially) is taking place on a [Unice][unice] platform (sorry Windows users
for now - maybe later I'll use my gf's laptop and write down instructions on
use of PowerShell or any contributors feel free to pull request any work if you
like to help out).

Audience
--------

Aspiring DocPad developers who can be be classified as having, not limited to
any combination of, what can be considered limited working knowledge of
node.js, the node package manager (npm), complex project management strategies
in git, GitHub, DocPad, the development principles of the core-development
team and, of course, it's creative parent, B.A. Luptons intent. However, even
seasoned developers may find some of the information in this article to be
useful as a contribution to their own work flow.

Outline
-------

The structure of this document can be loosely defined as a summary of several
things such as: best practices, references to specific (sometimes well hidden)
details, unfamiliar shortcuts or just handy things like one-liners, the best
configuration settings for the `~/.gitconfig` file, the best project strategy,
what forking is and how to do it, how to write plugins. But also DocPad
internal organizational aspects such as the use of the channel, any
thematic/team-discussions, the use of support forums (currently located at
[Stack Overflow][dpso]), how to report bugs, suggest features and anything
else.

In often enough cases, there will be existing resources which may explain or
illustrate a certain subject, in those cases we'll reference them in their
current article context, point to specific paragraphs using
[hash-tags][refhash]



Prerequisites
-------------

- a Unix-derived operating system like FreeBSD, Linux or Mac OS X;
- a Bourne shell, preferably a later derived shell such as [bash][bash] or [z-shell][zsh];
- internet connection with sufficient command line access to port 80/HTTP(S);
- plus a folder where you can download files to (/tmp will do but most should bare minimum have write inside home folder anyway);
- node.js running (refer to document 01 for a proper setup without use of sudo
- correct python 2.7 to have node-gyp natively compile binaries using e.g.:
- compiler like gcc, the GNU C-Compiler

Development platform: node.js
-----------------------------

The last two prerequisites, Python (specifically ~2.7) and the (GNU)
C-Compiler are required to [build node.js][noderepo], check the link to find
out more information on how to install node.js from the github repository or
[view the Readme build instructions directly][nodebuild]. Also the public
portal or visit the landing-page of node.js official representation
(non-github .org domain) at [nodejs.org][nodedotorg] for more details on
node.js and it's libraries. It is advised to install node.js (and consequently
the node.js package manager `npm`) in a location that is writable by your
every day user account, such as it's `$HOME` directory or any such designated
folder of your choosing.

Development requirement: Python 2.7 caveats
-------------------------------------------

#### Arch Linux default Python version symbolic link inside file path

If your operating system distribution is Arch Linux, you may probably know
already (as I consider Arch users to be rather informed on their systems) that
it the default python version used in Arch is 3.x. This results in the fact
that there is a symbolic file link from `/usr/bin/python` to
`/usr/bin/python3` (or equivalent). Due to this symbolic link, and the way the
kernel looks for executables down the file system path (the `$PATH` variable
and order of appearance in the colon delimited bash array (or zsh wrapper at
`$path` which allows for spaces instead of color)) this practically means the
wrong `python` command is executed when using certain node.js native addons.
More familiar for some, this will result in errors when node.js tries to use [node-gyp][nodegyp],
a tool for node.js native addon building that relies on python 2.7
specifically - or for the time being anyway - often displayed as the following
partial errors or exception messages:

`Attempting to compile native extensions. ~> Native code compile failed!`

`gyp ERR! ...`

`gyp ERR! stack SyntaxError: invalid syntax`

#### Possible solutions

##### Solution 1: replace symlink to python version (safe-method environment variabe and /tmp folder)

A quick and elegant solution which doesn't break your Python binaries/symlink
setup is to perform the following shell operations:

```sh
mkdir /tmp/bin
ln -s /usr/bin/python2 /tmp/bin/python
export PATH=/tmp/bin:$PATH
```

You need to consider the scope of your shell and the way it operates together
with environment variables, which do not persist from sub-shell up to it's
parent, so using this in a script would require you to execute it every
instance together with the python code you like to execute. Now I myself use
the z-shell extensively

_for tips and some rationale behind the use of this
shell and scripting language that `zsh` embodies, see ... TODO: add reference
uri to (oh-my)zsh tips for using_

_..._ and if you do as well, you'll probably know that
`~/.zshrc` is the place you'd initially put this. However, I personally have
chosen for the even earlier entry=point in the whole spawning of shell process
and sub-processes: the file `~/.zshenv` to ensure the python symlink to be
available within `~/.zshrc` already where I set the node.js system environment
variables (_TODO_ add link to boilerplate profile rc files for zsh, bash etc).

Also the script is somewhat of a raw and naive implement, more properly handle
of any testable circumstances might be to use this script:

```sh
[[ -d "/tmp/bin" ]] || mkdir /tmp/bin
[[ -L "/tmp/bin/python" ]] || ln -s /usr/bin/python2 /tmp/bin/python
```

Which does the following in this order: check if the directory /tmp/bin
already exists, else it creates it. Check if there is a symlink there named
`python` else creates it, pointing to python2 binary.

Furthermore we require this path to be first in the order of which our $PATH
array folders get searched for matching `python` commands by using this (also
inside the ~/.bashrc or equivalent file):

```sh
# ~/.bashrc, ~/.bash_profile, ~/.zshrc, ~/.zshenv
export PATH=/tmp/bin:$PATH
```

_TODO_ this should be inside some dev. setup shortcutsell script perhaps, to check
`python --version` output to stdout against 2.x for sanity




##### TODO
- investigate use of node version managers and best practices (I only have 1
  node.js installation)



[unice]: http://en.wikipedia.org/wiki/Unix#Branding Last paragraph on the plural forms of the brand name Unix
[bash]: http://wiki.bash-hackers.org/doku.php
[zsh]: http://zshwiki.org/home/
[noderepo]: https://github.com/joyent/node
[nodebuild]: https://github.com/joyent/node#to-build
[nodedotorg]: http://nodejs.org/
[dpso]: http://stackoverflow.com/questions/tagged/docpad
[refhash]: http://www.html-5.com/definitions/index.html#uri
[nodegyp]: https://github.com/TooTallNate/node-gyp
