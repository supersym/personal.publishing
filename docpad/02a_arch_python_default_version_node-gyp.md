
Option using temporary python symlink the safe way without breaking stuff:

```sh
mkdir /tmp/bin
ln -s /usr/bin/python2 /tmp/bin/python
export PATH=/tmp/bin:$PATH
```

Option using the above more permanently for your local user: Use this in
auto-run file like ~/.bashrc or ~/.zshenv which persists environment variables
top-shell so using $ bash or $ zsh sub-shells will also have correct python2
symlink first in line.

```sh
# if there isn't a directory make it
[[ -d /tmp/bin ]] || mkdir /tmp/bin
# if we have a symlink but it's incorrect or dangling
[[ -L /tmp/bin/python ]] && [[ $(readlink /tmp/bin/python | grep 'python2') ]] && \
{ rm /tmp/bin/python;
  # grab the first available path 
  py2=$(whereis python2|cut -d ' ' -f2)
  [[ $py2 != "" ]] && ln -s $py2 /tmp/bin/python
 }
```
_todo_ finish, untested raw script

Option when hacking into the source code which invokes node-gyp:

`node-gyp --python=python2`



