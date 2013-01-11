#!/usr/bin/python2.7

# On the issue of portability
"""

You may have noticed the `shebang` located on the first line of this
file. This was chosen after some consideration to be the most proper
way to ensure this script will run in as much systems of all major
platforms and/or operating systems or distributions/versions of such.
It requires python 2.7 to be present on the system.

We actually force the latter of the two mentioned possible versions of python
one is able to use with node.js, or atleast according to the readme at @see
[node.js at github.com](https://github.com/joyent/node#to-build)

Using a shebang does bring certain portability problems, which we
try to i ounter using the `env` shebang method instead of directly
referencing the binary executable interpreter at say `/usr/bin/python2`
or equivalent file. Read more about shebangs at Wikipedia:
@see http://en.wikipedia.org/wiki/Shebang_(Unix)#Portability

To solve some common problems around the differences in both Unix and
Windows world, we refer to the following article:
@see http://www.python.org/dev/peps/pep-0397/
section "Python Script Launching"

quote
" The launcher supports shebang lines referring to Python
executables with any of the (regex) prefixes "/usr/bin/", "/usr/local/bin"
and "/usr/bin/env *", as well as binaries specified without"
/quote

and the following other piece of the puzzle

quote
" On Unix, the user can control which specific version of Python is used by
adjusting the links in /usr/bin to point to the desired version.  As the
launcher on Windows will not use Windows links, cutomization options (exposed
via both environment variables and INI files) will be used to override the
semantics for determining what version of Python will be used.  For example,
while a shebang line of "/usr/bin/python2" will automatically locate a Python
2.x implementation, an environment variable can override exactly which Python
2.x implementation will be chosen."
/quote

As to why we've chosen to use python version 2.7 and not 2.6 is due to the fact
that node-gyp, the build tool, requires:

    " Python (v2.7.3 recommended, v3.x.x is not supported)
      see https://github.com/TooTallNate/node-gyp "

This concludes the rationale as to explaining why we use the first line
shebang the way it is now.
"""



class SanityCheckService



