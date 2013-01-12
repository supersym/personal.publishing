##################################################
# DocPad plugin for oh-my-zsh                    #
# Original Author: Rob Jentzema (supersym)       #
# Email: r.o.b.j.e.n.t.z.e.m.a[at]googlemail.com #
##################################################
# DocPad is a platform for first-class next-gen  #
# web development, it allows for nearly any HTML,#
# CSS or JS pre-processor or template language,  #
# great strength, flexibility & runs on node.js  #
##################################################
# Place this within your custom dir in oh-my-zsh #
# folder most likely found @ ~/.oh-my-zsh/custom #
##################################################

# Nicer color commands
#
blue=$(tput setaf 4)
normal=$(tput sgr0)

errorCode=0

# Local rollback functionality
rollback() {
  # undo stuff at pt 1A
  echo;
}
trap rollback INT TERM EXIT
# 1A: Operation to rollback upon failure
# ... do stuff
# remove the trap

printf -v signalMessage "%40sd\n%d\n" "${blue}${signalMessage}${normal}" \
"${errorCode}"

# Event handler for SIGTERM (terminate signal)
# make sure whatever it does, goes quickly...
#
on_die()
{
  signalMessage="Recieved SIGINT...dying"
  # Need to exit the script explicitly when done.
  # Otherwise the script would live on, until system
  # realy goes down, and KILL signals are send.
  exit 0
}

# Execute function on_die() event handler when
# receiving TERM signal
#
trap 'on_die' INT

# Loop forever, reporting life each second
#
SEC=0
while true ; do
  sleep 1
  SEC=$((SEC+1))
  echo "I'm PID# $$, and I'm alive for $SEC seconds now!"
done

# We never get here.
exit 0

# Check for docpad installation
hash docpad 2>/dev/null || {
printf "\n%s\n%s\n%s\n%s\n" >&2 \
"This oh-my-zsh plugin requires a globally installed docpad system." \
"The script could not locate the binary executable using the command `docpad`." \
"a) either you do not have docpad installed on your system or..." \
"b) do not have it's binary folder under your \$PATH environment variable.";
exit 1;
} && \



