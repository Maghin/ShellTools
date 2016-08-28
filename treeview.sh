#!/bin/sh
##################################################
## treeview.sh
##
## Shell script to list a whole directory
## with a nice output
##
## INSTALL NOTES:
## Copy it in /usr/local/bin/
## or your /home/billy/.local/bin/
## (check whith 'echo $PATH' where to put it)
##
##################################################
dir=${1:-.}
cd ${dir};
pwd
find ${dir} -type d -print | sort -f | sed \
  -e "s,^${dir},," \
  -e "/^$/d" \
  -e "s,[^/]*/\([^/]*\)$,\`----\1," \
  -e "s,[^/]*/, |    ,g";

exit
