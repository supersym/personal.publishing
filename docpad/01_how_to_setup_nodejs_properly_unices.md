How To Properly Setup Node.js in Unices
=======================================

For what audience is this article intended?
-------------------------------------------

This tutorial makes a few assumptions based on common usage statistics,
which also conveniently defines the scope of this article and for whom it is
intended. You may find the information in this article useful in the following
cases:

- you use node.js for tasks on your machine often;
- you are using a Unix-derived operating system such as Linux or Mac OSX;
- you are running a sh-like shell such as bash or zsh (nearly all platforms do);
- you are working with `sudo` to delegate root permission commands;
- you have to use the command `sudo npm install -g someapp` for certain things;

The last point refers to the use of the sudo codemmand/program in order to run
and install node.js applications as _global_ which boils down to any command
you install with the `-g` switch. This guide is explicitly not for *Windows*
operating systems as the system of permissions works different, our scope is
those systems which use the [traditional Unix permissions][unix1] way of
regulating read/write and other file-system permission attributes for
file/inode IO.

What problems are we trying to solve?
-------------------------------------

Aka what justifies this write-up of information? What I am trying to somewhat
coherently outline in this article are some common challenges you might
encounter while using node.js (and DocPad for that matter) - some of which
might not be noticed or recognized by you as such yet which however, in the
end, still are considered to be _improper_ use or _bad practice_.

I will list a few of the system notifications you may recieve and, after
elaborating some more on why they occur, tell you how to possibly solve them.
Due to the complexity and span of modern day software and my limited
knowledge, this is in no way a comprehensive debugging guide. It's simply some
stuff I experienced and found the information to deal with dispersed around
the web. I'll reference the sources where I can.

In short, this article tries to solve these problem areas:

- improper permissions to install global node.js software (need sudo);
- problems when trying to natively compile dependencies (node-gyp errors);

How does this relate to DocPad (context)
----------------------------------------

The `docpad` command is run from the command line. Command line apps should be
installed in the node.js global folder which, by default, requires root access
to install a global npm package and thus may require the `docpad` command to
further, after being installed with root, require root access to be executed.
As mentioned above, the unnecessary use of the root account is strongly
discouraged when not strictly required from a security perspective.

Following this logic, if you want only the root user to be able and install
node.js packages, there is no problem to solve and you may stop reading. This
however does constitute a security risk because you will essentially be sharing
the root permission with any global package executables that have the `setuid`
sticky bit set (see the long part for a full disclosure of the reasoning behind
it all).

What are the symptoms of these problems?
----------------------------------------

Some of the error messages you may encounter are:

`npm ERR! sh "-c" "node-gyp rebuild" failed with 1`

`npm ERR! Please try running this command again as root/Administrator`

`npm ERR! Error: EACCES, permission denied '/usr/lib/node_modules'`

`npm ERR! error rolling back Error: EPERM, chmod '/usr/lib/node_modules/someapp'`


What is causing these problems?
-------------------------------

I should warn you upfront: this is a long read. Somewhat opinionated I might
advise you to read it though, especially if you know little about how your
Unix derived operating system works on a deeper level of package and software
management because it is at the root of some of these problems.

#### The first problem (permissions)

In order to properly solve the permissions problem, the usual solution is to
prepend the previously issued command with `sudo` much like:

```
npm i -g someglobalapp
> receives error in stdout
sudo !!
```

This makes the shell execute `sudo npm i -g someglobalapp` without the hassle.
No questions asked. But if you know a bit more about the world of security in
the context of Unices, you should know that running any command in the context
of the 'root' user account is considered hazardous. Actually, in the previous
chapter, it's the last error message I used which hints what our problem area
is: `/usr/lib/node_modules`. The second hint is the use of the term `chmod`
which references the Unix [chmod][chmod] command which in turn is used for
setting file-system objects attributes such as read/write permissions on
inodes (which is the type that your files, directories are made up of).

#### Environment

The problem in fact is caused by node.js which sets up something called a
[environment variable][envvar] by default. The environment variable we are
talking about is the [NODE_PATH][npmglob] variable and it points to the
location at which the `npm` command, the Node Package Manager, can find
node.js installed. It will try to look for the `/usr/lib` location first and
if it finds it, but you lack the permissions, throws these errors.

For the origin we actually even have to take a step back once more, before we
realize what the underlying problem is: the way you install software on your
system. Now this is very specific for every distribution but most share some
common ancestor, usually this is the `apt-get` or `aptitude` program if your
distribution is derived from Debian and uses it's [dpkg][dpkg] architecture.
The other likely candidate (if you are using Linux) is the [rpm][redhat] way
that distributions derived from the RedHat branch of Linux flavours. Any
others could, but not limited to, be any of the following: [pacman][arch] for
Arch Linux or [softwareupdate][macosx] for the Mac OS X operating systems like
the ones used for say a Snow Leopard server using the [command line][macli].

Nearly all of them, if not all, will require use of the `sudo` command if the
program (sudo) is installed and in use on your system. Very few distro's come
without although its use (from a security-wise perspective) is debatable
(you'll find both sides to hold some valid arguments). Some of the downsides
which are closely related to our problem however, can be describes as the user
[bredman][sudo1] points out:

```md
The **human problem** is that it teaches bad practices. Every time you give advice
to a newbie, you fall into bad habits and teach them your bad habits. This
then becomes ingrained and the newbie grows up and is given control of an
operational server.

The **technical problem** is that everything that you do as root leave a trail of
priveliged files, These may be executables, config files or even log files.
The more that you do as root, the harder it is to run any program as a normal
user. This acts like a virus, spreading through your system.

As an example, a very common problem is with log files. To install a program,
you may be tempted to install it as root to save using the sudo command. After
installation, you will probably execute the program to check it works OK. But
if you execute the program as root, the program may create a log file which
will have root permissions. After this, no user will be able to use the
program properly, because the program cannot write to its log file unless run
by a root user.
```

Now let's consider a few of the following points you might need to have root
permissions for (as mentioned, the sudo command delegates the root permissions
to the current user - it does not however replaces the root user in a sense
that anything installed using `sudo` command is equivalent to installing it as
the root user itself: it just may not require the _root password_ for it to be
allowed!):

+ you must be the user who is allowed to execute sudo to start with (in
  /etc/sudoers file) before you get to use it: anyone who isn't and tries to
  use it will have its name reported to the admin
+ you will most likely (and should) need root access before you can execute
  the install option of your package manager (often listing installed software
  or such does not require root permissions or sudo);
+ if you are allowed to use `sudo` command, combined with your package manager
  install command (these can be fine-tuned per command and per user/group
  inside /etc/sudoers) the command will successfully elevate you temporarily
  to the root user, installed the package source files (compiled binaries)
  inside it's designated directory like `/usr/share` or perhaps `/opt` and
  even `/usr/local` folders.

The last point marks our last obstacle: by default all directories and
folders, except those of specialized utilities (like say Polkit or Avahi -
both which employ a proper use (or so it seems) of chrooting their services -
who have user accounts for running their background service (aka a
[daemon][bgps]) using less-privileged accounts than that of root.

Now you might ask yourself why this should be a problem. And you're right to
do so. The problem lays in the way how permissions work on processes and any
child-processes forked from this one. It's beyond the scope of this article to
elaborate much further but you might find the [following read][setuid] to be
interesting material. In summary though, consider that opening a file means
that you also create a process and that, if it's read-only to root, would
require root permissions to do so (fopen() system call if I'm correct) and,
although this is not common for many files - root read permissions only - most
of the more 'security' sensitive directories (such as your /usr/share or /opt)
will probably do require root for write permissions. And as a result apply the
root requirements

Now there are two ways to solve this problem, if we like this to be any
different. The first way is exactly how your `/home` directory is set-up. You
get a designated folder which you are the owner of and to which you may write
data - and only you - the second is optionally sharing these permissions with a
Unix [group][grpix] of your choosing. The last option might be desirable in a
multi-user environment where more than one person require write access to any
folder, for example the one where node.js is stored (one can imagine a
development environment where project leaders can install new global
packages). This poses us only with the following questions:

1. where do we want to install node.js?
1. how do we share this folders permissions with others?

Both are rather easily achieved:

1. This is a somewhat biased answer, and as a matter of fact: there is no
correct answer. Personally I follow the answer as given by the author of
node.js, Ryan Dahl in a [blog post][dahl] resembling this one but which I
failed to recollect. In my case however, I have a system where I am the only
one who has a single installation of npm (version) and it's located at the
`/usr/local/lib` path. The choice is mostly historical by nature, this folder
was once created for the local user to install his/her things - you might want
a different location but for me this follows the original intent of the
hierarchical file-system ordering in generic Unix-derived systems. Another
option might be the `/opt` folder which can be used for stand-alone optional
software which does not rely on any other libraries on your system. Do note
that node.js requires the following to be built from [source][nodegit]:

> Python 2.6 or 2.7
> GNU Make 3.81 or newer
> libexecinfo (FreeBSD and OpenBSD only)

1. However, our second problem we have to overcome, is how to share these
locations with others, should you decide to do so. This involves setting
something which is called the the `setguid` attribute flag and changing the
directory group. So we'll have to have the correct permissions to execute two
commands `chmod` and `chgrp` both which require the use of root. So let's get
down to business and assume that you wish to install node, like I have, at the
following (root user/group owned and default limited) folder `/usr/local/lib`:

`sudo chgrp wheel /usr/local/`

This changes the owner of the /usr/local directory to the `wheel` group which is,
mostly due to historic purposes and it's use in Unix/BSD operating systems, the
admin group on several operating systems. Chances are though you do not have such
a group (like on Debian) and may want to use `sudo` group instead or even create it

`sudo groupadd wheel && sudo chgrp wheel /usr/local`

Which would do what we want. Now the following step is to ensure that
everything we place (install, write) inside that folder is done under the
umbrella of this group, else our system would create a file (because we are
permitted to do so) but under the name of your default, primary user-group,
most likely either your username or the group 'users' or any such sort. To find
out your default group you'd have to type `id` at the shell and look for the
`gid` value. But that on a side-note. In order for our writings under /usr/local to be done as the `wheel` group, we have to set it's `guid`, the group unique id, sticky attribute. And just as done by using it's relative dangerous user unique id-sticky attribute flag, this also will inherit the permissions of, not it's owner this time, but it's group.

So let's assume this is how your folder looks, first without any modification, then after setting the group and finally setting the sticky attribute:

```sh
$ ls -lsh /usr
> 4.0K drwxr-xr-x  27 root root  36K jan  3 22:52 local
```

Then we change it's group to the `wheel` group as illustrated above:

```sh
> 40K drwxr-xr-x  27 root wheel 36K jan  3 22:52 local
```

And finally, to sticky it to the group we issue the command

`sudo chmod g+ws /usr/local`

Which will set the sticky group-id bit and after which our folder ls might display
something looking a lot like:

```sh
> 4.0K drwxrwsr-x  27 root wheel 4.0K dec 19 11:29 local
```

Note: this is in no way required by may come in handy... Also keep in mind, you
are totally free in the user, group and location you choose to install node.js










[unix1]: http://en.wikipedia.org/wiki/Filesystem_permissions#Traditional_Unix_permissions
[chmod]: http://en.wikipedia.org/wiki/Chmod
[dpkg]: http://en.wikipedia.org/wiki/Dpkg
[envvar]: http://en.wikipedia.org/wiki/Environment_variable
[npmglob]: http://nodejs.org/api/modules.html#modules_loading_from_the_global_foldersi
[redhat]: http://nl.wikipedia.org/wiki/RPM_Package_Manager
[arch]: https://wiki.archlinux.org/index.php/Pacman
[macli]: http://support.apple.com/kb/HT1974
[sudo1]: http://www.raspberrypi.org/phpBB3/viewtopic.php?f=27&t=8536
[bgps]: http://en.wikipedia.org/wiki/Daemon_(computing)
[setuid]: http://www.win.tue.nl/~aeb/linux/hh/hh-12.html
[grpix]: http://en.wikipedia.org/wiki/Group_(computing)
[dahl]: http://blog.nodejs.org/2011/04/04/development-environment/
[nodegit]: https://github.com/joyent/node
